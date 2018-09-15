//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_pkg.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_PKG_SV
`define OCP_UVC_PKG_SV

`include "ocp_uvc_if.sv"

package ocp_uvc_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "ocp_uvc_common.sv"
`include "ocp_uvc_agent_cfg.sv"
`include "ocp_uvc_cfg.sv"
`include "ocp_uvc_item.sv"
`include "ocp_uvc_master_driver.sv"
`include "ocp_uvc_slave_driver.sv"
`include "ocp_uvc_sequencer.sv"
`include "ocp_uvc_monitor.sv"
`include "ocp_uvc_cov.sv"
`include "ocp_uvc_master_agent.sv"
`include "ocp_uvc_slave_agent.sv"
`include "ocp_uvc_env.sv"
`include "ocp_uvc_seq_lib.sv"

endpackage : ocp_uvc_pkg

`endif // OCP_UVC_PKG_SV
