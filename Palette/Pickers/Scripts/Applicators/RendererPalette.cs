using UnityEngine;

namespace UI.Palettes
{
    [CreateAssetMenu(fileName = "RendererPalette", menuName = "UI/Applicators/RendererPalette")]
    public class RendererPalette : PaletteApplicator<Renderer>
    {
        public override void ApplyPalette(Palette palette, Renderer target, int index = 0)
        {
            MaterialPropertyBlock block = new();
            target.GetPropertyBlock(block, index);
            block.SetColor("_Shine", palette.GetColor(Shade.Shine));
            block.SetColor("_Lit", palette.GetColor(Shade.Light));
            block.SetColor("_Tone", palette.GetColor(Shade.Medium));
            block.SetColor("_Core", palette.GetColor(Shade.Dark));
            block.SetColor("_Cast", palette.GetColor(Shade.Shadow));
            target.SetPropertyBlock(block, index);
        }
    }
}
