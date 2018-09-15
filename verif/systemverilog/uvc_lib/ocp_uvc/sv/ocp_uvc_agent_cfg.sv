//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_agent_cfg.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_AGENT_CFG_SV
`define OCP_UVC_AGENT_CFG_SV

class ocp_uvc_agent_cfg extends uvm_object;
  
  // configuration fields
  uvm_active_passive_enum m_is_active = UVM_ACTIVE;
  bit m_has_checks;
  bit m_has_coverage;
	bit m_has_resp;  
	byte m_data_width;
  
  // registration macro
  `uvm_object_utils_begin(ocp_uvc_agent_cfg)
    `uvm_field_enum(uvm_active_passive_enum, m_is_active, UVM_ALL_ON)
    `uvm_field_int(m_has_checks, UVM_ALL_ON)
    `uvm_field_int(m_has_coverage, UVM_ALL_ON)
		`uvm_field_int(m_has_resp, UVM_ALL_ON)
		`uvm_field_int(m_data_width, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // constructor   
  extern function new(string name = "ocp_uvc_agent_cfg");
    
endclass : ocp_uvc_agent_cfg

// constructor
function ocp_uvc_agent_cfg::new(string name = "ocp_uvc_agent_cfg");
  super.new(name);
endfunction : new

`endif // OCP_UVC_AGENT_CFG_SV
