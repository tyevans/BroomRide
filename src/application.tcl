package require Itcl
package require ncgi

namespace eval ::broomride::application {

	namespace export Application

	::itcl::class Application {
		private variable _routes
		private variable _debug

		constructor {routes debug} {
			set _routes $routes
			set _debug $debug
		}

		private method _handle {} {
			set request [::broomride::request::HttpRequest #auto]
			set route [getRoute $request]
			if {[::itcl::is object $route]} {
				set response [[$route getView] handleRequest [namespace which $request]]
				if {![::itcl::is object [namespace which $response]]} {
					set response [::broomride::response::HttpResponse #auto $response]
				}
			} else {
				set response [::broomride::response::HttpResponse #auto "404: Not Found"]
				$response setHeaders [list "Status-Code" 404] 
			}


			sendResponse [namespace which $response]
			::itcl::delete object $request
			if {[::itcl::is object $response]} {
				::itcl::delete object $response
			}
		}

		method handle {} {
			if {$_debug} {
				if {[info exists ::env(REQUEST_METHOD)]} {
					set err [catch {_handle} errMsg]
					if {![string is false $err]} {
						::ncgi::header "text/plain"
						puts "Error: $err:: $errMsg"
					}
				} else {
					_handle
				}
			} else {
				catch {_handle}
			}
		}

		method sendResponse {response} {
			set contentType [$response getContentType]
			set headers [$response getHeaders]
			::ncgi::header $contentType $headers
			puts [$response getBody]

		}

		method getRoute {request} {
			set url [$request getURL]
			foreach route $_routes {
				set match [$route match $url]
				if {[string is true -strict $match]} {
					return $route
				}
			}
		}
	}
}

package provide broomride 1.0