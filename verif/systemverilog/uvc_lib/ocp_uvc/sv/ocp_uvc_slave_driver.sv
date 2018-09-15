//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_slave_driver.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_SLAVE_DRIVER_SV
`define OCP_UVC_SLAVE_DRIVER_SV

class ocp_uvc_slave_driver extends uvm_driver #(ocp_uvc_item);
  
  // registration macro
  `uvm_component_utils(ocp_uvc_slave_driver)
  
  // virtual interface reference
  virtual interface ocp_uvc_if m_vif;
  
  // configuration reference
  ocp_uvc_agent_cfg m_cfg;
  
  // request item
  REQ m_req;

	logic [2:0]  cmd = 0;
	logic [31:0] addr = 0;
   
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // process item
  extern virtual task process_item(ocp_uvc_item item);

endclass : ocp_uvc_slave_driver

// constructor
function ocp_uvc_slave_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void ocp_uvc_slave_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

// run phase
task ocp_uvc_slave_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);

  // init signals
  m_vif.cmd_accept <= 0;
	if (m_cfg.m_has_resp) begin
		m_vif.resp <= NULL;
	end

	m_vif.rdata <= 0;
  
  forever begin
  
  	// wait until reset is de-asserted
		`uvm_info(get_type_name(), "Wait until reset is deasserted.", UVM_HIGH)
		if (m_vif.reset_n !== 1) begin
 	  	wait (m_vif.reset_n === 1);
			addr = m_vif.addr;
			cmd = m_vif.cmd;
			if (m_cfg.m_has_resp) begin
				m_vif.resp = NULL;
			end
		end
		`uvm_info(get_type_name(), "Slave driver started.", UVM_HIGH)

		seq_item_port.get_next_item(m_req);

		fork : run_phase_fork_block

			// drive signals
			begin
				
				process_item(m_req);
				
			end

			// handle reset
			begin
				wait (m_vif.reset_n == 0);
 				`uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)
			end

		join_any // run_phase_fork_block
		disable fork;

		seq_item_port.item_done();

  end
endtask : run_phase

// process item
task ocp_uvc_slave_driver::process_item(ocp_uvc_item item);
  // print item
  `uvm_info(get_type_name(), $sformatf("Item to be driven: \n%s", item.sprint()), UVM_HIGH)

	// wait for transaction
	wait (m_vif.cmd != 0 && (m_vif.cmd != cmd || m_vif.addr != addr));
	//@(posedge m_vif.clock iff m_vif.cmd != IDLE);
	m_vif.cmd_accept <= 0;
	cmd = m_vif.cmd;
	addr = m_vif.addr;

	// wait before accept transaction
	if (item.delay != 0) begin
		repeat (item.delay - 1) begin
		@(posedge m_vif.clock);
		end
	end	

  // drive signals	
	m_vif.cmd_accept <= 1;

	if (m_cfg.m_has_resp) begin

		// wait before send response
		repeat (item.delay_resp) begin
			@(posedge m_vif.clock);
		end
	
		if (cmd == READ) begin
			m_vif.rdata <= item.rdata & (~(32'hFFFF_FFFF << m_cfg.m_data_width));
		end
		m_vif.resp <= item.resp;
	end
	else begin
		if (cmd == READ) begin
			m_vif.rdata <= item.rdata & (~(32'hFFFF_FFFF << m_cfg.m_data_width));
		end
	end
	@(posedge m_vif.clock);
	m_vif.cmd_accept <= 0;
	if (m_cfg.m_has_resp) begin
		m_vif.resp <= NULL;
	end

endtask : process_item

`endif // OCP_UVC_SLAVE_DRIVER_SV
