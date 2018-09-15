//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_env.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_ENV_SV
`define OCP_UVC_ENV_SV

class ocp_uvc_env extends uvm_env;
  
  // registration macro
  `uvm_component_utils(ocp_uvc_env)
  
  // configuration instance
  ocp_uvc_cfg m_cfg;

  // agents instances
  ocp_uvc_master_agent m_master_agent;
  ocp_uvc_slave_agent m_slave_agent;
  
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  
endclass : ocp_uvc_env

// constructor
function ocp_uvc_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void ocp_uvc_env::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // get configuration
  if(!uvm_config_db #(ocp_uvc_cfg)::get(this, "", "m_cfg", m_cfg)) begin
    `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
  end
  
  // set agents configurations
  uvm_config_db#(ocp_uvc_agent_cfg)::set(this, "m_master_agent", "m_cfg", m_cfg.m_master_agent_cfg);
  uvm_config_db#(ocp_uvc_agent_cfg)::set(this, "m_slave_agent", "m_cfg", m_cfg.m_slave_agent_cfg);  

  // create agents
  m_master_agent = ocp_uvc_master_agent::type_id::create("m_master_agent", this);
  m_slave_agent = ocp_uvc_slave_agent::type_id::create("m_slave_agent", this);
endfunction : build_phase

`endif // OCP_UVC_ENV_SV
