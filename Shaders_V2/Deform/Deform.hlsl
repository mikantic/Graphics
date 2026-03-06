#ifndef DEFORM_INCLUDED
#define DEFORM_INCLUDED

#include "DeformHelper.hlsl"
#include "../Shading/Shading.hlsl"

Varyings DeformVertex(Attributes IN)
{
    Varyings OUT = Vertex(IN);
    OUT.positionCS = GetPositionCSDeformed(IN.positionOS, IN.normalOS, IN.uv);
    return OUT;
}

#endif