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
    public abstract class Bar<R> : AnimatedBar<R, double> where R : Range<double>
    {
        /// <summary>
        /// increment readout
        /// </summary>
        [SerializeField] protected Image _increment;

        /// <summary>
        /// decrement readout
        /// </summary>
        [SerializeField] protected Image _decrement;

        /// <summary>
        /// implement any additional logic on animation iteration, params tbd
        /// </summary>
        protected virtual void OnAnimationIteration() { }

        /// <summary>
        /// animates images to move to goal value
        /// </summary>
        /// <returns></returns>
        protected override IEnumerator AnimateChange()
        {
            float startTime = Time.time;
            float endTime = startTime + _animationTime;
            float start = _value.fillAmount;
            float end = (float)_observable.InverseLerp;

            _increment.fillAmount = end;
            if (end <= start) _value.fillAmount = end;
            OnAnimationIteration();

            while (Time.time < endTime)
            {
                float delta = Mathf.InverseLerp(startTime, endTime, Time.time);
                float lerp = Mathf.Lerp(start, end, delta);
                if (end <= start)
                {
                    _decrement.fillAmount = lerp;
                }
                else
                {
                    _value.fillAmount = lerp;
                }
                OnAnimationIteration();
                yield return new WaitForEndOfFrame();
            }
            _value.fillAmount = end;
            _increment.fillAmount = end;
            _decrement.fillAmount = end;
            OnAnimationIteration();

        }
    }
}