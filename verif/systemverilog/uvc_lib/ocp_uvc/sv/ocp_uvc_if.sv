//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_if.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_IF_SV
`define OCP_UVC_IF_SV

interface ocp_uvc_if(input clock);
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  // signals
          
	logic reset_n;
	logic data_width;
	logic has_resp;
	logic has_checkers;                       
	logic [2:0]  cmd;
	logic [31:0] addr;
	logic [31:0] wdata;      // DATA_WIDTH
	logic resp;
	logic	       cmd_accept;
	logic [31:0] rdata;      // DATA_WIDTH

  // assertions

	property chk_cmd_valid_property;
		disable iff (!reset_n || !has_checkers)
		!$isunknown(cmd);
	endproperty: chk_cmd_valid_property

	chk_cmd_valid_assert: assert property (@(posedge clock) chk_cmd_valid_property)
	else `uvm_error("chk_cmd_valid_assert", "cmd has unknow value")

	property chk_addr_valid_property;
		disable iff (!reset_n || !has_checkers)
		!$isunknown(addr);
	endproperty: chk_addr_valid_property

	chk_addr_valid_assert: assert property (@(posedge clock) chk_addr_valid_property)
	else `uvm_error("chk_addr_valid_assert", "addr has unknow value")

	property chk_wdata_valid_property;
		disable iff (!reset_n || !data_width || !has_checkers)
		!$isunknown(wdata);
	endproperty: chk_wdata_valid_property

	chk_wdata_valid_assert: assert property (@(posedge clock) chk_wdata_valid_property)
	else `uvm_error("chk_wdata_valid_assert", "wdata has unknow value")

	property chk_wdata_valid_16_property;
		disable iff (!reset_n || data_width || !has_checkers)
		!$isunknown(wdata[15:0]);
	endproperty : chk_wdata_valid_16_property

	chk_wdata_valid_16_assert: assert property (@(posedge clock) chk_wdata_valid_16_property)
	else `uvm_error("chk_wdata_valid_assert", "wdata has unknow value")

	property chk_resp_valid_property;
		disable iff (!reset_n || !has_resp || !has_checkers)
		!$isunknown(resp);
	endproperty: chk_resp_valid_property

	chk_resp_valid_assert: assert property (@(posedge clock) chk_resp_valid_property)
	else `uvm_error("chk_resp_valid_assert", "resp has unknow value")

	property chk_cmd_accept_valid_property;
		disable iff (!reset_n || !has_checkers)
		!$isunknown(cmd_accept);
	endproperty: chk_cmd_accept_valid_property

	chk_cmd_accept_valid_assert: assert property (@(posedge clock) chk_cmd_accept_valid_property)
	else `uvm_error("chk_cmd_accept_valid_assert", "cmd_accept has unknow value")

	property chk_rdata_valid_property;
		disable iff (!reset_n || !data_width || !has_checkers)
		!$isunknown(rdata);
	endproperty: chk_rdata_valid_property

	chk_rdata_valid_assert: assert property (@(posedge clock) chk_rdata_valid_property)
	else `uvm_error("chk_rdata_valid_assert", "rdata has unknow value")

	property chk_rdata_valid_16_property;
		disable iff (!reset_n || data_width || !has_checkers)
		!$isunknown(rdata);
	endproperty: chk_rdata_valid_16_property

	chk_rdata_valid_16_assert: assert property (@(posedge clock) chk_rdata_valid_16_property)
	else `uvm_error("chk_rdata_valid_assert", "rdata has unknow value")

/*	sequence reset_0_to_1;
		$changed(reset_n) |-> (reset_n == 1'b1);
	endsequence reset_0_to_1
	
	cov_reset_0_to_1 : cover property (reset_0_to_1);

	sequence reset_1_to_0;
		$changed(reset_n) && (reset_n == 1'b0);
	endsequence reset_1_to_0
	
	cov_reset_0_to_1 : cover property (reset_1_to_0);*/


	property chk_cmd_stable_property;
		disable iff (!reset_n || !has_checkers)
		($changed(cmd) && cmd != 0 && cmd_accept == 1'b0) |=> $stable(cmd)[*1:32] ##0 $rose(cmd_accept);
	endproperty: chk_cmd_stable_property

	chk_cmd_stable_assert: assert property (@(posedge clock) chk_cmd_stable_property)
	else `uvm_error("chk_cmd_stable_assert", "cmd was not stable until cmd_accept was asserted")

	property chk_addr_stable_property;
		disable iff (!reset_n || !has_checkers)
		($changed(cmd) && cmd != 0 && cmd_accept == 1'b0) |=> $stable(addr)[*1:32] ##0 $rose(cmd_accept);
	endproperty: chk_addr_stable_property

	chk_addr_stable_assert: assert property (@(posedge clock) chk_addr_stable_property)
	else `uvm_error("chk_addr_stable_assert", "addr was not stable until cmd_accept was asserted")

	property chk_wdata_stable_property;
		disable iff (!reset_n || !has_checkers)
		($changed(cmd) && cmd != 0 && cmd_accept == 1'b0) |=> $stable(wdata)[*1:32] ##0 $rose(cmd_accept);
	endproperty: chk_wdata_stable_property

	chk_wdata_stable_assert: assert property (@(posedge clock) chk_wdata_stable_property)
	else `uvm_error("chk_wdata_stable_assert", "wdata was not stable until cmd_accept was asserted")

  
endinterface : ocp_uvc_if

`endif // OCP_UVC_IF_SV
