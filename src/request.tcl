package require Itcl

namespace eval ::broomride::request {

	namespace export HttpRequest

	catch {::itcl::delete class HttpRequest}
	::itcl::class HttpRequest {
		private variable _method
		private variable _headers
		private variable _query_params
		private variable _body

		constructor {method headers query_params body} {
			set _method $method
			set _headers $headers
			set _query_params $query_params
			set _body $body
		}

		method getMethod {} {
			return $_method
		}

		method getHeaders {} {
			return $_headers
		}

		method getHeader {key} {
			return [dict get $_headers key]
		}

		method getQueryParams {} {
			return $_query_params
		}

		method getQueryParam {key} {
			return [dict get $_query_params key]
		}

		method getBody {} {
			return $_body
		}
	}
}

package provide broomride 1.0