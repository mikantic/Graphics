#ifndef OUTLINE_INCLUDED
#define OUTLINE_INCLUDED

#include "../Helper/Helper.hlsl"
#include "../Texture/Helper.hlsl"
#include "../Depth/Helper.hlsl"

float4 _Color;
float _Threshold;
float _Width;

Texture2D<uint> _OutlineIdBuffer;

struct Attributes
{
    uint vertexID       : SV_VertexID;
};

struct Varyings
{
    float4 positionCS   : SV_POSITION;
    float2 uv           : TEXCOORD0;
    float2 texel        : TEXCOORD1;
    float fog           : TEXCOORD2;
};


bool CheckForEdge(float center, float2 uv, float2 offset)
{
    float depth = Linear01Depth(uv + offset);
    float opposite = Linear01Depth(uv - offset);

    float diff = (depth - center);
    float opp = (opposite - center);

    return (diff / center <= _Threshold && -opp / opposite > _Threshold) || (-diff / depth > _Threshold && opp / center <= _Threshold);
};

bool CheckDirectionForEdge(float center, float2 uv, float2 texel)
{
    [loop]
    for (int i = 1; i <= _Width; i++)
    {
        if (CheckForEdge(center, uv, i * texel))
        {
            return true;
        }
    }

    return false;
};

Varyings Vertex(Attributes IN)
{
    Varyings OUT;

    float2 pos = float2((IN.vertexID << 1) & 2, IN.vertexID & 2);
    OUT.positionCS = float4(pos * 2 - 1, 0, 1);

    OUT.uv = pos;
    OUT.uv.y = 1.0 - OUT.uv.y; 

    OUT.texel = 1.0 / _ScreenSize;

    OUT.fog = 0;
    #if defined(FOG_LINEAR)
        //float start = -unity_FogParams.w / unity_FogParams.z;
        float end = unity_FogParams.w / -unity_FogParams.z;
        OUT.fog = end;
    #endif

    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{   
    float raw = RawDepth(IN.uv);
    float eye = LinearEyeDepth(raw, _ZBufferParams);

    #if defined(FOG_LINEAR)
        if (eye >= IN.fog)
            return 0;
    #endif

    float center = Linear01Depth(raw, _ZBufferParams);

    uint2 pixel = uint2(IN.positionCS.xy);
    uint objectId = _OutlineIdBuffer.Load(int3(pixel, 0));
    
    if (CheckDirectionForEdge(center, IN.uv, float2(0, IN.texel.y))) return _Color;
    if (CheckDirectionForEdge(center, IN.uv, float2(IN.texel.x, 0))) return _Color;
    if (CheckDirectionForEdge(center, IN.uv, float2(-IN.texel.x, IN.texel.y))) return _Color;
    if (CheckDirectionForEdge(center, IN.uv, float2(IN.texel.x, IN.texel.y))) return _Color;

    return 0;
}

#endif