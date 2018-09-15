#------------------------------------------------------------------------------
# Copyright (c) 2017 Elsys Eastern Europe
# All rights reserved.
#------------------------------------------------------------------------------
# File name  : ocp_uvc_env_top.tcl
# Developer  : Luka Savic
# Date       : 
# Description: 
# Notes      : 
#
#------------------------------------------------------------------------------

#simvision input name_uvc_env_top.svcf

database -open waves -shm
probe -create ocp_uvc_tb_top -depth all -all -shm -database waves
run 
exit
