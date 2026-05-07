using UnityEngine;

namespace Graphics.Palettes
{
    public class Picker : MonoBehaviour
    {
        [SerializeField] private Material _material;
        [SerializeField] private Renderer _renderer;
        [SerializeField] private Palette _palette;
        [SerializeField] private Shade _shade;
        [SerializeField] private bool _useShade;

        private void Reset()
        {
            TryGetComponent(out _renderer);
            Apply();
        }

        private void Awake()
        {
            Apply();
        }

#if UNITY_EDITOR
        private void OnValidate()
        {
            Apply();
        }
#endif
        public void Apply()
        {
            if (!_renderer || _palette == null) return;

            _renderer.material = Materials.GetMaterial(_material);

            var block = new MaterialPropertyBlock();
            _renderer.GetPropertyBlock(block);

            block.SetColor(Shade.Shine.ToShader(), _palette.GetColor(_useShade ? _shade : Shade.Shine));
            block.SetColor(Shade.Light.ToShader(), _palette.GetColor(_useShade ? _shade : Shade.Light));
            block.SetColor(Shade.Medium.ToShader(), _palette.GetColor(_useShade ? _shade : Shade.Medium));
            block.SetColor(Shade.Dark.ToShader(), _palette.GetColor(_useShade ? _shade : Shade.Dark));
            block.SetColor(Shade.Shadow.ToShader(), _palette.GetColor(_useShade ? _shade : Shade.Shadow));

            _renderer.SetPropertyBlock(block);
        }
    }
}