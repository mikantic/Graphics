#ifndef OUTLINE_INCLUDED
#define OUTLINE_INCLUDED

#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Textures.hlsl"
#include "../Helpers/Depth.hlsl"

float _Threshold;
float _Width;
float _Darkness;

struct Attributes
{
    uint vertexID       : SV_VertexID;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
    float2 uv           : TEXCOORD0;
    float2 texel        : TEXCOORD1;
};

bool ValidateDepth(float center, float2 uv, float2 offset)
{
    float depth = LinearEyeDepth(uv + offset);
    float opposite = LinearEyeDepth(uv - offset);

    float diff = (center - depth) / max(center, depth);
    float opp  = (opposite - center) / max(opposite, center);

    return diff >= _Threshold && opp < _Threshold;
}

Varyings Vertex(Attributes IN)
{
    Varyings OUT;

    float2 pos = float2((IN.vertexID << 1) & 2, IN.vertexID & 2);
    OUT.positionCS = float4(pos * 2 - 1, 0, 1);

    OUT.uv = pos;
    OUT.uv.y = 1.0 - OUT.uv.y; 

    OUT.texel = 1.0 / _ScreenSize;

    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{   
    float center = LinearEyeDepth(IN.uv);

    float4 color = SampleTexture(IN.uv) * _Darkness;
    color.a = 1;

    if (ValidateDepth(center, IN.uv, float2(0, IN.texel.y * _Width))) return color;
    if (ValidateDepth(center, IN.uv, float2(-IN.texel.x * _Width, 0))) return color;
    if (ValidateDepth(center, IN.uv, float2(IN.texel.x * _Width, 0))) return color;
    if (ValidateDepth(center, IN.uv, float2(0, -IN.texel.y * _Width))) return color;

    if (ValidateDepth(center, IN.uv, float2(-IN.texel.x * _Width, IN.texel.y * _Width))) return color;
    if (ValidateDepth(center, IN.uv, float2(-IN.texel.x * _Width, -IN.texel.y * _Width))) return color;
    if (ValidateDepth(center, IN.uv, float2(IN.texel.x * _Width, IN.texel.y * _Width))) return color;
    if (ValidateDepth(center, IN.uv, float2(IN.texel.x * _Width, -IN.texel.y * _Width))) return color;

    return float4(0, 0, 0, 0);
}

#endif