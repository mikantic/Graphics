using Core.Tools;
using UnityEngine;

namespace Graphics.Tools
{
    /// <summary>
    /// class for components that want to display backend data without editing
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public abstract class Observer<O, T> : MonoBehaviour where O : Observable<T>
    {
        protected O _observable { get; private set; }

        protected abstract void ValueChanged(T value);
        public virtual void Link(O observable)
        {
            if (_observable != null) Unlink(_observable);

            _observable = observable;
            observable.ValueChanged += ValueChanged;
            ValueChanged(observable);
        }

        public virtual void Unlink(O observable)
        {
            observable.ValueChanged -= ValueChanged;
            _observable = null;
        }
    }
}