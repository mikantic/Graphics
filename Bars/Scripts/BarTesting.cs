using Core.Tools;
using UI.Bar;
using Unity.VisualScripting;
using UnityEngine;

public class BarTesting : MonoBehaviour
{
    [SerializeField] private Bar _bar;

    [SerializeField] private Range _range;

    private void Awake()
    {
        _range = new Range(4, 0, 5);
    }

    private void Start()
    {
        _bar.Link(_range);
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Z))
        {
            _range.Value = -2;
        }

        if (Input.GetKeyDown(KeyCode.A))
        {
            _range.Value = 2;
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            _range.Value = 4;
        }

        if (Input.GetKeyDown(KeyCode.D))
        {
            _range.Value = 6;
        }
    }
}
