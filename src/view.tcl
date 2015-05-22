package require Itcl

namespace eval ::broomride::view {

	namespace export View

	catch {::itcl::delete class View}
	::itcl::class View {
		private variable REQUEST_METHODS [list "GET" "POST" "PUT" "DELETE" "HEAD"]

		method handle_request {request} {
			switch [$request getMethod] {
				"GET" { return [get $request] }
				"POST" { return [post $request] }
				"PUT" { return [put $request] }
				"DELETE" { return [delete $request] }
				"HEAD" { return [head $request] }
				default { error "NotImplemented" }
			}
		}

		method get {request} { error "NotImplemented" }
		method post {request} { error "NotImplemented" }
		method put {request} { error "NotImplemented" }
		method delete {resquest} { error "NotImplemented" }
		method head {request} { error "NotImplemented" }

	}
}

package provide broomride 1.0