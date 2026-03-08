#ifndef SHADING_INCLUDED
#define SHADING_INCLUDED

#include "../Helpers/Lighting.hlsl"
#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Textures.hlsl"
#include "../Helpers/Rim.hlsl"

struct Attributes {
    float4 positionOS   : POSITION;
    float2 uv           : TEXCOORD0;
    float3 normalOS     : NORMAL;
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
    OUT.normalWS = GetNormalWS(IN.normalOS);
    OUT.shadowCoord = GetShadowCoord(OUT.positionWS);   // FIX
    OUT.uv = IN.uv;
    return OUT;
}


float4 Fragment(Varyings IN) : SV_Target
{    
    float NdotL;
    float light = GetLighting(IN.normalWS, IN.shadowCoord, IN.positionWS, NdotL); 
    float tex = SampleTexture(TRANSFORM_TEX(IN.uv, _Texture), _Texture, sampler_Texture);
    float3 color = EvaluateLightingRamp(light * tex * _Scaler) * tex;
    color = GetColorWithRim(color, NdotL, IN.positionWS, IN.normalWS);
    return float4(color, 1);
}

#endif
