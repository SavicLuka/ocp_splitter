//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_ocp_splitter_example.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_OCP_SPLITTER_EXAMPLE_SV
`define TEST_OCP_SPLITTER_EXAMPLE_SV

// example test
class test_ocp_splitter_example extends test_ocp_splitter_base;
  
  // registration macro
  `uvm_component_utils(test_ocp_splitter_example)

	ocp_splitter_vir_sequence virtual_sequence;

  // constructor
  extern function new(string name, uvm_component parent);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // set default configuration
  extern function void set_default_configuration();
  
endclass : test_ocp_splitter_example

// constructor
function test_ocp_splitter_example::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// run phase
task test_ocp_splitter_example::run_phase(uvm_phase phase);
  super.run_phase(phase);

  uvm_test_done.raise_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)

	virtual_sequence = ocp_splitter_vir_sequence::type_id::create("virtual_sequence");
	
	virtual_sequence.num_of_sequences = 50000;	
	virtual_sequence.test_values = 1'b0;
	virtual_sequence.test_cmd = WRITE;
	virtual_sequence.test_addr = 32'h2234_1234;
	virtual_sequence.test_rdata = 0;
	virtual_sequence.test_delay_master = 3;
	virtual_sequence.test_dalay_slave = 4;
	virtual_sequence.test_wdata = 32'hFFAA_BBCC;
	
	virtual_sequence.start(m_ocp_splitter_env_top.m_ocp_splitter_vir_sequencer);

	 uvm_test_done.drop_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW)

endtask : run_phase

// set default configuration
function void test_ocp_splitter_example::set_default_configuration();
  super.set_default_configuration();
  
endfunction : set_default_configuration

`endif // TEST_OCP_SPLITTER_EXAMPLE_SV
