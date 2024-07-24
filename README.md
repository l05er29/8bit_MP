# 8-bit RISC Microprocessor Design

In digital computing, various instruction set architectures (ISAs) exist, including:

- **RISC** (Reduced Instruction Set Computer)
- **CISC** (Complex Instruction Set Computer)
- **VLIW** (Very Long Instruction Word)
- **EPIC** (Explicitly Parallel Instruction Computing)

We have chosen the RISC architecture for our microprocessor due to its simplicity, efficiency, and adaptability.

## CPU Stages

Our CPU is designed with a 5-stage pipeline comprising:

1. **Fetch**
2. **Decode**
3. **Execute**
4. **Memory**
5. **Writeback**

## Instruction Set Architecture

We implement basic instructions from the RV32I Base Integer Instruction Set. These instructions are all 32 bits in length and aligned on a four-byte boundary in memory. Our base ISA includes three instruction formats: R-type, I-type, and S-type.

### Instruction Formats

- **R-type**: 
  ```
  funct7 [31:25] | rs2 [24:20] | rs1 [19:15] | funct3 [14:12] | rd [11:7] | opcode [6:0]
  ```

- **I-type**:
  ```
  0000 (unused) | immediate [31:24] | rs1 [19:15] | funct3 [14:12] | rd [11:7] | opcode [6:0]
  ```

- **S-type**:
  ```
  0000 (unused) | immediate [27:25] | rs2 [24:20] | rs1 [19:15] | funct3 [14:12] | immediate [11:7] | opcode [6:0]
  ```

## Memory Architecture

The microprocessor employs the Harvard architecture, featuring separate memories for instructions and data. This approach enhances performance by allowing simultaneous access to both instruction and data memories.

### Instruction Memory

- **Address Space**: 64x8
- **Word Size**: 8-bit
- **Byte Ordering**: Little-endian
- **Instruction Storage**: Each instruction is stored in 4 consecutive registers.

### Data Memory

- **Address Space**: 64x8
- **Word Size**: 8-bit

## Register File

- **Registers**: 32x8-bit
- **Special Register**: `x0` is hardwired to zero.

## Control Unit

The control unit generates control signals based on the opcode. It is divided into two levels:

1. **Main Control Unit**: Manages control signals for the data memory, register file, and various multiplexers.
2. **ALU Control Unit**: Receives signals from both the main control unit and the instruction to generate appropriate signals for the ALU.

## Currently Supported Instructions

### RV32I Base Integer Instruction Set

1. **ADDI** 
   - Adds 8-bit immediate to register `rs1`.
   - Result stored in `rd`.

2. **SLTI** 
   - Sets `rd` to 1 if `rs1` is less than the immediate (signed comparison), otherwise 0.

3. **SLTIU** 
   - Sets `rd` to 1 if `rs1` is less than the immediate (unsigned comparison), otherwise 0.

4. **XORI** 
   - Performs bitwise XOR on `rs1` and the 8-bit immediate.
   - Result stored in `rd`.

5. **ORI** 
   - Performs bitwise OR on `rs1` and the 8-bit immediate.
   - Result stored in `rd`.

6. **ANDI** 
   - Performs bitwise AND on `rs1` and the 8-bit immediate.
   - Result stored in `rd`.

7. **SLLI** 
   - Shifts `rs1` left logically by the shift amount in the lower 5 bits of the immediate.
   - Result stored in `rd`.

8. **SLRI** 
   - Shifts `rs1` right logically by the shift amount in the lower 5 bits of the immediate.
   - Result stored in `rd`.

9. **ADD** 
   - Adds `rs1` and `rs2`.
   - Result stored in `rd`.

10. **SUB** 
    - Subtracts `rs2` from `rs1`.
    - Result stored in `rd`.

11. **SLL** 
    - Shifts `rs1` left logically by the shift amount in the lower 5 bits of `rs2`.
    - Result stored in `rd`.

12. **SLR** 
    - Shifts `rs1` right logically by the shift amount in the lower 5 bits of `rs2`.
    - Result stored in `rd`.

13. **SLT** 
    - Sets `rd` to 1 if `rs1` is less than `rs2` (signed comparison), otherwise 0.

14. **SLTU** 
    - Sets `rd` to 1 if `rs1` is less than `rs2` (unsigned comparison), otherwise 0.

15. **SRA** 
    - Shifts `rs1` right arithmetically by the shift amount in the lower 5 bits of `rs2`.
    - Result stored in `rd`.

16. **XOR** 
    - Performs bitwise XOR on `rs1` and `rs2`.
    - Result stored in `rd`.

17. **AND** 
    - Performs bitwise AND on `rs1` and `rs2`.
    - Result stored in `rd`.

18. **OR** 
    - Performs bitwise OR on `rs1` and `rs2`.
    - Result stored in `rd`.

19. **LOAD** 
    - Loads an 8-bit value from memory.
    - Stores it in `rd`.

20. **STORE** 
    - Stores an 8-bit value from `rs2` to memory.

### RV32M Standard Extension for Integer Multiplication and Division

21. **MUL** 
    - Multiplies signed `rs1` by signed `rs2`.
    - Lower XLEN bits stored in `rd`.

22. **MULH** 
    - Multiplies signed `rs1` by signed `rs2`.
    - Upper XLEN bits stored in `rd`.

23. **MULSU** 
    - Multiplies signed `rs1` by unsigned `rs2`.
    - Upper XLEN bits stored in `rd`.

24. **MULHU** 
    - Multiplies unsigned `rs1` by unsigned `rs2`.
    - Upper XLEN bits stored in `rd`.

25. **DIV** 
    - Divides signed `rs1` by signed `rs2`.
    - Result stored in `rd`.

26. **DIVU** 
    - Divides unsigned `rs1` by unsigned `rs2`.
    - Result stored in `rd`.

27. **REM** 
    - Computes remainder of signed `rs1` divided by signed `rs2`.
    - Result stored in `rd`.

28. **REMU** 
    - Computes remainder of unsigned `rs1` divided by unsigned `rs2`.
    - Result stored in `rd`.

### Notes

- **ADDI rd, rs1, 0** is utilized to implement the `MV rd, rs1` assembler pseudo-instruction, which moves the value from register `rs1` to register `rd`.

- **XORI rd, rs1, -1** performs a bitwise logical inversion of the value in register `rs1`, effectively implementing the `NOT rd, rs1` assembler pseudo-instruction.

- **SUB rd, x0, rs** computes the two's complement of the value in register `rs`, storing the result in register `rd`. This operation is used to implement the `NEG rd, rs` assembler pseudo-instruction, which negates the value in register `rs`.

## Pipelining

Pipelining is a technique used to enhance the performance of a microprocessor by overlapping the execution of multiple instructions. In our 8-bit RISC microprocessor design, we implement a 5-stage pipeline. Each stage of the pipeline is separated by pipeline latches (also known as pipeline registers) to hold intermediate data and control signals between stages.

### Pipeline Stages

1. **IF (Instruction Fetch)**: Fetches the instruction from memory.
2. **ID (Instruction Decode)**: Decodes the instruction and reads registers.
3. **EX (Execute)**: Performs the operation specified by the instruction.
4. **MEM (Memory Access)**: Accesses memory for load and store instructions.
5. **WB (Writeback)**: Writes the result back to the register file.

### Pipeline Latches

- **IF_ID**: Holds information between the Fetch and Decode stages.
- **ID_EX**: Holds information between the Decode and Execute stages.
- **EX_MEM**: Holds information between the Execute and Memory stages.
- **MEM_WB**: Holds information between the Memory and Writeback stages.

### Hazards

In a pipelined microprocessor, hazards can be categorized into three main types:

1. **Data Hazards:**
   - Occur when instructions that exhibit data dependencies modify data in different stages of the pipeline.
   - **Types:**
     - **Read After Write (RAW):** A subsequent instruction tries to read a source operand before a previous instruction writes to it.
     - **Write After Read (WAR):** A subsequent instruction tries to write to a destination operand before a previous instruction reads it.
     - **Write After Write (WAW):** Two instructions try to write to the same destination operand in an incorrect order.

2. **Control Hazards:**
   - Arise from the pipelining of branch instructions and other instructions that change the Program Counter (PC).
   - **Example:** Incorrect predictions of branch outcomes can lead to fetching and executing wrong instructions.

3. **Structural Hazards:**
   - Occur when hardware resources are insufficient to support all the concurrent operations in the pipeline.
   - **Example:** If the instruction and data memory share the same memory and both stages need access simultaneously, a conflict occurs.

### Hazard Mitigation Techniques

- **Forwarding (Data Hazard):** Bypassing data from one pipeline stage to another without waiting for it to be written and read from the register file.
- **Pipeline Stalling (Data & Control Hazard):** Pausing the pipeline until the hazard is resolved.
- **Branch Prediction (Control Hazard):** Using algorithms to guess the outcome of a branch to minimize control hazards.
- **Multiple Memory Access Paths (Structural Hazard):** Providing separate instruction and data memory paths to avoid conflicts.

Effective hazard management is crucial for maintaining the efficiency and performance of the pipelined processor.
if possible we will implement superscalar microprocessor by giving 2 data paths.
