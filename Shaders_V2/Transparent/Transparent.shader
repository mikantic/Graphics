Shader "Graphics/Transparent"
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
        _Alpha ("Alpha", Range(0, 1)) = 0.75

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
                "RenderType" = "Transparent"
            }
            ZWrite On
            ZTest LEqual
            Blend SrcAlpha OneMinusSrcAlpha
            
            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment
            // to do: could potentially rename these to specifics like TransparentFragment which then takes the output of ShadingFragment and adds Alpha to it... and in Shading.Shader it pragmas ShadingFragment, etc
            // even better code sharing!!! wicked smaht 

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
            #include "../Helpers/Default.hlsl"
            ENDHLSL
        }
    }
}