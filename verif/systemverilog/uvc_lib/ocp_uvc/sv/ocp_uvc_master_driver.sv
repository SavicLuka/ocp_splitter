//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_master_driver.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_MASTER_DRIVER_SV
`define OCP_UVC_MASTER_DRIVER_SV

class ocp_uvc_master_driver extends uvm_driver #(ocp_uvc_item);
  
  // registration macro
  `uvm_component_utils(ocp_uvc_master_driver)
  
  // virtual interface reference
  virtual interface ocp_uvc_if m_vif;
  
  // configuration reference
  ocp_uvc_agent_cfg m_cfg;
  
  // request item
  REQ m_req;
   
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // process item
  extern virtual task process_item(ocp_uvc_item item);

endclass : ocp_uvc_master_driver

// constructor
function ocp_uvc_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void ocp_uvc_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

// run phase
task ocp_uvc_master_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);

  // init signals
	m_vif.cmd <= IDLE;
	m_vif.addr <= 0;
	m_vif.wdata <= 0;
  
  forever begin

		// wait until reset is de-asserted
		`uvm_info(get_type_name(), "Wait until reset is deasserted.", UVM_HIGH)
		if (m_vif.reset_n !== 1) begin
  		wait (m_vif.reset_n === 1);
			m_vif.cmd = IDLE;
		end
		`uvm_info(get_type_name(), "Master driver starts.", UVM_HIGH)
		seq_item_port.get_next_item(m_req);

		fork : run_phase_fork_block

			// drive signals
			begin
				
				process_item(m_req);
				
			end

			// handle reset
			begin
				@(posedge m_vif.clock iff m_vif.reset_n == 0);
				//m_vif.cmd <= IDLE;
 				`uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)
			end
		join_any // run_phase_fork_block
		disable fork;

		seq_item_port.item_done();

  end
endtask : run_phase


// process item
task ocp_uvc_master_driver::process_item(ocp_uvc_item item);
  // print item
  `uvm_info(get_type_name(), $sformatf("Item to be driven: \n%s", item.sprint()), UVM_HIGH)
  
	// wait before start transaction
	repeat (item.delay) begin
		@(posedge m_vif.clock);
	end

  // drive signals
	/*
  if (item.delay == 0) begin
		@(posedge m_vif.clock);
	end*/
	m_vif.cmd <= item.cmd;
	m_vif.addr <= item.addr;
	if (item.cmd == WRITE) begin
		m_vif.wdata <= item.wdata & (~(32'hFFFF_FFFF << m_cfg.m_data_width));
	end

	// wait until transaction is accepted
	@(posedge m_vif.clock);
	while (m_vif.cmd_accept == 0) begin
		@(posedge m_vif.clock);
	end

	// return to initial values
	m_vif.cmd <= IDLE;

	if (m_cfg.m_has_resp) begin
		// wait for response
		while (m_vif.resp == NULL) begin
			@(posedge m_vif.clock);
		end
	end // if

endtask : process_item

`endif // OCP_UVC_MASTER_DRIVER_SV
