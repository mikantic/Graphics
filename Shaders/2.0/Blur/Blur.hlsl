#ifndef BLUR_INCLUDED
#define BLUR_INCLUDED

#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Textures.hlsl"

struct Attributes 
{
    float4 positionOS   : POSITION;
    float2 uv           : TEXCOORD0;
};

struct Varyings 
{
    float4 positionCS   : SV_POSITION;
    float2 uv           : TEXCOORD0;
};

TEXTURE2D(_Texture);
SAMPLER(sampler_Texture);

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    OUT.positionCS = GetPositionCS(IN.positionOS);
    OUT.uv = IN.uv;
    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    return SampleTexture(IN.uv, _Texture, sampler_Texture);
}

#endif