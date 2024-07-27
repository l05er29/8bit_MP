module InstructionIssuingUnit (
    input wire clk,
    input wire rst,
    input wire [31:0] instr1,  // First instruction from I-Cache
    input wire [31:0] instr2,  // Second instruction from I-Cache
    output reg [31:0] issue_instr1, // First instruction to be issued
    output reg [31:0] issue_instr2, // Second instruction to be issued
    output reg rollback
);
    reg [31:0] hold_instr;
    reg has_dependency;
    integer file;  // File descriptor
    integer first_write;  // Flag to indicate first write
    integer cycle_count;  // Counter for clock cycles

    // Initialize the flag and counter
    initial begin
        first_write = 1;
        cycle_count = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            issue_instr1 <= 32'b0;
            issue_instr2 <= 32'b0;
            hold_instr <= 32'b0;
            rollback <= 1'b0;
            has_dependency <= 1'b0;
            cycle_count <= 0;  // Reset cycle count on reset
        end else begin
            // Dependency check (simplified example)
            if (instr1[11:7] == instr2[19:15] || instr1[11:7] == instr2[24:20]) begin
                has_dependency <= 1'b1;
                hold_instr <= instr2;
                rollback <= 1'b1;
                issue_instr1 <= instr1;
                issue_instr2 <= 32'b0;  // Only issue instr1, delay instr2
            end else if (has_dependency) begin
                issue_instr1 <= hold_instr;
                issue_instr2 <= instr1;  // Issue held instruction and next instruction in sequence
                rollback <= 1'b0;
                has_dependency <= 1'b0;
            end else begin
                issue_instr1 <= instr1;
                issue_instr2 <= instr2;  // Issue both instructions
                rollback <= 1'b0;
            end

            // Increment the clock cycle counter
            cycle_count <= cycle_count + 1;
        end
    end

    // Write the instructions to a text file with clock cycles, excluding undefined values
    always @(posedge clk) begin
        // Open file in append mode
        file = $fopen("instructions_with_cycle.txt", "a");
        if (file) begin
            if (first_write) begin
                // Write headers to the file
                $fwrite(file, "%-10s %-10s %-10s\n", "Clock Cycle", "instr1", "instr2");
                first_write = 0;  // Set flag to false after writing headers
            end
            // Write instructions with clock cycle to file, excluding undefined values
            if (issue_instr1 !== 32'bx && issue_instr2 !== 32'bx) begin
                $fwrite(file, "%-10d %-10h %-10h\n", cycle_count, issue_instr1, issue_instr2);
            end
            // Close the file
            $fclose(file);
        end else begin
            $display("Error: Could not open file for writing.");
        end
    end

endmodule