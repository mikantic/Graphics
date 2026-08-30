using Graphics.Palettes;
using UnityEditor;
using UnityEngine;

public static class MaterialEditor
{
    #if UNITY_EDITOR
    private static void ApplyFlavor<T>() where T : ScriptableObject
    {
        if (Selection.activeObject is not Material material) return;

        Undo.RecordObject(material, "Apply Palette");

        material.SetColor("_Highlight", Palette<T>.Shine);
        material.SetColor("_Light", Palette<T>.Light);
        material.SetColor("_Medium", Palette<T>.Medium);
        material.SetColor("_Dark", Palette<T>.Dark);
        material.SetColor("_Darkest", Palette<T>.Shadow);

        EditorUtility.SetDirty(material);
        AssetDatabase.SaveAssets();
    }

    private static void ApplyShader(Graphics.Palettes.Shader shader)
    {
        if (Selection.activeObject is not Material material) return;

        Undo.RecordObject(material, "Apply Shader");

        material.shader = Shaders.GetShader(shader);

        EditorUtility.SetDirty(material);
        AssetDatabase.SaveAssets();
    }

    [MenuItem("Assets/Palette/Basic", true)]
    [MenuItem("Assets/Palette/Savory", true)]
    [MenuItem("Assets/Palette/Spicy", true)]
    [MenuItem("Assets/Palette/Salty", true)]
    [MenuItem("Assets/Palette/Sweet", true)]
    [MenuItem("Assets/Palette/Bitter", true)]
    [MenuItem("Assets/Palette/Minty", true)]
    [MenuItem("Assets/Palette/Sour", true)]
    [MenuItem("Assets/Palette/Rotten", true)]
    [MenuItem("Assets/Palette/Terrain", true)]
    [MenuItem("Assets/Shader/Opaque", true)]
    [MenuItem("Assets/Shader/Transparent", true)]
    [MenuItem("Assets/Shader/OpaqueDeform", true)]
    [MenuItem("Assets/Shader/TransparentDeform", true)]
    private static bool ValidateFlavor()
    {
        return Selection.activeObject is UnityEngine.Material;
    }

    [MenuItem("Assets/Palette/Basic")]    
    private static void ApplyBasic() => ApplyFlavor<Basic>();

    [MenuItem("Assets/Palette/Savory")]
    private static void ApplySavory() => ApplyFlavor<Savory>();

    [MenuItem("Assets/Palette/Spicy")]
    private static void ApplySpicy() => ApplyFlavor<Spicy>();

    [MenuItem("Assets/Palette/Salty")]
    private static void ApplySalty() => ApplyFlavor<Salty>();

    [MenuItem("Assets/Palette/Sweet")]
    private static void ApplySweet() => ApplyFlavor<Sweet>();

    [MenuItem("Assets/Palette/Bitter")]
    private static void ApplyBitter() => ApplyFlavor<Bitter>();

    [MenuItem("Assets/Palette/Minty")]
    private static void ApplyMinty() => ApplyFlavor<Minty>();

    [MenuItem("Assets/Palette/Sour")]
    private static void ApplySour() => ApplyFlavor<Sour>();

    [MenuItem("Assets/Palette/Rotten")]
    private static void ApplyRotten() => ApplyFlavor<Rotten>();

    [MenuItem("Assets/Palette/Terrain")]
    private static void ApplyTerrain() => ApplyFlavor<Graphics.Palettes.Terrain>();

    

    [MenuItem("Assets/Shader/Opaque")]
    private static void ApplyOpaque() => ApplyShader(Graphics.Palettes.Shader.Opaque);

    [MenuItem("Assets/Shader/Transparent")]
    private static void ApplyTransparent() => ApplyShader(Graphics.Palettes.Shader.Transparent);

    [MenuItem("Assets/Shader/OpaqueDeform")]
    private static void ApplyOpaqueDeform() => ApplyShader(Graphics.Palettes.Shader.OpaqueDeform);

    [MenuItem("Assets/Shader/TransparentDeform")]
    private static void ApplyTransparentDeform() => ApplyShader(Graphics.Palettes.Shader.TransparentDeform);

    #endif
}