#ifndef INSTANCE_INCLUDED
#define INSTANCE_INCLUDED

#include "../Shading/Shading.hlsl"

struct Instance
{
    float3 position;
    float4 rotation;
    float scale;
};

StructuredBuffer<Instance> _Instances;

TEXTURE2D(_Shape);
SAMPLER(sampler_Shape);
float4 _Shape_ST;

float3 RotateByQuat(float3 v, float4 q)
{
    return v + 2.0 * cross(q.xyz, cross(q.xyz, v) + q.w * v);
}

Varyings InstanceVertex(Attributes IN, uint instanceID : SV_InstanceID)
{
    Instance instance = _Instances[instanceID];
    Varyings OUT;

    float3 scaledPos = IN.positionOS * instance.scale;
    float3 rotatedPos = RotateByQuat(scaledPos, instance.rotation);
    float3 worldPos = TransformObjectToWorld(rotatedPos) + instance.position;
    OUT.positionWS = worldPos;
    OUT.positionCS = TransformWorldToHClip(worldPos);

    float3 rotatedNormal = RotateByQuat(IN.normalOS, instance.rotation);
    OUT.normalWS = GetNormalWS(rotatedNormal);

    OUT.shadowCoord = GetShadowCoord(OUT.positionWS);
    OUT.uv = IN.uv;
    return OUT;
}

float4 InstanceFragment(Varyings IN) : SV_TARGET
{
    float4 OUT = Fragment(IN);
    clip(SampleTexture(IN.uv, _Shape, sampler_Shape) - 0.05);
    return OUT;
}

#endif