#ifndef TEXTURES_HELPER_INCLUDED
#define TEXTURES_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

float SampleTexture(float2 uv, Texture2D map, SamplerState sample)
{
    return map.SampleLevel(sample, uv, 0).r;
};
#endif