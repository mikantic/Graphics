using UnityEngine;

namespace Graphics
{
    public class MaterialProperty : UniqueMaterialProperty
    {
        [SerializeField] protected Vector2 Tiling = Vector2.one;
        [SerializeField] protected Vector2 Offset = Vector2.zero;
        [SerializeField] protected int index;

        protected override int Index() => index;

        protected override void Apply(MaterialPropertyBlock block)
        {
            block.SetVector("_MainTex_ST", new Vector4(Tiling.x, Tiling.y, Offset.x, Offset.y));
            base.Apply(block);
        }
    }
}