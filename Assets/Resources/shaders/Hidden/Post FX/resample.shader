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

This is a super basic resampler that just takes 4 taps and averages them for the
poor-man's MSAA implementation in ResolutionOverride.cs
*/
Shader "Hidden/resample"
{
    Properties
    {
        _ResampleSettings ("Sample offset min-max (XY) and resolution blend (Z, 0 = src, 1 = dst, 2 is inverse), disable when resolution scale < 1 (W), I don't know how thos works so fuck around here to avoid recompiling", Vector) = (0.0, 1.0, 1.0, 0.0)
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
            // step size X, Y
            uniform float4 uRcp; 
            
            float4 frag(v2f i) : SV_Target
            {
                float2 X = float2(uRcp.x, 0.0);
                float2 Y = float2(0.0, uRcp.y);
                float4 og = tex2D(uImage0, i.uv);
                return max(0.0, tex2D(uImage0, i.uv + X) +
                        tex2D(uImage0, i.uv + Y) +
                        tex2D(uImage0, i.uv + uRcp) +
                        og) * 0.25;
            }
            ENDCG
        }
    }
}
