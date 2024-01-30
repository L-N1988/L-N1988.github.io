+++
title = "data hazard"
date = 2023-06-20T23:35:00+08:00
tags = ["pipeline", "CSAPP"]
draft = true
+++

{{< figure src="/ox-hugo/2023-06-22_12-36-20_screenshot.png" caption="<span class=\"figure-number\">Figure 1: </span>The datapath modified to resolve hazards via forwarding." >}}


## two pairs of hazard conditions {#two-pairs-of-hazard-conditions}

```text
1a. EX/MEM.RegisterRd =ID/EX.RegisterRs1
1b. EX/MEM.RegisterRd =ID/EX.RegisterRs2
2a. MEM/WB.RegisterRd =ID/EX.RegisterRs1
2b. MEM/WB.RegisterRd =ID/EX.RegisterRs2
```

The first part of the name, to the left of the period, is the name of the pipeline register; the second part is the name of the field in that register.


## What happens when a register is read and written in the same clock cycle? {#what-happens-when-a-register-is-read-and-written-in-the-same-clock-cycle}

{{< figure src="/ox-hugo/2023-06-21_19-54-41_screenshot.png" caption="<span class=\"figure-number\">Figure 2: </span>Pipelined dependences in a five- instruction sequence using simplified datapaths to show the dependences." >}}

We assume that the write is in the first half of the clock cycle and the read is in the second half, so the read delivers what is written.

that the values read for register x2 would not be the result of the sub instruction unless the read occurred during clock cycle 5 or later.

the desired result is available at the end of the EX stage of the sub instruction or clock cycle 3. When are the data actually needed by the and and or instructions? The answer is at the beginning of the EX stage of the and and or instructions, or clock cycles 4 and 5, respectively. Thus, we can execute this segment without stalls if we simply **forward** the data as soon as it is available to any units that need it before it is ready to read from the register file.


## forwarding: use pipeline registers {#forwarding-use-pipeline-registers}

![](/ox-hugo/2023-06-21_20-51-39_screenshot.png)
The change is that the dependence begins from a pipeline register, rather than waiting for the WB stage to write the register file. Thus, the required data exist in time for later instructions, with the [pipeline registers]({{< relref "data path#pipeline-registers" >}}) holding the data to be forwarded.

The values in the pipeline registers show that the desired value is available before it is written into the register file. We assume that the register file forwards values that are read and written during the same clock cycle, so the add does not stall, but the values come from the register file instead of a pipeline register. Register file “forwarding”—that is, the read gets the value of the write in that clock cycle—is why clock cycle 5 shows register x2 having the value 10 at the beginning and −20 at the end of the clock cycle.

{{< figure src="/ox-hugo/2023-06-21_21-02-26_screenshot.png" >}}

{{< figure src="/ox-hugo/2023-06-21_21-05-17_screenshot.png" caption="<span class=\"figure-number\">Figure 4: </span>The control values for the forwarding multiplexors" >}}

This forwarding control will be in the EX stage, because the ALU forwarding multiplexors are found in that stage.


### EX hazards {#ex-hazards}

同一时钟周期下，检查下述情况：

```text
// 前一条的指令将写入寄存器
if (EX/MEM.RegWrite
// 将写入的寄存器不是零寄存器
and (EX/MEM.RegisterRd ≠ 0)
// 将写入的寄存器与将在ALU中计算的寄存器相同
// ForwardA = 10: 第一个ALU操作数来源于之前一条指令的ALU结果
and (EX/MEM.RegisterRd = ID/EX.RegisterRs1)) ForwardA = 10

if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd ≠ 0)
and (EX/MEM.RegisterRd = ID/EX.RegisterRs2)) ForwardB = 10
```

This case forwards the result from the previous instruction to either input of the ALU. If the previous instruction is going to write to the register file, and the write register number matches the read register number of ALU inputs A or B, provided it is not register 0, then steer the multiplexor to pick the value instead from the pipeline register EX/MEM.


### MEM hazards {#mem-hazards}

```text
if (MEM/WB.RegWrite
//  Not forwarding results destined for x0
and (MEM/WB.RegisterRd ≠ 0)
and (MEM/WB.RegisterRd = ID/EX.RegisterRs1)) ForwardA = 01
if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd ≠ 0)
and (MEM/WB.RegisterRd = ID/EX.RegisterRs2)) ForwardB = 01
```

As mentioned above, there is no hazard in the WB stage, because we assume that the register file supplies the correct result if the instruction in the ID stage reads the same register written by the instruction in the WB stage. Such a register file performs another form of forwarding, but it occurs within the register file.


## Stall {#stall}

{{< figure src="/ox-hugo/2023-06-22_13-46-24_screenshot.png" >}}

one case where forwarding cannot save the day is when an instruction tries to read a register following a load instruction that writes the same register

Hence, in addition to a **forwarding unit**, we need a **hazard detection unit**. It operates during the ID stage so that it can insert the stall between the load and the instruction dependent on it.

```text
if (ID/EX.MemRead and
 ((ID/EX.RegisterRd = IF/ID.RegisterRs1) or
 (ID/EX.RegisterRd = IF/ID.RegisterRs2)))
 stall the pipeline
```
<div class="src-block-caption">
  <span class="src-block-number">Code Snippet 1:</span>
  load-use hazard test
</div>

-   The first line tests to see if the instruction is a load: the only instruction that reads data memory is a load.
-   The next two lines check to see if the destination register field of the load in the EX stage matches either source register of the instruction in the ID stage. If the condition holds, the instruction stalls one clock cycle. After this one-cycle stall, the **forwarding logic** can handle the dependence and execution proceeds.

If the instruction in the ID stage is stalled, then the instruction in the IF stage must also be stalled; otherwise, we would lose the fetched instruction. Preventing these two instructions from making progress is accomplished simply by preventing the PC register and the IF/ID pipeline register from changing. Provided these registers are preserved, the instruction in the IF stage will continue to be read using the same PC, and the registers in the ID stage will continue to be read using the same instruction fields in the IF/ID pipeline register. Returning to our favorite analogy, it’s as if you restart the washer with the same clothes and let the dryer continue tumbling empty. Of course, like the dryer, the back half of the pipeline starting with the EX stage must be doing something; what it is doing is executing instructions that have no effect: nops.

How can we insert these nops, which act like bubbles, into the pipeline? In Figure 4.47, we see that deasserting all seven control signals (setting them to 0) in the EX, MEM, and WB stages will create a “do nothing” or nop instruction. By identifying the hazard in the ID stage, we can insert a bubble into the pipeline by changing the EX, MEM, and WB control fields of the ID/EX pipeline register to 0. These benign control values are percolated forward at each clock cycle with the proper effect: no registers or memories are written if the control values are all 0.

{{< figure src="/ox-hugo/2023-06-22_14-07-44_screenshot.png" caption="<span class=\"figure-number\">Figure 5: </span>The way stalls are really inserted into the pipeline." >}}

A bubble is inserted beginning in clock cycle 4, by changing the and instruction to a nop. Note that the and instruction is really fetched and decoded in clock cycles 2 and 3, but its EX stage is delayed until clock cycle 5 (versus the unstalled position in clock cycle 4). Likewise, the or instruction is fetched in clock cycle 3, but its ID stage is delayed until clock cycle 5 (versus the unstalled clock cycle 4 position). After insertion of the bubble, all the dependences go forward in time and no further hazards occur.


### hazard detection unit {#hazard-detection-unit}

The hazard detection unit controls the writing of the PC and IF/ID registers plus the multiplexor that chooses between the real control values and all 0s. The hazard detection unit stalls and deasserts the control fields if the load-use hazard test above is true.

{{< figure src="/ox-hugo/2023-06-22_14-20-37_screenshot.png" caption="<span class=\"figure-number\">Figure 6: </span>Pipelined control overview, showing the two multiplexors for forwarding, the hazard detection unit, and the forwarding unit." >}}

> There are a thousand hacking at the branches of evil to one who is striking at the root.
