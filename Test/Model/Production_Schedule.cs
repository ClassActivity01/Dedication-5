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
    
    public partial class Production_Schedule
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Production_Schedule()
        {
            this.Production_Task = new HashSet<Production_Task>();
        }
    
        public int Production_Schedule_ID { get; set; }
        public System.DateTime Production_Schedule_Date { get; set; }
        public int intervals { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Production_Task> Production_Task { get; set; }
    }
}