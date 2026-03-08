Shader "Graphics/Instance"
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

        _Shape ("Shape", 2D) = "white" {}
    }

    SubShader
    {
        Pass
        {
            Tags 
            { 
                "LightMode" = "UniversalForward"
                "RenderPipeline"="UniversalPipeline"
                "RenderType"="Opaque" 
                "SurfaceType" = "Cutout"
            }
            ZTest LEqual
            ZWrite On
            Cull Back

            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_instancing

            #pragma vertex InstanceVertex
            #pragma fragment InstanceFragment

            #include "Instance.hlsl"
           
            ENDHLSL
        }
    }
}