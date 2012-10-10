`timescale 1ns/10ps
`include "alu32.v"

`define PERIOD 10
`define SIZE 32

module alu32_tb;

    parameter NOP=5'b01001,ADD=5'b00000,SUB=5'b00001,AND=5'b00010,
              OR=5'b00100,XOR=5'b00011,SRLI=5'b01001,SLLI=5'b01000,
              ROTRI=5'b01011;
    wire [31:0]alu_result;
    wire alu_overflow;
    
    reg [31:0]scr1,scr2;
    reg [5:0]opcode;
    reg [4:0]sub_opcode;
    reg reset;
    reg enable_execute;
    
    reg clk;

    alu u(alu_result,alu_overflow,scr1,scr2,opcode,sub_opcode,enable_execute,reset);
	
    // setup clk
    initial begin
        clk = 0; // Start clock from LOW
        forever #(`PERIOD/2) clk = ~clk;
    end   

    initial begin
//        preld_val = DEFAULT_VAL;
//        _updown = 1;
//        _carry_in = 1;
        enable_execute = 0;
        scr1 = 32'hFFFFFF00;
        scr2 = 32'h00000005;
        opcode = ADD;
        enable_execute = 1;
        #100000 $finish;
    end

    initial begin
        $dumpfile("alu32_tb.vcd");
        $dumpvars();
    end

//    initial begin
//        $fsdbDumpfile("alu32_tb.fsdb");
//        $fsdbDumpvars();
//    end
    
endmodule
