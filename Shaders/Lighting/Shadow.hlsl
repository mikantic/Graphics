#ifndef SHADOW_INCLUDED
#define SHADOW_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct Attributes {
    float4 positionOS : POSITION;
};

struct Varyings {
    float4 positionCS : SV_POSITION;
};

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    OUT.positionCS = TransformWorldToHClip(TransformObjectToWorld(IN.positionOS.xyz)); 
    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    return 0;
}

#endif
