package require Itcl

namespace eval ::broomride::route {

	namespace export Route

	::itcl::class Route {
		private variable _url_pattern
		private variable _view

		constructor {url_pattern view} {
			set _url_pattern $url_pattern
			set _view $view
		}

		method match {url} {
			set is_match [regexp -inline $_url_pattern $url]
			return [expr {[string length $is_match]>0}]
		}

		method getView {} {
			return $_view
		}

		method handleRequest {request} {
			return [[$this getView] handleRequest [namespace which $request]]
		}

	}
}

package provide broomride 1.0