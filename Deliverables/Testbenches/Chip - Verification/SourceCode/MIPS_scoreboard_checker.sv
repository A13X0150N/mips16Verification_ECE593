class MIPS_scoreboard_checker;

bit isCorrect;
virtual mipsIF mif;

function new(virtual mipsIF mif_i);
	this.mif = mif_i;
	
endfunction

// Checker compares register values of DUV and Reference Design
function checking();

	for(int i=0;i<16;i++)
	begin
		if(mif.DataRegister_rm[i] != mif.duv_registers[i])
		begin
			isCorrect = 0;
			$display("Warning! - register[%d] is different at instruction number: %d",i, mif.PC);
			// Not fatal, otherwise it stops
		end
		else
		begin
			// $display("Checker -> valid");
			isCorrect = 1;
		end
	end
	
endfunction

// scoreboard writes which instruction is executed and register values into the scoreboard.txt file
function scoreboard();
	int f;
	if(this.mif.PC == 0)
	begin
		// f = $fopen("scoreboard.txt","w");
		f = $fopen("scoreboard.txt","a");
		$fwrite(f,"%10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s %10s","PC","Reg[0]_d","Reg[1]_d","Reg[2]_d","Reg[3]_d","Reg[4]_d","Reg[5]_d","Reg[6]_d","Reg[7]_d","Reg[0]_r","Reg[1]_r","Reg[2]_r","Reg[3]_r","Reg[4]_r","Reg[5]_r","Reg[6]_r","Reg[7]_r");
	end
	
		$fwrite(f,"%d \t %h \t %h \t %h \t %h \t %h \t %h \t %h \t %h \t | \t \t %h \t %h \t %h \t %h \t %h \t %h \t %h \t %h \t", this.mif.PC, this.mif.duv_registers[0], this.mif.duv_registers[1], this.mif.duv_registers[2], this.mif.duv_registers[3], this.mif.duv_registers[4], this.mif.duv_registers[5], this.mif.duv_registers[6], this.mif.duv_registers[7], this.mif.DataRegister_rm[0], this.mif.DataRegister_rm[1], this.mif.DataRegister_rm[2], this.mif.DataRegister_rm[3], this.mif.DataRegister_rm[4], this.mif.DataRegister_rm[5], this.mif.DataRegister_rm[6], this.mif.DataRegister_rm[7]);
	
	if(this.mif.PC == 255)
	begin
		$fclose(f);
	end
endfunction

endclass