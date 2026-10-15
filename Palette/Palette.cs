using System;
using UnityEngine;
#nullable enable

namespace Graphics
{
    public enum Color
    {
        White, Red, Orange, Brown, Yellow, Green, Teal, Blue, Purple, Black
    }

    public enum Tone
    {
        Light, Medium, Dark
    }

    [Serializable]
    public struct Tones
    {
        [SerializeField] private UnityEngine.Color highlight;
        [SerializeField] private UnityEngine.Color light;
        [SerializeField] private UnityEngine.Color medium;
        [SerializeField] private UnityEngine.Color dark;
        [SerializeField] private UnityEngine.Color shadow;

        public UnityEngine.Color Highlight { get => highlight; }
        public UnityEngine.Color Light { get => light; }
        public UnityEngine.Color Medium { get => medium; }
        public UnityEngine.Color Dark { get => dark; }
        public UnityEngine.Color Shadow { get => shadow; }
        public UnityEngine.Color OfTone(Tone tone, Tone range)
        {
            int offset = (int)range;
            int index = (int)tone + offset;
            return index switch
            {
                4 => Shadow,
                3 => Dark,
                1 => Light,
                0 => Highlight,
                2 or _ => Medium,
            };
        }
    }

    [CreateAssetMenu(fileName = "Palette", menuName = "Graphics/Palette")]
    public sealed class Palette : ScriptableObject
    {
        private static Palette? _instance;
        public static Palette Instance
        {
            get => _instance ??= Resources.Load<Palette>("Palette") ?? throw new Exception("Palette not found.");
        }

        [SerializeField] private Tones white;
        public static Tones White { get => Instance.white; }

        [SerializeField] private Tones red;
        public static Tones Red { get => Instance.red; }

        [SerializeField] private Tones orange;
        public static Tones Orange { get => Instance.orange; }

        [SerializeField] private Tones brown;
        public static Tones Brown { get => Instance.brown; }

        [SerializeField] private Tones yellow;
        public static Tones Yellow { get => Instance.yellow; }

        [SerializeField] private Tones green;
        public static Tones Green { get => Instance.green; }

        [SerializeField] private Tones teal;
        public static Tones Teal { get => Instance.teal; }

        [SerializeField] private Tones blue;
        public static Tones Blue { get => Instance.blue; }

        [SerializeField] private Tones purple;
        public static Tones Purple { get => Instance.purple; }

        [SerializeField] private Tones black;
        public static Tones Black { get => Instance.black; }

        public static UnityEngine.Color OfType(Color type, Tone tone, Tone range)
        {
            return type switch
            {
                Color.Red => Red.OfTone(tone, range),
                Color.Orange => Orange.OfTone(tone, range),
                Color.Brown => Brown.OfTone(tone, range),
                Color.Yellow => Yellow.OfTone(tone, range),
                Color.Green => Green.OfTone(tone, range),
                Color.Teal => Teal.OfTone(tone, range),
                Color.Blue => Blue.OfTone(tone, range),
                Color.Purple => Purple.OfTone(tone, range),
                Color.Black => Black.OfTone(tone, range),
                Color.White or _ => White.OfTone(tone, range),
            };
        }

        [SerializeField] private Texture2D defaultTexture;
        public static Texture2D DefaultTexture { get => Instance.defaultTexture; }
    }
}