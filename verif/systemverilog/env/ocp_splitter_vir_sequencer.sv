//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_vir_sequencer.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_VIR_SEQUENCER_SV
`define OCP_SPLITTER_VIR_SEQUENCER_SV

class ocp_splitter_vir_sequencer extends uvm_sequencer;

	// registration macro
	`uvm_component_utils(ocp_splitter_vir_sequencer)

	ocp_uvc_sequencer master_sequencer;
	ocp_uvc_sequencer slave_sequencer;

	// constructor
	extern function new(string name = "ocp_splitter_vir_sequencer", uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);

endclass : ocp_splitter_vir_sequencer

// constructor
function ocp_splitter_vir_sequencer::new(string name = "ocp_splitter_vir_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction : new

// build phase
function void ocp_splitter_vir_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

`endif // OCP_SPLITTER_VIR_SEQUENCER_SV
