using UnityEngine;

namespace UI.Palettes
{
    public abstract class PaletteApplicator<T> : Applicator
    {
        public abstract void ApplyPalette(Palette palette, T target, int index = 0);   
    }
}
