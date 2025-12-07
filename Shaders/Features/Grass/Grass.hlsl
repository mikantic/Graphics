#ifndef GRASS_INCLUDED
#define GRASS_INCLUDED

// Include helper functions from URP
#include "../Helpers/Geometry.hlsl"
#include "../Helpers/Textures.hlsl"
#include "../Helpers/Lighting.hlsl"

struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
    float2 uv           : TEXCOORD0;
};

struct Varyings
{
    float3 positionWS   : TEXCOORD0;
    float2 uv           : TEXCOORD1;
    float light         : TEXCOORD3;
};

TEXTURE2D(_LightMap);
SAMPLER(sampler_LightMap);

TEXTURE2D(_NoiseMap);
SAMPLER(sampler_NoiseMap);

float4 _Shine;
float4 _Lit;
float4 _Tone;
float4 _Core;
float4 _Cast;

float _MinNoise;
float _HeightScaler;


// Vertex functions
Varyings Vertex(Attributes IN) {
    Varyings OUT;
    OUT.positionWS = GetPositionWS(IN.positionOS);
    OUT.uv = IN.uv;

    float light = GetLighting(IN.positionOS, IN.normalOS);
    float noise = SampleTexture(IN.uv, _NoiseMap, sampler_NoiseMap);
    OUT.light = SampleTexture(0, light * noise, _LightMap, sampler_LightMap);

    return OUT;
}

void SetupAndOutputTriangle(inout TriangleStream<GeometryOutput> outputStream, Varyings a, Varyings b, Varyings c) {
    outputStream.RestartStrip();
    float3 normalWS = GetNormalFromTriangle(a.positionWS, b.positionWS, c.positionWS);
    outputStream.Append(SetupVertex(a.positionWS, normalWS, a.uv, a.light));
    outputStream.Append(SetupVertex(b.positionWS, normalWS, b.uv, b.light));
    outputStream.Append(SetupVertex(c.positionWS, normalWS, c.uv, c.light));
};


// to do: clean this up

[maxvertexcount(9)]
void Geometry(triangle Varyings IN[3], inout TriangleStream<GeometryOutput> OUT) {
    Varyings center = (Varyings)0;
    float3 triNormal = GetNormalFromTriangle(IN[0].positionWS, IN[1].positionWS, IN[2].positionWS);
    center.uv = GetTriangleCenterUV(IN[0].uv, IN[1].uv, IN[2].uv);
    center.light = max(max(IN[0].light, IN[1].light), IN[2].light);

    float sample = SampleTexture(center.uv, _NoiseMap, sampler_NoiseMap);
    float height = _HeightScaler * sample;

    if (sample > _MinNoise)
    {
        center.positionWS = GetTriangleCenter(IN[0].positionWS, IN[1].positionWS, IN[2].positionWS) + triNormal * height;
        SetupAndOutputTriangle(OUT, IN[0], IN[1], center);
        SetupAndOutputTriangle(OUT, IN[1], IN[2], center);
        SetupAndOutputTriangle(OUT, IN[2], IN[0], center);
    }
    else
    {
        SetupAndOutputTriangle(OUT, IN[0], IN[1], IN[2]);
    }

}

float3 EvaluateLightingRamp(float light)
{
    if (light < 0.05) return _Cast.rgb;
    else if (light < 0.2) return _Core.rgb;
    else if (light < 0.4) return _Tone.rgb;
    else if (light < 0.6) return _Lit.rgb;
    else return _Shine.rgb;
}

float4 Fragment(GeometryOutput IN) : SV_Target
{
    float3 color = EvaluateLightingRamp(IN.light);
    return float4(color, 1);
}

#endif
