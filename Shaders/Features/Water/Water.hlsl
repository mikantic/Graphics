#ifndef WATER_INCLUDED
#define WATER_INCLUDED

#include "../Helpers/Depth.hlsl"
#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Lighting.hlsl"

struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
    float light         : TEXCOORD0;
};

float4 _Shine;
float4 _Lit;
float4 _Tone;
float4 _Core;
float4 _Cast;

float _Alpha;
float _Threshold;

TEXTURE2D(_NoiseMap);
SAMPLER(sampler_NoiseMap);

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    OUT.positionCS = GetPositionCS(IN.positionOS);
    OUT.light = GetLighting(IN.positionOS, IN.normalOS);
    return OUT;
}

float3 EvaluateLightingRamp(float light)
{
    if (light < 0.05) return _Shine.rgb;
    else if (light < 0.2) return _Lit.rgb;
    else if (light < 0.4) return _Tone.rgb;
    else if (light < 0.6) return _Core.rgb;
    else return _Cast.rgb;
}

half4 Fragment(Varyings IN) : SV_Target
{
    float eyeDepth = LinearEyeDepth(IN.positionCS);
    float fade = saturate(saturate(eyeDepth - IN.positionCS.w) / _Threshold);

    float alpha = _Alpha * max(fade, 1.0 - IN.light);
    float3 color = EvaluateLightingRamp(alpha);

    return float4(color, alpha);
}

#endif
