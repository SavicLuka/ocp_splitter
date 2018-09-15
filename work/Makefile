#makefile
#-------------------------------------------------------------------------------
# Copyright (c) 2017 Elsys Eastern Europe
# All rights reserved.
#-------------------------------------------------------------------------------
# File name  : Makefile
# Developer  : Filip
# Date       : 
# Description: 
# Notes      : 
#
#-------------------------------------------------------------------------------

# options
SIM = irun

INCDIRS = -incdir ../source/tb \
          -incdir ../source/tests \
          -incdir ../source/env/source \
          -incdir ../source/env/seq_lib \
          -incdir ../source/utils \
#          -incdir ....../name_uvc/sv
#          -incdir ....../name_uvc/sv

#PACKAGES = ../..._uvc_pkg.sv \
#          ../source/env/source/_env_top_pkg.sv \
#          ../source/tests/_test_pkg.sv

#TEST_NAME = "test_.._example"

SEED = random

RTL_FILES = rtl.files

#TOP_FILE = ../source/tb/.._top.sv

TCL_FILE = apb_spi_2.tcl

VERBOSITY = UVM_LOW

OPTIONS = +UVM_VERBOSITY=$(VERBOSITY) \
          +UVM_TESTNAME=$(TEST_NAME) \
          -svseed $(SEED) \
          -access rwc \
          -timescale 1ns/1ns \
          -file $(RTL_FILES) \
          $(TOP_FILE)

RUN_TCL = +tcl+$(TCL_FILE)

COVERAGE_OPTIONS = -coverage all \
                   -covoverwrite

DEBUG_OPTIONS = -linedebug \
                -uvmlinedebug

# targets
run_gui : 
	$(SIM) $(INCDIRS) $(PACKAGES) $(OPTIONS) $(RUN_TCL) $(COVERAGE_OPTIONS) $(DEBUG_OPTIONS) -gui

run_batch : 
	$(SIM) $(INCDIRS) $(PACKAGES) $(OPTIONS) $(COVERAGE_OPTIONS) $(DEBUG_OPTIONS)
    
clean :	
	rm -rf INCA* *.key *.log *.diag waves* cov_work *.err .simvis* *.history
