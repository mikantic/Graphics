using System;
using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using Core.Tools;

namespace Graphics.Bar
{
    /// <summary>
    /// default class is range of double
    /// </summary>
    public abstract class AnimatedBar<R, T> : Bar<R, T> where R : Range<T> where T : IComparable
    {
        /// <summary>
        /// active coroutine running animation
        /// </summary>
        protected Coroutine _coroutine;

        /// <summary>
        /// how long animation should be
        /// </summary>
        [SerializeField] protected float _animationTime;

        /// <inheritdoc/>
        protected override void MaxChanged(T max)
        {
            ValueChanged(_observable);
        }

        /// <inheritdoc/>
        protected override void MinChanged(T min)
        {
            ValueChanged(_observable);
        }

        /// <inheritdoc/>
        protected override void ValueChanged(T value)
        {
            if (_coroutine != null) StopCoroutine(_coroutine);
            _coroutine = StartCoroutine(AnimateChange());
        }

        /// <summary>
        /// animate image based on value
        /// </summary>
        /// <returns></returns>
        protected abstract IEnumerator AnimateChange();
    }
}