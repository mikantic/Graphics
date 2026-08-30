Shader "Graphics/Opaque"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "Empty" {}
        
        _Highlight ("Shine", Color) = (1, 1, 1, 1)
        _Light ("Lit", Color) = (1, 1, 1, 1)
        _Medium ("Tone", Color) = (1, 1, 1, 1)
        _Dark ("Core", Color) = (1, 1, 1, 1)
        _Darkest ("Cast", Color) = (1, 1, 1, 1)

        _RimWidth ("Rim Width", Float) = 0
        _RimAngle ("Rim Angle", Range(0.0, 0.5)) = 0.0

        _NoiseTex ("Noise", 2D) = "Empty" {}
        _HatchTex ("Hatch", 2D) = "Empty" {}
        
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