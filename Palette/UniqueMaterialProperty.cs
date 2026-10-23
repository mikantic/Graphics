using UnityEngine;

namespace Graphics
{
    public class UniqueMaterialProperty : MonoBehaviour
    {
        [SerializeField] protected Color color = Color.White;
        [SerializeField] protected Tone tone = Tone.Medium;
        [SerializeField] protected Texture texture;

        protected UnityEngine.Renderer target;
        protected MaterialPropertyBlock block;

        protected virtual int Index() => 0;

        protected void Awake()
        {
            Initialize();
            Apply();
        }

        protected void Initialize()
        {
            if (target == null) target = GetComponent<UnityEngine.Renderer>();
            if (block == null) block = new();
        }

        protected void Apply()
        {
            if (target == null || block == null)
            return;

            target.GetPropertyBlock(block, Index());
            Apply(block);
            target.SetPropertyBlock(block, Index());
        }

        protected virtual void Apply(MaterialPropertyBlock block)
        {
            block.SetColor("_Light", Palette.OfType(color, Tone.Light, tone));
            block.SetColor("_Medium", Palette.OfType(color, Tone.Medium, tone));
            block.SetColor("_Dark", Palette.OfType(color, Tone.Dark, tone));
            block.SetTexture("_MainTex", texture == null ? Palette.DefaultTexture : texture);
        }

#if UNITY_EDITOR
        protected void OnValidate()
        {
            if (Application.isPlaying) return;
            Initialize();
            Apply();
        }
#endif

    }
}