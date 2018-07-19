Add-Type @'
    using System.Collections;
    namespace Bootstraps {
    namespace Metaprogramming {
        public class ParameterHashtable
        {
            public Hashtable Hashtable;
            public ParameterHashtable ( Hashtable h )
            {
                Hashtable = h;
            }
        }
    }}
'@ -ErrorAction Stop