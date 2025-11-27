using UnityEngine;

namespace Graphics.Palettes
{
    public abstract class ShadeApplicator : Applicator
    {

    }
    
    public abstract class ShadeApplicator<T> : ShadeApplicator
    {
        public abstract void ApplyShade(Palette palette, Shade shade, T target, int index = 0);
    }
}
