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
    
    public partial class Recipe
    {
        public int Recipe_ID { get; set; }
        public string Recipe_Type { get; set; }
        public int Quantity_Required { get; set; }
        public int Stage_in_Manufacturing { get; set; }
        public Nullable<int> Part_Type_ID { get; set; }
        public Nullable<int> Item_ID { get; set; }
        public string Item_Name { get; set; }
        public string Dimension { get; set; }
    
        public virtual Part_Type Part_Type { get; set; }
    }
}