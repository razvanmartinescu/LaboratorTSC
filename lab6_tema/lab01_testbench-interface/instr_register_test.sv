/*************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 ************************/

//TEMA -> COVERPOINT PENTRU REZULTAT

 //in afara de initial begin, adaugam tot in clasa - functii, task-uri, interfata si variabile interne (seed)
  module instr_register_test
  import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
  (
	tb_ifc.TB intf_lab 
  );

  class Transaction;
  parameter nr = 100;

  covergroup my_coverage;
    coverpoint intf_lab.cb.operand_a{
      bins neg = {[-15:-1]};
      bins zero = {0};
      bins pos = {[1:15]};
    }
    coverpoint intf_lab.cb.operand_b{
      bins zero = {0};
      bins pos = {[1:15]};
    }
    coverpoint intf_lab.cb.opcode{
      bins zero = {0};
      bins pos = {[1:7]};
    }
  endgroup

  virtual tb_ifc.TB intf_lab;

  function new(virtual tb_ifc.TB interfata); 
    intf_lab = interfata; 
  endfunction

  //int seed = nr; //nr cu care se incepe randomizarea
  //timeunit 1ns/1ns;

  //initial begin
    task run();
    $display("\n\n*********************");
    $display(    "*  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  *");
    $display(    "*  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     *");
    $display(    "*  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  *");
    $display(    "*********************");

    $display("\nReseting the instruction register...");
    intf_lab.cb.write_pointer  <= 5'h00;         // initialize write pointer
    intf_lab.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    intf_lab.cb.load_en        <= 1'b0;          // initialize load control line
    intf_lab.cb.reset_n       <= 1'b0;           // assert reset_n (active low)
    repeat (2) @(posedge intf_lab.cb) ;      // hold in reset for 2 clock cycles
    intf_lab.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge intf_lab.cb) intf_lab.cb.load_en <= 1'b1;  // enable writing to register
    repeat (nr) begin
      @(posedge intf_lab.cb) randomize_transaction;
      @(negedge intf_lab.cb) print_transaction;
      my_coverage.sample; 
    end
    @(posedge intf_lab.cb) intf_lab.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=0; i<=nr; i++) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      @(posedge intf_lab.cb) intf_lab.cb.read_pointer <= i;
      @(negedge intf_lab.cb) print_results;
      my_coverage.sample; 
    end

    @(posedge intf_lab.cb) ;
    $display("\n*********************");
    $display(  "*  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  *");
    $display(  "*  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     *");
    $display(  "*  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  *");
    $display(  "*********************\n");
    $finish;
  //end
  endtask

  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    intf_lab.cb.operand_a     <= $urandom()%16;                 // between -15 and 15
    //intf_lab.cb.operand_a    <= $random(seed)%16;                 // between -15 and 15
    intf_lab.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    intf_lab.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
    intf_lab.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", intf_lab.cb.write_pointer);
    $display("  opcode = %0d (%s)", intf_lab.cb.opcode, intf_lab.cb.opcode.name);
    $display("  operand_a = %0d",   intf_lab.cb.operand_a);
    $display("  operand_b = %0d\n", intf_lab.cb.operand_b);
    $display("  TIME: %t ns", $time);
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", intf_lab.cb.read_pointer);
    $display("  opcode = %0d (%s)", intf_lab.cb.instruction_word.opc, intf_lab.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   intf_lab.cb.instruction_word.op_a);
    $display("  operand_b = %0d\n", intf_lab.cb.instruction_word.op_b);
  endfunction: print_results

 endclass : Transaction

initial begin 
  Transaction tr;
  tr = new(intf_lab);
  //tr.intf_lab = intf_lab;
  tr.run();
end

//CONSTRUCTOR 
// initial begin 
//   Transaction tr;
//   tr = new();
//   tr.intf_lab = intf_lab;
//   tr.run();
// end

endmodule: instr_register_test

//contructor new, care sa primeasca interfata