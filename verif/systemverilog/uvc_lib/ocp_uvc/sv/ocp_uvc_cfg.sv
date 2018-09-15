//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_cfg.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_CFG_SV
`define OCP_UVC_CFG_SV

class ocp_uvc_cfg extends uvm_object;
  
  // agents configurations
  ocp_uvc_agent_cfg m_master_agent_cfg;
  ocp_uvc_agent_cfg m_slave_agent_cfg;
  
  // registration macro
  `uvm_object_utils_begin(ocp_uvc_cfg)
    `uvm_field_object(m_master_agent_cfg, UVM_ALL_ON)
    `uvm_field_object(m_slave_agent_cfg, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // constructor   
  extern function new(string name = "ocp_uvc_cfg");
    
endclass : ocp_uvc_cfg

// constructor
function ocp_uvc_cfg::new(string name = "ocp_uvc_cfg");
  super.new(name);

  // create agents configurations
  m_master_agent_cfg = ocp_uvc_agent_cfg::type_id::create("m_master_agent_cfg");
  m_slave_agent_cfg = ocp_uvc_agent_cfg::type_id::create("m_slave_agent_cfg");
endfunction : new

`endif // OCP_UVC_CFG_SV
