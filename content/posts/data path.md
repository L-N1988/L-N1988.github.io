+++
title = "datapath"
date = 2023-06-21T00:29:00+08:00
tags = ["pipeline", "CSAPP"]
draft = false
+++

## single-cycle datapath {#single-cycle-datapath}

[processor::datapath]({{< relref "processor#datapath" >}})

{{< figure src="/ox-hugo/2023-06-21_00-29-52_screenshot.png" >}}

{{< figure src="/ox-hugo/2023-06-21_00-38-15_screenshot.png" caption="<span class=\"figure-number\">Figure 1: </span>Instructions being executed using the single-cycle datapath" >}}


## ⭐pipeline registers {#pipeline-registers}

{{< figure src="/ox-hugo/2023-06-21_00-48-49_screenshot.png" >}}

The registers must be wide enough to store all the data corresponding to the lines that go through them. For example, the IF/ID register must be 96 bits wide, because it must hold both the 32-bit instruction fetched from memory and the incremented 64-bit PC address.

Notice that there is no pipeline register at the end of the write-back stage.

The PC is part of the visible architectural state; its contents must be saved when an exception occurs, while the contents of the pipeline registers can be discarded.

As was the case for the single-cycle implementation, we assume that the PC is written on each clock cycle, so there is no separate write signal for the PC. By the same argument, there are no separate write signals for the pipeline registers (IF/ID, ID/EX, EX/MEM, and MEM/WB), since the pipeline registers are also written during each clock cycle.


## 7 control lines {#7-control-lines}

{{< figure src="/ox-hugo/2023-06-21_17-02-51_screenshot.png" >}}

{{< figure src="/ox-hugo/2023-06-21_17-13-22_screenshot.png" >}}

{{< figure src="/ox-hugo/2023-06-21_19-37-01_screenshot.png" >}}

![](/ox-hugo/2023-06-21_19-40-11_screenshot.png)
The simplest way to pass these control signals is to extend the pipeline registers to include control information.


## Overview {#overview}

{{< figure src="/ox-hugo/2023-06-21_19-45-19_screenshot.png" caption="<span class=\"figure-number\">Figure 3: </span>The pipelined datapath of with the control signals connected to the control portions of the pipeline registers." >}}

The control values for the last three stages are created during the instruction decode stage and then placed in the ID/EX pipeline register. The control lines for each pipe stage are used, and remaining control lines are then passed to the next pipeline stage.
