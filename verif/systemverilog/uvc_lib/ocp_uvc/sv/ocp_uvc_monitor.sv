//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_monitor.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_MONITOR_SV
`define OCP_UVC_MONITOR_SV

class ocp_uvc_monitor extends uvm_monitor;
  
  // registration macro
  `uvm_component_utils(ocp_uvc_monitor)
  
  // analysis port
  uvm_analysis_port #(ocp_uvc_item) m_aport;
  
  // virtual interface reference
  virtual interface ocp_uvc_if m_vif;
  
  // configuration reference
  ocp_uvc_agent_cfg m_cfg;
  
  // monitor item
  ocp_uvc_item m_item;
	ocp_uvc_item m_item_cloned;

  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // handle reset
  extern virtual task handle_reset();
  // collect item
  extern virtual task collect_item();
  // print item
  extern virtual function void print_item(ocp_uvc_item item);

endclass : ocp_uvc_monitor

// constructor
function ocp_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void ocp_uvc_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // create port
  m_aport = new("m_aport", this);
  
  // create item
  m_item = ocp_uvc_item::type_id::create("m_item", this);
endfunction : build_phase

// run phase
task ocp_uvc_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
  m_item.cmd = IDLE;
	m_item.addr = 0;

  forever begin
    fork : run_phase_fork_block
      begin
        handle_reset();
      end
      begin
        collect_item();    
      end
    join_any // run_phase_fork_block
		m_item.cmd = m_vif.cmd;
		m_item.addr = m_vif.addr;
    disable fork;
  end
endtask : run_phase

// handle reset
task ocp_uvc_monitor::handle_reset();
  // wait reset assertion
  @(m_vif.reset_n iff m_vif.reset_n == 0);
  `uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)
endtask : handle_reset

// collect item
task ocp_uvc_monitor::collect_item();  
  // wait until reset is de-asserted
  wait (m_vif.reset_n == 1);
  `uvm_info(get_type_name(), "Reset de-asserted. Starting to collect items...", UVM_HIGH)
  
  forever begin    
    // wait signal change
		@(posedge m_vif.clock iff (m_vif.cmd_accept === 1 && m_vif.cmd != IDLE));

    // begin transaction recording
    void'(begin_tr(m_item, "ocp_uvc item"));
    
    // collect item
    m_item.cmd = m_vif.cmd;
		m_item.addr = m_vif.addr;
		m_item.wdata = m_vif.wdata;
		m_item.rdata = m_vif.rdata;

		if (m_cfg.m_has_resp) begin
			@(posedge m_vif.clock iff (m_vif.resp != NULL));
			// begin transaction recording
		  void'(begin_tr(m_item, "ocp_uvc item"));
		  
		  // collect item
			m_item.rdata = m_vif.rdata;
			m_item.resp = m_vif.resp;
		end

		// end transaction recording
		end_tr(m_item);

		// print item
    print_item(m_item);

		// clone item
		$cast(m_item_cloned,m_item.clone());
    
		// write analysis port
    m_aport.write(m_item_cloned);
    
  end // forever begin  
endtask : collect_item

// print item
function void ocp_uvc_monitor::print_item(ocp_uvc_item item);
  `uvm_info(get_type_name(), $sformatf("Item collected: \n%s", item.sprint()), UVM_HIGH)
endfunction : print_item

`endif // OCP_UVC_MONITOR_SV
