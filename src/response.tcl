package require Itcl

namespace eval ::broomride::response {

	namespace export HttpResponse 

	::itcl::class HttpResponse {
		private variable _content
		private variable _headers
		private variable _contentType "text/html"

		constructor {content {headers 0}} {
			set  _content $content

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
			return $_content
		}

		method send {
			send_headers
			send_body
		}

		method getReference {
			return $this
		}
	}

}

package provide broomride 1.0
