Shader "Custom/Liquid"
{
    Properties
    {
        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)
        _Threshold ("Threshold", Range(0.001, 100)) = 0.3
        _Alpha ("Alpha", Range(0, 1)) = 1
        _Height ("Height", Range(0, 1)) = 0.5
        _NoiseMap ("NoiseMap", 2D) = "white" {}
        _WaveMap ("WaveMap", 2D) = "white" {}
    }

    SubShader
    {
        Pass
        {
            Tags
            {
                "RenderType" = "Transparent"
                "Queue" = "Transparent"
            }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            #include "Liquid.hlsl"
            ENDHLSL
        }

        Pass
        {
            Tags { "LightMode"="ShadowCaster" }

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            #include "../Shadows/Shadows.hlsl"
            ENDHLSL
        }
    }
}
