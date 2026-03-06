Shader "Graphics/Transparent"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        
        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)

        _Scaler ("Scaler", Float) = 1
        _Alpha ("Alpha", Range(0, 1)) = 0.75

        _Rim ("Rim", Float) = 5
        _RimAngle ("Rime Angle", Float) = 0.7
    }

    SubShader
    {
        Pass
        {
            Tags 
            { 
                "LightMode" = "UniversalForward"
                "RenderPipeline"="UniversalPipeline"
                "RenderType" = "Transparent"
            }
            ZWrite On
            ZTest LEqual
            Blend SrcAlpha OneMinusSrcAlpha
            
            HLSLPROGRAM

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment
            // to do: could potentially rename these to specifics like TransparentFragment which then takes the output of ShadingFragment and adds Alpha to it... and in Shading.Shader it pragmas ShadingFragment, etc
            // even better code sharing!!! wicked smaht 

            #include "Transparent.hlsl"
            
            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            #include "../Helpers/Default.hlsl"
            ENDHLSL
        }
    }
}

/*
also this:

#ifndef SHADING_CORE_INCLUDED
#define SHADING_CORE_INCLUDED

#include "../Helpers/Helpers.hlsl"
#include "../Helpers/Textures.hlsl"
#include "ShadingHelper.hlsl"
#include "../Helpers/Rim.hlsl"

struct Attributes
{
    float4 positionOS : POSITION;
    float2 uv         : TEXCOORD0;
    float3 normalOS   : NORMAL;
};

struct Varyings
{
    float4 positionCS  : SV_POSITION;
    float3 normalWS    : TEXCOORD0;
    float4 shadowCoord : TEXCOORD1;
    float2 uv          : TEXCOORD2;
    float3 positionWS  : TEXCOORD3;
};

Varyings ShadingVertex(Attributes IN)
{
    Varyings OUT;

    GetPositionData(IN.positionOS, OUT.positionCS, OUT.positionWS);
    OUT.normalWS = GetNormalWS(IN.normalOS);
    OUT.shadowCoord = GetShadowCoord(IN.positionOS);
    OUT.uv = IN.uv;

    return OUT;
}

float3 EvaluateShadingColor(Varyings IN, out float tex)
{
    float NdotL;

    float light = GetLighting(IN.normalWS, IN.shadowCoord, NdotL);

    tex = SampleTexture(
        TRANSFORM_TEX(IN.uv, _Texture),
        _Texture,
        sampler_Texture
    );

    float3 color = EvaluateLightingRamp(light * tex * _Scaler) * tex;

    color = GetColorWithRim(color, NdotL, IN.positionWS, IN.normalWS);

    return color;
}

#endif


#ifndef SHADING_INCLUDED
#define SHADING_INCLUDED

#include "ShadingCore.hlsl"

Varyings Vertex(Attributes IN)
{
    return ShadingVertex(IN);
}

float4 Fragment(Varyings IN) : SV_Target
{
    float tex;
    float3 color = EvaluateShadingColor(IN, tex);
    return float4(color, 1);
}

#endif

#ifndef TRANSPARENT_INCLUDED
#define TRANSPARENT_INCLUDED

#include "ShadingCore.hlsl"

float _Alpha;

Varyings Vertex(Attributes IN)
{
    return ShadingVertex(IN);
}

float4 Fragment(Varyings IN) : SV_Target
{
    float tex;
    float3 color = EvaluateShadingColor(IN, tex);

    return float4(color, _Alpha);
}

#endif

*/


/*

#ifndef SURFACE_TYPES_INCLUDED
#define SURFACE_TYPES_INCLUDED

struct Attributes
{
    float4 positionOS : POSITION;
    float3 normalOS   : NORMAL;
    float2 uv         : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS  : SV_POSITION;
    float3 normalWS    : TEXCOORD0;
    float4 shadowCoord : TEXCOORD1;
    float2 uv          : TEXCOORD2;
    float3 positionWS  : TEXCOORD3;
};

#endif

#ifndef CORE_VERTEX_INCLUDED
#define CORE_VERTEX_INCLUDED

#include "../Helpers/Helpers.hlsl"
#include "SurfaceTypes.hlsl"

void BuildVertex(in Attributes IN, out Varyings OUT)
{
    GetPositionData(IN.positionOS, OUT.positionCS, OUT.positionWS);
    OUT.normalWS = GetNormalWS(IN.normalOS);
    OUT.shadowCoord = GetShadowCoord(IN.positionOS);
    OUT.uv = IN.uv;
}

#endif

#ifndef DEFORM_VERTEX_INCLUDED
#define DEFORM_VERTEX_INCLUDED

#include "DeformHelper.hlsl"
#include "SurfaceTypes.hlsl"

void ApplyDeform(in Attributes IN, inout Varyings OUT)
{
    OUT.positionCS = GetPositionCSDeformed(IN.positionOS, IN.normalOS, IN.uv);
}

#endif

#ifndef LIGHTING_SURFACE_INCLUDED
#define LIGHTING_SURFACE_INCLUDED

#include "../Helpers/Lighting.hlsl"
#include "../Helpers/Textures.hlsl"
#include "../Shading/ShadingHelper.hlsl"

float3 EvaluateSurfaceLighting(Varyings IN, out float tex, out float NdotL)
{
    float light = GetLighting(IN.normalWS, IN.shadowCoord, NdotL);

    tex = SampleTexture(IN.uv);

    float3 color = EvaluateLightingRamp(light * tex * _Scaler) * tex;

    return color;
}

#endif

#ifndef RIM_HELPER_INCLUDED
#define RIM_HELPER_INCLUDED

float _Rim;
float _RimAngle;
float4 _Shine;

float3 ApplyRim(float3 color, float NdotL, float3 positionWS, float3 normalWS)
{
    float3 viewDir = normalize(_WorldSpaceCameraPos - positionWS);

    float silhouette = 1 - abs(dot(normalWS, viewDir));

    float edge = step(1.0 - _Rim * fwidth(silhouette), silhouette);
    float lightMask = step(_RimAngle, NdotL);

    float outline = edge * lightMask;

    return lerp(color, _Shine.rgb, outline);
}

#endif

#ifndef SHADING_INCLUDED
#define SHADING_INCLUDED

#include "SurfaceTypes.hlsl"
#include "CoreVertex.hlsl"
#include "LightingSurface.hlsl"
#include "../Helpers/Rim.hlsl"

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    BuildVertex(IN, OUT);
    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    float tex;
    float NdotL;

    float3 color = EvaluateSurfaceLighting(IN, tex, NdotL);

    color = ApplyRim(color, NdotL, IN.positionWS, IN.normalWS);

    return float4(color, 1);
}

#endif

#ifndef TRANSPARENT_INCLUDED
#define TRANSPARENT_INCLUDED

#include "SurfaceTypes.hlsl"
#include "CoreVertex.hlsl"
#include "LightingSurface.hlsl"
#include "../Helpers/Rim.hlsl"

float _Alpha;

Varyings Vertex(Attributes IN)
{
    Varyings OUT;
    BuildVertex(IN, OUT);
    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    float tex;
    float NdotL;

    float3 color = EvaluateSurfaceLighting(IN, tex, NdotL);

    color = ApplyRim(color, NdotL, IN.positionWS, IN.normalWS);

    return float4(color, _Alpha);
}

#endif

#ifndef DEFORM_SHADER_INCLUDED
#define DEFORM_SHADER_INCLUDED

#include "SurfaceTypes.hlsl"
#include "CoreVertex.hlsl"
#include "DeformVertex.hlsl"
#include "LightingSurface.hlsl"
#include "../Helpers/Rim.hlsl"

Varyings Vertex(Attributes IN)
{
    Varyings OUT;

    BuildVertex(IN, OUT);
    ApplyDeform(IN, OUT);

    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    float tex;
    float NdotL;

    float3 color = EvaluateSurfaceLighting(IN, tex, NdotL);

    color = ApplyRim(color, NdotL, IN.positionWS, IN.normalWS);

    return float4(color, 1);
}

#endif

*/


/*

#ifndef SURFACE_TYPES_INCLUDED
#define SURFACE_TYPES_INCLUDED

struct Attributes
{
    float4 positionOS : POSITION;
    float3 normalOS   : NORMAL;
    float2 uv         : TEXCOORD0;
};

struct Varyings
{
    float4 positionCS  : SV_POSITION;
    float3 normalWS    : TEXCOORD0;
    float4 shadowCoord : TEXCOORD1;
    float2 uv          : TEXCOORD2;
    float3 positionWS  : TEXCOORD3;
};

#endif

#ifndef CORE_VERTEX_INCLUDED
#define CORE_VERTEX_INCLUDED

#include "../Helpers/Helpers.hlsl"
#include "SurfaceTypes.hlsl"

void BuildVertex(in Attributes IN, out Varyings OUT)
{
    GetPositionData(IN.positionOS, OUT.positionCS, OUT.positionWS);
    OUT.normalWS = GetNormalWS(IN.normalOS);
    OUT.shadowCoord = GetShadowCoord(IN.positionOS);
    OUT.uv = IN.uv;
}

#endif

#ifndef LIGHTING_SURFACE_INCLUDED
#define LIGHTING_SURFACE_INCLUDED

#include "../Helpers/Lighting.hlsl"
#include "../Helpers/Textures.hlsl"
#include "../Shading/ShadingHelper.hlsl"

float3 EvaluateSurfaceLighting(Varyings IN, out float tex, out float NdotL)
{
    float light = GetLighting(IN.normalWS, IN.shadowCoord, NdotL);
    tex = SampleTexture(IN.uv);
    float3 color = EvaluateLightingRamp(light * tex * _Scaler) * tex;
    return color;
}

#endif


#ifndef RIM_FEATURE_INCLUDED
#define RIM_FEATURE_INCLUDED

float _Rim;
float _RimAngle;
float4 _Shine;

float3 ApplyRim(float3 color, float NdotL, float3 positionWS, float3 normalWS)
{
    float3 viewDir = normalize(_WorldSpaceCameraPos - positionWS);
    float silhouette = 1 - abs(dot(normalWS, viewDir));
    float edge = step(1.0 - _Rim * fwidth(silhouette), silhouette);
    float lightMask = step(_RimAngle, NdotL);
    float outline = edge * lightMask;
    return lerp(color, _Shine.rgb, outline);
}

#endif


#ifndef MODULAR_SHADING_INCLUDED
#define MODULAR_SHADING_INCLUDED

#include "SurfaceTypes.hlsl"
#include "CoreVertex.hlsl"
#include "LightingSurface.hlsl"
#include "RimFeature.hlsl"
#include "DeformVertex.hlsl"

// Feature toggles
//#define FEATURE_DEFORM
//#define FEATURE_RIM
//#define FEATURE_TRANSPARENT

float _Alpha = 1; // Used only if FEATURE_TRANSPARENT

Varyings Vertex(Attributes IN)
{
    Varyings OUT;

    BuildVertex(IN, OUT);

    #ifdef FEATURE_DEFORM
        ApplyDeform(IN, OUT);
    #endif

    return OUT;
}

float4 Fragment(Varyings IN) : SV_Target
{
    float tex;
    float NdotL;

    float3 color = EvaluateSurfaceLighting(IN, tex, NdotL);

    #ifdef FEATURE_RIM
        color = ApplyRim(color, NdotL, IN.positionWS, IN.normalWS);
    #endif

    float alpha = 1;

    #ifdef FEATURE_TRANSPARENT
        alpha = _Alpha;
    #endif

    return float4(color, alpha);
}

#endif

Shader "Graphics/ModularShading"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}

        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)

        _Scaler ("Scaler", Float) = 1

        _Rim ("Rim", Float) = 5
        _RimAngle ("Rim Angle", Float) = 0.7

        _Alpha ("Alpha", Float) = 1
    }

    SubShader
    {
        // =====================================
        // Opaque Forward Pass
        // =====================================
        Pass
        {
            Name "Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Opaque"
            }
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment

            // Enable or disable features here
            #define FEATURE_RIM
            //#define FEATURE_DEFORM
            //#define FEATURE_TRANSPARENT

            #include "ModularShading.hlsl"

            ENDHLSL
        }

        // =====================================
        // Transparent Pass
        // =====================================
        Pass
        {
            Name "Transparent"
            Tags
            {
                "LightMode" = "UniversalForward"
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Transparent"
            }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            ZTest LEqual

            HLSLPROGRAM
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment

            // Enable transparency feature
            #define FEATURE_TRANSPARENT
            #define FEATURE_RIM
            //#define FEATURE_DEFORM

            #include "ModularShading.hlsl"

            ENDHLSL
        }

        // =====================================
        // ShadowCaster Pass
        // =====================================
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment

            // Shadow pass can use only core vertex if needed
            #include "ModularShading.hlsl"

            ENDHLSL
        }
    }
}


*/


/*

Shader "Graphics/ModularShading"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}

        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)

        _Scaler ("Scaler", Float) = 1

        _Rim ("Rim", Float) = 5
        _RimAngle ("Rim Angle", Float) = 0.7

        _Alpha ("Alpha", Float) = 1
    }

    SubShader
    {
        // =====================================
        // Opaque Pass
        // =====================================
        Pass
        {
            Name "Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Opaque"
            }
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM

            // Multi_compile keywords for features
            #pragma multi_compile _ FEATURE_DEFORM FEATURE_RIM FEATURE_TRANSPARENT
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment

            // Enable features for this pass
            #define FEATURE_RIM
            //#define FEATURE_DEFORM
            //#define FEATURE_TRANSPARENT

            #include "ModularShading.hlsl"

            ENDHLSL
        }

        // =====================================
        // Transparent Pass
        // =====================================
        Pass
        {
            Name "Transparent"
            Tags
            {
                "LightMode" = "UniversalForward"
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Transparent"
            }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            ZTest LEqual

            HLSLPROGRAM

            // Multi_compile keywords for features
            #pragma multi_compile _ FEATURE_DEFORM FEATURE_RIM FEATURE_TRANSPARENT
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment

            // Enable features for transparent pass
            #define FEATURE_TRANSPARENT
            #define FEATURE_RIM
            //#define FEATURE_DEFORM

            #include "ModularShading.hlsl"

            ENDHLSL
        }

        // =====================================
        // ShadowCaster Pass
        // =====================================
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            // Minimal features for shadows
            #define FEATURE_DEFORM

            #include "ModularShading.hlsl"

            ENDHLSL
        }
    }
}

*/

/*

Shader "Graphics/ModularShadingFull"
{
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}

        _Shine ("Shine", Color) = (1, 1, 1, 1)
        _Lit ("Lit", Color) = (1, 1, 1, 1)
        _Tone ("Tone", Color) = (1, 1, 1, 1)
        _Core ("Core", Color) = (1, 1, 1, 1)
        _Cast ("Cast", Color) = (1, 1, 1, 1)

        _Scaler ("Scaler", Float) = 1

        _Rim ("Rim", Float) = 5
        _RimAngle ("Rim Angle", Float) = 0.7

        _Alpha ("Alpha", Float) = 1
    }

    SubShader
    {
        // =====================================
        // Opaque Pass
        // =====================================
        Pass
        {
            Name "Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Opaque"
            }
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM

            // Multi_compile keywords for runtime toggling
            #pragma multi_compile _ FEATURE_DEFORM FEATURE_RIM FEATURE_TRANSPARENT
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment

            // Enable default features for this pass
            #define FEATURE_DEFORM
            #define FEATURE_RIM
            //#define FEATURE_TRANSPARENT

            #include "ModularShading.hlsl"

            ENDHLSL
        }

        // =====================================
        // Transparent Pass
        // =====================================
        Pass
        {
            Name "Transparent"
            Tags
            {
                "LightMode" = "UniversalForward"
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Transparent"
            }
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            ZTest LEqual

            HLSLPROGRAM

            #pragma multi_compile _ FEATURE_DEFORM FEATURE_RIM FEATURE_TRANSPARENT
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE

            #pragma vertex Vertex
            #pragma fragment Fragment

            // Enable default features for this pass
            #define FEATURE_DEFORM
            #define FEATURE_RIM
            #define FEATURE_TRANSPARENT

            #include "ModularShading.hlsl"

            ENDHLSL
        }

        // =====================================
        // ShadowCaster Pass
        // =====================================
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM

            #pragma vertex Vertex
            #pragma fragment Fragment

            // Shadows only need deform (if vertex displacement)
            #define FEATURE_DEFORM

            #include "ModularShading.hlsl"

            ENDHLSL
        }
    }
}

*/