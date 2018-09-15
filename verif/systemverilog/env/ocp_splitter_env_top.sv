//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_env_top.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_ENV_TOP_SV
`define OCP_SPLITTER_ENV_TOP_SV

class ocp_splitter_env_top extends uvm_env;
  
  // registration macro
  `uvm_component_utils(ocp_splitter_env_top)

  // configuration references
  ocp_splitter_cfg_top m_cfg;
    
  // component instance
  ocp_uvc_env m_ocp_uvc_env;

	// scoreboard instance
	ocp_splitter_scoreboard m_ocp_splitter_scoreboard;

	// virtual sequencer instance
	ocp_splitter_vir_sequencer m_ocp_splitter_vir_sequencer;
  
	covergroup ocp_splitter_reset_cg @(posedge m_ocp_uvc_env.m_master_agent.m_vif.clock);
		option.per_instance = 1;
	
		cov_reset : coverpoint m_ocp_uvc_env.m_master_agent.m_vif.reset_n{
			bins reset_0_to_1 = ( 0 => 1 );
			bins reset_1_to_0 = ( 1 => 0 );
		}
	endgroup : ocp_splitter_reset_cg	

  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
	// connect phase
	extern virtual function void connect_phase(uvm_phase phase);
  
endclass : ocp_splitter_env_top

// constructor
function ocp_splitter_env_top::new(string name, uvm_component parent);
  super.new(name, parent);
	ocp_splitter_reset_cg = new();
endfunction : new

// build phase
function void ocp_splitter_env_top::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // get configuration
  if(!uvm_config_db #(ocp_splitter_cfg_top)::get(this, "", "m_cfg", m_cfg)) begin
    `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
  end

  // set configuration
  uvm_config_db#(ocp_uvc_cfg)::set(this, "m_ocp_uvc_env", "m_cfg", m_cfg.m_ocp_uvc_cfg);

  // create component
  m_ocp_uvc_env = ocp_uvc_env::type_id::create("m_ocp_uvc_env", this);

	// create scoreboard
	m_ocp_splitter_scoreboard = ocp_splitter_scoreboard::type_id::create("m_ocp_splitter_scoreboard", this);

	// create virtual sequencer
	m_ocp_splitter_vir_sequencer = ocp_splitter_vir_sequencer::type_id::create("m_ocp_splitter_vir_sequencer", this);
endfunction : build_phase

// connect phase
function void ocp_splitter_env_top::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	m_ocp_uvc_env.m_master_agent.m_aport.connect(m_ocp_splitter_scoreboard.m_port_32);
	m_ocp_uvc_env.m_slave_agent.m_aport.connect(m_ocp_splitter_scoreboard.m_port_16);

	m_ocp_splitter_vir_sequencer.master_sequencer = m_ocp_uvc_env.m_master_agent.m_sequencer;
	m_ocp_splitter_vir_sequencer.slave_sequencer = m_ocp_uvc_env.m_slave_agent.m_sequencer;

	m_ocp_splitter_scoreboard.m_cfg = m_cfg.m_score_cfg;

endfunction : connect_phase

`endif // OCP_SPLITTER_ENV_TOP_SV
