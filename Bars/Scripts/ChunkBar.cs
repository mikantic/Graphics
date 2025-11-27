using System.Collections.Generic;
using System.Linq;
using Core.Tools;
using UnityEngine;
using UnityEngine.UI;

namespace Graphics.Bar

{
    public class ChunkBar : Bar<Core.Tools.Chunk>
    {
        [SerializeField] private Image _chunk;
        [SerializeField] private Transform _chunkParent;

        /// <summary>
        /// current chunks
        /// </summary>
        protected Queue<Image> _chunks { get; } = new Queue<Image>();

        public override void Link(Chunk observable)
        {
            base.Link(observable);
            UpdateChunkCount(observable.Max.Value.Floor());
        }

        protected override void MaxChanged(double max)
        {
            base.MaxChanged(max);
            UpdateChunkCount(_observable.Max.Value.Floor());
        }

        protected override void MinChanged(double min)
        {
            base.MinChanged(min);
            UpdateChunkCount(_observable.Max.Value.Floor());
        }

        protected virtual void UpdateChunkCount(int count)
        {
            int current = _chunks.Count;
            if (current > count)
            {
                for (int i = current; i > count; i--)
                {
                    Image image = _chunks.Dequeue();
                    Destroy(image.gameObject);
                }
            }
            else
            {
                for (int i = current; i < count; i++)
                {
                    Image image = Instantiate(_chunk, _chunkParent);
                    _chunks.Enqueue(image);
                }
            }
            FillChunks();
        }

        protected virtual void FillChunks()
        {
            for (int i = 0; i < _chunks.Count; i++)
            {
                _chunks.ElementAt(i).fillAmount = (i + 1) <= _value.fillAmount * _observable.Distance ? 1 : 0;
            }
        }
        

        protected override void OnAnimationIteration()
        {
            base.OnAnimationIteration();
            FillChunks();
        }
    }
}