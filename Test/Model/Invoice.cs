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
    
    public partial class Invoice
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Invoice()
        {
            this.Invoice_Payment = new HashSet<Invoice_Payment>();
        }
    
        public int Invoice_ID { get; set; }
        public System.DateTime Invoice_Date { get; set; }
        public int Invoice_Status_ID { get; set; }
        public int Delivery_Note_ID { get; set; }
        public decimal amount_noVat { get; set; }
        public decimal amount_Vat { get; set; }
    
        public virtual Delivery_Note Delivery_Note { get; set; }
        public virtual Invoice_Status Invoice_Status { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Invoice_Payment> Invoice_Payment { get; set; }
    }
}
