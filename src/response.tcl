package require Itcl

namespace eval ::broomride::response {

	namespace export HttpResponse

	catch {::itcl::delete class HttpResponse}
	::itcl::class HttpResponse {
		private variable _body
		private variable _headers

		constructor {body {headers 0}} {
			set _body $body

			if {![string is false -strict _headers]} {
				set _headers $headers
			} else {
				set _headers {dict create \
					"Content-Type" "text/html"\
				}
			}

		}

		method send_headers {} {
			dict for {key value} $_headers {
				puts "$key: $value"
			} 
		}

		method send_body {} {
			puts $_body
		}

		method send {
			send_headers
			send_body
		}
	}

	::itcl::class HttpResponse404 {
		inherit HttpResponse

		constructor {body {headers 0}} {$body $headers} {

		}

		method send_headers {} {
			puts "404 Not Found"
			chain
		}

	}

	::itcl::class HttpResponseRedirect {

	}

}

package provide broomride 1.0
