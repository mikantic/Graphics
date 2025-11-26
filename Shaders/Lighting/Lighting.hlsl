#ifndef LIGHTING_INCLUDED
#define LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

float4 _Shine;
float4 _Lit;
float4 _Tone;
float4 _Core;
float4 _Cast;

struct Attributes {
    float4 positionOS : POSITION;
    float3 normalOS   : NORMAL;
};

struct Varyings {
    float4 positionHCS : SV_POSITION;
    float3 normalWS    : TEXCOORD0;
    float3 positionWS  : TEXCOORD1;
    float4 shadowCoord : TEXCOORD2;
};

Varyings Vertex(Attributes IN)
{
    Varyings OUT;

    VertexPositionInputs pos = GetVertexPositionInputs(IN.positionOS.xyz);
    OUT.positionHCS = pos.positionCS;
    OUT.positionWS  = pos.positionWS;
    OUT.normalWS = TransformObjectToWorldNormal(IN.normalOS);
    OUT.shadowCoord = GetShadowCoord(pos);

    return OUT;
}

float3 EvaluateLightingRamp(float3 normalWS, float4 shadowCoord)
{
    Light mainLight = GetMainLight(shadowCoord);
    float shadowAtten = mainLight.shadowAttenuation;

    float light = saturate(dot(normalWS, normalize(mainLight.direction))) * shadowAtten;

    if (light < 0.01) return _Cast.rgb;
    else if (light < 0.33) return _Core.rgb;
    else if (light < 0.66) return _Tone.rgb;
    else if (light < 0.99) return _Lit.rgb;
    else return _Shine.rgb;
}

float4 Fragment(Varyings IN) : SV_Target
{
    float3 n = normalize(IN.normalWS);
    float3 col = EvaluateLightingRamp(n, IN.shadowCoord);
    return float4(col, 1);
}

#endif
