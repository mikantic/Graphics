using System;

namespace Graphics.Palettes
{
    /// <summary>
    /// enum for all palette types
    /// </summary>
    [Serializable]
    public enum Color
    {
        Savory, Spicy, Salty, Sweet, Bitter, Minty, Sour, Rotten, Basic, Terrain
    }

    /// <summary>
    /// enum for all shades
    /// </summary>
    [Serializable]
    public enum Shade
    {
        Shine, Light, Medium, Dark, Shadow
    }
}