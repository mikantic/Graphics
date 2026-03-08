#ifndef TRANSPARENT_INCLUDED
#define TRANSPARENT_INCLUDED

#include "../Shading/Shading.hlsl"

float _Alpha;

float4 TransparentFragment(Varyings IN) : SV_Target
{    
    return float4(Fragment(IN).xyz, _Alpha);
}

#endif
