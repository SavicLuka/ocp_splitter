*******************************************************************
*	Directory structure for APB2SPI project
*******************************************************************
apb2spi
	----><ams>
	----><ana>
	----><doc>
	----><lay>
	----><rtl> contains RTL files organized in subfolders based on the used HDL
		----><sv>
		----><verilog>
		----><vhdl>
	----><script>
	----><verif> verification components
		----><directed> directed TB
			----><lib>
			----><tb>
		----><specman> TB written in Specman
			----><lib>
			----><tb>
		----><systemverilog> UVM components written in SystemVerilog
			----><env> UVM description of top environment
			----><tb> UVM top testbench components
			----><test> UVM description of UVM test cases
			----><apb_uvc> APB UVCs contained in environment
				----><sv> contains all UVCs needed for reuse
				----><example>  contains UVC2UVC env, tb and exmaple testcase needed
								to show how to instance, configure and use UVC
				----><makefile> script for running UVC2UVC testcase
			----><spi_uvc> SPI UVC contained
				----><sv> contains SPI UVC
	----><work> Makefiles