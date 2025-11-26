using System;
using System.Collections;
using Core.Tools;
using UI.Tools;
using UnityEngine;
using UnityEngine.UI;

namespace UI.Bar
{
    public abstract class Bar<R, T> : Observer<R, T> where R : Range<T> where T : IComparable
    {
        [SerializeField] protected Image _value;

        protected abstract void MinChanged(T min);
        protected abstract void MaxChanged(T max);

        public override void Link(R observable)
        {
            observable.Min.ValueChanged += MinChanged;
            observable.Max.ValueChanged += MaxChanged;
            base.Link(observable);
        }

        public override void Unlink(R observable)
        {
            observable.Min.ValueChanged -= MinChanged;
            observable.Max.ValueChanged -= MaxChanged;
            base.Unlink(observable);
        }
    }   
}