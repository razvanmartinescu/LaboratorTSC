/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 **********************************************************************/

module top;
  //timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;
  logic test_clk;
  tb_ifc Lab1TSC();
  // interconnecting signals
  //logic          load_en;
  //logic          reset_n;
  //opcode_t       opcode;
  //operand_t      operand_a, operand_b;
  //address_t      write_pointer, read_pointer;
  //instruction_t  instruction_word;

  // instantiate testbench and connect ports
  instr_register_test test (
    .clk(test_clk),
    .load_en(Lab2TSC.load_en),
    .reset_n(Lab2TSC.reset_n),
    .operand_a(Lab2TSC.operand_a),
    .operand_b(Lab2TSC.operand_b),
    .opcode(Lab2TSC.opcode),
    .write_pointer(Lab2TSC.write_pointer),
    .read_pointer(Lab2TSC.read_pointer),
    .instruction_word(Lab2TSC.instruction_word)
   );

  // instantiate design and connect ports
  instr_register dut (
    .clk(clk),
    .load_en(Lab2TSC.load_en),
    .reset_n(Lab2TSC.reset_n),
    .operand_a(Lab2TSC.operand_a),
    .operand_b(Lab2TSC.operand_b),
    .opcode(Lab2TSC.opcode),
    .write_pointer(Lab2TSC.write_pointer),
    .read_pointer(Lab2TSC.read_pointer),
    .instruction_word(Lab2TSC.instruction_word)
   );

  // clock oscillators
  initial begin
    clk <= 0;
    forever #5  clk = ~clk;
  end

  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    #4 forever begin
      #2ns test_clk = 1'b1;
      #8ns test_clk = 1'b0;
    end
  end

endmodule: top