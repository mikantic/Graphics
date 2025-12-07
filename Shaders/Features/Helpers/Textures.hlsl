#ifndef TEXTURE_HELPER_INCLUDED
#define TEXTURE_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

float SampleTexture(float2 uv, Texture2D map, SamplerState sample)
{
    return map.SampleLevel(sample, uv, 0).r;
};

float SampleTexture(float u, float v, Texture2D map, SamplerState sample)
{
    return SampleTexture(float2(u, v), map, sample);
};

#endif
