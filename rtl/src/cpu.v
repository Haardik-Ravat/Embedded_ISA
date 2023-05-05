`timescale 1ns / 1ps
`include "branch.v"
`include "control.v"
`include "controller.v"
`include "memory.v"
`include "ic.v"
`include "alu.v"


module ARM_CPU
(
  input RESET,
  input CLOCK,
  input [31:0] IC,
  input [63:0] mem_data_in,
  output reg [63:0] PC,
  output [63:0] mem_address_out,
  output [63:0] mem_data_out,
  output control_memwrite_out,
  output control_memread_out
);

  always @(posedge CLOCK) begin
    if (PC === 64'bx) begin
    	PC <= 0;
   	end else if (PCSrc_wire == 1'b1) begin
      PC <= jump_PC_wire;
    end else begin
      PC <= PC + 4;
  end

  //$display("Current = %0d | Jump = %0d | Natural Next = %0d", PC, jump_PC_wire, (PC + 4));
  end

  /* Stage : Instruction Fetch */
  wire PCSrc_wire;
  wire [63:0] jump_PC_wire;
  wire [63:0] IFID_PC;
  wire [31:0] IFID_IC;
  IFID cache1 (CLOCK, PC, IC, IFID_PC, IFID_IC);


  /* Stage : Instruction Decode */
  wire [1:0] CONTROL_aluop; // EX
  wire CONTROL_alusrc; // EX
  wire CONTROL_isZeroBranch; // M
  wire CONTROL_isUnconBranch; // M
  wire CONTROL_memRead; // M
  wire CONTROL_memwrite; // M
  wire CONTROL_regwrite; // WB
  wire CONTROL_mem2reg; // WB
  ARM_Control unit1 (IFID_IC[31:21], CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg);

  wire [4:0] reg2_wire;
  ID_Mux unit2(IFID_IC[20:16], IFID_IC[4:0], IFID_IC[28], reg2_wire);

  wire [63:0] reg1_data, reg2_data;
  wire MEMWB_regwrite;
  wire [4:0] MEMWB_write_reg;
  wire [63:0] write_reg_data;
  Registers unit3(CLOCK, IFID_IC[9:5], reg2_wire, MEMWB_write_reg, write_reg_data, MEMWB_regwrite, reg1_data, reg2_data);

  wire [63:0] sign_extend_wire;
  SignExtend unit4 (IFID_IC, sign_extend_wire);

  wire [1:0] IDEX_aluop;
  wire IDEX_alusrc;
  wire IDEX_isZeroBranch;
  wire IDEX_isUnconBranch;
  wire IDEX_memRead;
  wire IDEX_memwrite;
  wire IDEX_regwrite;
  wire IDEX_mem2reg;
  wire [63:0] IDEX_reg1_data;
  wire [63:0] IDEX_reg2_data;
  wire [63:0] IDEX_PC;
  wire [63:0] IDEX_sign_extend;
  wire [10:0] IDEX_alu_control;
  wire [4:0] IDEX_write_reg;
  IDEX cache2 (CLOCK, CONTROL_aluop, CONTROL_alusrc, CONTROL_isZeroBranch, CONTROL_isUnconBranch, CONTROL_memRead, CONTROL_memwrite, CONTROL_regwrite, CONTROL_mem2reg, IFID_PC, reg1_data, reg2_data, sign_extend_wire, IFID_IC[31:21], IFID_IC[4:0], IDEX_aluop, IDEX_alusrc, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, IDEX_PC, IDEX_reg1_data, IDEX_reg2_data, IDEX_sign_extend, IDEX_alu_control, IDEX_write_reg);


  /* Stage : Execute */
  wire [63:0] shift_left_wire;
  wire [63:0] PC_jump;
  wire jump_is_zero;
  Shift_Left unit5 (IDEX_sign_extend, shift_left_wire);
  ALU unit6 (IDEX_PC, shift_left_wire, 4'b0010, PC_jump, jump_is_zero);

  wire [3:0] alu_main_control_wire;
  wire [63:0] alu_data2_wire;
  wire alu_main_is_zero;
  wire [63:0] alu_main_result;
  ALU_Control unit7(IDEX_aluop, IDEX_alu_control, alu_main_control_wire);
  ALU_Mux mux3(IDEX_reg2_data, IDEX_sign_extend, IDEX_alusrc, alu_data2_wire);
  ALU main_alu(IDEX_reg1_data, alu_data2_wire, alu_main_control_wire, alu_main_result, alu_main_is_zero);

  wire EXMEM_isZeroBranch;
  wire EXMEM_isUnconBranch;
  wire EXMEM_regwrite;
  wire EXMEM_mem2reg;
  wire EXMEM_alu_zero;
  wire [4:0] EXMEM_write_reg;
  EXMEM cache3(CLOCK, IDEX_isZeroBranch, IDEX_isUnconBranch, IDEX_memRead, IDEX_memwrite, IDEX_regwrite, IDEX_mem2reg, PC_jump, alu_main_is_zero, alu_main_result, IDEX_reg2_data, IDEX_write_reg, EXMEM_isZeroBranch, EXMEM_isUnconBranch, control_memread_out, control_memwrite_out, EXMEM_regwrite, EXMEM_mem2reg, jump_PC_wire, EXMEM_alu_zero, mem_address_out, mem_data_out, EXMEM_write_reg);


  /* Stage : Memory */
  Branch unit8 (EXMEM_isUnconBranch, EXMEM_isZeroBranch, EXMEM_alu_zero, PCSrc_wire);

  wire MEMWB_mem2reg;
  wire [63:0] MEMWB_address;
  wire [63:0] MEMWB_read_data;
  MEMWB cache4(CLOCK, mem_address_out, mem_data_in, EXMEM_write_reg, EXMEM_regwrite, EXMEM_mem2reg, MEMWB_address, MEMWB_read_data, MEMWB_write_reg, MEMWB_regwrite, MEMWB_mem2reg);


  /* Stage : Writeback */
  WB_Mux unit9 (MEMWB_address, MEMWB_read_data, MEMWB_mem2reg, write_reg_data);
endmodule
