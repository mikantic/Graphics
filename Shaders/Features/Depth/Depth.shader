Shader "Custom/Depth"
{
    SubShader
    {
        Pass
        {
            // Full Shading
            Tags { "LightMode" = "DepthOnly" }

            HLSLPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "../Shadows/Shadows.hlsl"

            ENDHLSL
        }

        // extra stuff goes here

        Pass
        {
            // Lighting Primer
            Tags { "LightMode" = "ShadowCaster" }
            HLSLPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "../Shadows/Shadows.hlsl"

            ENDHLSL
        }
    }
}