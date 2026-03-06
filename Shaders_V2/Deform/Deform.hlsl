#ifndef DEFORM_INCLUDED
#define DEFORM_INCLUDED

#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Lighting.hlsl"
#include "../Helpers/Rim.hlsl"
#include "DeformHelper.hlsl"
#include "../Shading/ShadingHelper.hlsl"

struct Attributes {
    float4 positionOS   : POSITION;
    float3 normalOS     : NORMAL;
    float2 uv           : TEXCOORD0;
};

struct Varyings {
    float4 positionCS   : SV_POSITION;
    float3 normalWS     : TEXCOORD0;
    float4 shadowCoord  : TEXCOORD1;
    float2 uv           : TEXCOORD2;
    float3 positionWS   : TEXCOORD3;
};

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    GetPositionData(IN.positionOS, OUT.positionCS, OUT.positionWS);
    OUT.positionCS = GetPositionCSDeformed(IN.positionOS, IN.normalOS, IN.uv);
    OUT.normalWS = GetNormalWS(IN.normalOS);
    OUT.shadowCoord = GetShadowCoord(IN.positionOS);
    OUT.uv = IN.uv;
    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    float NdotL;
    float light = GetLighting(IN.normalWS, IN.shadowCoord, NdotL); 
    float tex = SampleTexture(IN.uv);
    float3 color = EvaluateLightingRamp(light * tex * _Scaler) * tex;
    color = GetColorWithRim(color, NdotL, IN.positionWS, IN.normalWS);
    return float4(color, 1);
}

#endif