#ifndef HELPING_INCLUDED
#define HELPING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
#include "Textures.hlsl"

float RawDepth(float2 uv)
{
    return SampleTexture(uv, _CameraDepthTexture, sampler_CameraDepthTexture);
};

float LinearEyeDepth(float2 uv)
{
    return LinearEyeDepth(RawDepth(uv), _ZBufferParams);
};

float LinearEyeDepth(float4 positionCS)
{
    return LinearEyeDepth(GetNormalizedScreenSpaceUV(positionCS));
}

float Linear01Depth(float2 uv)
{
    return Linear01Depth(RawDepth(uv), _ZBufferParams);
};

#endif
