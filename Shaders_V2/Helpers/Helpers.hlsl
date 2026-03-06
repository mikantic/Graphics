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

void GetPositionData(float4 positionOS, out float4 positionCS, out float3 positionWS)
{
    VertexPositionInputs pos = GetVertexPositionInputs(positionOS);
    positionCS = pos.positionCS;
    positionWS = pos.positionWS;
}

#endif