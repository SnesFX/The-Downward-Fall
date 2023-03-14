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

Downsample source image to quarter size image, simply take 4 pixels of the original image
and average them. It is assumed that uImage0's resolution is _ScreenParams * 2
(_ScreenParams being the output resolution).
*/
Shader "Hidden/downsample"
{
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
            
            float4 frag(v2f i) : SV_Target
            {
                float2 r = 1.0 / (_ScreenParams + _ScreenParams);
                return max(0.0, tex2Dlod(uImage0, float4(i.uv + float2(1.0, 0.0) * r, 0, 0)) +
                                tex2Dlod(uImage0, float4(i.uv + float2(1.0, 1.0) * r, 0, 0)) +
                                tex2Dlod(uImage0, float4(i.uv + float2(0.0, 1.0) * r, 0, 0)) +
                                tex2Dlod(uImage0, float4(i.uv + float2(0.0, 0.0) * r, 0, 0))) * 0.25;
            }
            ENDCG
        }
    }
}
