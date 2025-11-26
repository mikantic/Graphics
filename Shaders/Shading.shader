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
            }
            
            ZWrite On
            ZTest LEqual
            

            HLSLPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Lighting/Lighting.hlsl"
            
            ENDHLSL
        }
    }
}
