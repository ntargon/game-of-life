TB              := tbench
# rtl
FILE 		:= $(shell find ../rtl/* | grep -e "\.vhdl")# | xargs echo)
FILE_ 		:= $(shell find ../rtl/* | grep -e "\.sv" | grep -v "tp.sv")# | xargs echo)
# test bench
TBFILE		:= $(shell find ../tb/* | grep -e "\.vhdl" -e "\.sv" | grep -v "tp.sv")# | xargs echo)
# include directory
INCPATH		:= ../tb
all: xvhdl xvlog xelab xsim wave
xvhdl:
	xvhdl -L uvm \
		  --lib ../rtl/ \
		  $(FILE)
xvlog:
	xvlog -sv \
		  --uvm_version 1.2 \
		  -L uvm \
		  --include $(INCPATH) \
		  --sourcelibdir ../rtl/ \
		  $(FILE_) \
		  $(TBFILE)
xelab:
	xelab -debug typical \
		  --include $(INCPATH) \
		  --uvm_version 1.2 \
		  -L uvm \
		  $(TB) \
		  -s $(TB).sim
xsim:
	xsim --wdb sim.wdb \
	     $(TB).sim \
	     -tclbatch sim.tcl
wave:
	xsim -gui sim.wdb
xsim_wave:
	xsim -gui $(TB).sim
.PHONY: clean
clean:
	find ./* | grep -v -E 'makefile|sim.sh|xvlog.log|xelab.log|sim.tcl|xsim.log' | xargs rm -rf & rm -rf .Xil