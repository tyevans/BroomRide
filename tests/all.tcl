package require tcltest
namespace import ::tcltest::*
 
if {$argc != 0} {
    foreach {action arg} $::argv {
        if {[string match -* $action]} {
            configure $action $arg
        } else {
            $action $arg
        }
    }
}
 
runAllTests