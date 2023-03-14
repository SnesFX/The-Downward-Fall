Shader "Hidden/Post FX/Lut Generator" {
	Properties {
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 32179
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_ST;
			// $Globals ConstantBuffers for Fragment Shader
			float3 _Balance;
			float3 _Lift;
			float3 _InvGamma;
			float3 _Gain;
			float3 _Offset;
			float3 _Power;
			float3 _Slope;
			float _HueShift;
			float _Saturation;
			float _Contrast;
			float3 _ChannelMixerRed;
			float3 _ChannelMixerGreen;
			float3 _ChannelMixerBlue;
			float4 _LutParams;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _Curves;
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                tmp0 = v.vertex.yyyy * unity_ObjectToWorld._m01_m11_m21_m31;
                tmp0 = unity_ObjectToWorld._m00_m10_m20_m30 * v.vertex.xxxx + tmp0;
                tmp0 = unity_ObjectToWorld._m02_m12_m22_m32 * v.vertex.zzzz + tmp0;
                tmp0 = tmp0 + unity_ObjectToWorld._m03_m13_m23_m33;
                tmp1 = tmp0.yyyy * unity_MatrixVP._m01_m11_m21_m31;
                tmp1 = unity_MatrixVP._m00_m10_m20_m30 * tmp0.xxxx + tmp1;
                tmp1 = unity_MatrixVP._m02_m12_m22_m32 * tmp0.zzzz + tmp1;
                o.position = unity_MatrixVP._m03_m13_m23_m33 * tmp0.wwww + tmp1;
                o.texcoord1.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.texcoord.xy = v.texcoord.xy;
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                tmp0.yz = inp.texcoord.xy - _LutParams.yz;
                tmp1.x = tmp0.y * _LutParams.x;
                tmp0.x = frac(tmp1.x);
                tmp1.x = tmp0.x / _LutParams.x;
                tmp0.w = tmp0.y - tmp1.x;
                tmp0.xyz = tmp0.xzw * _LutParams.www + float3(-0.386036, -0.386036, -0.386036);
                tmp0.xyz = tmp0.xyz * float3(13.60548, 13.60548, 13.60548);
                tmp0.xyz = exp(tmp0.xyz);
                tmp0.xyz = tmp0.xyz - float3(0.047996, 0.047996, 0.047996);
                tmp0.xyz = tmp0.xyz * float3(0.18, 0.18, 0.18);
                tmp1.x = dot(float3(0.439701, 0.382978, 0.177335), tmp0.xyz);
                tmp1.y = dot(float3(0.0897923, 0.813423, 0.0967616), tmp0.xyz);
                tmp1.z = dot(float3(0.017544, 0.111544, 0.870704), tmp0.xyz);
                tmp0.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = min(tmp0.xyz, float3(65504.0, 65504.0, 65504.0));
                tmp1.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5) + float3(0.0000153, 0.0000153, 0.0000153);
                tmp1.xyz = log(tmp1.xyz);
                tmp1.xyz = tmp1.xyz + float3(9.72, 9.72, 9.72);
                tmp1.xyz = tmp1.xyz * float3(0.0570776, 0.0570776, 0.0570776);
                tmp2.xyz = log(tmp0.xyz);
                tmp0.xyz = tmp0.xyz < float3(0.0000305, 0.0000305, 0.0000305);
                tmp2.xyz = tmp2.xyz + float3(9.72, 9.72, 9.72);
                tmp2.xyz = tmp2.xyz * float3(0.0570776, 0.0570776, 0.0570776);
                tmp0.xyz = tmp0.xyz ? tmp1.xyz : tmp2.xyz;
                tmp0.xyz = tmp0.xyz * _Slope + _Offset;
                tmp1.xyz = log(tmp0.xyz);
                tmp1.xyz = tmp1.xyz * _Power;
                tmp1.xyz = exp(tmp1.xyz);
                tmp2.xyz = tmp0.xyz > float3(0.0, 0.0, 0.0);
                tmp0.xyz = tmp2.xyz ? tmp1.xyz : tmp0.xyz;
                tmp0.w = tmp0.y >= tmp0.z;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp1.xy = tmp0.zy;
                tmp2.xy = tmp0.yz - tmp1.xy;
                tmp1.zw = float2(-1.0, 0.6666667);
                tmp2.zw = float2(1.0, -1.0);
                tmp1 = tmp0.wwww * tmp2.xywz + tmp1.xywz;
                tmp0.w = tmp0.x >= tmp1.x;
                tmp0.w = tmp0.w ? 1.0 : 0.0;
                tmp2.z = tmp1.w;
                tmp1.w = tmp0.x;
                tmp2.xyw = tmp1.wyx;
                tmp2 = tmp2 - tmp1;
                tmp1 = tmp0.wwww * tmp2 + tmp1;
                tmp0.w = min(tmp1.y, tmp1.w);
                tmp0.w = tmp1.x - tmp0.w;
                tmp2.x = tmp0.w * 6.0 + 0.0001;
                tmp1.y = tmp1.w - tmp1.y;
                tmp1.y = tmp1.y / tmp2.x;
                tmp1.y = tmp1.y + tmp1.z;
                tmp1.x = tmp1.x + 0.0001;
                tmp2.z = tmp0.w / tmp1.x;
                tmp2.x = abs(tmp1.y);
                tmp2.yw = float2(0.25, 0.25);
                tmp1 = tex2D(_Curves, tmp2.xy);
                tmp2 = tex2D(_Curves, tmp2.zw);
                tmp2.x = saturate(tmp2.x);
                tmp0.w = tmp2.x + tmp2.x;
                tmp1.x = saturate(tmp1.x);
                tmp1.x = tmp1.x + tmp1.x;
                tmp0.w = tmp0.w * tmp1.x;
                tmp1.x = dot(tmp0.xyz, float3(0.2126, 0.7152, 0.0722));
                tmp0.xyz = tmp0.xyz - tmp1.xxx;
                tmp1.yw = float2(0.25, 0.25);
                tmp2 = tex2D(_Curves, tmp1.xy);
                tmp2.x = saturate(tmp2.x);
                tmp1.y = tmp2.x + tmp2.x;
                tmp0.w = tmp0.w * tmp1.y;
                tmp0.w = tmp0.w * _Saturation;
                tmp0.xyz = tmp0.www * tmp0.xyz + tmp1.xxx;
                tmp0.xyz = tmp0.xyz - float3(0.4135884, 0.4135884, 0.4135884);
                tmp0.xyz = tmp0.xyz * _Contrast.xxx + float3(0.4135884, 0.4135884, 0.4135884);
                tmp2 = tmp0.xxyy < float4(-0.3013699, 1.467996, -0.3013699, 1.467996);
                tmp0.xyw = tmp0.xyz * float3(17.52, 17.52, 17.52) + float3(-9.72, -9.72, -9.72);
                tmp1.xy = tmp0.zz < float2(-0.3013699, 1.467996);
                tmp0.xyz = exp(tmp0.xyw);
                tmp2.yw = tmp2.yw ? tmp0.xy : float2(65504.0, 65504.0);
                tmp0.xyw = tmp0.xyz - float3(0.0000153, 0.0000153, 0.0000153);
                tmp0.z = tmp1.y ? tmp0.z : 65504.0;
                tmp0.xyw = tmp0.xyw + tmp0.xyw;
                tmp2.xy = tmp2.xz ? tmp0.xy : tmp2.yw;
                tmp2.z = tmp1.x ? tmp0.w : tmp0.z;
                tmp0.x = dot(float3(1.451439, -0.2365108, -0.2149286), tmp2.xyz);
                tmp0.y = dot(float3(-0.0765538, 1.17623, -0.0996759), tmp2.xyz);
                tmp0.z = dot(float3(0.0083161, -0.0060325, 0.9977163), tmp2.xyz);
                tmp2.x = dot(float3(0.390405, 0.549941, 0.0089263), tmp0.xyz);
                tmp2.y = dot(float3(0.0708416, 0.963172, 0.0013578), tmp0.xyz);
                tmp2.z = dot(float3(0.0231082, 0.128021, 0.936245), tmp0.xyz);
                tmp0.xyz = tmp2.xyz * _Balance;
                tmp2.x = dot(float3(2.85847, -1.62879, -0.024891), tmp0.xyz);
                tmp2.y = dot(float3(-0.210182, 1.1582, 0.0003243), tmp0.xyz);
                tmp2.z = dot(float3(-0.041812, -0.118169, 1.06867), tmp0.xyz);
                tmp0.xyz = float3(1.0, 1.0, 1.0) - _Lift;
                tmp0.xyz = tmp0.xyz * _Gain;
                tmp3.xyz = _Lift * _Gain;
                tmp0.xyz = tmp2.xyz * tmp0.xyz + tmp3.xyz;
                tmp2.xyz = log(tmp0.xyz);
                tmp2.xyz = tmp2.xyz * _InvGamma;
                tmp2.xyz = exp(tmp2.xyz);
                tmp3.xyz = tmp0.xyz > float3(0.0, 0.0, 0.0);
                tmp0.xyz = tmp3.xyz ? tmp2.xyz : tmp0.xyz;
                tmp0.xyw = max(tmp0.yzx, float3(0.0, 0.0, 0.0));
                tmp1.x = tmp0.x >= tmp0.y;
                tmp1.x = tmp1.x ? 1.0 : 0.0;
                tmp2.xy = tmp0.yx;
                tmp3.xy = tmp0.xy - tmp2.xy;
                tmp2.zw = float2(-1.0, 0.6666667);
                tmp3.zw = float2(1.0, -1.0);
                tmp2 = tmp1.xxxx * tmp3 + tmp2;
                tmp1.x = tmp0.w >= tmp2.x;
                tmp1.x = tmp1.x ? 1.0 : 0.0;
                tmp0.xyz = tmp2.xyw;
                tmp2.xyw = tmp0.wyx;
                tmp2 = tmp2 - tmp0;
                tmp0 = tmp1.xxxx * tmp2 + tmp0;
                tmp1.x = min(tmp0.y, tmp0.w);
                tmp1.x = tmp0.x - tmp1.x;
                tmp1.y = tmp1.x * 6.0 + 0.0001;
                tmp0.y = tmp0.w - tmp0.y;
                tmp0.y = tmp0.y / tmp1.y;
                tmp0.y = tmp0.y + tmp0.z;
                tmp1.z = abs(tmp0.y) + _HueShift;
                tmp2 = tex2D(_Curves, tmp1.zw);
                tmp2.x = saturate(tmp2.x);
                tmp0.y = tmp2.x - 0.5;
                tmp0.y = tmp0.y + tmp1.z;
                tmp0.z = tmp0.y > 1.0;
                tmp1.yz = tmp0.yy + float2(1.0, -1.0);
                tmp0.z = tmp0.z ? tmp1.z : tmp0.y;
                tmp0.y = tmp0.y < 0.0;
                tmp0.y = tmp0.y ? tmp1.y : tmp0.z;
                tmp0.yzw = tmp0.yyy + float3(1.0, 0.6666667, 0.3333333);
                tmp0.yzw = frac(tmp0.yzw);
                tmp0.yzw = tmp0.yzw * float3(6.0, 6.0, 6.0) + float3(-3.0, -3.0, -3.0);
                tmp0.yzw = saturate(abs(tmp0.yzw) - float3(1.0, 1.0, 1.0));
                tmp0.yzw = tmp0.yzw - float3(1.0, 1.0, 1.0);
                tmp1.y = tmp0.x + 0.0001;
                tmp1.x = tmp1.x / tmp1.y;
                tmp0.yzw = tmp1.xxx * tmp0.yzw + float3(1.0, 1.0, 1.0);
                tmp0.xyz = tmp0.yzw * tmp0.xxx;
                tmp1.x = dot(tmp0.xyz, _ChannelMixerRed);
                tmp1.y = dot(tmp0.xyz, _ChannelMixerGreen);
                tmp1.z = dot(tmp0.xyz, _ChannelMixerBlue);
                tmp0.x = dot(float3(1.70505, -0.62179, -0.08326), tmp1.xyz);
                tmp0.y = dot(float3(-0.13026, 1.1408, -0.01055), tmp1.xyz);
                tmp0.z = dot(float3(-0.024, -0.12897, 1.15297), tmp1.xyz);
                tmp0.xyz = tmp0.xyz + float3(0.0039063, 0.0039063, 0.0039063);
                tmp0.w = 0.75;
                tmp1 = tex2D(_Curves, tmp0.xw);
                tmp1.x = saturate(tmp1.x);
                tmp2 = tex2D(_Curves, tmp0.yw);
                tmp0 = tex2D(_Curves, tmp0.zw);
                tmp1.z = saturate(tmp0.w);
                tmp1.y = saturate(tmp2.w);
                tmp0.xyz = tmp1.xyz + float3(0.0039063, 0.0039063, 0.0039063);
                tmp0.w = 0.75;
                tmp1 = tex2D(_Curves, tmp0.xw);
                o.sv_target.x = saturate(tmp1.x);
                tmp1 = tex2D(_Curves, tmp0.yw);
                tmp0 = tex2D(_Curves, tmp0.zw);
                o.sv_target.z = saturate(tmp0.z);
                o.sv_target.y = saturate(tmp1.y);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
	}
}