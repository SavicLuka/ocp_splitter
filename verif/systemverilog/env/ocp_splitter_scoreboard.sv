//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_scoreboard.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_SCOREBOARD_SV
`define OCP_SPLITTER_SCOREBOARD_SV

`uvm_analysis_imp_decl(_32)
`uvm_analysis_imp_decl(_16)

// coverage groups
covergroup ocp_splitter_cg(ref ocp_uvc_item t_item);
  option.per_instance = 1;

	cov_cmd: coverpoint t_item.cmd {
		bins write = { WRITE };
		bins read = { READ };
	}
	cov_addr: coverpoint t_item.addr {
		option.auto_bin_max = 4096;
	}
	cov_addr_1234 : coverpoint t_item.addr {
		bins addr_1234 = {[32'h1234_0000 : 32'h1234_FFFF]};
	}
	cov_cmd_cross_addr: cross cov_cmd, cov_addr;
	cov_write_cross_addr_1234 : cross cov_cmd, cov_addr_1234{
		bins write_cross_addr_1234  = binsof(cov_cmd.write);		
	}

endgroup : ocp_splitter_cg

covergroup ocp_splitter_cg_1_32 with function sample(bit[31:0] data, bit[4:0] position);
	option.per_instance = 1;
	
	cov_data_1 : coverpoint position iff (data[position] == 1){
		bins bin_data[] = {[ 0 : 31 ]};
	}
endgroup : ocp_splitter_cg_1_32

covergroup ocp_splitter_cg_0_32 with function sample(bit[31:0] data, bit[4:0] position);
	option.per_instance = 1;
	
	cov_data_0 : coverpoint position iff (data[position] == 0){
		bins bin_data[] = {[ 0 : 31 ]};
	}
endgroup : ocp_splitter_cg_0_32	


class ocp_splitter_scoreboard extends uvm_component;

	// registration macro
	`uvm_component_utils(ocp_splitter_scoreboard)

	ocp_uvc_item item_queue[$];

	// analysis ports
  uvm_analysis_imp_32 #(ocp_uvc_item, ocp_splitter_scoreboard) m_port_32;
	uvm_analysis_imp_16 #(ocp_uvc_item, ocp_splitter_scoreboard) m_port_16;

	// configuration reference
  ocp_splitter_scoreboard_cfg m_cfg;

	// slave items
	ocp_uvc_item m_item_16_1;
	ocp_uvc_item m_item_16_2;

	// coverage fields 
  ocp_uvc_item t_item;

  // coverage groups
  ocp_splitter_cg m_ocp_splitter_cg;
	ocp_splitter_cg_1_32 wdata_ocp_splitter_cg_1_32;
	ocp_splitter_cg_0_32 wdata_ocp_splitter_cg_0_32;
	ocp_splitter_cg_1_32 rdata_ocp_splitter_cg_1_32;
	ocp_splitter_cg_0_32 rdata_ocp_splitter_cg_0_32;	

	// constructor
  extern function new(string name, uvm_component parent);
	// build phase
  extern virtual function void build_phase(uvm_phase phase);
	// check phase
	extern virtual function void check_phase(uvm_phase phase);
	// write functions
	extern function void write_32(ocp_uvc_item t);
	extern function void write_16(ocp_uvc_item t);

endclass : ocp_splitter_scoreboard

// constructor
function ocp_splitter_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
	m_ocp_splitter_cg = new(t_item);
	wdata_ocp_splitter_cg_0_32 = new();
	wdata_ocp_splitter_cg_1_32 = new();
	rdata_ocp_splitter_cg_0_32 = new();
	rdata_ocp_splitter_cg_1_32 = new();
endfunction : new

// build phase
function void ocp_splitter_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	m_port_32 = new("m_port_32",this);
	m_port_16 = new("m_port_16",this);
endfunction : build_phase

// check phase
function void ocp_splitter_scoreboard::check_phase(uvm_phase phase);
	super.check_phase(phase);
	if (item_queue.size() != 0) begin
		`uvm_error("chk_unmatched_transactions",$sformatf("Some transactions are not matched, queue is not empty.\nQueue size = %d",item_queue.size()))
	end
endfunction : check_phase

// write_32
function void ocp_splitter_scoreboard::write_32(ocp_uvc_item t);
	if (item_queue.size() > 1) begin
		m_item_16_2 = item_queue.pop_back();
		m_item_16_1 = item_queue.pop_back();		
		`uvm_info(get_type_name(), $sformatf("Comparing items :\n%s\n%s\n%s\n",t.sprint(),m_item_16_1.sprint(),m_item_16_2.sprint()), UVM_HIGH)

		if (t.cmd != m_item_16_1.cmd) begin
			`uvm_error("chk_cmd1", "m_cmd_in_32 should be same as m_cmd_out_16_1")
		end
		if (t.cmd != m_item_16_2.cmd) begin
			`uvm_error("chk_cmd2", "m_cmd_in_32 should be same as m_cmd_out_16_2")
		end
		if (t.addr != m_item_16_1.addr) begin
			`uvm_error("chk_addr", "m_addr_32 should be same as m_addr_16_1")
		end
		if ((m_item_16_1.addr + 2) != m_item_16_2.addr) begin
			`uvm_error("chk_addr_16", "m_addr_16_2 should be higher by two than m_addr_16_1")
		end
		if (t.cmd == WRITE) begin
			if (t.wdata[15:0] != m_item_16_1.wdata[15:0]) begin
				`uvm_error("chk_write_data1", "If command is write, least significant 16 bits of m_data_in_32 should be same as m_data_out_16_1")
			end
			if (t.wdata[31:16] != m_item_16_2.wdata[15:0]) begin
				`uvm_error("chk_write_data2", "If command is write, most significant 16 bits of m_data_in_32 should be same as m_data_out_16_2")
			end
		end // write
		if (t.cmd == READ) begin
			if (t.rdata[15:0] != m_item_16_1.rdata[15:0]) begin
				`uvm_error("chk_read_data_1", "If command is read, least significant 16 bits of s_data_out_32 should be same as s_data_in_16_1")
			end
			if (t.rdata[31:16] != m_item_16_2.rdata[15:0]) begin
				`uvm_error("chk_read_data_2", "If command is read, most significant 16 bits of s_data_out_32 should be same as s_data_in_16_2")
			end
		end // read
	end
	else begin
		`uvm_error("chk_cmd_accept_early", "s_cmd_accept_out_32 is asserted before s_cmd_accept_in_16_1 and s_cmd_accept_in_16_2 are both asserted")
	end

	t_item = t;
	m_ocp_splitter_cg.sample();

	for (int i = 0 ; i < m_cfg.m_data_width ; i = i + 1) begin
		wdata_ocp_splitter_cg_0_32.sample(t.wdata,i);
		wdata_ocp_splitter_cg_1_32.sample(t.wdata,i);
		rdata_ocp_splitter_cg_0_32.sample(t.rdata,i);
		rdata_ocp_splitter_cg_1_32.sample(t.rdata,i);
	end

endfunction : write_32
		
// write_16
function void ocp_splitter_scoreboard::write_16(ocp_uvc_item t);
/*
	if (item_queue.size() > 1) begin
		`uvm_error("chk_cmd_accept_late", "s_cmd_accept_out_32 was not asserted after s_cmd_accept_in_16_1 and s_cmd_accept_in_16_2 are both asserted")
	end
*/
	item_queue.push_back(t);
endfunction : write_16


`endif // OCP_SPLITTER_SCOREBOARD_SV
