#ifndef TEXTURE_HELPER_INCLUDED
#define TEXTURE_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_Texture);
SAMPLER(sampler_Texture);
float4 _Texture_ST;

float SampleTexture(float2 uv, Texture2D map, SamplerState sample)
{
    return map.SampleLevel(sample, uv, 0);
};

float SampleTexture(float2 uv)
{
    return SampleTexture(TRANSFORM_TEX(uv, _Texture), _Texture, sampler_Texture);
}


#endif
