/*
MIT License

Copyright (c) 2020 Trevor van Hoof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
Shader "Hidden/ssao"
{
    Properties
    {
        uKernelSize ("Kernel size (units)", Float) = 0.5
        uLUT ("Rotation matrices LUT", 2D) = "white" {}
        uRejectionKernelScale ("Rejection kernel scale", Range(1.0, 10.0)) = 2.0
    }
    
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from DX11, OpenGL ES 2.0 because it uses unsized arrays
#pragma exclude_renderers d3d11 gles
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            uniform sampler2D _CameraDepthTexture;
            uniform float uKernelSize;
            uniform uint _Frame;
            
            static const float2 offsets[] = {
                float2(0.0, -0.5), float2(-0.22, -0.13), float2(-0.654, 0.374),
                float2(0.0, 0.5), float2(0.22, 0.13), float2(0.654, -0.374),
            };

            static const float thickness[] = {
                sqrt(1.0 - dot(offsets[0], offsets[0])),
                sqrt(1.0 - dot(offsets[1], offsets[1])),
                sqrt(1.0 - dot(offsets[2], offsets[2])),
                sqrt(1.0 - dot(offsets[3], offsets[3])),
                sqrt(1.0 - dot(offsets[4], offsets[4])),
                sqrt(1.0 - dot(offsets[5], offsets[5]))
            };

            uniform sampler2D uLUT;
            uniform float uRejectionKernelScale;
            uniform float uBias;

            fixed4 frag(v2f i) : SV_Target
            {
                // we will sample at 0,0 and at the given offsets both positive and negative
                // each sample represents 1/7th of the volume sphere
                float depth = tex2D(_CameraDepthTexture, i.uv).r;
                depth = LinearEyeDepth(depth);
                
                float kernelSize = uKernelSize / depth;

                uint2 px = uint2(i.uv * _ScreenParams.xy);
                uint seed = _Frame * 7 + px.y * 11 + px.x;
                float2x2 rotate = float2x2((tex2D(uLUT, float(seed % 16) / 16.0f) - 0.5) * 2.0);
                
                float visibility = 1;
                UNITY_UNROLL
                for (int j = 0; j < 6; ++j)
                {
                    float delta = LinearEyeDepth(tex2D(_CameraDepthTexture, i.uv + mul(rotate, offsets[j]) * kernelSize).r) - depth;
                    if(abs(delta) < uKernelSize * uRejectionKernelScale)
                        visibility += clamp(delta / thickness[j], -1, 1) + 1;
                    else
                        visibility += 1;
                }
                visibility /= 7;

                return visibility - 0.5;
            }
            ENDCG
        }
    }
}    