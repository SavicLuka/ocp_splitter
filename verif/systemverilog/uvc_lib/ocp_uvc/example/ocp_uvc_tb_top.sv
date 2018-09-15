//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_tb_top.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_TB_TOP_SV
`define OCP_UVC_TB_TOP_SV

// define timescale
`timescale 1ns/1ns

module ocp_uvc_tb_top;
  
  `include "uvm_macros.svh"  
  import uvm_pkg::*;
  
  // import test package
  import ocp_uvc_test_pkg::*;
      
  // signals
  reg reset_n;
  reg clock;
  
  // UVC interface instance
  ocp_uvc_if ocp_uvc_if_inst(clock);
  
  // DUT instance
 // dut_dummy dut (
   // .reset_n(reset_n),
  //  .clock(clock)
 // );
  
  // configure UVC's virtual interface in DB
  initial begin : config_if_block
    uvm_config_db#(virtual ocp_uvc_if)::set(uvm_root::get(), "uvm_test_top.m_ocp_uvc_env_top.m_ocp_uvc_env.m_master_agent", "m_vif", ocp_uvc_if_inst);
    uvm_config_db#(virtual ocp_uvc_if)::set(uvm_root::get(), "uvm_test_top.m_ocp_uvc_env_top.m_ocp_uvc_env.m_slave_agent", "m_vif", ocp_uvc_if_inst);
  end
    
  // define initial clock value and generate reset
  initial begin : clock_and_rst_init_block
    ocp_uvc_if_inst.reset_n <= 1'b0;
    clock <= 1'b1;
    #501 ocp_uvc_if_inst.reset_n <= 1'b1;
  end
  
  // generate clock
  always begin : clock_gen_block
    #50 clock <= ~clock;
  end
  
  // run test
  initial begin : run_test_block
    run_test();
  end
  
endmodule : ocp_uvc_tb_top

`endif // OCP_UVC_TB_TOP_SV
