#ifndef TEXTURE_HELPER_INCLUDED
#define TEXTURE_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_MainTex);
SAMPLER(sampler_MainTex);
float4 _MainTex_ST;

float SampleTexture(
    float2 uv,
    Texture2D map,
    SamplerState samplerState,
    float4 st)
{
    uv = uv * st.xy + st.zw;

    return map.SampleLevel(samplerState, uv, 0).a;
}


float SampleTexture(float2 uv)
{
    return SampleTexture(
        uv,
        _MainTex,
        sampler_MainTex,
        _MainTex_ST
    );
}


#endif
