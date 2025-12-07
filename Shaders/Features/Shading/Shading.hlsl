#ifndef SHADING_INCLUDED
#define SHADING_INCLUDED

#include "../Helpers/Lighting.hlsl"
#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Textures.hlsl"

float4 _Shine;
float4 _Lit;
float4 _Tone;
float4 _Core;
float4 _Cast;

TEXTURE2D(_LightMap);
SAMPLER(sampler_LightMap);

TEXTURE2D(_NoiseMap);
SAMPLER(sampler_NoiseMap);


struct Attributes {
    float4 positionOS   : POSITION;
    float2 uv           : TEXCOORD0;
    float3 normalOS     : NORMAL;
};

struct Varyings {
    float4 positionCS   : SV_POSITION;
    float light         : TEXCOORD1;
};

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    OUT.positionCS = GetPositionCS(IN.positionOS);

    float light = GetLighting(IN.positionOS, IN.normalOS);
    float noise = SampleTexture(IN.uv, _NoiseMap, sampler_NoiseMap);
    OUT.light = SampleTexture(0, light * noise, _LightMap, sampler_LightMap);
    return OUT;
}

float3 EvaluateLightingRamp(float light)
{
    if (light < 0.05) return _Cast.rgb;
    else if (light < 0.2) return _Core.rgb;
    else if (light < 0.4) return _Tone.rgb;
    else if (light < 0.6) return _Lit.rgb;
    else return _Shine.rgb;
}

float4 Fragment(Varyings IN) : SV_Target
{    
    float3 col = EvaluateLightingRamp(IN.light);
    return float4(col, 0.5);
}

#endif
