//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_ocp_splitter_example_reset.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_OCP_SPLITTER_EXAMPLE_RESET_SV
`define TEST_OCP_SPLITTER_EXAMPLE_RESET_SV

// example test
class test_ocp_splitter_example_reset extends test_ocp_splitter_base;
  
  // registration macro
  `uvm_component_utils(test_ocp_splitter_example_reset)

	int reset_delay;
	int num_of_res = 50;

	ocp_splitter_vir_sequence m_sequence;

  // constructor
  extern function new(string name, uvm_component parent);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // set default configuration
  extern function void set_default_configuration();
  
endclass : test_ocp_splitter_example_reset

// constructor
function test_ocp_splitter_example_reset::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// run phase
task test_ocp_splitter_example_reset::run_phase(uvm_phase phase);
  super.run_phase(phase);

  uvm_test_done.raise_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)

	m_sequence = ocp_splitter_vir_sequence::type_id::create("m_sequence");
	
	m_sequence.num_of_sequences = 50000;
	
	fork : vir_seq_start
		m_sequence.start(m_ocp_splitter_env_top.m_ocp_splitter_vir_sequencer);

		begin
			repeat(num_of_res) begin
				if (!randomize(reset_delay) with {
					reset_delay inside {[2:50]};
				}) begin
					`uvm_fatal(get_type_name(), "Failed to randomize.")
				end
				#(reset_delay * 100) m_ocp_splitter_env_top.m_ocp_uvc_env.m_master_agent.m_vif.reset_n = 0;
				m_ocp_splitter_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.reset_n = 0;
				if (!randomize(reset_delay) with {
					reset_delay inside {[2:50]};
				}) begin
					`uvm_fatal(get_type_name(), "Failed to randomize.")
				end
				#(reset_delay * 100) m_ocp_splitter_env_top.m_ocp_uvc_env.m_master_agent.m_vif.reset_n = 1;
				m_ocp_splitter_env_top.m_ocp_uvc_env.m_slave_agent.m_vif.reset_n = 1;
			end
		end

	join

	 uvm_test_done.drop_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW)

endtask : run_phase

// set default configuration
function void test_ocp_splitter_example_reset::set_default_configuration();
  super.set_default_configuration();
  
endfunction : set_default_configuration

`endif // TEST_OCP_SPLITTER_EXAMPLE_RESET_SV
