#ifndef HELPER_INCLUDED
#define HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

float4 GetPositionCS(float4 positionOS)
{
    return TransformObjectToHClip(positionOS);
};

#endif