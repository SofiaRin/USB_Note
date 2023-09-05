Shader "Custom/MDPKeWordEnum"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        // keywordEnum
        [KeywordEnum(Off,Red,Blue)]
        _Options("Color Options",Float) = 0
        // Enum
        [Enum(none,0,Front,1,Back,2)]
        _Face("Face Culling",Float) = 0
        // PowerSlider
        [PowerSlider(3.)]
        _Boost ("Boost",Range(0.01,1)) = 0.04
        // IntRange
        [IntRange]
        _Samples("Samples",Range(0,255)) = 100
    }
    SubShader
    {
        // Use Enum property as a command
        Cull [_Face]
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED _OPTIONS_BLUE

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _Boost;
        int _Samples;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables

            #if _OPTIONS_OFF

            #elif _OPTIONS_RED
                 o.Albedo = float3(1,0,0);
            #elif _OPTIONS_BLUE
                 o.Albedo = float3(0,0,1);
            #endif


            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
