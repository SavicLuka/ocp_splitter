//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_env_top_pkg.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_ENV_TOP_PKG_SV
`define OCP_SPLITTER_ENV_TOP_PKG_SV

package ocp_splitter_env_top_pkg;

`include "uvm_macros.svh"
import uvm_pkg::*;

// import UVC's packages
import ocp_uvc_pkg::*;

// include env files
`include "ocp_splitter_scoreboard_cfg.sv"
`include "ocp_splitter_scoreboard.sv"
`include "ocp_splitter_vir_sequencer.sv"
`include "ocp_splitter_vir_sequence.sv"
`include "ocp_splitter_cfg_top.sv"
`include "ocp_splitter_env_top.sv"

endpackage : ocp_splitter_env_top_pkg

`endif // OCP_SPLITTER_ENV_TOP_PKG_SV
