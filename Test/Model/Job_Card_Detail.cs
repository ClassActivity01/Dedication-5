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
    
    public partial class Job_Card_Detail
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Job_Card_Detail()
        {
            this.Parts = new HashSet<Part>();
        }
    
        public int Job_Card_Details_ID { get; set; }
        public int Quantity { get; set; }
        public bool Non_Manual { get; set; }
        public int Job_Card_ID { get; set; }
        public int Part_Type_ID { get; set; }
    
        public virtual Job_Card Job_Card { get; set; }
        public virtual Part_Type Part_Type { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Part> Parts { get; set; }
    }
}
