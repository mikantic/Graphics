Shader "Custom/Crystal"
{
    Properties
    {
        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)
        _Power ("Power", Range(0, 5)) = 1
        _Alpha ("Alpha", Range(0, 1)) = 0.75
        _Sharpness ("Sharpness", Range(0, 5)) = 1
        _LightMap ("LightMap", 2D) = "white" {}
        _NoiseMap ("NoiseMap", 2D) = "white" {}
    }

    SubShader
    {
        Pass
        {
            Tags 
            { 
                "LightMode" = "UniversalForward"
                "RenderPipeline"="UniversalPipeline"
                "RenderType" = "Transparent"
            }
            ZWrite On
            ZTest LEqual
            Blend SrcAlpha OneMinusSrcAlpha
            //Cull Off
            
            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Crystal.hlsl"
            
            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            #include "../Shadows/Shadows.hlsl"
            ENDHLSL
        }
    }
}
