Shader "Custom/DepthOutline"
{
    Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _OutlineColor("Outline Color", Color) = (1, 0, 0, 1)
        _DepthThreshold("Depth Threshold", Range(0.0001, 0.05)) = 0.004
        _SlopeScale("Slope Sensitivity", Range(0,3)) = 1.0
    }

    SubShader
    {
        Tags 
        { 
            "RenderPipeline" = "UniversalPipeline"
            "Queue" = "Geometry"
        }

        Pass
        {
            Name "FullScreenDepthOutline"

            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            ZTest LEqual
            Cull Off

            HLSLPROGRAM
            #pragma vertex Vert
            #pragma fragment Frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"

            float4 _OutlineColor;
            float _DepthThreshold;
            float _SlopeScale;

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

            Varyings Vert(Attributes v)
            {
                Varyings o;
                o.positionHCS = TransformObjectToHClip(v.positionOS);
                o.uv = v.uv;
                return o;
            }

            float SampleDepth(float2 uv)
            {
                // Return linear depth
                float raw = SAMPLE_TEXTURE2D(_CameraDepthTexture, sampler_CameraDepthTexture, uv).r;
                return LinearEyeDepth(raw, _ZBufferParams);
            }

            half4 Frag(Varyings i) : SV_Target
            {
                float rawDepth = SampleSceneDepth(i.uv);
                float linearDepth = LinearEyeDepth(rawDepth, _ZBufferParams);
                //return linearDepth * _OutlineColor;

                //return half4(1, 1, 1, 1);

                float2 texel = 1.0 / _ScreenSize.xy;

                float d  = SampleDepth(i.uv);
                float dL = SampleDepth(i.uv + float2(-texel.x, 0));
                float dR = SampleDepth(i.uv + float2( texel.x, 0));
                float dU = SampleDepth(i.uv + float2(0,  texel.y));
                float dD = SampleDepth(i.uv + float2(0, -texel.y));

                // Compute depth deltas
                float dx = abs(d - dL) + abs(d - dR);
                float dy = abs(d - dU) + abs(d - dD);

                float edge = max(dx, dy);

                // Adjust threshold for steep slopes (relative depth)
                float adaptiveThreshold = _DepthThreshold * (1 + d * _SlopeScale);

                if (edge > adaptiveThreshold)
                    return _OutlineColor;

                return float4(0,0,0,0); // transparent (no outline)
            }

            ENDHLSL
        }
    }
}
