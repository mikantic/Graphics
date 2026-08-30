using UnityEngine;
using UnityEditor;

namespace Graphics.Palettes
{
    public enum Shader
    {
        Opaque, Transparent, OpaqueDeform, TransparentDeform
    }

    [CreateAssetMenu(fileName = "Shaders", menuName = "UI/Palettes/Shaders")]
    public class Shaders : ScriptableObject
    {
        private static Shaders _instance;
        public static Shaders Instance
        {
            get
            {
                if (_instance == null)
                {
                    string path = $"Shaders/Shaders";
                    _instance = Resources.Load<Shaders>(path);
                    if (_instance == null) Debug.LogError($"{path} not found");
                }
                return _instance;
            }
        }

        public static UnityEngine.Shader GetShader(Shader material)
        {
            return material switch
            {
                Shader.Transparent => Transparent,
                Shader.OpaqueDeform => OpaqueDeform,
                Shader.TransparentDeform => TransparentDeform,
                Shader.Opaque or _ => Opaque,
            };
        }

        public static UnityEngine.Shader Opaque { get => Instance._opaque; }
        public static UnityEngine.Shader Transparent { get => Instance._transparent; }
        public static UnityEngine.Shader OpaqueDeform { get => Instance._opaqueDeform; }
        public static UnityEngine.Shader TransparentDeform { get => Instance._transparentDeform; }

        [SerializeField] private UnityEngine.Shader _opaque;
        [SerializeField] private UnityEngine.Shader _transparent;
        [SerializeField] private UnityEngine.Shader _opaqueDeform;
        [SerializeField] private UnityEngine.Shader _transparentDeform;


    }   
}