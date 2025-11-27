using UnityEngine;

namespace Graphics.Palettes
{
    public abstract class Palette : ScriptableObject
    {
        [SerializeField] protected UnityEngine.Color _shine;
        [SerializeField] protected UnityEngine.Color _light;
        [SerializeField] protected UnityEngine.Color _medium;
        [SerializeField] protected UnityEngine.Color _dark;
        [SerializeField] protected UnityEngine.Color _shadow;

        public UnityEngine.Color GetColor(Shade shade)
        {
            switch (shade)
            {
                case Shade.Shine:
                    return _shine;
                case Shade.Light:
                    return _light;
                default:
                case Shade.Medium:
                    return _medium;
                case Shade.Dark:
                    return _dark;
                case Shade.Shadow:
                    return _shadow;
            }
        }
    }

    public abstract class Palette<T> : Palette where T : ScriptableObject
    {
        public static UnityEngine.Color Shine { get => Instance._shine; }
        public static UnityEngine.Color Light { get => Instance._light; }
        public static UnityEngine.Color Medium { get => Instance._medium; }
        public static UnityEngine.Color Dark { get => Instance._dark; }
        public static UnityEngine.Color Shadow { get => Instance._shadow; }

        private static Palette<T> _instance;
        public static Palette<T> Instance
        {
            get
            {
                if (_instance == null)
                {
                    string path = $"UI/Palette/Objects/{typeof(T).Name}";
                    _instance = Resources.Load<Palette<T>>(path);
                    if (_instance == null) Debug.LogError($"{path} not found");
                }
                return _instance;
            }
        }
    }
}