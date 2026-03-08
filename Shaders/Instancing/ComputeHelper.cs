using System.Collections.Generic;
using UnityEngine;

public class ComputeHelper : MonoBehaviour
{
    [Header("Compute")]
    [SerializeField] private ComputeShader _computeShader;
    [SerializeField] private MeshFilter[] _terrain;
    [SerializeField] private Material _grassMaterial;
    [SerializeField] private int _instancesPerTriangle = 2;
    [SerializeField] private Camera _camera;
    [SerializeField] private float _Range = 50f;

    [Header("Rendering")]
    [SerializeField] private Mesh _mesh;
    [SerializeField] private Material _material;
    [SerializeField] private float _scale = 1;
    

    private int _kernel;
    private ComputeBuffer _triangleBuffer;
    private ComputeBuffer _instanceBuffer;
    private ComputeBuffer _argsBuffer;

    private int _triangleCount;

    [System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Sequential)]
    private struct Triangle
    {
        public Vector3 A;
        public Vector3 B;
        public Vector3 C;
    }

    private void Start()
    {
        _kernel = _computeShader.FindKernel("CSMain");

        InitTriangles();
        InitInstanceBuffer();
        InitArgsBuffer();
    }

    private void InitTriangles()
    {
        List<Triangle> triangles = new();

        foreach (MeshFilter mf in _terrain)
        {
            Mesh mesh = mf.sharedMesh;
            Vector3[] verts = mesh.vertices;
            Renderer renderer = mf.GetComponent<Renderer>();

            for (int sub = 0; sub < mesh.subMeshCount; sub++)
            {
                if (_grassMaterial != null && renderer.sharedMaterials[sub] != _grassMaterial)
                    continue;

                int[] tris = mesh.GetTriangles(sub);

                for (int i = 0; i < tris.Length; i += 3)
                {
                    Triangle tri = new Triangle()
                    {
                        A = mf.transform.TransformPoint(verts[tris[i]]),
                        B = mf.transform.TransformPoint(verts[tris[i + 1]]),
                        C = mf.transform.TransformPoint(verts[tris[i + 2]])
                    };

                    triangles.Add(tri);
                }
            }
        }

        _triangleCount = triangles.Count;

        _triangleBuffer = new ComputeBuffer(_triangleCount, sizeof(float) * 9);
        _triangleBuffer.SetData(triangles);

        _computeShader.SetBuffer(_kernel, "_Triangles", _triangleBuffer);
        _computeShader.SetInt("_TriangleCount", _triangleCount);
        _computeShader.SetInt("_InstancesPerTriangle", _instancesPerTriangle);
    }

    private void InitInstanceBuffer()
    {
        int maxInstances = _triangleCount * _instancesPerTriangle;
        _instanceBuffer = new ComputeBuffer(maxInstances, sizeof(float) * 8, ComputeBufferType.Append);
        _instanceBuffer.SetCounterValue(0);
        _computeShader.SetBuffer(_kernel, "_Instances", _instanceBuffer);
    }

    private void InitArgsBuffer()
    {
        _argsBuffer = new ComputeBuffer(1, 5 * sizeof(uint), ComputeBufferType.IndirectArguments);
        uint[] args = new uint[5];
        args[0] = _mesh.GetIndexCount(0); 
        args[1] = 0;
        args[2] = _mesh.GetIndexStart(0);
        args[3] = _mesh.GetBaseVertex(0);
        args[4] = 0;
        _argsBuffer.SetData(args);
    }

    private void Update()
    {
        _instanceBuffer.SetCounterValue(0);

        _computeShader.SetVector("_CameraPosition", _camera.transform.position);
        _computeShader.SetFloat("_Range", _Range);
        SetFrustumPlanes(_camera);

        _computeShader.SetFloat("_Scale", _scale);

        int groups = Mathf.CeilToInt(_triangleCount / 64f);
        _computeShader.Dispatch(_kernel, groups, 1, 1);
        ComputeBuffer.CopyCount(_instanceBuffer, _argsBuffer, 4);
        _material.SetBuffer("_Instances", _instanceBuffer);

        UnityEngine.Graphics.DrawMeshInstancedIndirect(
            _mesh,
            0,
            _material,
            new Bounds(Vector3.zero, Vector3.one * 100000f),
            _argsBuffer
        );
    }

    private void SetFrustumPlanes(Camera cam)
    {
        Plane[] planes = GeometryUtility.CalculateFrustumPlanes(cam);
        Vector4[] vecPlanes = new Vector4[6];
        for (int i = 0; i < 6; i++)
        {
            Plane p = planes[i];
            vecPlanes[i] = new Vector4(p.normal.x, p.normal.y, p.normal.z, p.distance);
        }
        _computeShader.SetVectorArray("_FrustumPlanes", vecPlanes);
    }

    private void OnDestroy()
    {
        _triangleBuffer?.Release();
        _instanceBuffer?.Release();
        _argsBuffer?.Release();
    }
}