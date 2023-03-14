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

This Unity shader uses ACES tone mapping code sourced from
https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
(C) Krzysztof Narkowicz (MIT licensed)

Linear to sRGB conversion (C) 2012 Ian Taylor 
from http://chilliant.blogspot.com/2012/08/srgb-approximations-for-hlsl.html
*/
Shader "Hidden/grading"
{
    Properties
    {
        uExposure ("Exposure", Float) = 1.0
        uGamma ("Gamma", Float) = 1.0
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

            // https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
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
            uniform float uGamma;

            float4 frag(v2f i) : SV_Target
            {
                float4 C_lin = tex2D(uImage0, i.uv);
                float3 S1 = sqrt(pow(ACESFilm(C_lin.xyz * uExposure), uGamma));
                float3 S2 = sqrt(S1);
                float3 S3 = sqrt(S2);
                float3 sRGB = 0.585122381 * S1 + 0.783140355 * S2 - 0.368262736 * S3;
                
                /*C_lin_3 = 0.012522878 * sRGB +
                    0.682171111 * sRGB * sRGB +
                    0.305306011 * sRGB * sRGB * sRGB;*/

                return float4(sRGB, C_lin.a);
            }
            ENDCG
        }
    }
}
