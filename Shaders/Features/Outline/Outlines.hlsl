#ifndef DEPTH_INCLUDED
#define DEPTH_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
#include "../Helpers/Depth.hlsl"

float4 _Color;
float _Threshold;

struct Attributes
{
    float4 positionOS : POSITION;
    float2 uv         : TEXCOORD0;
};

struct Varyings
{
    float4 positionHCS : SV_POSITION;
    float2 uv          : TEXCOORD0;
};

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    OUT.positionHCS = TransformObjectToHClip(IN.positionOS);
    OUT.uv = IN.uv;
    return OUT;
}

bool SampleDepthInDirection(float depth, float2 uv, float2 texel, int factor)
{
    float sample = RawDepth(uv + texel);
    float reverse = RawDepth(uv - texel);

    float sampleDelta = sample - depth;
    float sampleReverseDelta = reverse - depth;

    if (sampleDelta / sample >= _Threshold * factor && abs(sampleDelta) - abs(sampleReverseDelta) > _Threshold) return 1;
    if (sampleReverseDelta / reverse >= _Threshold * factor && abs(sampleReverseDelta) - abs(sampleDelta) > _Threshold) return 1;

    return 0;
}

float4 Fragment(Varyings IN) : SV_Target
{
    float2 texel = 1.0 / _ScreenSize.xy;
    float depth  = RawDepth(IN.uv);
    float2 pixels;

    // Top Row
    pixels = float2(-texel.x, 3 * texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 3)) { return _Color; }

    pixels = float2(0, 3 * texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 3)) { return _Color; }

    pixels = float2(texel.x, 3 * texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 3)) { return _Color; }

    // Second Row
    pixels = float2(-2 * texel.x, 2 * texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 2)) { return _Color; }

    pixels = float2(-texel.x, 2 * texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 2)) { return _Color; }

    pixels = float2(0, 2 * texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 2)) { return _Color; }
    
    pixels = float2(texel.x, 2 * texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 2)) { return _Color; }

    pixels = float2(2 * texel.x, 2 * texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 2)) { return _Color; }

    // Third Row
    pixels = float2(-3 * texel.x, texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 3)) { return _Color; }

    pixels = float2(-2 * texel.x, texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 2)) { return _Color; }

    pixels = float2(-texel.x, texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 1)) { return _Color; }
    
    pixels = float2(0, texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 1)) { return _Color; }

    pixels = float2(texel.x, texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 1)) { return _Color; }

    pixels = float2(2 * texel.x, texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 2)) { return _Color; }

    pixels = float2(3 * texel.x, texel.y);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 3)) { return _Color; }

    // Fourth Row
    pixels = float2(-3 * texel.x, 0);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 3)) { return _Color; }

    pixels = float2(-2 * texel.x, 0);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 2)) { return _Color; }

    pixels = float2(-texel.x, 0);
    if (SampleDepthInDirection(depth, IN.uv, pixels, 1)) { return _Color; }

    return float4(0,0,0,0);
}

#endif
