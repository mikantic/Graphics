#ifndef CRYSTAL_INCLUDED
#define CRYSTAL_INCLUDED

#include "../Helpers/Lighting.hlsl"
#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Textures.hlsl"

float4 _Shine;
float4 _Lit;
float4 _Tone;
float4 _Core;
float4 _Cast;

float _Power;
float _Sharpness;


TEXTURE2D(_LightMap);
SAMPLER(sampler_LightMap);

float4 _NoiseMap_ST;
TEXTURE2D(_NoiseMap);
SAMPLER(sampler_NoiseMap);

struct Attributes {
    float4 positionOS   : POSITION;
    float2 uv           : TEXCOORD0;
    float3 normalOS     : NORMAL;
};

struct Varyings {
    float4 positionCS   : SV_POSITION;
    float fresnel       : TEXCOORD0;
    float light         : TEXCOORD1;
};

float Fresnel(float3 normalWS, float3 view, float power)
{
    float fresnel = dot(normalWS, view);
    return pow(saturate(1 - fresnel), power);
}

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    OUT.positionCS = GetPositionCS(IN.positionOS);

    float3 worldPos = GetPositionWS(IN.positionOS);
    float3 viewDir = normalize(GetCameraPositionWS() - worldPos);

    OUT.fresnel = Fresnel(GetNormalWS(IN.normalOS), viewDir, _Power);

    float light = GetLighting(IN.positionOS, IN.normalOS);

    float2 uv = IN.uv * _NoiseMap_ST.xy + _NoiseMap_ST.zw;
    float noise = _Sharpness * SampleTexture(uv, _NoiseMap, sampler_NoiseMap);
    OUT.light = SampleTexture(0, light * noise, _LightMap, sampler_LightMap);
    return OUT;
}

float3 EvaluateLightingRamp(float light)
{
    if (light > 0.5) return _Shine.rgb;
    if (light > 0.3) return _Lit.rgb;
    if (light > 0.15) return _Tone.rgb;
    if (light > 0.05) return _Core.rgb;
    return _Cast.rgb;
}

float4 Fragment(Varyings IN) : SV_Target
{    
    float3 col = EvaluateLightingRamp(max(IN.light, IN.fresnel));
    return float4(col, 1);
}

#endif
