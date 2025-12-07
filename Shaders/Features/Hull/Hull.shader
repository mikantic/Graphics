Shader "Custom/Hull"
{
    Properties
    {
        _Thickness ("Thickness", float) = .1
        _Color ("Color", Color) = (1,1,1,1)
        _Amplifier ("Amplifier", float) = 0.2
        _Frequency ("Frequency", float) = 50
        _Seed ("Seed", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "RenderPipeline"="UniversalPipeline" "Queue"="Transparent" }

        Pass
        {
            Cull Front

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Hull.hlsl"

            ENDHLSL
        }
        
    }
}
