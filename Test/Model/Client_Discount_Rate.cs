//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Test.Model
{
    using System;
    using System.Collections.Generic;
    
    public partial class Client_Discount_Rate
    {
        public int Client_ID { get; set; }
        public double Discount_Rate { get; set; }
        public int Part_Type_ID { get; set; }
    
        public virtual Client Client { get; set; }
        public virtual Part_Type Part_Type { get; set; }
    }
}
