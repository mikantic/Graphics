using UnityEngine;
using UnityEditor;

namespace Graphics.Palettes
{
    public enum Material
    {
        Opaque, Transparent, OpaqueDeform, TransparentDeform
    }

    [CreateAssetMenu(fileName = "Materials", menuName = "UI/Palettes/Materials")]
    public class Materials : ScriptableObject
    {
        private static Materials _instance;
        public static Materials Instance
        {
            get
            {
                if (_instance == null)
                {
                    string path = $"UI/Palette/Objects/Materials";
                    _instance = Resources.Load<Materials>(path);
                    if (_instance == null) Debug.LogError($"{path} not found");
                }
                return _instance;
            }
        }

        public static UnityEngine.Material GetMaterial(Material material)
        {
            return material switch
            {
                Material.Transparent => Transparent,
                Material.OpaqueDeform => OpaqueDeform,
                Material.TransparentDeform => TransparentDeform,
                Material.Opaque or _ => Opaque,
            };
        }

        public static UnityEngine.Material Opaque { get => Instance._opaque; }
        public static UnityEngine.Material Transparent { get => Instance._transparent; }
        public static UnityEngine.Material OpaqueDeform { get => Instance._opaqueDeform; }
        public static UnityEngine.Material TransparentDeform { get => Instance._transparentDeform; }

        [SerializeField] private UnityEngine.Material _opaque;
        [SerializeField] private UnityEngine.Material _transparent;
        [SerializeField] private UnityEngine.Material _opaqueDeform;
        [SerializeField] private UnityEngine.Material _transparentDeform;


    }   
}