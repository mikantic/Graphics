Shader "Graphics/Outline"
{
    Properties
    {
        _Color ("Color", Color) = (0, 0, 0, 1)
        _Threshold ("Threshold", Float) = 1
        _Width ("Width", Float) = 3
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
            #pragma multi_compile_fog
            
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Outline.hlsl"
            ENDHLSL
        }
    }
}