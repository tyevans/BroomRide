#!C:\Tcl\bin\tclsh.exe
set auto_path [linsert $auto_path 0 "[pwd]/../src/"]

package require Itcl
package require broomride 1.0

namespace import ::broomride::application::*
namespace import ::broomride::route::*
namespace import ::broomride::view::*
namespace import ::broomride::response::*

set DEBUG 1

::itcl::class HelloWorldView {
	inherit ::broomride::view::View

	method get {request} {
		return "Hello, World!"
	}
}

::itcl::class CatchAllView {
	inherit ::broomride::view::View

	method handleRequest {request} {
		set response [HttpResponse #auto "404: Not Found"]
		$response setHeaders [list "Status-Code" 404]
		return [namespace which $response]
	}
}


set routes [list \
	[Route #auto "/hello" [HelloWorldView #auto]]\
	[Route #auto ".*" [CatchAllView #auto]]\
]

Application app $routes $DEBUG
app handle