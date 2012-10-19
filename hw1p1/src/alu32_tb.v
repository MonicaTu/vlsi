`timescale 1ns/10ps
`include "alu32.v"

`define PERIOD 10
`define SIZE 32

module alu32_tb;

    parameter NOP=5'b01001,ADD=5'b00000,SUB=5'b00001,AND=5'b00010,
              OR=5'b00100,XOR=5'b00011,SRLI=5'b01001,SLLI=5'b01000,
              ROTRI=5'b01011;

    parameter OP_ARITH = 6'b100000;
    parameter OP_ADDI  = 6'b101000;
    parameter OP_ORI   = 6'b101100;
    parameter OP_XORI  = 6'b101011;

    wire [31:0]alu_result;
    wire alu_overflow;
    
    reg [31:0]scr1,scr2;
    reg [5:0]opcode;
    reg [4:0]sub_opcode;
    reg reset;
    reg enable_execute;
    
    reg clk;
    reg [31:0]tb_result;

    alu u(alu_result,alu_overflow,scr1,scr2,opcode,sub_opcode,enable_execute,reset);
	
    // setup clk
    initial begin
        clk = 0; // Start clock from LOW
        forever #(`PERIOD/2) clk = ~clk;
    end   

    initial begin
        enable_execute = 0;
        opcode = OP_ARITH;
        scr1 = 32'h0000162E; // (5678) dec
        scr2 = 32'h000004D2; // (1234) dec
        
        // NOP
        #(`PERIOD/2) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = NOP;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // ADD
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = ADD;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // SUB
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = SUB;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // AND
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = AND;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // OR
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = OR;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // XOR
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = XOR;
        #(`PERIOD) reset = 0; enable_execute = 1;
 
        scr1 = 32'h0000162E; // (5678) dec
        scr2 = 32'h00000003; //

        // SRLI
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = SRLI;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // SLLI
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = SLLI;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // ROTRI
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) sub_opcode = ROTRI;
        #(`PERIOD) reset = 0; enable_execute = 1;
 
        scr1 = 32'h0000162E; // (5678) dec
        scr2 = 32'h0000F0F0; //

        // ADDI
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) opcode = OP_ADDI;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // ORI
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) opcode = OP_ORI;
        #(`PERIOD) reset = 0; enable_execute = 1;
        // XORI
        #(`PERIOD) reset = 1; enable_execute = 0;
        #(`PERIOD) opcode = OP_XORI;
        #(`PERIOD) reset = 0; enable_execute = 1;

        #(`PERIOD) $finish;
    end
    
    initial begin

        // NOP
        #(`PERIOD/2); 
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 0;  
        #(`PERIOD); 
        // ADD
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h00001B00;  
        #(`PERIOD) tb_result = 0; 
        // SUB
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h0000115C;  
        #(`PERIOD) tb_result = 0; 
        // AND
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h00000402;  
        #(`PERIOD) tb_result = 0; 
        // OR
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h000016FE;  
        #(`PERIOD) tb_result = 0; 
        // XOR
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h000012FC;  
        #(`PERIOD) tb_result = 0; 
        // SRLI
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h000002C5;  
        #(`PERIOD) tb_result = 0; 
        // SLLI
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h0000B170;  
        #(`PERIOD) tb_result = 0; 
        // ROTRI
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'hC00002C5;  
        #(`PERIOD) tb_result = 0; 
        // ADDI
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h0001071E;  
        #(`PERIOD) tb_result = 0; 
        // ORI
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h00001020;  
        #(`PERIOD) tb_result = 0; 
        // XORI
        #(`PERIOD) tb_result = 0; 
        #(`PERIOD) tb_result = 32'h000066DE;  
        #(`PERIOD) tb_result = 0; 
        // MOVI
//        #(`PERIOD) tb_result = 0; 
//        #(`PERIOD) tb_result = 32'h0000F0F0;  
        #(`PERIOD) $finish;
    end

    initial begin
        $dumpfile("alu32_tb.vcd");
        $dumpvars();
    end

    initial begin
        $fsdbDumpfile("alu32_tb.fsdb");
        $fsdbDumpvars();
    end
    
endmodule
