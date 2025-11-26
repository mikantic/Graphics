using UnityEngine;
using UnityEngine.UI;

namespace UI.Palettes
{
    [CreateAssetMenu(fileName = "GraphicPalette", menuName = "UI/Applicators/GraphicPalette")]
    public class GraphicPalette : PaletteApplicator<Graphic>
    {
        public override void ApplyPalette(Palette palette, Graphic target, int index = 0)
        {
            target.material.SetColor("_Shine", palette.GetColor(Shade.Shine));
            target.material.SetColor("_Lit", palette.GetColor(Shade.Light));
            target.material.SetColor("_Tone", palette.GetColor(Shade.Medium));
            target.material.SetColor("_Core", palette.GetColor(Shade.Dark));
            target.material.SetColor("_Cast", palette.GetColor(Shade.Shadow));
        }
    }
}
