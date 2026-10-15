using UnityEngine;

public class Waves : MonoBehaviour
{
    [SerializeField] protected Renderer _renderer;
    [SerializeField] protected float _speed;
    [SerializeField] protected float _offset;

    protected void Update()
    {
        if (_renderer == null) return;

        Vector2 offset = new(Mathf.Cos(Time.time * _speed), Mathf.Sin(Time.time * _speed));
        offset.Normalize();
        offset *= _offset;

        _renderer.material.SetTextureOffset("_MainTex", offset);

        offset = new(Mathf.Cos(Time.time * -_speed), Mathf.Sin(Time.time * -_speed));
        offset.Normalize();
        offset *= _offset;
        _renderer.material.SetTextureOffset("_HatchTex", offset);
    }
}
