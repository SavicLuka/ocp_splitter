//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_env_top.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_ENV_TOP_SV
`define OCP_UVC_ENV_TOP_SV

class ocp_uvc_env_top extends uvm_env;
  
  // registration macro
  `uvm_component_utils(ocp_uvc_env_top)

  // configuration reference
  ocp_uvc_cfg_top m_cfg;
    
  // component instance
  ocp_uvc_env m_ocp_uvc_env;
  
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  
endclass : ocp_uvc_env_top

// constructor
function ocp_uvc_env_top::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void ocp_uvc_env_top::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // get configuration
  if(!uvm_config_db #(ocp_uvc_cfg_top)::get(this, "", "m_cfg", m_cfg)) begin
    `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
  end

  // set configuration
  uvm_config_db#(ocp_uvc_cfg)::set(this, "m_ocp_uvc_env", "m_cfg", m_cfg.m_ocp_uvc_cfg);

  // create component
  m_ocp_uvc_env = ocp_uvc_env::type_id::create("m_ocp_uvc_env", this);
endfunction : build_phase

`endif // OCP_UVC_ENV_TOP_SV
