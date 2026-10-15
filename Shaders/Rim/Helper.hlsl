#ifndef RIM_HELPER_INCLUDED
#define RIM_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

float _RimWidth;
float _RimAngle;

float GetRimLight(float NdotL, float3 positionWS, float3 normalWS)
{
    float3 viewDir = normalize(_WorldSpaceCameraPos - positionWS);
    float silhouette = 1 - abs(dot(normalWS, viewDir));

    float edge = step(1.0 - _RimWidth * fwidth(silhouette), silhouette);

    float lightThreshold = 1.0 - (_RimAngle * 2.0);
    float lightMask = step(lightThreshold, NdotL);

    return edge * lightMask;
}


#endif