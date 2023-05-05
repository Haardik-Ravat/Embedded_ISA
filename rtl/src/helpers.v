
module IFID
(
  input CLOCK,
  input [63:0] PC_in,
  input [31:0] IC_in,
  output reg [63:0] PC_out,
  output reg [31:0] IC_out
);

  always @(negedge CLOCK) begin
    PC_out <= PC_in;
    IC_out <= IC_in;
  end
endmodule


module IDEX
(
  input CLOCK,
  input [1:0] aluop_in, 	       // EX Stage
  input alusrc_in, 			         // EX Stage
  input isZeroBranch_in, 	       // M Stage
  input isUnconBranch_in, 	     // M Stage
  input memRead_in, 		         // M Stage
  input memwrite_in, 		         // M Stage
  input regwrite_in, 		         // WB Stage
  input mem2reg_in, 		         // WB Stage
  input [63:0] PC_in,
  input [63:0] regdata1_in,
  input [63:0] regdata2_in,
  input [63:0] sign_extend_in,
  input [10:0] alu_control_in,
  input [4:0] write_reg_in,
  output reg [1:0] aluop_out, 	// EX Stage
  output reg alusrc_out, 		    // EX Stage
  output reg isZeroBranch_out, 	// M Stage
  output reg isUnconBranch_out, // M Stage
  output reg memRead_out, 		  // M Stage
  output reg memwrite_out, 		  // M Stage
  output reg regwrite_out,		  // WB Stage
  output reg mem2reg_out,		    // WB Stage
  output reg [63:0] PC_out,
  output reg [63:0] regdata1_out,
  output reg [63:0] regdata2_out,
  output reg [63:0] sign_extend_out,
  output reg [10:0] alu_control_out,
  output reg [4:0] write_reg_out
);

  always @(negedge CLOCK) begin
    /* Values for EX */
    aluop_out <= aluop_in;
    alusrc_out <= alusrc_in;

    /* Values for M */
  	isZeroBranch_out <= isZeroBranch_in;
    isUnconBranch_out <= isUnconBranch_in;
  	memRead_out <= memRead_in;
 	  memwrite_out <= memwrite_in;

    /* Values for WB */
    regwrite_out <= regwrite_in;
  	mem2reg_out <= mem2reg_in;

    /* Values for all Stages */
    PC_out <= PC_in;
    regdata1_out <= regdata1_in;
    regdata2_out <= regdata2_in;

    /* Values for variable stages */
    sign_extend_out <= sign_extend_in;
  	alu_control_out <= alu_control_in;
  	write_reg_out <= write_reg_in;
  end
endmodule


module EXMEM
(
  input CLOCK,
  input isZeroBranch_in, 	// M Stage
  input isUnconBranch_in, 	// M Stage
  input memRead_in, 		// M Stage
  input memwrite_in, 		// M Stage
  input regwrite_in, 		// WB Stage
  input mem2reg_in, 		// WB Stage
  input [63:0] shifted_PC_in,
  input alu_zero_in,
  input [63:0] alu_result_in,
  input [63:0] write_data_mem_in,
  input [4:0] write_reg_in,
  output reg isZeroBranch_out, 	// M Stage
  output reg isUnconBranch_out, // M Stage
  output reg memRead_out, 		// M Stage
  output reg memwrite_out, 		// M Stage
  output reg regwrite_out,		// WB Stage
  output reg mem2reg_out,		// WB Stage
  output reg [63:0] shifted_PC_out,
  output reg alu_zero_out,
  output reg [63:0] alu_result_out,
  output reg [63:0] write_data_mem_out,
  output reg [4:0] write_reg_out
);

  always @(negedge CLOCK) begin
    /* Values for M */
  	isZeroBranch_out <= isZeroBranch_in;
    isUnconBranch_out <= isUnconBranch_in;
  	memRead_out <= memRead_in;
 	memwrite_out <= memwrite_in;

    /* Values for WB */
    regwrite_out <= regwrite_in;
  	mem2reg_out <= mem2reg_in;

    /* Values for all Stages */
    shifted_PC_out <= shifted_PC_in;
    alu_zero_out <= alu_zero_in;
    alu_result_out <= alu_result_in;
    write_data_mem_out <= write_data_mem_in;
  write_reg_out <= write_reg_in;
  end
endmodule


module MEMWB
(
  input CLOCK,
  input [63:0] mem_address_in,
  input [63:0] mem_data_in,
  input [4:0] write_reg_in,
  input regwrite_in,
  input mem2reg_in,
  output reg [63:0] mem_address_out,
  output reg [63:0] mem_data_out,
  output reg [4:0] write_reg_out,
  output reg regwrite_out,
  output reg mem2reg_out
);

  always @(negedge CLOCK) begin
    regwrite_out <= regwrite_in;
    mem2reg_out <= mem2reg_in;
    mem_address_out <= mem_address_in;
    mem_data_out <= mem_data_in;
    write_reg_out <= write_reg_in;
  end
endmodule


module ID_Mux
(
  input [4:0] read1_in,
  input [4:0] read2_in,
  input reg2loc_in,
  output reg [4:0] reg_out
);

  always @(read1_in, read2_in, reg2loc_in) begin
    case (reg2loc_in)
        1'b0 : begin
            reg_out <= read1_in;
        end
        1'b1 : begin
            reg_out <= read2_in;
        end
        default : begin
            reg_out <= 1'bx;
        end
    endcase
  end
endmodule


module WB_Mux
(
  input [63:0] input1,
  input [63:0] input2,
  input mem2reg_control,
  output reg [63:0] out
);

  always @(*) begin
    if (mem2reg_control == 0) begin
      out <= input1;
    end

    else begin
      out <= input2;
    end
  end
endmodule


module Shift_Left
(
  input [63:0] data_in,
  output reg [63:0] data_out
);

  always @(data_in) begin
    data_out = data_in << 2;
  end
endmodule


module SignExtend
(
  input [31:0] inputInstruction,
  output reg [63:0] outImmediate
);

  always @(inputInstruction) begin
    if (inputInstruction[31:26] == 6'b000101) begin // B
      outImmediate[25:0] = inputInstruction[25:0];
      outImmediate[63:26] = {64{outImmediate[25]}};

    end else if (inputInstruction[31:24] == 8'b10110100) begin // CBZ
      outImmediate[19:0] = inputInstruction[23:5];
      outImmediate[63:20] = {64{outImmediate[19]}};

    end else begin // D Type, ignored if R type
      outImmediate[9:0] = inputInstruction[20:12];
      outImmediate[63:10] = {64{outImmediate[9]}};
    end
  end
endmodule