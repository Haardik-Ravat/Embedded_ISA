module IC
(
  input [63:0] PC_in,
  output reg [31:0] instruction_out
);

  reg [8:0] Data[63:0];

  initial begin

  	// LDUR x2, [x9, #1]
    Data[0] = 8'hf8;
    Data[1] = 8'h40;
    Data[2] = 8'h11;
    Data[3] = 8'h22;

    // ADD x3, x10, x5
    Data[4] = 8'h8b;
    Data[5] = 8'h05;
    Data[6] = 8'h01;
    Data[7] = 8'h43;

    // SUB x4, x10, x5
    Data[8] = 8'hcb;
    Data[9] = 8'h05;
    Data[10] = 8'h01;
    Data[11] = 8'h44;

    // ORR x5, x30, x10
    Data[12] = 8'haa;
    Data[13] = 8'h0a;
    Data[14] = 8'h03;
    Data[15] = 8'hc5;

    // AND x6, x30, x10
    Data[16] = 8'h8a;
    Data[17] = 8'h0a;
    Data[18] = 8'h03;
    Data[19] = 8'hc6;

    // STUR x2, [x31]
    Data[20] = 8'hf8;
    Data[21] = 8'h00;
    Data[22] = 8'h03;
    Data[23] = 8'he2;

    // MOV x7, #0x42
    Data[24] = 8'h20;
    Data[25] = 8'h07;
    Data[26] = 8'h00;
    Data[27] = 8'h12;

    // MUL x8, x9, x10
    Data[28] = 8'h9b;
    Data[29] = 8'h0a;
    Data[30] = 8'h08;
    Data[31] = 8'h1b;

    // VADD.F32 q0, q1, q2
    Data[32] = 8'h4e;
    Data[33] = 8'h21;
    Data[34] = 8'h40;
    Data[35] = 8'h0e;

    // VSUB.F32 q0, q1, q2
    Data[36] = 8'h4e;
    Data[37] = 8'h21;
    Data[38] = 8'h40;
    Data[39] = 8'h4e;

    // VMUL.F32 q0, q1, q2
    Data[40] = 8'h4e;
    Data[41] = 8'h21;
    Data[42] = 8'h40;
    Data[43] = 8'h8e;

    // VMOV d0, r0, r1
    Data[44] = 8'h4f;
    Data[45] = 8'h20;
    Data[46] = 8'h10;
    Data[47] = 8'h4e;

    // MAC x11, x12, x13, x14
    Data[48] = 8'h1b;
    Data[49] = 8'h0d;
    Data[50] = 8'h0c;
    Data[51] = 8'h3b;

    // B #0x1
    Data[52] = 8'h00;

    // CBZ x15, #0x1
    Data[53] = 8'h00;
    Data[54] = 8'h00;
    Data[55] = 8'h00;
    Data[56] = 8'h35;

    // CBNZ x16, #0x1
    Data[57] = 8'h00;
    Data[58] = 8'h00;
    Data[59] = 8'h00;
    Data[60] = 8'hb5;

    // VST1.32 {d0}, [r0]
    Data[61] = 8'h4f;
    Data[62] = 8'h00;
    Data[63] = 8'h00;
    Data[64] = 8'h0e;

    // VLD1.32 {d0}, [r0]
    Data[65] = 8'h4f;
    Data[66] = 8'h00;
    Data[67] = 8'h00;
    Data[68] = 8'h4e;


  end

  always @(PC_in) begin
    instruction_out[8:0] = Data[PC_in + 3];
    instruction_out[16:8] = Data[PC_in + 2];
    instruction_out[24:16] = Data[PC_in + 1];
    instruction_out[31:24] = Data[PC_in];
  end
endmodule
