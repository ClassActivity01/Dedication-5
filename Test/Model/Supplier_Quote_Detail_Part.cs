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
    
    public partial class Supplier_Quote_Detail_Part
    {
        public int Supplier_Quote_ID { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
        public int Part_Type_ID { get; set; }
    
        public virtual Part_Type Part_Type { get; set; }
        public virtual Supplier_Quote Supplier_Quote { get; set; }
    }
}
