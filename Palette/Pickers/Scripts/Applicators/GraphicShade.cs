using UnityEngine;
using UnityEngine.UI;

namespace UI.Palettes
{
    [CreateAssetMenu(fileName = "GraphicShade", menuName = "UI/Applicators/GraphicShade")]
    public class GraphicShade : ShadeApplicator<Graphic>
    {
        public override void ApplyShade(Palette palette, Shade shade, Graphic target, int index = 0)
        {
            target.color = palette.GetColor(shade);
        }
    }
}
