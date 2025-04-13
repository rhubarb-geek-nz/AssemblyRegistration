/***********************************
 * Copyright (c) 2025 Roger Brown.
 * Licensed under the MIT License.
 ****/

using System;
using System.Runtime.InteropServices;
using RhubarbGeekNz.AssemblyRegistration;

namespace RhubarbGeekNz.AssemblyRegistration.Library
{
    [Guid("4c00572c-ccf0-4f6d-8203-546c754a125a")]
    public class CHelloWorld : IHelloWorld
    {
        public string GetMessage(int Hint)
        {
            return "Hello World";
        }
    }
}
