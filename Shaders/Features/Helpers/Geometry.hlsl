#ifndef GEOMETRY_INCLUDED
#define GEOMETRY_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct GeometryOutput {
    float3 positionWS               : TEXCOORD0;
    float3 normalWS                 : TEXCOORD1;
    float2 uv                       : TEXCOORD2;
    float light                     : TEXCOORD3;
    float4 positionCS               : SV_POSITION;
};

float3 GetNormalFromTriangle(float3 a, float3 b, float3 c) {
    return normalize(cross(b - a, c - a));
};

float3 GetTriangleCenter(float3 a, float3 b, float3 c) 
{
    return (a + b + c) / 3.0;
};

float2 GetTriangleCenterUV(float2 a, float2 b, float2 c) 
{
    return (a + b + c) / 3.0;
};

float3 GetViewDirectionFromPosition(float3 positionWS) 
{
    return normalize(GetCameraPositionWS() - positionWS);
};

float4 CalculatePositionCSWithShadowCasterLogic(float3 positionWS) 
{
    float4 positionCS;
    positionCS = TransformWorldToHClip(positionWS);
    return positionCS;
};


GeometryOutput SetupVertex(float3 positionWS, float3 normalWS, float2 uv, float light) {
    GeometryOutput output = (GeometryOutput)0;
    output.positionWS = positionWS;
    output.normalWS = normalWS;
    output.uv = uv;
    output.light = light;
    output.positionCS = CalculatePositionCSWithShadowCasterLogic(positionWS);

    return output;
};

#endif
