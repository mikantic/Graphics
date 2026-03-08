Shader "Graphics/Outline"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Threshold ("Threshold", Float) = 1
        _Width ("Width", Float) = 3
        _Darkness ("Darkness", Float) = 1
    }

    SubShader
    {
        Pass
        {
            Tags { "RenderPipeline"="UniversalPipeline" }

            ZWrite Off
            ZTest Always
            Cull Off
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Outline.hlsl"
            ENDHLSL
        }
    }
}