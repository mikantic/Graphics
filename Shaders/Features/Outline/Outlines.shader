Shader "Custom/Outlines"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _Color("Color", Color) = (1, 0, 0, 1)
        _Threshold("Threshold", Range(0.0001, 0.1)) = 0.01
    }

    SubShader
    {
        Pass
        {
            Tags 
            { 
                "RenderPipeline" = "UniversalPipeline"
                "Queue" = "Transparent+1"
            }

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest LEqual
            Cull Off

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Outlines.hlsl"
            ENDHLSL
        }
    }
}
