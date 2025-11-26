Shader "Custom/Shading"
{
    Properties
    {
        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Pass
        {
            Name "Lighting"
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

            #include "Lighting.hlsl"
            
            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            #include "Shadow.hlsl"
            ENDHLSL
        }
    }
}
