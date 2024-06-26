module instruc_mem(input [7:0] inst_address,
    output reg [31:0] instruction);
    reg [7:0] inst_mem[64:0]; // inst_mem size/4 = nomber of instructions passed
   //Loading the instructions  
    initial
    begin
      {inst_mem[3], inst_mem[2], inst_mem[1], inst_mem[0]} = 32'h10000213;
      {inst_mem[7], inst_mem[6], inst_mem[5], inst_mem[4]} = 32'h09000193;
      {inst_mem[11], inst_mem[10], inst_mem[9], inst_mem[8]} = 32'b00000000010000011000001010110011;
      {inst_mem[15], inst_mem[14], inst_mem[13], inst_mem[12]} = 32'h0032A023;
      {inst_mem[19], inst_mem[18], inst_mem[17], inst_mem[16]} = 32'h0042A223;
      {inst_mem[23], inst_mem[22], inst_mem[21], inst_mem[20]} = 32'h002A383;
      {inst_mem[27], inst_mem[26], inst_mem[25], inst_mem[24]} = 32'h0402A383;
    
        end
    
  always @ (*)
    begin
      instruction[7:0] = inst_mem[inst_address+0];
      instruction[15:8] = inst_mem[inst_address+1];
      instruction[23:16] = inst_mem[inst_address+2];
      instruction[31:24] = inst_mem[inst_address+3];
    end
endmodule

