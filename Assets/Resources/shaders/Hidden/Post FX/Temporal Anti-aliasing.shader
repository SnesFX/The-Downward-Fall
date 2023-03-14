Shader "Hidden/Post FX/Temporal Anti-aliasing" {
	Properties {
		_MainTex ("", 2D) = "black" {}
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 39808
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
				float4 sv_target1 : SV_Target1;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _CameraDepthTexture_TexelSize;
			float2 _Jitter;
			float4 _SharpenParameters;
			float4 _FinalBlendParameters;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _CameraMotionVectorsTexture;
			sampler2D _MainTex;
			sampler2D _HistoryTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord.xzw = v.texcoord.xxy;
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
                float4 tmp4;
                float4 tmp5;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.yz = _Jitter * float2(1.0, -1.0);
                tmp0.xy = tmp0.xx ? tmp0.yz : _Jitter;
                tmp0.xy = inp.texcoord.xy - tmp0.xy;
                tmp0.zw = -_MainTex_TexelSize.xy * float2(0.5, 0.5) + tmp0.xy;
                tmp1.xyz = tex2D(_MainTex, tmp0.zw);
                tmp0.z = max(tmp1.z, tmp1.y);
                tmp0.z = max(tmp0.z, tmp1.x);
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = rcp(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.zw = _MainTex_TexelSize.xy * float2(0.5, 0.5) + tmp0.xy;
                tmp3.xyz = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tex2D(_MainTex, tmp0.zw);
                tmp0.w = max(tmp0.z, tmp0.y);
                tmp0.w = max(tmp0.w, tmp0.x);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = rcp(tmp0.w);
                tmp4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1.xyz = min(tmp2.xyz, tmp4.xyz);
                tmp2.xyz = max(tmp2.xyz, tmp4.xyz);
                tmp4.xyz = tmp3.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0) + -tmp4.xyz;
                tmp4.xyz = -tmp0.xyz * float3(0.166667, 0.166667, 0.166667) + tmp3.xyz;
                tmp4.xyz = tmp4.xyz * _SharpenParameters.xxx;
                tmp3.xyz = tmp4.xyz * float3(2.718282, 2.718282, 2.718282) + tmp3.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.142857, 0.142857, 0.142857);
                tmp0.w = max(tmp0.z, tmp0.y);
                tmp0.w = max(tmp0.w, tmp0.x);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = rcp(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.y = max(tmp3.z, tmp3.y);
                tmp0.y = max(tmp0.y, tmp3.x);
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = rcp(tmp0.y);
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp0.y = dot(tmp3.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.yzw = -abs(tmp0.xxx) * float3(4.0, 4.0, 4.0) + tmp1.xyz;
                tmp1.xyz = abs(tmp0.xxx) * float3(4.0, 4.0, 4.0) + tmp2.xyz;
                tmp2.xyz = tmp1.xyz - tmp0.yzw;
                tmp0.xyz = tmp0.yzw + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5);
                tmp2.xy = inp.texcoord.zw - _CameraDepthTexture_TexelSize.xy;
                tmp2.z = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp4.z = tex2D(_CameraDepthTexture, inp.texcoord.zw);
                tmp1.w = tmp2.z >= tmp4.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp2.xy = float2(-1.0, -1.0);
                tmp4.xy = float2(0.0, 0.0);
                tmp2.xyz = tmp2.xyz - tmp4.yyz;
                tmp2.xyz = tmp1.www * tmp2.xyz + tmp4.xyz;
                tmp4.xy = float2(1.0, -1.0);
                tmp5 = _CameraDepthTexture_TexelSize * float4(1.0, -1.0, -1.0, 1.0) + inp.texcoord.zwzw;
                tmp4.z = tex2D(_CameraDepthTexture, tmp5.xy);
                tmp5.z = tex2D(_CameraDepthTexture, tmp5.zw);
                tmp1.w = tmp4.z >= tmp2.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp4.xyz = tmp4.xyz - tmp2.yyz;
                tmp2.xyz = tmp1.www * tmp4.xyz + tmp2.xyz;
                tmp5.xyw = float3(-1.0, 1.0, 0.0);
                tmp1.w = tmp5.z >= tmp2.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp4.xyz = tmp5.xyz - tmp2.xyz;
                tmp2.xyz = tmp1.www * tmp4.xyz + tmp2.xyz;
                tmp4.xy = inp.texcoord.zw + _CameraDepthTexture_TexelSize.xy;
                tmp1.w = tex2D(_CameraDepthTexture, tmp4.xy);
                tmp1.w = tmp1.w >= tmp2.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp2.zw = float2(1.0, 1.0) - tmp2.xy;
                tmp2.xy = tmp1.ww * tmp2.zw + tmp2.xy;
                tmp2.xy = tmp2.xy * _CameraDepthTexture_TexelSize.xy + inp.texcoord.zw;
                tmp2.xy = tex2D(_CameraMotionVectorsTexture, tmp2.xy);
                tmp2.zw = inp.texcoord.zw - tmp2.xy;
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = sqrt(tmp1.w);
                tmp2 = tex2D(_HistoryTex, tmp2.zw);
                tmp4.x = max(tmp2.z, tmp2.y);
                tmp4.x = max(tmp2.x, tmp4.x);
                tmp4.x = tmp4.x + 1.0;
                tmp4.x = rcp(tmp4.x);
                tmp5.xyz = tmp2.xyz * tmp4.xxx + -tmp0.xyz;
                tmp4.xyz = tmp2.xyz * tmp4.xxx;
                tmp0.w = tmp2.w;
                tmp1.xyz = tmp5.xyz / tmp1.xyz;
                tmp1.y = max(abs(tmp1.z), abs(tmp1.y));
                tmp1.x = max(tmp1.y, abs(tmp1.x));
                tmp2 = tmp5 / tmp1.xxxx;
                tmp1.x = tmp1.x > 1.0;
                tmp2 = tmp0 + tmp2;
                tmp4.w = tmp0.w;
                tmp0 = tmp1.xxxx ? tmp2 : tmp4;
                tmp1.x = -_MainTex_TexelSize.z * 0.002 + tmp1.w;
                tmp1.y = tmp1.w * _FinalBlendParameters.z;
                tmp1.z = _MainTex_TexelSize.z * 0.0015;
                tmp1.z = 1.0 / tmp1.z;
                tmp1.x = saturate(tmp1.z * tmp1.x);
                tmp1.z = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.z;
                tmp3.w = min(tmp1.x, 1.0);
                tmp0 = tmp0 - tmp3;
                tmp1.x = _FinalBlendParameters.y - _FinalBlendParameters.x;
                tmp1.x = tmp1.y * tmp1.x + _FinalBlendParameters.x;
                tmp1.x = max(tmp1.x, _FinalBlendParameters.y);
                tmp1.x = min(tmp1.x, _FinalBlendParameters.x);
                tmp0 = tmp1.xxxx * tmp0 + tmp3;
                tmp1.x = max(tmp0.z, tmp0.y);
                tmp1.x = max(tmp0.x, tmp1.x);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = rcp(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                o.sv_target1.xyz = tmp0.xyz;
                o.sv_target = tmp0;
                o.sv_target1.w = tmp0.w * 0.85;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 124378
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
				float4 sv_target1 : SV_Target1;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float2 _Jitter;
			float4 _SharpenParameters;
			float4 _FinalBlendParameters;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraMotionVectorsTexture;
			sampler2D _MainTex;
			sampler2D _HistoryTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord.xzw = v.texcoord.xxy;
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
                float4 tmp4;
                float4 tmp5;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.yz = _Jitter * float2(1.0, -1.0);
                tmp0.xy = tmp0.xx ? tmp0.yz : _Jitter;
                tmp0.xy = inp.texcoord.xy - tmp0.xy;
                tmp0.zw = -_MainTex_TexelSize.xy * float2(0.5, 0.5) + tmp0.xy;
                tmp1.xyz = tex2D(_MainTex, tmp0.zw);
                tmp0.z = max(tmp1.z, tmp1.y);
                tmp0.z = max(tmp0.z, tmp1.x);
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = rcp(tmp0.z);
                tmp2.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.zw = _MainTex_TexelSize.xy * float2(0.5, 0.5) + tmp0.xy;
                tmp3.xyz = tex2D(_MainTex, tmp0.xy);
                tmp0.xyz = tex2D(_MainTex, tmp0.zw);
                tmp0.w = max(tmp0.z, tmp0.y);
                tmp0.w = max(tmp0.w, tmp0.x);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = rcp(tmp0.w);
                tmp4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1.xyz = min(tmp2.xyz, tmp4.xyz);
                tmp2.xyz = max(tmp2.xyz, tmp4.xyz);
                tmp4.xyz = tmp3.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0) + -tmp4.xyz;
                tmp4.xyz = -tmp0.xyz * float3(0.166667, 0.166667, 0.166667) + tmp3.xyz;
                tmp4.xyz = tmp4.xyz * _SharpenParameters.xxx;
                tmp3.xyz = tmp4.xyz * float3(2.718282, 2.718282, 2.718282) + tmp3.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.142857, 0.142857, 0.142857);
                tmp0.w = max(tmp0.z, tmp0.y);
                tmp0.w = max(tmp0.w, tmp0.x);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = rcp(tmp0.w);
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.y = max(tmp3.z, tmp3.y);
                tmp0.y = max(tmp0.y, tmp3.x);
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = rcp(tmp0.y);
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp0.y = dot(tmp3.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.yzw = -abs(tmp0.xxx) * float3(4.0, 4.0, 4.0) + tmp1.xyz;
                tmp1.xyz = abs(tmp0.xxx) * float3(4.0, 4.0, 4.0) + tmp2.xyz;
                tmp2.xyz = tmp0.yzw + tmp1.xyz;
                tmp0.xyz = tmp1.xyz - tmp0.yzw;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5);
                tmp2.xy = tex2D(_CameraMotionVectorsTexture, inp.texcoord.zw);
                tmp2.zw = inp.texcoord.zw - tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp2 = tex2D(_HistoryTex, tmp2.zw);
                tmp4.x = max(tmp2.z, tmp2.y);
                tmp4.x = max(tmp2.x, tmp4.x);
                tmp4.x = tmp4.x + 1.0;
                tmp4.x = rcp(tmp4.x);
                tmp5.xyz = tmp2.xyz * tmp4.xxx + -tmp1.xyz;
                tmp4.xyz = tmp2.xyz * tmp4.xxx;
                tmp1.w = tmp2.w;
                tmp0.xyz = tmp5.xyz / tmp0.xyz;
                tmp0.y = max(abs(tmp0.z), abs(tmp0.y));
                tmp0.x = max(tmp0.y, abs(tmp0.x));
                tmp5.w = 0.0;
                tmp2 = tmp5 / tmp0.xxxx;
                tmp0.x = tmp0.x > 1.0;
                tmp2 = tmp1 + tmp2;
                tmp4.w = tmp1.w;
                tmp1 = tmp0.xxxx ? tmp2 : tmp4;
                tmp0.x = -_MainTex_TexelSize.z * 0.002 + tmp0.w;
                tmp0.y = tmp0.w * _FinalBlendParameters.z;
                tmp0.z = _MainTex_TexelSize.z * 0.0015;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.x = saturate(tmp0.z * tmp0.x);
                tmp0.z = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp3.w = min(tmp0.x, 1.0);
                tmp1 = tmp1 - tmp3;
                tmp0.x = _FinalBlendParameters.y - _FinalBlendParameters.x;
                tmp0.x = tmp0.y * tmp0.x + _FinalBlendParameters.x;
                tmp0.x = max(tmp0.x, _FinalBlendParameters.y);
                tmp0.x = min(tmp0.x, _FinalBlendParameters.x);
                tmp0 = tmp0.xxxx * tmp1 + tmp3;
                tmp1.x = max(tmp0.z, tmp0.y);
                tmp1.x = max(tmp0.x, tmp1.x);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = rcp(tmp1.x);
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                o.sv_target1.xyz = tmp0.xyz;
                o.sv_target = tmp0;
                o.sv_target1.w = tmp0.w * 0.85;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 170307
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
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
                tmp0.xyz = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 205383
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
				float4 sv_target1 : SV_Target1;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float4 _CameraDepthTexture_TexelSize;
			float2 _Jitter;
			float4 _SharpenParameters;
			float4 _FinalBlendParameters;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			sampler2D _CameraMotionVectorsTexture;
			sampler2D _MainTex;
			sampler2D _HistoryTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord.xzw = v.texcoord.xxy;
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
                float4 tmp4;
                float4 tmp5;
                float4 tmp6;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.yz = _Jitter * float2(1.0, -1.0);
                tmp0.xy = tmp0.xx ? tmp0.yz : _Jitter;
                tmp0.xy = inp.texcoord.xy - tmp0.xy;
                tmp0.zw = -_MainTex_TexelSize.xy * float2(0.5, 0.5) + tmp0.xy;
                tmp1 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = max(tmp1.z, tmp1.y);
                tmp0.z = max(tmp0.z, tmp1.x);
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = 1.0 / tmp0.z;
                tmp2.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.zw = _MainTex_TexelSize.xy * float2(0.5, 0.5) + tmp0.xy;
                tmp3 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0.w = max(tmp0.z, tmp0.y);
                tmp0.w = max(tmp0.w, tmp0.x);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1.xyz = min(tmp2.xyz, tmp4.xyz);
                tmp2.xyz = max(tmp2.xyz, tmp4.xyz);
                tmp4.xyz = tmp3.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0) + -tmp4.xyz;
                tmp4.xyz = -tmp0.xyz * float3(0.166667, 0.166667, 0.166667) + tmp3.xyz;
                tmp4.xyz = tmp4.xyz * _SharpenParameters.xxx;
                tmp3.xyz = tmp4.xyz * float3(2.718282, 2.718282, 2.718282) + tmp3.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.142857, 0.142857, 0.142857);
                tmp0.w = max(tmp0.z, tmp0.y);
                tmp0.w = max(tmp0.w, tmp0.x);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.y = max(tmp3.z, tmp3.y);
                tmp0.y = max(tmp0.y, tmp3.x);
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = 1.0 / tmp0.y;
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp0.y = dot(tmp3.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.yzw = -abs(tmp0.xxx) * float3(4.0, 4.0, 4.0) + tmp1.xyz;
                tmp1.xyz = abs(tmp0.xxx) * float3(4.0, 4.0, 4.0) + tmp2.xyz;
                tmp2.xyz = tmp1.xyz - tmp0.yzw;
                tmp0.xyz = tmp0.yzw + tmp1.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5);
                tmp2.xy = inp.texcoord.zw - _CameraDepthTexture_TexelSize.xy;
                tmp2 = tex2D(_CameraDepthTexture, tmp2.xy);
                tmp4 = tex2D(_CameraDepthTexture, inp.texcoord.zw);
                tmp1.w = tmp2.z >= tmp4.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp2.xy = float2(-1.0, -1.0);
                tmp4.xy = float2(0.0, 0.0);
                tmp2.xyz = tmp2.xyz - tmp4.yyz;
                tmp2.xyz = tmp1.www * tmp2.xyz + tmp4.xyz;
                tmp4.xy = float2(1.0, -1.0);
                tmp5 = _CameraDepthTexture_TexelSize * float4(1.0, -1.0, -1.0, 1.0) + inp.texcoord.zwzw;
                tmp6 = tex2D(_CameraDepthTexture, tmp5.xy);
                tmp5 = tex2D(_CameraDepthTexture, tmp5.zw);
                tmp4.z = tmp6.x;
                tmp1.w = tmp6.x >= tmp2.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp4.xyz = tmp4.xyz - tmp2.yyz;
                tmp2.xyz = tmp1.www * tmp4.xyz + tmp2.xyz;
                tmp5.xyw = float3(-1.0, 1.0, 0.0);
                tmp1.w = tmp5.z >= tmp2.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp4.xyz = tmp5.xyz - tmp2.xyz;
                tmp2.xyz = tmp1.www * tmp4.xyz + tmp2.xyz;
                tmp4.xy = inp.texcoord.zw + _CameraDepthTexture_TexelSize.xy;
                tmp4 = tex2D(_CameraDepthTexture, tmp4.xy);
                tmp1.w = tmp4.x >= tmp2.z;
                tmp1.w = tmp1.w ? 1.0 : 0.0;
                tmp2.zw = float2(1.0, 1.0) - tmp2.xy;
                tmp2.xy = tmp1.ww * tmp2.zw + tmp2.xy;
                tmp2.xy = tmp2.xy * _CameraDepthTexture_TexelSize.xy + inp.texcoord.zw;
                tmp2 = tex2D(_CameraMotionVectorsTexture, tmp2.xy);
                tmp2.zw = inp.texcoord.zw - tmp2.xy;
                tmp1.w = dot(tmp2.xy, tmp2.xy);
                tmp1.w = sqrt(tmp1.w);
                tmp2 = tex2D(_HistoryTex, tmp2.zw);
                tmp4.x = max(tmp2.z, tmp2.y);
                tmp4.x = max(tmp2.x, tmp4.x);
                tmp4.x = tmp4.x + 1.0;
                tmp4.x = 1.0 / tmp4.x;
                tmp5.xyz = tmp2.xyz * tmp4.xxx + -tmp0.xyz;
                tmp4.xyz = tmp2.xyz * tmp4.xxx;
                tmp0.w = tmp2.w;
                tmp1.xyz = tmp5.xyz / tmp1.xyz;
                tmp1.y = max(abs(tmp1.z), abs(tmp1.y));
                tmp1.x = max(tmp1.y, abs(tmp1.x));
                tmp2 = tmp5 / tmp1.xxxx;
                tmp1.x = tmp1.x > 1.0;
                tmp2 = tmp0 + tmp2;
                tmp4.w = tmp0.w;
                tmp0 = tmp1.xxxx ? tmp2 : tmp4;
                tmp1.x = -_MainTex_TexelSize.z * 0.002 + tmp1.w;
                tmp1.y = tmp1.w * _FinalBlendParameters.z;
                tmp1.z = _MainTex_TexelSize.z * 0.0015;
                tmp1.z = 1.0 / tmp1.z;
                tmp1.x = saturate(tmp1.z * tmp1.x);
                tmp1.z = tmp1.x * -2.0 + 3.0;
                tmp1.x = tmp1.x * tmp1.x;
                tmp1.x = tmp1.x * tmp1.z;
                tmp3.w = min(tmp1.x, 1.0);
                tmp0 = tmp0 - tmp3;
                tmp1.x = _FinalBlendParameters.y - _FinalBlendParameters.x;
                tmp1.x = tmp1.y * tmp1.x + _FinalBlendParameters.x;
                tmp1.x = max(tmp1.x, _FinalBlendParameters.y);
                tmp1.x = min(tmp1.x, _FinalBlendParameters.x);
                tmp0 = tmp1.xxxx * tmp0 + tmp3;
                tmp1.x = max(tmp0.z, tmp0.y);
                tmp1.x = max(tmp0.x, tmp1.x);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = 1.0 / tmp1.x;
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                o.sv_target1.xyz = tmp0.xyz;
                o.sv_target = tmp0;
                o.sv_target1.w = tmp0.w * 0.85;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 319200
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float4 texcoord : TEXCOORD0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
				float4 sv_target1 : SV_Target1;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float4 _MainTex_TexelSize;
			// $Globals ConstantBuffers for Fragment Shader
			float2 _Jitter;
			float4 _SharpenParameters;
			float4 _FinalBlendParameters;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraMotionVectorsTexture;
			sampler2D _MainTex;
			sampler2D _HistoryTex;
			
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
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.y = 1.0 - v.texcoord.y;
                o.texcoord.y = tmp0.x ? tmp0.y : v.texcoord.y;
                o.texcoord.xzw = v.texcoord.xxy;
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
                float4 tmp4;
                float4 tmp5;
                tmp0.x = _MainTex_TexelSize.y < 0.0;
                tmp0.yz = _Jitter * float2(1.0, -1.0);
                tmp0.xy = tmp0.xx ? tmp0.yz : _Jitter;
                tmp0.xy = inp.texcoord.xy - tmp0.xy;
                tmp0.zw = -_MainTex_TexelSize.xy * float2(0.5, 0.5) + tmp0.xy;
                tmp1 = tex2D(_MainTex, tmp0.zw);
                tmp0.z = max(tmp1.z, tmp1.y);
                tmp0.z = max(tmp0.z, tmp1.x);
                tmp0.z = tmp0.z + 1.0;
                tmp0.z = 1.0 / tmp0.z;
                tmp2.xyz = tmp0.zzz * tmp1.xyz;
                tmp0.zw = _MainTex_TexelSize.xy * float2(0.5, 0.5) + tmp0.xy;
                tmp3 = tex2D(_MainTex, tmp0.xy);
                tmp0 = tex2D(_MainTex, tmp0.zw);
                tmp0.w = max(tmp0.z, tmp0.y);
                tmp0.w = max(tmp0.w, tmp0.x);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp4.xyz = tmp0.www * tmp0.xyz;
                tmp0.xyz = tmp0.xyz + tmp1.xyz;
                tmp1.xyz = min(tmp2.xyz, tmp4.xyz);
                tmp2.xyz = max(tmp2.xyz, tmp4.xyz);
                tmp4.xyz = tmp3.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * float3(4.0, 4.0, 4.0) + -tmp4.xyz;
                tmp4.xyz = -tmp0.xyz * float3(0.166667, 0.166667, 0.166667) + tmp3.xyz;
                tmp4.xyz = tmp4.xyz * _SharpenParameters.xxx;
                tmp3.xyz = tmp4.xyz * float3(2.718282, 2.718282, 2.718282) + tmp3.xyz;
                tmp3.xyz = max(tmp3.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xyz = tmp0.xyz + tmp3.xyz;
                tmp0.xyz = tmp0.xyz * float3(0.142857, 0.142857, 0.142857);
                tmp0.w = max(tmp0.z, tmp0.y);
                tmp0.w = max(tmp0.w, tmp0.x);
                tmp0.w = tmp0.w + 1.0;
                tmp0.w = 1.0 / tmp0.w;
                tmp0.xyz = tmp0.www * tmp0.xyz;
                tmp0.x = dot(tmp0.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.y = max(tmp3.z, tmp3.y);
                tmp0.y = max(tmp0.y, tmp3.x);
                tmp0.y = tmp0.y + 1.0;
                tmp0.y = 1.0 / tmp0.y;
                tmp3.xyz = tmp0.yyy * tmp3.xyz;
                tmp0.y = dot(tmp3.xyz, float3(0.0396819, 0.4580218, 0.0060965));
                tmp0.x = tmp0.x - tmp0.y;
                tmp0.yzw = -abs(tmp0.xxx) * float3(4.0, 4.0, 4.0) + tmp1.xyz;
                tmp1.xyz = abs(tmp0.xxx) * float3(4.0, 4.0, 4.0) + tmp2.xyz;
                tmp2.xyz = tmp0.yzw + tmp1.xyz;
                tmp0.xyz = tmp1.xyz - tmp0.yzw;
                tmp0.xyz = tmp0.xyz * float3(0.5, 0.5, 0.5);
                tmp1.xyz = tmp2.xyz * float3(0.5, 0.5, 0.5);
                tmp2 = tex2D(_CameraMotionVectorsTexture, inp.texcoord.zw);
                tmp2.zw = inp.texcoord.zw - tmp2.xy;
                tmp0.w = dot(tmp2.xy, tmp2.xy);
                tmp0.w = sqrt(tmp0.w);
                tmp2 = tex2D(_HistoryTex, tmp2.zw);
                tmp4.x = max(tmp2.z, tmp2.y);
                tmp4.x = max(tmp2.x, tmp4.x);
                tmp4.x = tmp4.x + 1.0;
                tmp4.x = 1.0 / tmp4.x;
                tmp5.xyz = tmp2.xyz * tmp4.xxx + -tmp1.xyz;
                tmp4.xyz = tmp2.xyz * tmp4.xxx;
                tmp1.w = tmp2.w;
                tmp0.xyz = tmp5.xyz / tmp0.xyz;
                tmp0.y = max(abs(tmp0.z), abs(tmp0.y));
                tmp0.x = max(tmp0.y, abs(tmp0.x));
                tmp5.w = 0.0;
                tmp2 = tmp5 / tmp0.xxxx;
                tmp0.x = tmp0.x > 1.0;
                tmp2 = tmp1 + tmp2;
                tmp4.w = tmp1.w;
                tmp1 = tmp0.xxxx ? tmp2 : tmp4;
                tmp0.x = -_MainTex_TexelSize.z * 0.002 + tmp0.w;
                tmp0.y = tmp0.w * _FinalBlendParameters.z;
                tmp0.z = _MainTex_TexelSize.z * 0.0015;
                tmp0.z = 1.0 / tmp0.z;
                tmp0.x = saturate(tmp0.z * tmp0.x);
                tmp0.z = tmp0.x * -2.0 + 3.0;
                tmp0.x = tmp0.x * tmp0.x;
                tmp0.x = tmp0.x * tmp0.z;
                tmp3.w = min(tmp0.x, 1.0);
                tmp1 = tmp1 - tmp3;
                tmp0.x = _FinalBlendParameters.y - _FinalBlendParameters.x;
                tmp0.x = tmp0.y * tmp0.x + _FinalBlendParameters.x;
                tmp0.x = max(tmp0.x, _FinalBlendParameters.y);
                tmp0.x = min(tmp0.x, _FinalBlendParameters.x);
                tmp0 = tmp0.xxxx * tmp1 + tmp3;
                tmp1.x = max(tmp0.z, tmp0.y);
                tmp1.x = max(tmp0.x, tmp1.x);
                tmp1.x = 1.0 - tmp1.x;
                tmp1.x = 1.0 / tmp1.x;
                tmp0.xyz = tmp0.xyz * tmp1.xxx;
                o.sv_target1.xyz = tmp0.xyz;
                o.sv_target = tmp0;
                o.sv_target1.w = tmp0.w * 0.85;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 356975
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
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			
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
                tmp0 = tex2D(_MainTex, inp.texcoord.xy);
                o.sv_target.xyz = tmp0.xyz;
                o.sv_target.w = 0.0;
                return o;
			}
			ENDCG
		}
	}
}