Shader "Custom/Grayscale"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Cutoff ("Cutoff Threshold", Range(0,1)) = 0.05
    }

    SubShader
    {
        Tags 
        { 
            "RenderPipeline"="UniversalPipeline"
            "RenderType" = "TransparentCutout"
            "Queue" = "AlphaTest"
        }

        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }

            ZWrite On
            Blend Off
            Cull Off

            HLSLPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Grayscale.hlsl"
            
            ENDHLSL
        }
    }
}