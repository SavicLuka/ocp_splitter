//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_env_top_pkg.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_ENV_TOP_PKG_SV
`define OCP_UVC_ENV_TOP_PKG_SV

package ocp_uvc_env_top_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

// import UVC's packages
import ocp_uvc_pkg::*;

// include env files
`include "ocp_uvc_cfg_top.sv"
`include "ocp_uvc_env_top.sv"

endpackage : ocp_uvc_env_top_pkg

`endif // OCP_UVC_ENV_TOP_PKG_SV
