#ifndef HELPER_INCLUDED
#define HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

float3 GetNormalWS(float3 normalOS)
{
    return normalize(TransformObjectToWorldNormal(normalOS));
};

float4 GetPositionCS(float4 positionOS)
{
    return TransformObjectToHClip(positionOS);
};

float3 GetPositionWS(float4 positionOS)
{
    VertexPositionInputs vertexInput = GetVertexPositionInputs(positionOS.xyz);
    return vertexInput.positionWS;
};

float rand(float3 co)
{
    return frac(sin(dot(co ,float3(12.9898,78.233, 37.719))) * 43758.5453);
}

#endif