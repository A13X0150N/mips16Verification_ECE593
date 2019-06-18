full:
	vlib work
	vlog Testbenches/Chip_Verification/SourceCode/MIPS_pkg.sv
	vlog Testbenches/Chip_Verification/SourceCode/*.sv
	vlog DUV/*.v
	vsim -c top_tb -do "run -all; quit"

compile:
	vlog Testbenches/Chip_Verification/SourceCode/MIPS_pkg.sv
	vlog Testbenches/Chip_Verification/SourceCode/*.sv
	vlog DUV/*.v

alu:
	vlib work
	vlog DUV/*.v
	vlog Testbenches/ALU_Verification/SourceCode/*.sv
	vsim -c top -do "run -all; quit"

hazard:
	vlib work
	vlog DUV/*.v
	vlog Testbenches/Hazard_Verification/SourceCode/*.sv
	vsim -c top -do "run -all; quit"

chip:
	vlib work
	vlog Testbenches/Chip_Verification/SourceCode/MIPS_pkg.sv
	vlog Testbenches/Chip_Verification/SourceCode/*.sv
	vlog DUV/*.v
	vsim -c top_tb -do "run -all; quit"

run:
	vsim -c top_tb -do "run -all; quit"

clean:
	rm -rf work transcript vsim.wlf
