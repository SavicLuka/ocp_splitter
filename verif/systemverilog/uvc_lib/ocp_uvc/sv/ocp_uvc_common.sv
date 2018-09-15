//------------------------------------------------------------------------------
// Copyright (c) 2017 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : ocp_uvc_common.sv
// Developer  : Luka Savic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef OCP_UVC_COMMON_SV
`define OCP_UVC_COMMON_SV

typedef enum int {IDLE, WRITE, READ} cmd_type_e; 	 		// type of command
typedef enum int {NULL, DVA} resp_type_e;	// type of response

typedef enum bit {
  OCP_UVC_LOW_E  = 0,
  OCP_UVC_HIGH_E = 1
} ocp_uvc_signal_value_e;

`endif // OCP_UVC_COMMON_SV
