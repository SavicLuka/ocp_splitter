//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File ocp  : test_ocp_splitter_base.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_OCP_SPLITTER_BASE_SV
`define TEST_OCP_SPLITTER_BASE_SV

class test_ocp_splitter_base extends uvm_test;
  
  // registration macro
  `uvm_component_utils(test_ocp_splitter_base)
  
  // component instance
  ocp_splitter_env_top m_ocp_splitter_env_top;
  
  // configuration instance
  ocp_splitter_cfg_top m_cfg;
  
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  // run phase
	extern virtual task run_phase(uvm_phase phase);
  // end_of_elaboration phase
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  // set default configuration
  extern virtual function void set_default_configuration();
    
endclass : test_ocp_splitter_base 

// constructor
function test_ocp_splitter_base::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

task test_ocp_splitter_base::run_phase(uvm_phase phase);
	super.run_phase(phase);								
	
	m_ocp_splitter_env_top.m_ocp_uvc_env.m_master_agent.m_vif.has_resp = 0;
	m_ocp_splitter_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.has_resp = 0;
	m_ocp_splitter_env_top.m_ocp_uvc_env.m_master_agent.m_vif.data_width = 1;
	m_ocp_splitter_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.data_width = 0;														
endtask : run_phase

// build phase
function void test_ocp_splitter_base::build_phase(uvm_phase phase);
  super.build_phase(phase);    
  
  // create component
  m_ocp_splitter_env_top = ocp_splitter_env_top::type_id::create("m_ocp_splitter_env_top", this);
   
  // create and set configuration
  m_cfg = ocp_splitter_cfg_top::type_id::create("m_cfg", this);
  set_default_configuration();
  
  // set configuration in DB
  uvm_config_db#(ocp_splitter_cfg_top)::set(this, "m_ocp_splitter_env_top", "m_cfg", m_cfg);

  // enable monitor item recording
  set_config_int("*", "recording_detail", 1);
  
  // define verbosity
  uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
endfunction : build_phase

// end_of_elaboration phase
function void test_ocp_splitter_base::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

  // allow additional time before stopping
  uvm_test_done.set_drain_time(this, 10us);
endfunction : end_of_elaboration_phase

// set default configuration
function void test_ocp_splitter_base::set_default_configuration();
  // define default configuration
	m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_is_active = UVM_ACTIVE;
  m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_has_checks = 1;
  m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_has_coverage = 0;
	m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_data_width = 'h20;
	m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_has_resp = 0;
  m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_is_active = UVM_ACTIVE;
  m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_has_checks = 1;
  m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_has_coverage = 0;
	m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_data_width = 'h10;
	m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_has_resp = 0;
	m_cfg.m_score_cfg.m_has_checks = 1;
	m_cfg.m_score_cfg.m_has_coverage = 1;
	m_cfg.m_score_cfg.m_data_width = 'h20;
endfunction : set_default_configuration

`endif // TEST_OCP_SPLITTER_BASE_SV
