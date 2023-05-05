module ALU_Control
(
  input [1:0] ALU_Op,
  input [10:0] ALU_INSTRUCTION,
  output reg [3:0] ALU_Out
);

  always @(ALU_Op or ALU_INSTRUCTION) begin
    case (ALU_Op)
      2'b00 : ALU_Out = 4'b0010;
      2'b01 : ALU_Out = 4'b0111;
      2'b10 : begin

      case (ALU_INSTRUCTION)
        11'b10001011000 : ALU_Out = 4'b0010; // ADD
        11'b11001011000 : ALU_Out = 4'b0110; // SUB
        11'b10001010000 : ALU_Out = 4'b0000; // AND
        11'b10101010000 : ALU_Out = 4'b0001; // ORR
        11'b10011010000 : ALU_Out = 4'b0100; // MUL
        11'b10111010000 : ALU_Out = 4'b0101; // MOV
        11'b10001010010 : ALU_Out = 4'b0010; // VADD
        11'b11001010010 : ALU_Out = 4'b0110; // VSUB
        11'b10011010010 : ALU_Out = 4'b0100; // VMUL
        11'b10001010100 : ALU_Out = 4'b0010; // VMOV
        11'b11111010100 : ALU_Out = 4'b1000; // MAC
        11'b10011110000 : ALU_Out = 4'b0100; // VLD1
        11'b10001110000 : ALU_Out = 4'b0010; // VST1

      endcase
      end
      default : ALU_Out = 4'bxxxx;
    endcase
  end
endmodule