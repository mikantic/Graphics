#ifndef LIGHTING_HELPER_INCLUDED
#define LIGHTING_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

#include "../Texture/Helper.hlsl"

// Color Options
float4 _Highlight;
float4 _Light;
float4 _Medium;
float4 _Dark;
float4 _Darkest;

TEXTURE2D(_HatchTex);
SAMPLER(sampler_HatchTex);
float4 _HatchTex_ST;

// gets shadow coord
float4 GetShadowCoord(float3 positionWS)
{
    return TransformWorldToShadowCoord(positionWS);
}

// gets the [0 .. 1] light value
float GetLighting(float3 normalWS, float4 shadowCoord, float3 positionWS, out float NdotL)
{
    float totalLight = 0;

    Light mainLight = GetMainLight(shadowCoord);
    float mainNdotL = saturate(dot(normalWS, mainLight.direction));
    totalLight += mainNdotL * mainLight.shadowAttenuation;

    NdotL = mainNdotL;
    uint lightCount = GetAdditionalLightsCount();

    for (uint i = 0; i < lightCount; i++)
    {
        Light light = GetAdditionalLight(i, positionWS);
        float ndotl = saturate(dot(normalWS, light.direction));
        float attenuation = light.distanceAttenuation * light.shadowAttenuation;
        totalLight += ndotl * attenuation;
    }

    return totalLight;
}

float4 HatchLighting(float light, float minLight, float maxLight, float4 minColor, float4 maxColor, float hatch)
{
    float t = saturate((light - minLight) / (maxLight - minLight));
    return t > hatch ? maxColor : minColor;
}

float4 MapLighting(float light, float2 uv)
{
    if (light >= 0.875)
        return _Highlight;

    if (light >= 0.625)
        return _Light;

    float hatch = SampleTexture(uv, _HatchTex, sampler_HatchTex, _HatchTex_ST);

    if (light >= 0.575)
        return HatchLighting(light, 0.575, 0.625, _Medium, _Light, hatch);

    if (light >= 0.375)
        return _Medium;
    
    if (light >= 0.325)
        return HatchLighting(light, 0.325, 0.375, _Dark, _Medium, hatch);

    if (light >= 0.125)
        return _Dark;

    if (light >= 0.075)
        return HatchLighting(light, 0.075, 0.125, _Darkest, _Dark, hatch);

    return _Darkest;
};

#endif
