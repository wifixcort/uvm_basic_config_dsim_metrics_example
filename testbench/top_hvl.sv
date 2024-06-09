`include "uvm_macros.svh"
import uvm_pkg::*;

`include "../testbench/testbench.sv"

// module top;
//   logic clk;
//   arb_intf intf(clk);

//   // Generar señal de reloj
//   initial begin
//     clk = 0;
//     forever #5 clk = ~clk;
//   end

//   // Asignar la interfaz virtual a la base de datos UVM
//   initial begin
//     uvm_config_db#(virtual arb_intf)::set(null, "uvm_test_top", "VIRTUAL_INTERFACE", intf);
//     run_test("test_basic");
//   end
// endmodule


module top_hvl();
  // logic clk;
  // arb_intf intf(clk);

  // initial begin
  //   clk = 0;
  //   forever #1 clk = ~clk;
  // end

initial begin 
  run_test("test_basic");	
end
  
endmodule