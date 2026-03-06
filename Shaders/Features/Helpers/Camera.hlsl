#ifndef CAMERA_HELPER_INCLUDED
#define CAMERA_HELPER_INCLUDED


#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

float3 CameraPosition()
{
    return _WorldSpaceCameraPos;
};

float DistanceToCamera(float3 position)
{
    return distance(CameraPosition(), position);
}


#endif
