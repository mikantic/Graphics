Shader "Custom/Grass"
{
    Properties
    {
        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)

        _LightMap ("LightMap", 2D) = "white" {}
        _NoiseMap ("NoiseMap", 2D) = "white" {}
        
        _MinNoise ("Minimum Noise", Float) = 0.6
        _HeightScaler ("Height Scaler", Float) = 2
    }
    SubShader
    {
        Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" }
        ZWrite On
        ZTest LEqual
        LOD 100
        Cull Off

        Pass
        {
            // Lighting Primer
            Tags { "LightMode" = "ShadowCaster" }
            HLSLPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "../Shadows/Shadows.hlsl"

            ENDHLSL
        }

        Pass
        {
            // Full Shading
            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma geometry Geometry
            #pragma fragment Fragment

            #include "Grass.hlsl"

            ENDHLSL
        }
    }
}
