 proc loadBroomride {dir} {
    source [file join $dir broomride.tcl]
    source [file join $dir template.tcl]
    source [file join $dir request.tcl]
    source [file join $dir response.tcl]
    source [file join $dir view.tcl]
    source [file join $dir route.tcl]
    source [file join $dir application.tcl]
    # source [file join $dir ncgi.tcl]
 }

 package ifneeded broomride 1.0 [list loadBroomride $dir]