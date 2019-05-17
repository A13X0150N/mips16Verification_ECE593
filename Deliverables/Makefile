full:
	vlib work
	vlog ./*.sv
	vlog ./*.v
	vsim -c top_tb -do "run -all; quit"
compile:
	vlog ./*.sv
	vlog ./*.v
run:
	vsim -c top_tb -do "run -all; quit"
clean:
	rm -rf work transcript vsim.wlf
