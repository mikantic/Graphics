#ifndef SHADING_HELPER_INCLUDED
#define SHADING_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "../Helpers/Textures.hlsl"
#include "../Helpers/Lighting.hlsl"

TEXTURE2D(_Texture);
SAMPLER(sampler_Texture);
float4 _Texture_ST;

float _Scaler;

float3 EvaluateLightingRamp(float light)
{
    //if (light < 0.05) return _Cast.rgb;
    if (light < 0.15) return _Core.rgb;
    else if (light < 0.5) return _Tone.rgb;
    return _Lit.rgb;
    //else return _Shine.rgb;
}

float SampleTexture(float2 uv)
{
    return SampleTexture(TRANSFORM_TEX(uv, _Texture), _Texture, sampler_Texture);
}


#endif