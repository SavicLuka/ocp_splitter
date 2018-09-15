//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_ocp_uvc_example.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_OCP_UVC_EXAMPLE_SV
`define TEST_OCP_UVC_EXAMPLE_SV

// example test
class test_ocp_uvc_example extends test_ocp_uvc_base;
  
  // registration macro
  `uvm_component_utils(test_ocp_uvc_example)
  
  // sequences
  ocp_uvc_master_seq m_master_seq;
  ocp_uvc_slave_seq m_slave_seq;

	int num_of_trans = 100;

	int reset_delay;
	bit has_resp;		
	bit data_width;  // 0 - 16b , 1 - 32b

  // constructor
  extern function new(string name, uvm_component parent);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // set default configuration
  extern function void set_default_configuration();
  
endclass : test_ocp_uvc_example

// constructor
function test_ocp_uvc_example::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// run phase
task test_ocp_uvc_example::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  uvm_test_done.raise_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
	`uvm_info(get_type_name(), $sformatf("Data width = : %d (0 - 16b, 1 - 32b)\n", data_width), UVM_HIGH)	
	`uvm_info(get_type_name(), $sformatf("Have response = : %d\n", has_resp), UVM_HIGH)		

  m_slave_seq = ocp_uvc_slave_seq::type_id::create("m_slave_seq", this);
  m_master_seq = ocp_uvc_master_seq::type_id::create("m_master_seq", this);
	
	m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent.m_vif.has_resp = has_resp;
	m_ocp_uvc_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.has_resp = has_resp;
	m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent.m_vif.data_width = data_width;
	m_ocp_uvc_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.data_width = data_width;
	m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent.m_vif.has_checkers = 1;
	m_ocp_uvc_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.has_checkers = 1;

	fork : test_slave_fork

	// slave 
	begin
		forever begin
			if(!m_slave_seq.randomize() with {
					//s_delay == 0;
					//s_delay_resp == 0;
			}) begin
				 `uvm_fatal(get_type_name(), "Failed to randomize.")
			end

			m_slave_seq.start(m_ocp_uvc_env_top.m_ocp_uvc_env.m_slave_agent.m_sequencer);
		end // forever
	end // slave
/**/
	//reset
	begin
		repeat(num_of_trans) begin
      if (!randomize(reset_delay) with {
				reset_delay inside {[2:50]};
		  }) begin
				`uvm_fatal(get_type_name(), "Failed to randomize.")
			end
			#(reset_delay * 100) m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent.m_vif.reset_n = 0;
			if (!randomize(reset_delay) with {
				reset_delay inside {[2:50]};
		  }) begin
				`uvm_fatal(get_type_name(), "Failed to randomize.")
			end
			#(reset_delay * 100) m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent.m_vif.reset_n = 1;
		end // repeat
	end // reset
/**/
	join_none 

	repeat(num_of_trans) begin		
		
		if(!m_master_seq.randomize() with {
		 // s_delay == 0;
		}) begin
		  `uvm_fatal(get_type_name(), "Failed to randomize.")
		end
		m_master_seq.start(m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent.m_sequencer);
	end

  uvm_test_done.drop_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW)
endtask : run_phase

// set default configuration
function void test_ocp_uvc_example::set_default_configuration();
  super.set_default_configuration();
	if (!randomize(has_resp)) begin
		`uvm_fatal(get_type_name(), "Failed to randomize.")
	end
	if (!randomize(data_width)) begin
		`uvm_fatal(get_type_name(), "Failed to randomize.")
	end  
	m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_is_active = UVM_ACTIVE;
  m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_has_checks = 1;
  m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_has_coverage = 1;
	if (data_width == 1) begin
		m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_data_width = 'h20;
	end
	else begin
		m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_data_width = 'h10;
	end
	if (has_resp == 1) begin
		m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_has_resp = 1;
		//m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent.m_vif.has_resp = 1;
	end
	else begin
		m_cfg.m_ocp_uvc_cfg.m_master_agent_cfg.m_has_resp = 0;
		//m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent.m_vif.has_resp = 0;
	end
  m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_is_active = UVM_ACTIVE;
  m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_has_checks = 1;
  m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_has_coverage = 1;
	if (data_width == 1) begin
		m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_data_width = 'h20;
	end
	else begin
		m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_data_width = 'h10;
	end
	if (has_resp == 1) begin
		m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_has_resp = 1;
		//m_ocp_uvc_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.has_resp = 1;
	end
	else begin
		m_cfg.m_ocp_uvc_cfg.m_slave_agent_cfg.m_has_resp = 0;
		//m_ocp_uvc_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.has_resp = 0;
	end

endfunction : set_default_configuration

`endif // TEST_OCP_UVC_EXAMPLE_SV
