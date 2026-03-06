#ifndef LIGHTING_INCLUDED
#define LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
#include "Helpers.hlsl"

float4 _Lit;
float4 _Tone;
float4 _Core;
float4 _Cast;

float4 GetShadowCoord(float3 positionOS)
{
    VertexPositionInputs position = GetVertexPositionInputs(positionOS);
    return GetShadowCoord(position);
}

float GetLighting(float3 normalWS, float4 shadowCoord)
{
    Light mainLight = GetMainLight(shadowCoord);
    float NdotL = saturate(dot(normalWS, mainLight.direction));
    return NdotL * mainLight.shadowAttenuation;
}

float GetLighting(float3 normalWS, float4 shadowCoord, out float NdotL)
{
    Light mainLight = GetMainLight(shadowCoord);
    NdotL = saturate(dot(normalWS, mainLight.direction));
    return NdotL * mainLight.shadowAttenuation;
}

#endif
