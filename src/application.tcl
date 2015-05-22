package require Itcl

namespace eval ::broomride::application {

	namespace export Application

	catch {::itcl::delete class Application}
	::itcl::class Application {
	}
}

package provide broomride 1.0