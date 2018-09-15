//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_scoreboard_cfg.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_SCOREBOARD_CFG_SV
`define OCP_SPLITTER_SCOREBOARD_CFG_SV

class ocp_splitter_scoreboard_cfg extends uvm_object;
    
  // configuration fields
	bit m_has_checks;
  bit m_has_coverage;
	byte m_data_width;
  
  // registration macro
  `uvm_object_utils_begin(ocp_splitter_scoreboard_cfg)
    `uvm_field_int(m_has_checks, UVM_ALL_ON)
		`uvm_field_int(m_has_coverage, UVM_ALL_ON)
		`uvm_field_int(m_data_width, UVM_ALL_ON)
  `uvm_object_utils_end
    
  // constructor
  extern function new(string name = "ocp_splitter_scoreboard_cfg");
  
endclass : ocp_splitter_scoreboard_cfg

// constructor
function ocp_splitter_scoreboard_cfg::new(string name = "ocp_splitter_scoreboard_cfg");
  super.new(name);
endfunction : new


`endif // OCP_SPLITTER_SCOREBOARD_CFG_SV
