#ifndef DEPTH_INCLUDED
#define DEPTH_INCLUDED

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

// Fragment is never called for depth-only pass in URP/HDRP, but must exist
float4 Fragment(Varyings IN) : SV_Target
{
    return 0;
}

#endif