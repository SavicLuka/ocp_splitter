//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_sequencer.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_SEQUENCER_SV
`define OCP_UVC_SEQUENCER_SV

class ocp_uvc_sequencer extends uvm_sequencer #(ocp_uvc_item);
  
  // registration macro
  `uvm_component_utils(ocp_uvc_sequencer)
    
  // configuration reference
  ocp_uvc_agent_cfg m_cfg;
  
  // constructor    
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  
endclass : ocp_uvc_sequencer

// constructor
function ocp_uvc_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void ocp_uvc_sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

`endif // OCP_UVC_SEQUENCER_SV
