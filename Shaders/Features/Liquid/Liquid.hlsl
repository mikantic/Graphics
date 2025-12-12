#ifndef LIQUID_INCLUDED
#define LIQUID_INCLUDED

#include "../Helpers/Depth.hlsl"
#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Lighting.hlsl"

struct Attributes
{
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
    float2 uv           : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
    float light         : TEXCOORD0;
    float height        : TEXCOORD1;
    float2 uv           : TEXCOORD2;
};

float4 _Shine;
float4 _Lit;
float4 _Tone;
float4 _Core;
float4 _Cast;

float _Alpha;
float _Threshold;
float _Height;

float4 _WaveMap_ST;

TEXTURE2D(_WaveMap);
SAMPLER(sampler_WaveMap);

TEXTURE2D(_NoiseMap);
SAMPLER(sampler_NoiseMap);

Varyings Vertex(Attributes IN)
{
    Varyings OUT;

    float2 uv = IN.uv * _WaveMap_ST.xy + _WaveMap_ST.zw;
    uv.x += _Time.x * 2.0;
    uv.y += _Time.x * 2.0;
    float height = SampleTexture(uv, _WaveMap, sampler_WaveMap) * _Height;
    height *= SampleTexture(IN.uv, _NoiseMap, sampler_NoiseMap);

    float3 distortion = IN.positionOS.xyz + IN.normalOS * (height);
    float4 positionOS = float4(distortion, IN.positionOS.w);

    OUT.positionCS = GetPositionCS(positionOS);
    OUT.light = GetLighting(positionOS, IN.normalOS);
    OUT.height = height;
    OUT.uv = IN.uv;
    return OUT;
}

float3 EvaluateLightingRamp(float color, float light)
{
    if (light <= 0)
    {
        if (color < 0.2) return _Cast.rgb;
        else if (color < 0.4) return _Core.rgb;
        else if (color < 0.6) return _Tone.rgb;
        else return _Lit.rgb;
    }
    
    if (color < 0.05) return _Cast.rgb;
    else if (color < 0.2) return _Core.rgb;
    else if (color < 0.4) return _Tone.rgb;
    else if (color < 0.6) return _Lit.rgb;
    else return _Shine.rgb;
}

half4 Fragment(Varyings IN) : SV_Target
{
    float eyeDepth = LinearEyeDepth(IN.positionCS);
    float fade = saturate(saturate(eyeDepth - IN.positionCS.w) / _Threshold);
    float alpha = _Alpha * fade;
    float3 color = EvaluateLightingRamp(max(1.0 - alpha, IN.height / _Height), IN.light);
    return float4(color, 1);
}

#endif
