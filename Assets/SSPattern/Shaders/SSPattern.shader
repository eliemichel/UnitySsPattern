Shader "FX/SSPattern"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_PatternTex("Pattern", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
		_PatternRatio("PatternRatio", float) = 1.0
		_PatternSize("PatternSize", float) = 1.0

		[HideInInspector] _ScreenRatio("ScreenRatio", float) = 1.0
		[HideInInspector] _Distance("Distance", float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _PatternTex;
		float4 _PatternTex_TexelSize;

        struct Input
        {
            float2 uv_MainTex;
			float4 screenPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
		float _ScreenRatio;
		float _PatternRatio;
		float _PatternSize;
		float _Distance;
		float3 _SSPos;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			// Base color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			// Pattern
			float2 uv0 = ((IN.screenPos.xy / IN.screenPos.w * 2 - 1) - (_SSPos.xy * 2 - 1)) * 0.5 + 0.5;
			float ratio = _PatternRatio * _ScreenRatio * (_PatternTex_TexelSize.w / _PatternTex_TexelSize.z);
			uv0.x = (uv0.x - 0.5) * ratio + 0.5;
			uv0 -= 0.5;
			float2 uv1 = uv0 * _PatternSize * _Distance * 0.01;
			uv1 += 0.5;
			fixed4 p = tex2D(_PatternTex, uv1) * _Color;

            o.Albedo = c.rgb * p.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
