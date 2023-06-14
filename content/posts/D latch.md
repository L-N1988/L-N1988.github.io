+++
title = "D latch"
date = 2023-06-14T14:07:00+08:00
draft = false
+++

The inputs are the data value to be stored (called D ) and a clock signal (called C ) that indicates when the latch should read the value on the D input and store it. The outputs are simply the value of the internal state (Q ) and its complement (<img src="/ltximg/D latch_950c64a3ba8701dd1ff38de4f8c3865aaf952a31.svg" alt="\(\overline{Q}\)" class="org-svg" />). When the clock input C is asserted, the latch is said to be open, and the value of the output (Q ) becomes the value of the input D . When the clock input C is deasserted, the latch is said to be closed, and the value of the output (Q ) is whatever value was stored the last time the latch was open.

-   S = 1, R = 0: Set
-   S = 0, R = 0: Hold
-   S = 0, R = 1: Reset
-   S = 1, R = 1: Not allowed
