﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CE.Model
{
    public class ComboBoxItem
    {
        public string Value;
        public string Text;

        public ComboBoxItem(string val, string text)
        {
            Value = val;
            Text = text;
        }

        public override string ToString()
        {
            return Text;
        }
    }
}
