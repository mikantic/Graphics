using Core.Tools;
using Graphics.Bar;
using Unity.VisualScripting;
using UnityEngine;

public class BarTesting : MonoBehaviour
{
    [SerializeField] private ChunkBar _bar;

    [SerializeField] private Chunk _chunk;

    private void Awake()
    {
        _chunk = new Chunk(4, 0, 5);
    }

    private void Start()
    {
        _bar.Link(_chunk);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            _chunk.Value -= 0.5;
        }

        if (Input.GetKeyDown(KeyCode.D))
        {
            _chunk.Value += 0.5;
        }
    }
}
