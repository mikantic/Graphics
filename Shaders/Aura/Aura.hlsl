#ifndef AURA_INCLUDED
#define AURA_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
};

struct VertexOutput
{
    float4 positionCS   : SV_POSITION;
};

// Shader properties
float _Thickness;
float _Amplifier;
float _Frequency;
float _Seed;
float4 _Color;

// --- Simple random function for jitter ---
float rand(float3 co)
{
    return frac(sin(dot(co ,float3(12.9898,78.233, 37.719))) * 43758.5453);
}

VertexOutput Vertex(Attributes input)
{
    VertexOutput output = (VertexOutput)0;

    float3 normalOS = input.normalOS;
    float3 positionOS = input.positionOS.xyz + normalOS * _Thickness;

    // --- Add jitter with slower update ---
    float timeStep = floor((_Time.x + _Seed) * _Frequency);
    float noise = rand(positionOS + timeStep);
    positionOS += normalOS * (noise - 0.5) * _Amplifier;

    output.positionCS = GetVertexPositionInputs(positionOS).positionCS;
    return output;
};

float4 Fragment(VertexOutput input) : SV_Target
{
    return _Color;
};

#endif
