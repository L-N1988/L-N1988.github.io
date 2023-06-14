+++
title = "register file"
date = 2023-06-14T12:50:00+08:00
tags = ["register"]
draft = false
+++

## Definition {#definition}

register file:
A state element that consists of a set of registers that can be read and written by supplying a register number to be accessed.

A register file is a collection of registers in which any register can be read or written by specifying the number of the register in the file. The register file contains the register state of the computer.


## <span class="org-todo todo TODO">TODO</span> Implementation {#implementation}

A register file can be implemented with a decoder for each read or write port and an array of registers built from D flip-flops.

-   decoder:

A logic block that has an n -bit input and <img src="/ltximg/register file_c2cc16a26ba3599cc92443c0c13342eb087fa010.svg" alt="\(2^n\)" class="org-svg" /> outputs, where only one output is asserted for each input combination.

{{< figure src="/ox-hugo/2023-06-14_13-59-57_screenshot.png" >}}

-   flip-flop(触发器):

A memory element for which the output is equal to the value of the stored state inside the element and for which the internal state is changed only on a clock edge.

-   latch(锁存器):

A memory element in which the output is equal to the value of the stored state inside the element and the state is changed whenever the appropriate inputs change and the clock is asserted.

-   D flip-flop（[D latch]({{< relref "D latch.md" >}})）:

A flip-flop with one data input that stores the value of that input signal in the internal memory when the clock edge occurs.


### Read port {#read-port}

{{< figure src="/ox-hugo/2023-06-14_14-23-42_screenshot.png" >}}


### Write port {#write-port}

{{< figure src="/ox-hugo/2023-06-14_14-25-36_screenshot.png" >}}
