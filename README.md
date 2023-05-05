# Embedded Systems Project Report

### Group Members

> Aaditya Baranwal baranwal.1@iitj.ac.in ;  Github: [eternal-f1ame](https://github.com/aeternum) <br>
> Haardik Ravat ravat.1@iitj.ac.in ; Github: [Haardik-Ravat](https://github.com/Haardik-Ravat)

# Abstract

* In this project, we developed a pipelined ARM-like processor in Verilog to execute a subset of instructions that included `ADD`, `SUB`, `MUL`, `MAC`, `LUDR`, `STUR`, `VADD`, `VSUB`, `VMUL`, `MOV`, `VMOV`, `VLD1`, `VST1`, `ADDS`, `SUBS`, `B`, `CBZ`, and `CBNZ`. 

* This project aimed to design and implement an ARM CPU for a custom(subset) instruction set architecture (ISA) based on the ARMv7 instruction set. The pipeline architecture included buffers and caches to optimize the execution of multiple instructions simultaneously. In addition to basic arithmetic instructions, the ISA included more complex instructions such as MAC (multiply and accumulate), LDUR (load unsigned register), VADD, VSUB, and VMUL (vector operations). The project also considered issues such as pipeline hazards and data memory management. Potential future scopes for the project include further optimization of pipeline stages and buffers/caches, incorporation of additional instructions and support for various data types, and potential optimization for machine learning applications.

# Design

* The processor was pipelined, allowing multiple instructions to run simultaneously. Buffers/caches were added between each stage of the processor's operation to facilitate this. This optimization reduced the amount of time it took to run each instruction.

* We implemented an instruction memory consisting of 64 8-bit values for each index and a data memory consisting of 31 64-bit values to show that values could be accessed and stored via the CPU. The registers were initialized with values from 0-30, with register 31 defined and set to 0. The data memory was initialized with values starting from 0-3100, with each memory content being 100 more than the previous index, except index 12 and 13, which had contents 173 and 422, respectively.
