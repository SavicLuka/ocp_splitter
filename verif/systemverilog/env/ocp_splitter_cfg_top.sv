//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_cfg_top.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_CFG_TOP_SV
`define OCP_SPLITTER_CFG_TOP_SV

class ocp_splitter_cfg_top extends uvm_object;
    
  // ocp configuration
  ocp_uvc_cfg m_ocp_uvc_cfg;

	// scoreboard configuration
	ocp_splitter_scoreboard_cfg m_score_cfg;
  
  // registration macro
  `uvm_object_utils_begin(ocp_splitter_cfg_top)
    `uvm_field_object(m_ocp_uvc_cfg, UVM_ALL_ON)
		`uvm_field_object(m_score_cfg, UVM_ALL_ON)
  `uvm_object_utils_end
    
  // constructor
  extern function new(string name = "ocp_splitter_cfg_top");
  
endclass : ocp_splitter_cfg_top

// constructor
function ocp_splitter_cfg_top::new(string name = "ocp_splitter_cfg_top");
  super.new(name);
  
  // create configurations
  m_ocp_uvc_cfg = ocp_uvc_cfg::type_id::create("m_ocp_uvc_cfg");
	m_score_cfg = ocp_splitter_scoreboard_cfg::type_id::create("m_score_cfg");
endfunction : new

`endif // OCP_SPLITTER_CFG_TOP_SV
