Shader "Graphics/Shading"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        
        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)

        _Scaler ("Scaler", Float) = 1

        _Rim ("Rim", Float) = 5
        _RimAngle ("Rime Angle", Float) = 0.7
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

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Shading.hlsl"
            
            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            #include "../Helpers/Default.hlsl"
            ENDHLSL
        }
    }
}