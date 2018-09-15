//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_tb_top.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_TB_TOP_SV
`define OCP_SPLITTER_TB_TOP_SV

// define timescale
`timescale 1ns/1ns

module ocp_splitter_tb_top;
  
  `include "uvm_macros.svh"  
  import uvm_pkg::*;
  
  // import test package
  import ocp_splitter_test_pkg::*;
      
  // signals
  wire reset_n;
  reg clock;

  // UVC interface instance
	ocp_uvc_if ocp_uvc_if_slave_inst(clock);
  ocp_uvc_if ocp_uvc_if_master_inst(clock);

  // DUT instance
  ocp_splitter dut (
		.rst_ocp_na(reset_n),
		.clk(clock),

		.m_cmd_in_32(ocp_uvc_if_master_inst.cmd),
		.m_addr_in_32(ocp_uvc_if_master_inst.addr),
		.m_data_in_32(ocp_uvc_if_master_inst.wdata),

		.s_cmd_accept_out_32(ocp_uvc_if_master_inst.cmd_accept),
		.s_data_out_32(ocp_uvc_if_master_inst.rdata),

		.m_cmd_out_16(ocp_uvc_if_slave_inst.cmd),
		.m_addr_out_16(ocp_uvc_if_slave_inst.addr),
		.m_data_out_16(ocp_uvc_if_slave_inst.wdata[15:0]),

		.s_cmd_accept_in_16(ocp_uvc_if_slave_inst.cmd_accept),
		.s_data_in_16(ocp_uvc_if_slave_inst.rdata[15:0])
	);
  
  // configure UVC's virtual interface in DB
  initial begin : config_if_block
    uvm_config_db#(virtual ocp_uvc_if)::set(uvm_root::get(), "uvm_test_top.m_ocp_splitter_env_top.m_ocp_uvc_env.m_master_agent", "m_vif", ocp_uvc_if_master_inst);
    uvm_config_db#(virtual ocp_uvc_if)::set(uvm_root::get(), "uvm_test_top.m_ocp_splitter_env_top.m_ocp_uvc_env.m_slave_agent", "m_vif", ocp_uvc_if_slave_inst);
  end
    
  // define initial clock value and generate reset
  initial begin : clock_and_rst_init_block
    ocp_uvc_if_master_inst.reset_n <= 1'b0;
		ocp_uvc_if_slave_inst.reset_n <= 1'b0;
		ocp_uvc_if_master_inst.has_checkers <= 1'b1;
		ocp_uvc_if_slave_inst.has_checkers <= 1'b1;
		ocp_uvc_if_master_inst.data_width <= 1'b1;
		ocp_uvc_if_slave_inst.data_width <= 1'b0;
		ocp_uvc_if_master_inst.has_resp <= 1'b0;
		ocp_uvc_if_slave_inst.has_resp <= 1'b0;
    clock <= 1'b1;
    #501 ocp_uvc_if_master_inst.reset_n <= 1'b1;
		ocp_uvc_if_slave_inst.reset_n <= 1'b1;
  end
  
  // generate clock
  always begin : clock_gen_block
    #50 clock <= ~clock;
  end
  
  // run test
  initial begin : run_test_block
    run_test();
  end

	assign reset_n = ocp_uvc_if_master_inst.reset_n;


endmodule : ocp_splitter_tb_top

`endif // OCP_SPLITTER_TB_TOP_SV
