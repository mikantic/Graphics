#ifndef OPAQUE_INCLUDED
#define OPAQUE_INCLUDED

#include "../Lighting/Helper.hlsl"
#include "../Texture/Helper.hlsl"
#include "../Helper/Helper.hlsl"

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
    float fogFactor     : TEXCOORD4;
};


Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    GetPositionData(IN.positionOS, OUT.positionCS, OUT.positionWS);
    OUT.normalWS = GetNormalWS(IN.normalOS);
    OUT.shadowCoord = GetShadowCoord(OUT.positionWS);

    float fogInfluence = 1.0;
    #if defined(FOG_LINEAR)
        fogInfluence = ComputeFogFactor(OUT.positionCS.z);
    #endif
    OUT.fogFactor = fogInfluence;
    OUT.uv = IN.uv;
    return OUT;
}


float4 Fragment(Varyings IN) : SV_Target
{    
    float NdotL;
    float light = GetLighting(IN.normalWS, IN.shadowCoord, IN.positionWS, NdotL); 
    float tex = SampleTexture(IN.uv);
    light = saturate(light + tex - 0.5);

    #if defined(FOG_LINEAR)
        light = lerp(0.5, light, IN.fogFactor);
    #endif

    float3 color = GetColor(light);

    #if defined(FOG_LINEAR)
        color = lerp(unity_FogColor.rgb, color, IN.fogFactor);
    #endif

    return float4(color, 1);
}

#endif
