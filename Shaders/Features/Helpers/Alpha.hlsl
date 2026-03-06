// BaseAlpha.hlsl
#ifndef ALPHA_INCLUDED
#define ALPHA_INCLUDED

#include "Camera.hlsl"

float _Alpha;

float GetAlpha(float3 positionWS)
{
    if (DistanceToCamera(positionWS) < 1)
    {
        return 0;
    }
    return _Alpha;
}

#endif