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

Simple directional blur with hard-coded guassian blur kernel made with:
http://dev.theomader.com/gaussian-kernel-calculator/

Used for seperable 2D guassian blur passes.

See below, there is a larger kernel (costs more performance naturally)
as well as a tighter kernel alraedy commented out.
*/
Shader "Hidden/directionalblur"
{
    Properties
    {
        uDirection ("Direction", Vector) = (1.0, 0.0, 0.0, 0.0)
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

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            uniform sampler2D uImage0;
            uniform float2 uDirection;

#if 1
            static const int N = 6;
            static const float weights[7] = {
                0.197641, 0.174868, 0.121117, 0.065666, 0.027867, 0.009255, 0.002406 }; // S 2
#else
            static const int N = 3;
            static const float weights[4] = {
                // 0.383103, 0.241843, 0.060626, 0.00598 }; // S 1
                0.214607, 0.189879, 0.131514, 0.071303 }; // S 2
#endif

            float4 frag(v2f i) : SV_Target
            {
                i.uv -= i.uv * (1.0 / _ScreenParams);
                fixed4 c = (0.0).xxxx;
                for(int j = -N; j <= N; ++j)
                    c += tex2D(uImage0, i.uv + (uDirection * (float)j + 0.5) / _ScreenParams) * weights[abs(j)];
                return c;
            }
            ENDCG
        }
    }
}
