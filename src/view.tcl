package require Itcl

namespace eval ::broomride::view {

	namespace export View

	catch {::itcl::delete class View}
	::itcl::class View {
		private variable REQUEST_METHODS [list "GET" "POST" "PUT" "DELETE" "HEAD"]

		method handleRequest {request} {
			set method [$request getMethod]

			switch $method {
				"GET" { set result [get $request] }
				"POST" { set result [post $request] }
				"PUT" { set result [put $request] }
				"DELETE" { set result [delete $request] }
				"HEAD" { set result [head $request] }
				"OPTIONS" { set result [options $request] }
				default { error "NotImplemented" }
			}
			return [namespace which $result]
		}

		method get {request} { error "NotImplemented" }
		method post {request} { error "NotImplemented" }
		method put {request} { error "NotImplemented" }
		method delete {resquest} { error "NotImplemented" }
		method head {request} { error "NotImplemented" }
	}

	catch {::itcl::delete class TemplatedView}
	::itcl::class TemplatedView {
		inherit ::broomride::view::View

		private variable _template

		constructor {{template ""}} {} {
			set _template template
		}
	}
}

package provide broomride 1.0