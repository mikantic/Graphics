#ifndef DEPTH_HELPER_INCLUDED
#define DEPTH_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
#include "../Texture/Helper.hlsl"

float RawDepth(float2 uv)
{
    return SampleTexture(uv, _CameraDepthTexture, sampler_CameraDepthTexture, false);
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

float Linear01Depth(float4 positionCS)
{
    return Linear01Depth(RawDepth(GetNormalizedScreenSpaceUV(positionCS)), _ZBufferParams);
};

#endif
