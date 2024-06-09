import uvm_pkg::*;

module top_hdl();
  reg clk = 0;
  initial // clock generator
  forever #5 clk = ~clk;
   
  // Interface
  arb_intf intf(clk);
  
  // DUT connection	
  //ARBITER instance goes here

initial begin
  $dumpfile("dump.vcd"); 
  $dumpvars;
   
  uvm_config_db #(virtual arb_intf)::set (null, "uvm_test_top", "VIRTUAL_INTERFACE", intf);
  	
end
  
endmodule