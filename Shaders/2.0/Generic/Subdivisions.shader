Shader "Custom/URP_SimpleAdaptiveTess_DSsafe"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Displacement ("Displacement Strength", Range(0,1)) = 0.1
        _TessLimit ("Tess Limit", Float) = 5
    }

    SubShader
    {
        Tags { "RenderPipeline"="UniversalPipeline" }

        Pass
        {
            HLSLPROGRAM

            #pragma target 4.6
            #pragma vertex vert
            #pragma hull hull
            #pragma domain domain
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float2 uv         : TEXCOORD0;
            };

            struct ControlPoint
            {
                float4 positionCS : SV_POSITION;
                float3 positionOS : TEXCOORD0;
                float3 normalOS   : TEXCOORD1;
                float2 uv         : TEXCOORD2;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS   : TEXCOORD0;
                float2 uv         : TEXCOORD1;
            };

            struct TessFactors
            {
                float edge[3] : SV_TessFactor;
                float inside  : SV_InsideTessFactor;
            };

            TEXTURE2D(_Texture);
            SAMPLER(sampler_Texture);
            
            TEXTURE2D(_NoiseTex);
            SAMPLER(sampler_NoiseTex);

            float _Displacement;
            float _TessLimit;

            // ===============================
            // Vertex
            // ===============================

            ControlPoint vert (Attributes IN)
            {
                ControlPoint o;
                o.positionOS = IN.positionOS.xyz;
                o.normalOS = IN.normalOS;
                o.uv = IN.uv;

                o.positionCS = mul(UNITY_MATRIX_MVP, IN.positionOS);

                return o;
            }

            // ===============================
            // Tess factor (squared distance)
            // ===============================

            float ComputeTessFactor(float3 posOS)
            {
                float3 worldPos = mul(unity_ObjectToWorld, float4(posOS,1)).xyz;
                float toCam = distance(_WorldSpaceCameraPos, worldPos);

                if (toCam < _TessLimit - 1.0) return 3.0;
                if (toCam < _TessLimit) return 2.5;
                return 1.0;
            }

            TessFactors patchConstantFunction(InputPatch<ControlPoint,3> patch)
            {
                TessFactors f;

                float tess =
                    (ComputeTessFactor(patch[0].positionOS) +
                     ComputeTessFactor(patch[1].positionOS) +
                     ComputeTessFactor(patch[2].positionOS)) / 3.0;

                tess = round(tess);

                f.edge[0] = tess;
                f.edge[1] = tess;
                f.edge[2] = tess;
                f.inside  = tess;

                return f;
            }

            // ===============================
            // Hull
            // ===============================

            [domain("tri")]
            [partitioning("integer")]
            [outputtopology("triangle_cw")]
            [patchconstantfunc("patchConstantFunction")]
            [outputcontrolpoints(3)]
            ControlPoint hull (
                InputPatch<ControlPoint,3> patch,
                uint id : SV_OutputControlPointID)
            {
                return patch[id];
            }

            // ===============================
            // Domain (SAFE)
            // ===============================

            [domain("tri")]
            Varyings domain (
                TessFactors factors,
                const OutputPatch<ControlPoint,3> patch,
                float3 bary : SV_DomainLocation)
            {
                Varyings o;

                float3 posOS =
                    patch[0].positionOS * bary.x +
                    patch[1].positionOS * bary.y +
                    patch[2].positionOS * bary.z;

                float3 normalOS =
                    patch[0].normalOS * bary.x +
                    patch[1].normalOS * bary.y +
                    patch[2].normalOS * bary.z;

                float2 uv =
                    patch[0].uv * bary.x +
                    patch[1].uv * bary.y +
                    patch[2].uv * bary.z;

                // sample noise (allowed in DS)
                if (factors.inside > 2.5)
                {
                    float noise = SAMPLE_TEXTURE2D_LOD(_NoiseTex, sampler_NoiseTex, uv, 0).r;
                    posOS += normalOS * noise * _Displacement;
                }

                float4 worldPos = mul(unity_ObjectToWorld, float4(posOS,1));
                o.positionCS = mul(UNITY_MATRIX_VP, worldPos);

                o.normalWS = normalize(mul((float3x3)unity_ObjectToWorld, normalOS));
                o.uv = uv;

                return o;
            }

            float4 frag (Varyings IN) : SV_Target
            {
                return SAMPLE_TEXTURE2D_LOD(_Texture, sampler_Texture, IN.uv, 0);
            }

            ENDHLSL
        }
    }
}