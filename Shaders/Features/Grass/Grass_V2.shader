Shader "Custom/CameraAlignedGrassWarp"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _FrequencyX ("Wave Frequency (X Axis)", Float) = 20
        _AmplitudeY ("Wave Amplitude (Y Axis)", Float) = 0.03
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _FrequencyX;
            float _AmplitudeY;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            // analyze this it has some good crystal refraction, combine with transparency and glow

            fixed4 frag(v2f i) : SV_Target
            {
                // Camera forward and up in world space
                float3 camForward = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 camUp = float3(0,1,0); // world up

                // Camera right = perpendicular to forward & up
                float3 camRight = normalize(cross(camUp, camForward));

                // Camera up corrected = perpendicular to forward & right
                camUp = normalize(cross(camForward, camRight));

                // Project world position onto camera right (X axis of sine)
                float projX = dot(i.worldPos, camRight);

                // Compute sine wave along camera right
                float wave = sin(projX * _FrequencyX) * _AmplitudeY;

                // Offset UV along camera up
                float2 finalUV = i.uv + float2(0, wave);

                return tex2D(_MainTex, finalUV);
            }
            ENDCG
        }
    }
}