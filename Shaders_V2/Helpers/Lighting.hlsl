#ifndef LIGHTING_INCLUDED
#define LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"

#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

#pragma multi_compile_fragment _ _ADDITIONAL_LIGHTS
#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS

float4 _Lit;
float4 _Tone;
float4 _Core;

float _Scaler;

float4 GetShadowCoord(float3 positionOS)
{
    VertexPositionInputs position = GetVertexPositionInputs(positionOS);
    return GetShadowCoord(position);
}

float GetLighting(float3 normalWS, float4 shadowCoord, out float NdotL)
{
    Light mainLight = GetMainLight(shadowCoord);
    NdotL = saturate(dot(normalWS, mainLight.direction));
    return NdotL * mainLight.shadowAttenuation;
}

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

float3 EvaluateLightingRamp(float light)
{
    if (light < 0.15) return _Core.rgb;
    if (light < 0.5) return _Tone.rgb;
    return _Lit.rgb;
}


#endif
