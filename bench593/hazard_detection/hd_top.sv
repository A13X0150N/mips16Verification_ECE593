`include "hd_intf.sv"
`include "hd_test.sv"

module top;

  initial begin
    forever
      #5ns clk = ~clk;
  end

    hd_intf_f intf();
    hd hd(intf.a, intf.b, intf.cmd, intf.result);
    test test(intf);

endmodule : top