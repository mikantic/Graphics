#ifndef GRAYSCALE_INCLUDED
#define GRAYSCALE_INCLUDED

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

float _Cutoff;

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    OUT.positionCS = GetPositionCS(IN.positionOS);
    OUT.uv = IN.uv;
    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    float4 col = SampleTexture(IN.uv, _Texture, sampler_Texture);

    // Convert to grayscale
    float gray = dot(col.rgb, float3(0.299, 0.587, 0.114));

    // Clip near-black pixels
    clip(gray - _Cutoff);

    return float4(gray, gray, gray, 0.5);
}

#endif