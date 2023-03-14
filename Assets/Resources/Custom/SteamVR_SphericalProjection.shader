Shader "Custom/SteamVR_SphericalProjection" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_N ("N (normal of plane)", Vector) = (0,0,0,0)
		_Phi0 ("Phi0", Float) = 0
		_Phi1 ("Phi1", Float) = 1
		_Theta0 ("Theta0", Float) = 0
		_Theta1 ("Theta1", Float) = 1
		_UAxis ("uAxis", Vector) = (0,0,0,0)
		_VAxis ("vAxis", Vector) = (0,0,0,0)
		_UOrigin ("uOrigin", Vector) = (0,0,0,0)
		_VOrigin ("vOrigin", Vector) = (0,0,0,0)
		_UScale ("uScale", Float) = 1
		_VScale ("vScale", Float) = 1
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		sampler2D _MainTex;
		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}