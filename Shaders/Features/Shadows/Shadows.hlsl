#ifndef SHADOWS_INCLUDED
#define SHADOWS_INCLUDED

#include "../Helpers/Helpers.hlsl"

struct Attributes {
    float4 positionOS : POSITION;
};

struct Varyings {
    float4 positionCS : SV_POSITION;
};

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    OUT.positionCS = GetPositionCS(IN.positionOS);
    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    return 0;
}

#endif
