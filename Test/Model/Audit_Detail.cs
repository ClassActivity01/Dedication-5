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
    
    public partial class Audit_Detail
    {
        public int Details_ID { get; set; }
        public string Field { get; set; }
        public string Value { get; set; }
        public int Record_ID { get; set; }
        public int Audit_ID { get; set; }
    
        public virtual Audit Audit { get; set; }
    }
}