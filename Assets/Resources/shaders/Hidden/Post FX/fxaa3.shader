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

This was ported from my SqrMelon implementation (also MIT licensed)
https://github.com/trevorvanhoof/sqrmelon/blob/master/SqrMelon/defaultproject/Templates/default/fxaa3.glsl

Which in turn is a minification of a specific setting in FXAA3.11 by Timothy Lottes
https://developer.download.nvidia.com/assets/gamedev/files/sdk/11/FXAA_WhitePaper.pdf
https://gist.github.com/kosua20/0c506b81b3812ac900048059d2383126

The original code is public domain
https://stackoverflow.com/questions/12170575/using-nvidia-fxaa-in-my-code-whats-the-licensing-model
*/
Shader "Hidden/fxaa3"
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

#define bb(a)tex2D(uImage0,a)
#define cc(a)aa(tex2D(uImage0,a).rgb)
#define dd(a,b)aa(tex2D(uImage0,a+(b*c)).rgb)
#define ee(Q) v=abs(d)>=g;w=abs(h)>=g;if(!v)u.x-=t.x*Q;if(!v)u.y-=t.y*Q;x=(!v)||(!w);if(!w)s.x+=t.x*Q;if(!w)s.y+=t.y*Q;
#define ff if(!v)d=cc(u.xy);if(!w)h=cc(s.xy);if(!v)d=d-f*.5;if(!w)h=h-f*.5;
float aa(float3 a){float3 b=float3(.299,.587,.114);return dot(a,b);}
            
            float4 frag(v2f inpt) : SV_Target
            {
                float2 a=inpt.uv,
                    c=1/_ScreenParams;
                float4 b=bb(a);
                b.y=aa(b.rgb);
                float d=dd(a,float2(0,1)),
                    e=dd(a,float2(1,0)),
                    f=dd(a,float2(0,-1)),
                    g=dd(a,float2(-1,0)),
                    h=max(max(f,g),max(e,max(d,b.y))),
                    i=h-min(min(f,g),min(e,min(d,b.y)));
                if(i<max(.0833,h*.166))
                    return bb(a);
                h=dd(a,float2(-1,-1));
                float j=dd(a,float2( 1,1)),
                    k=dd(a,float2( 1,-1)),
                    l=dd(a,float2(-1,1)),
                    m=f+d,
                    n=g+e,
                    o=k+j,
                    p=h+l,
                    q=c.x;
                bool r=abs((-2*g)+p)+(abs((-2*b.y)+m)*2)+abs((-2*e)+o)>=abs((-2*d)+l+j)+(abs((-2*b.y)+n)*2)+abs((-2*f)+h+k);
                if(!r){
                    f=g;
                    d=e;
                }else
                    q=c.y;
                h=f-b.y,e=d-b.y,f=f+b.y,d=d+b.y,g=max(abs(h),abs(e));
                i=clamp((abs((((m+n)*2+p+o)*(1./12))-b.y)/i),0,1);
                if(abs(e)<abs(h))
                    q=-q;
                else
                    f=d;
                float2 s=a,
                    t=float2(!r?0:c.x,r?0:c.y);
                if(!r)
                    s.x+=q*.5;
                else
                    s.y+=q*.5;
                float2 u=float2(s.x-t.x,s.y-t.y);
                s=float2(s.x+t.x,s.y+t.y);
                j=((-2)*i)+3;
                d=cc(u);
                e=i*i;
                h=cc(s);
                g*=.25;
                i=b.y-f*.5;
                j=j*e;
                d-=f*.5;
                h-=f*.5;
                bool v,w,x,y=i<0;
                ee(1.5)if(x){
                    ff
                    ee(2.)
                    if(x){
                        ff 
                        ee(4.)
                        if(x){
                            ff 
                            ee(12.)
                        }
                    }
                }e=a.x-u.x;
                f=s.x-a.x;
                if(!r){
                    e=a.y-u.y;
                    f=s.y-a.y;
                }
                q*=max((e<f?(d<0)!=y:(h<0)!=y)?(min(e,f)*(-1/(f+e)))+.5:0,j*j*.75);
                if(!r)
                    a.x+=q;
                else
                    a.y+=q;
                return bb(a);
            }
            ENDCG
        }
    }
}
