#ifndef HULL_INCLUDED
#define HULL_INCLUDED

#include "../Helpers/Helpers.hlsl"

struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
};

float _Thickness;
float _Amplifier;
float _Frequency;
float _Seed;
float4 _Color;

Varyings Vertex(Attributes input)
{
    Varyings output = (Varyings)0;

    float3 normalOS = input.normalOS;
    float3 positionOS = input.positionOS.xyz + normalOS * _Thickness;

    float timeStep = floor((_Time.x + _Seed) * _Frequency);
    float noise = rand(positionOS + timeStep);
    positionOS += normalOS * (noise - 0.5) * _Amplifier;

    output.positionCS = GetVertexPositionInputs(positionOS).positionCS;
    return output;
};

float4 Fragment(Varyings input) : SV_Target
{
    return _Color;
};

#endif
