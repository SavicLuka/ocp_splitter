//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_cov.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_COV_SV
`define OCP_UVC_COV_SV

// coverage groups
covergroup ocp_uvc_cg(ref ocp_uvc_item t_item);
  option.per_instance = 1;

	cov_cmd: coverpoint t_item.cmd {
		bins paddr_write = { WRITE };
		bins paddr_read = { READ };
	}
	cov_addr: coverpoint t_item.addr {
		option.auto_bin_max = 16;
	}
	cov_cmd_cross_addr: cross cov_cmd, cov_addr;

endgroup : ocp_uvc_cg

  
covergroup ocp_uvc_cg_1_32 with function sample(bit[31:0] data, bit[4:0] position);
	option.per_instance = 1;
	
	cov_data_1 : coverpoint position iff (data[position] == 1){
		bins bin_data[] = {[0 : 31 ]};
	}
endgroup : ocp_uvc_cg_1_32


covergroup ocp_uvc_cg_0_32 with function sample(bit[31:0] data, bit[4:0] position);
	option.per_instance = 1;
	
	cov_data_0 : coverpoint position iff (data[position] == 0){
		bins bin_data[] = {[0 : 31 ]};
	}
endgroup : ocp_uvc_cg_0_32	


covergroup ocp_uvc_cg_1_16 with function sample(bit[31:0] data, bit[4:0] position);
	option.per_instance = 1;
	
	cov_data_1 : coverpoint position iff (data[position] == 1){
		bins bin_data[] = {[0 : 15 ]};
	}
endgroup : ocp_uvc_cg_1_16


covergroup ocp_uvc_cg_0_16 with function sample(bit[31:0] data, bit[4:0] position);
	option.per_instance = 1;
	
	cov_data_0 : coverpoint position iff (data[position] == 0){
		bins bin_data[] = {[0 : 15 ]};
	}
endgroup : ocp_uvc_cg_0_16


class ocp_uvc_cov extends uvm_subscriber #(ocp_uvc_item);
  
  // registration macro
  `uvm_component_utils(ocp_uvc_cov)
  
  // configuration reference
  ocp_uvc_agent_cfg m_cfg;

  // coverage fields 
  ocp_uvc_item t_item;

	ocp_uvc_cg m_ocp_uvc_cg;  

	ocp_uvc_cg_1_32 wdata_ocp_uvc_cg_1_32;
	ocp_uvc_cg_1_32 rdata_ocp_uvc_cg_1_32;
	ocp_uvc_cg_0_32 wdata_ocp_uvc_cg_0_32;
	ocp_uvc_cg_0_32 rdata_ocp_uvc_cg_0_32;

	ocp_uvc_cg_1_16 wdata_ocp_uvc_cg_1_16;
	ocp_uvc_cg_1_16 rdata_ocp_uvc_cg_1_16;
	ocp_uvc_cg_0_16 wdata_ocp_uvc_cg_0_16;
	ocp_uvc_cg_0_16 rdata_ocp_uvc_cg_0_16;

  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  // analysis implementation port function
  extern virtual function void write(ocp_uvc_item t);

endclass : ocp_uvc_cov

// constructor
function ocp_uvc_cov::new(string name, uvm_component parent);
  super.new(name, parent);
  m_ocp_uvc_cg = new(t_item);
	wdata_ocp_uvc_cg_0_32 = new();
	wdata_ocp_uvc_cg_1_32 = new();
	wdata_ocp_uvc_cg_0_16 = new();
	wdata_ocp_uvc_cg_1_16 = new();
	rdata_ocp_uvc_cg_0_32 = new();
	rdata_ocp_uvc_cg_1_32 = new();
	rdata_ocp_uvc_cg_0_16 = new();
	rdata_ocp_uvc_cg_1_16 = new();
endfunction : new

// build phase
function void ocp_uvc_cov::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction : build_phase

// analysis implementation port function
function void ocp_uvc_cov::write(ocp_uvc_item t);
  t_item = t;
  m_ocp_uvc_cg.sample();
	for (int i = 0 ; i < m_cfg.m_data_width ; i = i + 1) begin
		if (m_cfg.m_data_width == 32) begin
			wdata_ocp_uvc_cg_0_16.option.weight = 0;
			wdata_ocp_uvc_cg_1_16.option.weight = 0;
			wdata_ocp_uvc_cg_0_16.option.goal = 0;
			wdata_ocp_uvc_cg_1_16.option.goal = 0;
			rdata_ocp_uvc_cg_0_16.option.weight = 0;
			rdata_ocp_uvc_cg_1_16.option.weight = 0;
			rdata_ocp_uvc_cg_0_16.option.goal = 0;
			rdata_ocp_uvc_cg_1_16.option.goal = 0;
			wdata_ocp_uvc_cg_0_32.sample(t.wdata,i);
			wdata_ocp_uvc_cg_1_32.sample(t.wdata,i);
			rdata_ocp_uvc_cg_0_32.sample(t.rdata,i);
			rdata_ocp_uvc_cg_1_32.sample(t.rdata,i);
		end 
		else begin
			wdata_ocp_uvc_cg_0_32.option.weight = 0;
			wdata_ocp_uvc_cg_1_32.option.weight = 0;
			wdata_ocp_uvc_cg_0_32.option.goal = 0;
			wdata_ocp_uvc_cg_1_32.option.goal = 0;
			rdata_ocp_uvc_cg_0_32.option.weight = 0;
			rdata_ocp_uvc_cg_1_32.option.weight = 0;
			rdata_ocp_uvc_cg_0_32.option.goal = 0;
			rdata_ocp_uvc_cg_1_32.option.goal = 0;
			wdata_ocp_uvc_cg_0_16.sample(t.wdata,i);
			wdata_ocp_uvc_cg_1_16.sample(t.wdata,i);
			rdata_ocp_uvc_cg_0_16.sample(t.rdata,i);
			rdata_ocp_uvc_cg_1_16.sample(t.rdata,i);
		end
	end
endfunction : write

`endif // OCP_UVC_COV_SV
