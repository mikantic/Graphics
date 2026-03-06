#ifndef RIM_HELPER_INCLUDED
#define RIM_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "../Helpers/Lighting.hlsl"

float _Rim;
float _RimAngle;
float4 _Shine;

float3 GetColorWithRim(float3 color, float NdotL, float3 positionWS, float3 normalWS)
{
    float3 viewDir = normalize(_WorldSpaceCameraPos - positionWS);
    float silhouette = 1 - abs(dot(normalWS, viewDir));
    float lower = 1.0 - _Rim;
    float edge = step(1.0 - _Rim * fwidth(silhouette), silhouette);
    float lightMask = step(_RimAngle, NdotL);
    float outline = edge * lightMask;
    return lerp(color, _Shine.rgb, outline);
}


#endif