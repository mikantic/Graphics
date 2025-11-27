using System;
using System.Collections;
using Core.Tools;
using Graphics.Tools;
using UnityEngine;
using UnityEngine.UI;

namespace Graphics.Bar
{
    public abstract class Bar<R, T> : Observer<R, T> where R : Range<T> where T : IComparable
    {
        /// <summary>
        /// main value readout
        /// </summary>
        [SerializeField] protected Image _value;

        /// <summary>
        /// implement to adjust readouts when min changed
        /// </summary>
        /// <param name="min"></param>
        protected abstract void MinChanged(T min);

        /// <summary>
        /// implement to adjust readouts when max changed
        /// </summary>
        /// <param name="max"></param>
        protected abstract void MaxChanged(T max);

        /// <inheritdoc/>
        public override void Link(R observable)
        {
            observable.Min.ValueChanged += MinChanged;
            observable.Max.ValueChanged += MaxChanged;
            base.Link(observable);
        }

        /// <inheritdoc/>
        public override void Unlink(R observable)
        {
            observable.Min.ValueChanged -= MinChanged;
            observable.Max.ValueChanged -= MaxChanged;
            base.Unlink(observable);
        }
    }   
}