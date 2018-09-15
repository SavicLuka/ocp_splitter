#------------------------------------------------------------------------------
# Copyright (c) 2017 Elsys Eastern Europe
# All rights reserved.
#------------------------------------------------------------------------------
# File name  : ocp_splitter_env_top.tcl
# Developer  : Luka Savic
# Date       : 
# Description: 
# Notes      : 
#
#------------------------------------------------------------------------------

#simvision input ocp_splitter_env_top.svcf

database -open waves -shm

run uvm_phase -stop_at build-end
probe -create $uvm:{uvm_test_top.m_ocp_splitter_env_top} -depth all -uvm -all
probe -create ocp_splitter_tb_top -depth all -all -shm -database waves
run
