Shader "Graphics/Transparent"
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

        _Alpha ("Alpha", Range(0, 1)) = 0.75
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
                "Queue" = "Transparent"
            }
            ZWrite On
            ZTest LEqual
            Blend SrcAlpha OneMinusSrcAlpha
            
            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fog

            #pragma vertex Vertex
            #pragma fragment TransparentFragment

            #include "Transparent.hlsl"
            
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