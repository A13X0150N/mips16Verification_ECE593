full:
	vlib work
	vlog Testbench/MIPS_pkg.sv
	vlog Testbench/*.sv
	vlog DUV/*.v
	vsim -c top_tb -do "run -all; quit"
compile:
	vlog Testbench/MIPS_pkg.sv
	vlog Testbench/*.sv
	vlog DUV/*.v
run:
	vsim -c top_tb -do "run -all; quit"
clean:
	rm -rf work transcript vsim.wlf
