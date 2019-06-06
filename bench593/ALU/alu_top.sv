

module top;

  initial begin
    forever
      #5ns clk = ~clk;
  end

    alu_intf_f intf();
    alu alu(intf.a, intf.b, intf.cmd, intf.result);
    test test(intf);

endmodule : top