//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_splitter_vir_sequence.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_SPLITTER_VIR_SEQUENCE_SV
`define OCP_SPLITTER_VIR_SEQUENCE_SV

class ocp_splitter_vir_sequence extends uvm_sequence #(ocp_uvc_item, ocp_uvc_item);

	// registration macro
	`uvm_object_utils(ocp_splitter_vir_sequence)

	`uvm_declare_p_sequencer(ocp_splitter_vir_sequencer)

	// sequences
  ocp_uvc_master_seq m_master_seq;
  ocp_uvc_slave_seq m_slave_seq;
	
	// fields
	int num_of_sequences = 10;
	rand cmd_type_e cmd;
	rand bit[31:0] addr;
	rand bit[31:0] wdata;
	rand int delay_master;										// time before master start transaction
	rand resp_type_e resp;
	rand bit[31:0] rdata;
	rand int delay_slave;											// time before cmd_accept is asserted
	rand int delay_resp;											// time before slave sets resp


	logic test_values = 1'b0;

	cmd_type_e test_cmd = READ;
	bit[31:0] test_addr = 0;
	bit[31:0] test_wdata = 0;
	bit[31:0] test_rdata = 0;
	int test_delay_master = 0;
	int test_dalay_slave = 0;

	// constraints
	
	constraint c_cmd_sequence {
  	cmd != IDLE;
	}	

	constraint c_delay_master_sequence {
		delay_master inside {[0:10]};
	}

	constraint c_resp_sequence {
		resp == DVA;
	}

	constraint c_delay_slave_sequence {
		delay_slave inside {[0:10]};
	}

	constraint c_delay_resp_sequence {
		delay_resp inside { [0:10] };
	} 

	// constructor
	extern function new(string name = "ocp_splitter_vir_sequence");
	// pre body
	extern virtual task pre_body();
	// body
	extern virtual task body();

endclass : ocp_splitter_vir_sequence

// constructor
function ocp_splitter_vir_sequence::new(string name = "ocp_splitter_vir_sequence");
	super.new(name);
endfunction : new

// pre body
task ocp_splitter_vir_sequence::pre_body();
	super.pre_body();
	`uvm_info(get_type_name(),"Starting to generate traffic ...",UVM_HIGH)
endtask : pre_body

task ocp_splitter_vir_sequence::body();

	m_slave_seq = ocp_uvc_slave_seq::type_id::create("m_slave_seq");
	m_master_seq = ocp_uvc_master_seq::type_id::create("m_master_seq");

	fork : slave
		begin
			forever begin
				if(test_values == 1'b1) begin
					assert(this.randomize() with {
						delay_slave == test_dalay_slave;
						rdata == test_rdata;
					});
				end
				else begin
					assert(this.randomize());
				end
				
				if(!m_slave_seq.randomize() with {
					s_delay == delay_slave;
					s_delay_resp == delay_resp;
					s_rdata == rdata;
					s_resp == resp;
				}) begin
				 `uvm_fatal(get_type_name(), "Failed to randomize.")
				end
				m_slave_seq.start(p_sequencer.slave_sequencer);
			end
		end
	join_none
	
	repeat(num_of_sequences) begin
		if(test_values == 1'b1) begin
					assert(this.randomize() with {
						cmd == test_cmd;
						addr == test_addr;
						wdata == test_wdata;
						delay_master == test_delay_master;
					});
		end
		else begin
			assert(this.randomize());
		end

		if(!m_master_seq.randomize() with {
			s_cmd == cmd;
			s_addr == addr;
			s_wdata == wdata;
			s_delay == delay_master;
		}) begin
			`uvm_fatal(get_type_name(), "Failed to randomize.")
		end
		m_master_seq.start(p_sequencer.master_sequencer);
	end // repeat
endtask : body

`endif // OCP_SPLITTER_VIR_SEQUENCE_SV
