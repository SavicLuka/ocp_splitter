//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_seq_lib.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_SEQ_LIB_SV
`define OCP_UVC_SEQ_LIB_SV

class ocp_uvc_master_seq extends uvm_sequence #(ocp_uvc_item);
  
  // registration macro
  `uvm_object_utils(ocp_uvc_master_seq)
  
  // sequencer pointer macro
  `uvm_declare_p_sequencer(ocp_uvc_sequencer)
  
  // fields
  rand cmd_type_e s_cmd;
	rand bit[31:0] s_addr;
	rand bit[31:0] s_wdata;
	rand int s_delay;														// time before starting transaction
  
  // constraints

  constraint c_cmd_master {
  	soft s_cmd != IDLE;
	}	

	constraint c_delay_master {
		soft s_delay inside {[ 0 : 10 ]};
	}

  // constructor
  extern function new(string name = "ocp_uvc_master_seq");
  // body task
  extern virtual task body();

endclass : ocp_uvc_master_seq

// constructor
function ocp_uvc_master_seq::new(string name = "ocp_uvc_master_seq");
  super.new(name);
endfunction : new

// body task
task ocp_uvc_master_seq::body();
  `uvm_info(get_type_name(), $sformatf("Sequence ocp_uvc_master_seq :"), UVM_HIGH)
  
  req = ocp_uvc_item::type_id::create("req");
  
  start_item(req);
  
  if(!req.randomize() with {
		cmd == s_cmd;
		addr == s_addr;
		wdata == s_wdata;
		delay == s_delay;
  }) begin
    `uvm_fatal(get_type_name(), "Failed to randomize.")
  end  
  
  finish_item(req);
  
endtask : body


class ocp_uvc_slave_seq extends uvm_sequence #(ocp_uvc_item);
  
  // registration macro
  `uvm_object_utils(ocp_uvc_slave_seq)
 
	// sequencer pointer macro
  `uvm_declare_p_sequencer(ocp_uvc_sequencer)
  
  // fields
	rand resp_type_e s_resp;
	rand bit[31:0] s_rdata;
	rand int s_delay;														// time before cmd_accept is asserted
	rand int s_delay_resp;											// time before slave sets resp
  
  // constraints
	
	constraint c_resp_slave {
		soft s_resp == DVA;
	}

	constraint c_delay_master {
		soft s_delay inside {[0:10]};
	}

	constraint c_delay_resp {
		soft s_delay_resp inside { [0:10] };
	} 

  // constructor
  extern function new(string name = "ocp_uvc_slave_seq");
  // body task
  extern virtual task body();

endclass : ocp_uvc_slave_seq

// constructor
function ocp_uvc_slave_seq::new(string name = "ocp_uvc_slave_seq");
  super.new(name);
endfunction : new

// body task
task ocp_uvc_slave_seq::body();
  `uvm_info(get_type_name(), "Sequence ocp_uvc_slave_seq", UVM_HIGH)
  
  req = ocp_uvc_item::type_id::create("req");		
	start_item(req);
	
	if(!req.randomize() with {
		resp == s_resp;
		rdata == s_rdata;
		delay == s_delay;
		delay_resp == s_delay_resp;
	}) begin
	  `uvm_fatal(get_type_name(), "Failed to randomize.")
	end  
	
	finish_item(req);

endtask : body

`endif // OCP_UVC_SEQ_LIB_SV
