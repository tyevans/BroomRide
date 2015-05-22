package require Itcl

namespace eval ::broomride::response {

	namespace export HttpResponse 

	::itcl::class HttpResponse {
		private variable _body
		private variable _headers
		private variable _contentType "text/html"

		constructor {body {headers 0}} {
			set _body $body

			if {![string is false -strict _headers]} {
				set _headers $headers
			} else {
				set _headers [list]
			}

		}

		method getHeaders {} {
			return $_headers
		}

		method setHeaders {headers} {
			set _headers $headers
		}

		method setContentType {ct} {
			set _contentType $ct
		}

		method getContentType {} {
			return $_contentType
		}

		method getBody {} {
			return $_body
		}

		method send {
			send_headers
			send_body
		}
	}

}

package provide broomride 1.0
