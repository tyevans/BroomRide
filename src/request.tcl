package require Itcl

namespace eval ::broomride::request {

	namespace export HttpRequest

	::itcl::class HttpRequest {
		private variable _method
		private variable _url
		private variable _headers
		private variable _query_params
		private variable _body

		constructor {} {

		}

		method getMethod {} {
			if {![info exists _method]} {
				if {[info exists ::env(REQUEST_METHOD)]} {
					set _method $::env(REQUEST_METHOD)
				} else {
					set _method "GET"
				}
			}
			return $_method
		}

		method getURL {} {
			if {![info exists _url]} {
				if {[info exists ::env(REQUEST_URI)]} {
					regexp "(.*?)\?" $::env(REQUEST_URI) -> url 
					set _url $url
				} else {
					set _url "/"
				}
			}
			return $_url
		}

		method getQueryParams {} {
			if {![info exists _query_params]} {
				if {[info exists ::env(REQUEST_URI)]} { 
					set query_params [dict create]
					foreach {key value} [::ncgi::nvlist] {
						dict set query_params $key $value
					}
					set _query_params $query_params
				}
			}
			return $_query_params 
		}

		method getBody {} {
			return $_body
		}
	}
}

package provide broomride 1.0