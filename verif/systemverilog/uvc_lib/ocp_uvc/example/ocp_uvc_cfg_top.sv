//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_cfg_top.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_CFG_TOP_SV
`define OCP_UVC_CFG_TOP_SV

class ocp_uvc_cfg_top extends uvm_object;
    
  // UVC configuration
  ocp_uvc_cfg m_ocp_uvc_cfg;
  
  // registration macro
  `uvm_object_utils_begin(ocp_uvc_cfg_top)
    `uvm_field_object(m_ocp_uvc_cfg, UVM_ALL_ON)
  `uvm_object_utils_end
    
  // constructor
  extern function new(string name = "ocp_uvc_cfg_top");
  
endclass : ocp_uvc_cfg_top

// constructor
function ocp_uvc_cfg_top::new(string name = "ocp_uvc_cfg_top");
  super.new(name);
  
  // create UVC configuration
  m_ocp_uvc_cfg = ocp_uvc_cfg::type_id::create("m_ocp_uvc_cfg");
endfunction : new

`endif // OCP_UVC_CFG_TOP_SV
