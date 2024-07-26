# 8-bit Dual Pipeline Superscalar RISC-V Processor

In digital computing, various instruction set architectures (ISAs) exist, including:

- **RISC** (Reduced Instruction Set Computer)
- **CISC** (Complex Instruction Set Computer)
- **VLIW** (Very Long Instruction Word)
- **EPIC** (Explicitly Parallel Instruction Computing)

We have chosen the RISC architecture for our microprocessor due to its simplicity, efficiency, and adaptability.

## Introduction

Our 8-bit dual pipeline superscalar RISC-V microprocessor is designed as a part of our IITI SoC. This design enhances instruction throughput by executing multiple instructions per clock cycle. Leveraging a superscalar architecture, this processor aims to achieve higher performance than the non-pipelined ones.

## Features

- **8-bit RISC-V ISA CPU Core**
- **Dual-Issue Superscalar Architecture**
- **5-Stage Pipeline: IF, ID, EX, MEM, WB**
- **Harvard Architecture**
- **RV32I Base Integer & RV32M Extensions**
- **Two Integer ALUs**
- **Dynamic 2-bit Branch Prediction Unit**
- **Issue and Complete 2 Instructions/Cycle**
- **8-bit Instruction Fetch/Data Access**
- **32 General Purpose Registers**
- **Instruction Memory: 256x8-bit, Little-Endian**
- **Data Memory: 256x8-bit**
- **Hazard Management: Instruction Issue Unit, Hazard detection Unit and Forwading Path**
- **Pipeline Latches: IF_ID, ID_EX, EX_MEM, MEM_WB**
- **Supports Pseudo-Instructions: MV, NOT, NEG**

An in-depth explanation of our approach to designing the microprocessor and its specifications is provided below.
  
## Architecture Overview

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

- **Address Space**: 256x8
- **Word Size**: 8-bit
- **Byte Ordering**: Little-endian
- **Instruction Storage**: Each instruction is stored in 4 consecutive registers.
- **Dual Instruction Fetch**: Fetches two 32-bit instructions per cycle, allowing parallel instruction processing.

### Data Memory

- **Address Space**: 256x8
- **Word Size**: 8-bit
- **Dual-Path Read and Write**: Supports simultaneous read and write operations on two different addresses (Dual-Port Memory).

## Register File

- **Registers**: 32x8-bit
- **Special Register**: `x0` is hardwired to zero.
  

## Control Unit

The control unit generates control signals based on the opcode. It is divided into two levels:

1. **Main Control Unit**: Manages control signals for the data memory, register file, and various multiplexers.
2. **ALU Control Unit**: Receives signals from both the main control unit and the instruction to generate appropriate signals for the ALU.

## Arithmetic Logic Unit (ALU)

The Arithmetic Logic Unit (ALU) executes arithmetic operations like addition and subtraction, and logical operations such as AND, OR, and XOR. It processes data based on instructions, producing results that are then used by the rest of the processor, including writing them to registers or memory.A list of arithmetic and logic operations performed by ALU is given in the currently supported instruction section.

## Superscalar Pipeline

Our design aims to implement a superscalar architecture by giving the microprocessor two parallel data paths. This allows it to fetch, decode, and execute two instructions per clock cycle.

### Dual Pipeline Stages

1. **Fetch**
   - Two instructions are fetched from the instruction memory simultaneously.
   
2. **Decode**
   - Both instructions are decoded, and operands are read from the register file.
   
3. **Execute**
   - Each instruction is executed in a separate ALU.

4. **Memory**
   - Memory access operations are performed for both instructions.

5. **Writeback**
   - Results of both instructions are written back to the register file.

### Additional Control Logic

To support dual instruction execution, additional control logic is required to handle dependencies and resource conflicts between the two instructions. This includes:

- **Instruction Issuing Unit**: 
The Instruction Issuing Unit (IIU) operates in the ID stage, decoding incoming instructions from the Instruction Memory and detecting operand dependencies. If a dependency is found, the second instruction is held in a register and a "rollback" signal adjusts the next-PC value. The held instruction is then issued in the following clock cycle.

- **Next-PC Logic**:
- Whenever the “rollback” signal is asserted in the ID stage,next PC value will be the address of next instruction (PC + 4), otherwise it is the address of the instruction after the next instruction (PC + 8). 

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

## Conclusion

This 8-bit dual pipeline superscalar RISC-V processor leverages the advantages of RISC architecture and superscalar execution to achieve high performance. By carefully managing hazards and optimizing the pipeline, this design aims to provide efficient instruction throughput for embedded applications.
