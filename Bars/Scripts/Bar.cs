using System;

namespace UI.Bar
{
    /// <summary>
    /// default class is range of double
    /// </summary>
    public class Bar : Bar<Core.Tools.Range, double>
    {
        ///<inheritdoc/>
        protected override void MaxChanged(double max)
        {
            ValueChanged(_observable);
        }

        ///<inheritdoc/>
        protected override void MinChanged(double min)
        {
            ValueChanged(_observable);
        }

        ///<inheritdoc/>
        protected override void ValueChanged(double value)
        {
            _value.fillAmount = (float)_observable.Lerp;
        }
    }
}