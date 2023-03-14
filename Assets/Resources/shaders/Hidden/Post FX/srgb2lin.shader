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

Because Unity gives us a linear buffer & expects us to return one,
we have to convert our final texture back to linear space.

The reason we go to sRgb in the grading.glsl pass is that fxaa3.glsl only
works well on sRgb inputs. 

sRGB to linear conversion (C) 2012 Ian Taylor 
from http://chilliant.blogspot.com/2012/08/srgb-approximations-for-hlsl.html
*/
Shader "Hidden/srgb2lin"
{
    Properties
    {
        uExposure ("Exposure", Float) = 1.0
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

            float3 ACESFilm(float3 x)
            {
                float a = 2.51f;
                float b = 0.03f;
                float c = 2.43f;
                float d = 0.59f;
                float e = 0.14f;
                return clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0.0, 1.0);
            }

            uniform float uExposure;

            float4 frag(v2f i) : SV_Target
            {
                float4 C_srgb = tex2D(uImage0, i.uv);
                float3 C_lin_3 = 0.012522878 * C_srgb.xyz +
                    0.682171111 * C_srgb.xyz * C_srgb.xyz +
                    0.305306011 * C_srgb.xyz * C_srgb.xyz * C_srgb.xyz;
                return float4(C_lin_3, C_srgb.a);
            }
            ENDCG
        }
    }
}
