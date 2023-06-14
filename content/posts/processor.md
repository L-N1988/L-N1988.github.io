+++
title = "processor"
date = 2023-06-14T12:46:00+08:00
draft = false
+++

Sources:

-   [CDA 3101 Computer Organization II](https://www.cs.fsu.edu/~zwang/cda3101.html)


## registers {#registers}

The processor’s 32 general-purpose registers are stored in a <span class="underline">structure</span> called a [register file]({{< relref "register file.md" >}}).


## datapath {#datapath}

Refs:

-   <http://www.cs.fsu.edu/~zwang/files/cda3101/Fall2017/Lecture5_cda3101.pdf>

{{< figure src="/ox-hugo/2023-06-14_16-40-13_screenshot.png" caption="<span class=\"figure-number\">Figure 1: </span>The datapath with all necessary multiplexors and all control lines identified." >}}


### Control unit {#control-unit}

see:[Patterson, D.A. &amp; Hennessy, J.L. Computer Organization and Design(RISCV edition)](//select/items/1_63JADW9C) Appendix C.2

{{< figure src="/ox-hugo/2023-06-14_23-02-25_screenshot.png" caption="<span class=\"figure-number\">Figure 2: </span>The simple datapath with the control unit." >}}

control unit truth table: 7-bit opcode to

-   two 1-bit signals that are used to control multiplexors (ALUSrc and MemtoReg),
-   three signals for controlling reads and writes in the register file and data memory (RegWrite, MemRead, and MemWrite),
-   a 1-bit signal used in determining whether to possibly branch (Branch),
-   a 2-bit control signal for the ALU (ALUOp).

Notice that PCSrc(controls the selection of the next PC) is now a derived signal, rather than one coming directly from the control unit.

{{< figure src="/ox-hugo/2023-06-14_23-10-46_screenshot.png" caption="<span class=\"figure-number\">Figure 3: </span>The setting of the control lines is completely determined by the opcode fields of the instruction." >}}

| Instruction | opcode  |
|-------------|---------|
| R-format    | 0110011 |
| ld          | pseudo  |
| sd          | pseudo  |
| beq         | 1100011 |
