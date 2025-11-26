bool OutlineTest(float mainDepth, float4 position, float2 offset, float threshold)
{
    float depth = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(position + offset), _ZBufferParams);
    float altDepth = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(position - offset), _ZBufferParams);

    if ((mainDepth - depth) / mainDepth >= threshold && (altDepth - mainDepth) / altDepth < threshold) return 1;
    if ((mainDepth - altDepth) / mainDepth >= threshold && (depth - mainDepth) / depth < threshold) return 1;

    return 0;
};

void Outline_float(float4 position, float2 pixels, float3 thresholds, out float outline)
{
    outline = 0;
    float depth = Linear01Depth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(position), _ZBufferParams);
    float2 offset;

    // Top Row
    offset = float2(-pixels.x, 3 * pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.x)) { outline = 1; return; }

    offset = float2(0, 3 * pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.x)) { outline = 1; return; }

    offset = float2(pixels.x, 3 * pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.x)) { outline = 1; return; }

    // Second Row
    offset = float2(-2 * pixels.x, 2 * pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.x)) { outline = 1; return; }

    offset = float2(-pixels.x, 2 * pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.y)) { outline = 1; return; }

    offset = float2(0, 2 * pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.y)) { outline = 1; return; }
    
    offset = float2(pixels.x, 2 * pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.y)) { outline = 1; return; }

    offset = float2(2 * pixels.x, 2 * pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.x)) { outline = 1; return; }

    // Third Row
    offset = float2(-3 * pixels.x, pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.x)) { outline = 1; return; }

    offset = float2(-2 * pixels.x, pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.y)) { outline = 1; return; }

    offset = float2(-pixels.x, pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.z)) { outline = 1; return; }
    
    offset = float2(0, pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.z)) { outline = 1; return; }

    offset = float2(pixels.x, pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.z)) { outline = 1; return; }

    offset = float2(2 * pixels.x, pixels.y);
    if (OutlineTest(depth, position, offset, thresholds.y)) { outline = 1; return; }

    offset = float2(3 * pixels.x, pixels.y);
   if (OutlineTest(depth, position, offset, thresholds.x)) { outline = 1; return; }

   // Fourth Row
   offset = float2(-3 * pixels.x, 0);
    if (OutlineTest(depth, position, offset, thresholds.x)) { outline = 1; return; }

    offset = float2(-2 * pixels.x, 0);
    if (OutlineTest(depth, position, offset, thresholds.y)) { outline = 1; return; }

    offset = float2(-pixels.x, 0);
    if (OutlineTest(depth, position, offset, thresholds.z)) { outline = 1; return; }

};