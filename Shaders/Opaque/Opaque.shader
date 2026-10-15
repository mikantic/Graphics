Shader "Graphics/Opaque"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "Empty" {}
        
        _Light ("Light", Color) = (1, 1, 1, 1)
        _Medium ("Medium", Color) = (1, 1, 1, 1)
        _Dark ("Dark", Color) = (1, 1, 1, 1)        
    }

    SubShader
    {
        Pass
        {
            Tags 
            { 
                "LightMode" = "UniversalForward"
                "RenderPipeline"="UniversalPipeline"
                "RenderType" = "Opaque"
            }
            ZWrite On
            ZTest LEqual
            
            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fog

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Opaque.hlsl"
            
            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            #include "../Depth/Default.hlsl"
            ENDHLSL
        }
    }
}