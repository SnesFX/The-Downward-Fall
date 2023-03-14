Shader "Hidden/Post FX/Builtin Debug Views" {
	Properties {
	}
	SubShader {
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 29575
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
			float4 _CameraDepthTexture_ST;
			float _DepthScale;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthTexture;
			
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
                tmp0.xy = inp.texcoord.xy * _CameraDepthTexture_ST.xy + _CameraDepthTexture_ST.zw;
                tmp0 = tex2D(_CameraDepthTexture, tmp0.xy);
                tmp0.x = _ZBufferParams.x * tmp0.x + _ZBufferParams.y;
                tmp0.x = 1.0 / tmp0.x;
                tmp0.x = tmp0.x * _DepthScale;
                tmp0.y = tmp0.x * 0.305306 + 0.6821711;
                tmp0.y = tmp0.x * tmp0.y + 0.0125229;
                o.sv_target.xyz = tmp0.yyy * tmp0.xxx;
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 73083
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
			float4 _CameraDepthNormalsTexture_ST;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _CameraDepthNormalsTexture;
			
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
                tmp0.xy = inp.texcoord.xy * _CameraDepthNormalsTexture_ST.xy + _CameraDepthNormalsTexture_ST.zw;
                tmp0 = tex2D(_CameraDepthNormalsTexture, tmp0.xy);
                tmp0.xyz = tmp0.xyz * float3(3.5554, 3.5554, 0.0) + float3(-1.7777, -1.7777, 1.0);
                tmp0.z = dot(tmp0.xyz, tmp0.xyz);
                tmp0.z = 2.0 / tmp0.z;
                tmp1.xy = tmp0.xy * tmp0.zz;
                tmp1.z = tmp0.z - 1.0;
                o.sv_target.xyz = tmp1.xyz * float3(1.0, 1.0, -1.0);
                o.sv_target.w = 1.0;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 174527
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
			float _Opacity;
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
                o.sv_target.xyz = tmp0.xyz * _Opacity.xxx;
                o.sv_target.w = tmp0.w;
                return o;
			}
			ENDCG
		}
		Pass {
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 208950
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
			float _Opacity;
			float _Amplitude;
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			// Texture params for Fragment Shader
			sampler2D _MainTex;
			sampler2D _CameraMotionVectorsTexture;
			
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
                tmp0 = tex2D(_CameraMotionVectorsTexture, inp.texcoord.xy);
                tmp0.yz = tmp0.xy * _Amplitude.xx;
                tmp0.xw = -tmp0.zz;
                tmp1.x = max(abs(tmp0.x), abs(tmp0.y));
                tmp1.x = 1.0 / tmp1.x;
                tmp1.y = min(abs(tmp0.x), abs(tmp0.y));
                tmp1.x = tmp1.x * tmp1.y;
                tmp1.y = tmp1.x * tmp1.x;
                tmp1.z = tmp1.y * 0.0208351 + -0.085133;
                tmp1.z = tmp1.y * tmp1.z + 0.180141;
                tmp1.z = tmp1.y * tmp1.z + -0.3302995;
                tmp1.y = tmp1.y * tmp1.z + 0.999866;
                tmp1.z = tmp1.y * tmp1.x;
                tmp1.z = tmp1.z * -2.0 + 1.570796;
                tmp1.w = abs(tmp0.x) < abs(tmp0.y);
                tmp1.z = tmp1.w ? tmp1.z : 0.0;
                tmp1.x = tmp1.x * tmp1.y + tmp1.z;
                tmp0.z = tmp0.x < tmp0.z;
                tmp0.z = tmp0.z ? -3.141593 : 0.0;
                tmp0.z = tmp0.z + tmp1.x;
                tmp1.x = min(tmp0.x, tmp0.y);
                tmp1.x = tmp1.x < -tmp1.x;
                tmp0.x = max(tmp0.x, tmp0.y);
                tmp0.y = dot(tmp0.xy, tmp0.xy);
                tmp0.y = sqrt(tmp0.y);
                tmp0.y = tmp0.y * _Opacity;
                tmp0.x = tmp0.x >= -tmp0.x;
                tmp0.x = tmp0.x ? tmp1.x : 0.0;
                tmp0.x = tmp0.x ? -tmp0.z : tmp0.z;
                tmp0.x = tmp0.x * 0.3183099 + 1.0;
                tmp0.xzw = tmp0.xxx * float3(3.0, 3.0, 3.0) + float3(-3.0, -2.0, -4.0);
                tmp0.xzw = saturate(abs(tmp0.xzw) * float3(1.0, -1.0, -1.0) + float3(-1.0, 2.0, 2.0));
                tmp1 = tex2D(_MainTex, inp.texcoord.xy);
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                o.sv_target.w = tmp1.w;
                tmp1.xyz = log(tmp1.xyz);
                tmp1.xyz = tmp1.xyz * float3(0.4166667, 0.4166667, 0.4166667);
                tmp1.xyz = exp(tmp1.xyz);
                tmp1.xyz = tmp1.xyz * float3(1.055, 1.055, 1.055) + float3(-0.055, -0.055, -0.055);
                tmp1.xyz = max(tmp1.xyz, float3(0.0, 0.0, 0.0));
                tmp0.xzw = tmp0.xzw - tmp1.xyz;
                tmp0.xyz = tmp0.yyy * tmp0.xzw + tmp1.xyz;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                o.sv_target.xyz = tmp0.xyz * tmp1.xyz;
                return o;
			}
			ENDCG
		}
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
			ZClip Off
			ZTest Always
			ZWrite Off
			Cull Off
			GpuProgramID 272815
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			struct v2f
			{
				float4 position : SV_POSITION0;
				float2 texcoord : TEXCOORD0;
				float4 color : COLOR0;
			};
			struct fout
			{
				float4 sv_target : SV_Target0;
			};
			// $Globals ConstantBuffers for Vertex Shader
			float _Opacity;
			float _Amplitude;
			float4 _Scale;
			// $Globals ConstantBuffers for Fragment Shader
			// Custom ConstantBuffers for Vertex Shader
			// Custom ConstantBuffers for Fragment Shader
			// Texture params for Vertex Shader
			sampler2D _CameraMotionVectorsTexture;
			// Texture params for Fragment Shader
			
			// Keywords: 
			v2f vert(appdata_full v)
			{
                v2f o;
                float4 tmp0;
                float4 tmp1;
                float4 tmp2;
                float4 tmp3;
                float4 tmp4;
                tmp0.y = -abs(v.vertex.x);
                tmp0.x = v.vertex.x;
                tmp0.zw = v.texcoord.xy * float2(1.0, -1.0) + float2(0.0, 1.0);
                tmp1 = tex2Dlod(_CameraMotionVectorsTexture, float4(tmp0.zw, 0, 0.0));
                tmp1.xy = tmp1.xy * _Amplitude.xx;
                tmp1.zw = -tmp1.yy;
                tmp0.z = dot(tmp1.xy, tmp1.xy);
                tmp0.w = sqrt(tmp0.z);
                tmp0.z = rsqrt(tmp0.z);
                tmp2.xy = tmp0.zz * tmp1.xw;
                tmp3.x = dot(tmp1.xy, v.vertex.xy);
                tmp0.xy = tmp0.ww * tmp0.xy;
                o.color.w = saturate(tmp0.w * _Opacity);
                tmp0.xy = tmp0.xy * float2(0.3, 0.3);
                tmp2.z = -tmp2.x;
                tmp4.y = dot(tmp2.xy, tmp0.xy);
                tmp4.x = dot(tmp2.xy, tmp0.xy);
                tmp0.xy = tmp4.xy * _Scale.xy;
                tmp3.y = dot(-tmp1.xy, v.vertex.xy);
                tmp0.xy = tmp3.xy * _Scale.xy + tmp0.xy;
                tmp0.xy = v.texcoord.xy * float2(2.0, 2.0) + tmp0.xy;
                tmp0.xy = tmp0.xy * _ScreenParams.xy;
                tmp0.xy = tmp0.xy * float2(0.5, 0.5);
                tmp0.xy = round(tmp0.xy);
                tmp0.zw = tmp0.xy + float2(0.5, 0.5);
                o.texcoord.xy = tmp0.xy;
                tmp0.xy = _ScreenParams.zw - float2(1.0, 1.0);
                tmp0.xy = tmp0.xy * tmp0.zw;
                o.position.xy = tmp0.xy * float2(2.0, 2.0) + float2(-1.0, -1.0);
                o.position.zw = float2(0.0, 1.0);
                tmp0.x = abs(tmp1.y);
                tmp0.y = max(tmp0.x, abs(tmp1.x));
                tmp0.y = 1.0 / tmp0.y;
                tmp0.z = min(tmp0.x, abs(tmp1.x));
                tmp0.x = tmp0.x < abs(tmp1.x);
                tmp0.y = tmp0.y * tmp0.z;
                tmp0.z = tmp0.y * tmp0.y;
                tmp0.w = tmp0.z * 0.0208351 + -0.085133;
                tmp0.w = tmp0.z * tmp0.w + 0.180141;
                tmp0.w = tmp0.z * tmp0.w + -0.3302995;
                tmp0.z = tmp0.z * tmp0.w + 0.999866;
                tmp0.w = tmp0.z * tmp0.y;
                tmp0.w = tmp0.w * -2.0 + 1.570796;
                tmp0.x = tmp0.x ? tmp0.w : 0.0;
                tmp0.x = tmp0.y * tmp0.z + tmp0.x;
                tmp0.y = -tmp1.y < tmp1.y;
                tmp0.y = tmp0.y ? -3.141593 : 0.0;
                tmp0.x = tmp0.y + tmp0.x;
                tmp0.y = min(-tmp1.y, tmp1.x);
                tmp0.z = max(-tmp1.y, tmp1.x);
                tmp0.z = tmp0.z >= -tmp0.z;
                tmp0.y = tmp0.y < -tmp0.y;
                tmp0.y = tmp0.z ? tmp0.y : 0.0;
                tmp0.x = tmp0.y ? -tmp0.x : tmp0.x;
                tmp0.x = tmp0.x * 0.3183099 + 1.0;
                tmp0.xyz = tmp0.xxx * float3(3.0, 3.0, 3.0) + float3(-3.0, -2.0, -4.0);
                tmp0.xyz = saturate(abs(tmp0.xyz) * float3(1.0, -1.0, -1.0) + float3(-1.0, 2.0, 2.0));
                tmp1.xyz = float3(1.0, 1.0, 1.0) - tmp0.xyz;
                tmp0.xyz = tmp1.xyz * float3(0.5, 0.5, 0.5) + tmp0.xyz;
                tmp1.xyz = tmp0.xyz * float3(0.305306, 0.305306, 0.305306) + float3(0.6821711, 0.6821711, 0.6821711);
                tmp1.xyz = tmp0.xyz * tmp1.xyz + float3(0.0125229, 0.0125229, 0.0125229);
                o.color.xyz = saturate(tmp0.xyz * tmp1.xyz);
                return o;
			}
			// Keywords: 
			fout frag(v2f inp)
			{
                fout o;
                float4 tmp0;
                tmp0.xy = frac(inp.texcoord.xy);
                tmp0.xy = tmp0.xy - float2(0.5, 0.5);
                tmp0.x = dot(tmp0.xy, tmp0.xy);
                tmp0.x = sqrt(tmp0.x);
                tmp0.y = tmp0.x * 0.4318331 + 0.6821711;
                tmp0.x = tmp0.x * 1.414427;
                tmp0.y = tmp0.x * tmp0.y + 0.0125229;
                tmp0.x = tmp0.y * tmp0.x;
                o.sv_target.w = tmp0.x * inp.color.w;
                o.sv_target.xyz = inp.color.xyz;
                return o;
			}
			ENDCG
		}
	}
}