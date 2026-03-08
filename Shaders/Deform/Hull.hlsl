#ifndef HULL_OUTLINE_INCLUDED
#define HULL_OUTLINE_INCLUDED

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

float _Hull;
float4 _HullColor;

Varyings Vertex(Attributes input)
{
    Varyings output = (Varyings)0;

    float3 normalOS = input.normalOS;
    float3 positionOS = input.positionOS.xyz + normalOS * _Hull / _ScreenParama.x;
    output.positionCS = GetVertexPositionInputs(positionOS).positionCS;
    return output;
};

float4 Fragment(Varyings input) : SV_Target
{
    return _HullColor;
};

#endif