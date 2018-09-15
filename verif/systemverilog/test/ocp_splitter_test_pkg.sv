//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_test_pkg.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_TEST_PKG_SV
`define OCP_SPLITTER_TEST_PKG_SV



package ocp_splitter_test_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

// import UVC's packages
import ocp_uvc_pkg::*;

// import env package
import ocp_splitter_env_top_pkg::*;

// include tests
`include "test_ocp_splitter_base.sv"
`include "test_ocp_splitter_example.sv"
`include "test_ocp_splitter_example_reset.sv"

endpackage : ocp_splitter_test_pkg

`endif // OCP_SPLITTER_TEST_PKG_SV
