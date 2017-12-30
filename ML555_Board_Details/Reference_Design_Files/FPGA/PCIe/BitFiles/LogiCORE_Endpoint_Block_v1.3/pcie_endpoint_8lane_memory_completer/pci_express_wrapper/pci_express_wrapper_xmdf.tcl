################################################################################
##   ____  ____ 
##  /   /\/   / 
## /___/  \  /    Vendor      : Xilinx 
## \   \   \/     Version     : 1.3
##  \   \         Application : Generated by Xilinx PCI Express Wizard
##  /   /         Filename    : pci_express_wrapper_xmdf.tcl
## /___/   /\   
## \   \  /  \ 
##  \___\/\___\ 
##
################################################################################

# The package naming convention is <core_name>_xmdf
package provide pci_express_wrapper_xmdf 1.0

# This includes some utilities that support common XMDF operations
package require utilities_xmdf

# Define a namespace for this package. The name of the name space
# is <core_name>_xmdf
namespace eval ::pci_express_wrapper_xmdf {
    # Use this to define any statics
}

# Function called by client to rebuild the params and port arrays
# Optional when the use context does not require the param or ports
# arrays to be available.
proc ::pci_express_wrapper_xmdf::xmdfInit { instance } {
    # Variable containg name of library into which module is compiled
    # Recommendation: <module_name>
    # Required
    utilities_xmdf::xmdfSetData $instance Module Attributes Name pci_express_wrapper
}
# ::pci_express_wrapper_xmdf::xmdfInit

# Function called by client to fill in all the xmdf* data variables
# based on the current settings of the parameters
proc ::pci_express_wrapper_xmdf::xmdfApplyParams { instance } {

}
# ::pci_express_wrapper_xmdf::xmdfApplyParams
