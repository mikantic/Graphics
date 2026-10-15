using UnityEngine;

namespace Graphics
{
    [RequireComponent(typeof(UnityEngine.Renderer))]
    public class Renderer : MonoBehaviour
    {
        [SerializeField] protected Color color;
        [SerializeField] protected Tone range = Tone.Medium;
        [SerializeField] protected Texture2D texture;

        protected UnityEngine.Renderer target;
        protected MaterialPropertyBlock block;

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

            target.GetPropertyBlock(block);

            block.SetColor("_Light", Palette.OfType(color, Tone.Light, range));
            block.SetColor("_Medium", Palette.OfType(color, Tone.Medium, range));
            block.SetColor("_Dark", Palette.OfType(color, Tone.Dark, range));

            block.SetTexture("_MainTex", texture == null ? Palette.DefaultTexture : texture);

            target.SetPropertyBlock(block);
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
