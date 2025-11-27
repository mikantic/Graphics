using UnityEngine;

namespace Graphics.Palettes
{
    [CreateAssetMenu(fileName = "RendererShade", menuName = "UI/Applicators/RendererShade")]
    public class RendererShade : ShadeApplicator<Renderer>
    {
        public override void ApplyShade(Palette palette, Shade shade, Renderer target, int index = 0)
        {
            MaterialPropertyBlock block = new();
            target.GetPropertyBlock(block, index);
            block.SetColor("_Color", palette.GetColor(shade));
            target.SetPropertyBlock(block, index);
        }
    }
}
