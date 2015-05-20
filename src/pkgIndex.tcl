 proc loadBroomride {dir} {
    source [file join $dir broomride.tcl]
    source [file join $dir templates.tcl]
 }

 package ifneeded broomride 1.0 [list loadBroomride $dir]