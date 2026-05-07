namespace Graphics.Palettes
{
    public static class Helpers
    {
        public static string ToShader(this Shade shade)
        {
            return shade switch
            {
                Shade.Shine => "_Shine",
                Shade.Light => "_Lit",
                Shade.Dark => "_Core",
                Shade.Shadow => "_Cast",
                Shade.Medium or _ => "_Tone",
            };
        }
    }
}