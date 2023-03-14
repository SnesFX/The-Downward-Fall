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
Shader "Hidden/applyao"
{
    Properties
    {
        uOpacity ("Opacity", Range(0,4)) = 1.0
        uBias ("Bias", Range(0, 0.5)) = 0.0
    }
    
    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        
        Pass
        {
            CGPROGRAM
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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            uniform sampler2D uImage0;
            uniform sampler2D uImage1;
            uniform sampler2D uImage2;
            uniform sampler2D _CameraDepthTexture;
            uniform float4x4 uPrevWorldToCameraMatrix;
            uniform float4x4 uFrustumCorners;
            uniform float uOpacity;
            uniform float uBias;

            float4 frag(v2f i) : SV_Target
            {
                // Reproject the previous frame
                float3 rayDirection = lerp(lerp(uFrustumCorners[0], uFrustumCorners[1], i.uv.x),
                                           lerp(uFrustumCorners[2], uFrustumCorners[3], i.uv.x), i.uv.y);
                float depth = tex2D(_CameraDepthTexture, i.uv).r;
                depth = LinearEyeDepth(depth);
                float3 worldPos = _WorldSpaceCameraPos + depth * rayDirection;
                float4 cc = mul(uPrevWorldToCameraMatrix, float4(worldPos, 1.0));
                float prevAO = tex2D(uImage2, cc.xy / cc.w * 0.5 + 0.5).r;

                float visibility = saturate(lerp(tex2D(uImage1, i.uv).r, prevAO, 0.5) + uBias) - uBias + 0.5;
                visibility = (visibility - 1.0) * uOpacity + 1.0;
                
                float4 r = tex2D(uImage0, i.uv);
                r.xyz *= visibility;
                return r;
            }
            ENDCG
        }
    }
}
