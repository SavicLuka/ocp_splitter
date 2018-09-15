//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_test_pkg.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_TEST_PKG_SV
`define OCP_UVC_TEST_PKG_SV

package ocp_uvc_test_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

// import UVC's packages
import ocp_uvc_pkg::*;

// import env package
import ocp_uvc_env_top_pkg::*;

// include tests
`include "test_ocp_uvc_base.sv"
`include "test_ocp_uvc_example.sv"

endpackage : ocp_uvc_test_pkg

`endif // OCP_UVC_TEST_PKG_SV
