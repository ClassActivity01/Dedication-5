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
    
    public partial class Supplier_Order
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Supplier_Order()
        {
            this.Supplier_Order_Detail_Part = new HashSet<Supplier_Order_Detail_Part>();
            this.Supplier_Order_Component = new HashSet<Supplier_Order_Component>();
            this.Supplier_Order_Detail_Raw_Material = new HashSet<Supplier_Order_Detail_Raw_Material>();
            this.Supplier_Return = new HashSet<Supplier_Return>();
            this.Unique_Raw_Material = new HashSet<Unique_Raw_Material>();
            this.Parts = new HashSet<Part>();
            this.Supplier_Quote = new HashSet<Supplier_Quote>();
        }
    
        public int Supplier_Order_ID { get; set; }
        public System.DateTime Date { get; set; }
        public int Supplier_ID { get; set; }
        public int Supplier_Order_Status_ID { get; set; }
    
        public virtual Supplier Supplier { get; set; }
        public virtual Supplier_Order_Status Supplier_Order_Status { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Supplier_Order_Detail_Part> Supplier_Order_Detail_Part { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Supplier_Order_Component> Supplier_Order_Component { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Supplier_Order_Detail_Raw_Material> Supplier_Order_Detail_Raw_Material { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Supplier_Return> Supplier_Return { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Unique_Raw_Material> Unique_Raw_Material { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Part> Parts { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Supplier_Quote> Supplier_Quote { get; set; }
    }
}
