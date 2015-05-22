package require Itcl

namespace eval ::broomride::template {

	namespace export TemplateProcessor Template SUBSTITUTION CODE COMMENT TEXT

	variable SUBSTITUTION	0
	variable CODE			1
	variable COMMENT		2
	variable TEXT 			3


	catch {::itcl::delete class TemplateProcessor}
	::itcl::class TemplateProcessor {
		private variable statements

		constructor {_statements} {
			set statements $_statements
		}

		method pop_statement {} {
    		set entry [lindex $statements 0]
    		set statements [lreplace $statements [set statements 0] 0]
    		return $entry
		}

		method process {context} {
			set result {}
			set current_handler 0

			while {[llength $statements] > 0} {
				lassign [pop_statement] type content
				switch $type {
					0 {
						catch {append result [dict get $context $content]}
					}
					1 {
						regexp "^(\[a-zA-Z0-9\]+)\\s+(.*)$" $content -> command args
						if {[info exists command]} {
							switch $command {
								"foreach" {
									set queue [list]
									while {$type != $::broomride::template::CODE || $content ne "endfor"} {
										lassign [pop_statement] type content
										lappend queue [list $type $content]
									}
									regexp "(\[a-zA-Z0-9\]+)\\s*in\\s*(\[a-zA-Z0-9\]+)$" $args -> x y
									foreach entry [dict get $context $y] {
										set local_context [dict get $context]
										dict set local_context $x $entry
										set t [TemplateProcessor #auto $queue]
										append result [$t process $local_context]
										::itcl::delete object $t 
									}
								}
								"if" {
									set queue [list]
									set previous_token {}
									while {$type != $::broomride::template::CODE || $content ne "endif"} {
										lassign [pop_statement] type content
										lappend queue [list $type $content]
									}
									set argprocessor [TemplateProcessor #auto [list [list $::broomride::template::TEXT $args]]]
									set args [$argprocessor process $context]
									if ([expr $args]) {
										set t [TemplateProcessor #auto $queue]
										append result [$t process $context]
										::itcl::delete object $t 
									}
								}
							}
						}
					}
					2 {
						# Handle comment objects (or don't)
					}
					3 {
						# Handle text objects
						append result $content
					}
				}
			}
			return $result
		}
	}


	catch {::itcl::delete class Template}
	::itcl::class Template {
		private variable template_str
		private variable tokenized_template
		private variable processor_cls

		# Defined parts of a document


		constructor {template {_processor_cls 0}} {
			set template_str $template

			if {[string is false -strict $_processor_cls]} {
				set processor_cls TemplateProcessor
			} else {
				set processor_cls _processor_cls
			}

			compile
		}

		method render {context} {
			return [[$processor_cls #auto $tokenized_template] process $context]
		}


		method compile {} {
			set break_points [regexp -inline -indices -all {\{[\{%#].*?[\}%#]\}} $template_str ]
			set template_len [string length $template_str]
			set indices [list]
			set deduped_indices [list]
			set tokenized_template [list]

			foreach entry $break_points {
				lassign $entry start end

				if {$start > 0} {
					lappend indices [expr {$start-1}]
				}

				lappend indices $start
				lappend indices $end

				if {$end < [expr {$template_len-1}]} {
					lappend indices [expr $end+1]
				}
			}

			lappend indices 0
			lappend indices [expr {$template_len-1}]

			foreach i [lsort -integer $indices] {
				if {$i ni $deduped_indices} {
					lappend deduped_indices $i
				}
			}

			foreach {start end} $deduped_indices {
				set part [string range $template_str $start $end]
				switch [string range $part 0 1] {
					"\{\{" {
						lappend tokenized_template [list $::broomride::template::SUBSTITUTION [string trim $part "\{\} "]]
					}
					"\{%" {
						lappend tokenized_template [list $::broomride::template::CODE [string trim $part "\{%\} "]]
					}
					"\{#" {
						lappend tokenized_template [list $::broomride::template::COMMENT [string trim $part "\{#\} "]]
					}
					default {
						lappend tokenized_template [list $::broomride::template::TEXT $part]
					}
				}
			}
		}
	}
}

package provide broomride 1.0