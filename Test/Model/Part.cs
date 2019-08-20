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
    
    public partial class Part
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Part()
        {
            this.Customer_Credit_Detail = new HashSet<Customer_Credit_Detail>();
            this.Production_Task = new HashSet<Production_Task>();
            this.Job_Card_Detail = new HashSet<Job_Card_Detail>();
            this.Supplier_Order = new HashSet<Supplier_Order>();
        }
    
        public int Part_ID { get; set; }
        public string Part_Serial { get; set; }
        public int Part_Status_ID { get; set; }
        public System.DateTime Date_Added { get; set; }
        public decimal Cost_Price { get; set; }
        public int Part_Stage { get; set; }
        public int Parent_ID { get; set; }
        public int Part_Type_ID { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Customer_Credit_Detail> Customer_Credit_Detail { get; set; }
        public virtual Part_Status Part_Status { get; set; }
        public virtual Part_Type Part_Type { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Production_Task> Production_Task { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Job_Card_Detail> Job_Card_Detail { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Supplier_Order> Supplier_Order { get; set; }
    }
}