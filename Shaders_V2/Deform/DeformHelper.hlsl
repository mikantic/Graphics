#ifndef DEFORM_HELPER_INCLUDED
#define DEFORM_HELPER_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "../Helpers/Textures.hlsl"

TEXTURE2D(_Deform);
SAMPLER(sampler_Deform);
float4 _Deform_ST;

float _Altitude;

float4 GetPositionCSDeformed(float4 positionOS, float3 normalOS, float2 uv)
{
    float3 position = positionOS.xyz + normalOS * SampleTexture(TRANSFORM_TEX(uv, _Deform), _Deform, sampler_Deform) * _Altitude;
    return GetVertexPositionInputs(position).positionCS;
}


#endif