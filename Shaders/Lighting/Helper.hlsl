#ifndef LIGHTING_HELPER_INCLUDED
#define LIGHTING_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

#include "../Texture/Helper.hlsl"

// Color Options
float4 _Light;
float4 _Medium;
float4 _Dark;

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

float4 GetColor(float value)
{
    // [0.7, _] = light
    if (value >= 0.7) return _Light;

    // [0.5, 0.7) = lerp
    if (value >= 0.5) return lerp(_Medium, _Light, (value - 0.5) / 0.2);

    // [0.2, 0.5) = medium
    if (value >= 0.2) return _Medium;

    // [0.0, 0.2) = lerp
    if (value >= 0.0) return lerp(_Dark, _Medium, (value) / 0.2);

    // [_, 0.0) = shadow
    return _Dark;
};

#endif
