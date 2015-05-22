#!C:\Tcl\bin\tclsh.exe
set auto_path [linsert $auto_path 0 "[pwd]/../src/"]

package require Itcl
package require broomride 1.0

namespace import ::broomride::application::*
namespace import ::broomride::route::*
namespace import ::broomride::view::*

set DEBUG 1

::itcl::class HelloWorldView {
	inherit ::broomride::view::View

	method get {request} {
		return "Hello, World!"
	}
}

set routes [list \
	[Route #auto "/hello" [HelloWorldView #auto]]\
]

Application app $routes $DEBUG
app handle