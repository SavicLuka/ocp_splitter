//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_item.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_ITEM_SV
`define OCP_UVC_ITEM_SV

class ocp_uvc_item extends uvm_sequence_item;
  
  // item fields
  
	rand cmd_type_e cmd;
	rand bit[31:0] addr;
	rand bit[31:0] wdata;											// DATA_WIDTH
	rand resp_type_e resp;
	rand bit[31:0] rdata;											// DATA_WIDTH
	rand int delay;														// master -> time before starting transaction, slave -> time before cmd_accept is asserted
	rand int delay_resp;											// time before slave sets resp

  // registration macro    
  `uvm_object_utils_begin(ocp_uvc_item)
    `uvm_field_enum(cmd_type_e, cmd, UVM_ALL_ON)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_int(wdata, UVM_ALL_ON)
		`uvm_field_enum(resp_type_e, resp, UVM_ALL_ON)
		`uvm_field_int(rdata, UVM_ALL_ON)
		`uvm_field_int(delay, UVM_ALL_ON)
		`uvm_field_int(delay_resp, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // constraints

	constraint c_delay {
		soft delay inside { [0:10] };
	}

	constraint c_delay_resp {
		soft delay_resp inside { [0:10] };
	}
	
  
  // constructor  
  extern function new(string name = "ocp_uvc_item");
  
endclass : ocp_uvc_item

// constructor
function ocp_uvc_item::new(string name = "ocp_uvc_item");
  super.new(name);
endfunction : new

`endif // OCP_UVC_ITEM_SV
