#ifndef LIGHTING_HELPER_INCLUDED
#define LIGHTING_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Helpers.hlsl"

float GetLightingWithShadow(float4 shadowCoord, float3 normalWS)
{
    Light mainLight = GetMainLight(shadowCoord);
    float attenuation = mainLight.shadowAttenuation;
    return saturate(dot(normalWS, normalize(mainLight.direction))) * attenuation;
}

float4 GetShadowCoord(float4 positionOS)
{
    VertexPositionInputs position = GetVertexPositionInputs(positionOS);
    return GetShadowCoord(position);
}

float GetLighting(float4 positionOS, float3 normalOS)
{
    float3 normalWS = GetNormalWS(normalOS);
    float4 shadowCoord = GetShadowCoord(positionOS);
    return GetLightingWithShadow(shadowCoord, normalWS);
};

#endif
