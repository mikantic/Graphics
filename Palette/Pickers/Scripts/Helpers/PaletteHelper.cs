using UnityEngine;
namespace Graphics.Palettes
{
    public abstract class PaletteHelper<T> : MonoBehaviour
    {
        [SerializeField] private Applicator _applicator;

        [SerializeField] private Palette _palette;

        [EnableIfChild("_applicator", typeof(ShadeApplicator))]
        [SerializeField] private Shade _shade = Shade.Medium;

        [SerializeField] private T _target;

        [EnableIfGeneric(typeof(Renderer))]
        [SerializeField] private int _index;

        private bool TryGetTarget()
        {
            if (_target != null) return true;
            _target = GetComponent<T>();
            return _target != null;
        }

        private void Reset()
        {
            TryApplyPalette();
        }

        private void OnValidate()
        {
            TryApplyPalette();
        }

        private void TryApplyPalette()
        {
            if (!TryGetTarget()) return;
            if (_palette == null) return;

            if (_applicator is PaletteApplicator<T> paletteApplicator)
            {
                paletteApplicator.ApplyPalette(_palette, _target, _index);
                return;
            }

            if (_applicator is ShadeApplicator<T> shadeApplicator)
            {
                shadeApplicator.ApplyShade(_palette, _shade, _target, _index);
            }
        }
    }

}
