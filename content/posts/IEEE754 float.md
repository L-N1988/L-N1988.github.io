+++
title = "IEEE754 float"
date = 2023-06-13T23:15:00+08:00
draft = false
+++

{{< figure src="/ox-hugo/2023-06-13_12-06-28_Float_example.svg" >}}

tool:

-   [IEEE-754 Floating Point Converter](https://www.h-schmidt.net/FloatConverter/IEEE754.html)
-   gdb: see [gdb print format](https://ftp.gnu.org/old-gnu/Manuals/gdb/html_node/gdb_54.html).
    ```text
    p/t (float)decimal number
    ==> binary IEEE754 format(32 bits)
    p/tx (float)decimal number
    ==> hex IEEE754 format(32 bits)
    p 0b0100111 or 0B0100111
    ==> binary to deciaml
    ```

-   course: [IEEE 754](https://bob.cs.sonoma.edu/IntroCompOrg-RPi/sec-ieee.html)

{{< figure src="/ox-hugo/2023-06-13_14-16-33_image-129.svg" caption="<span class=\"figure-number\">Figure 1: </span>(Figure 16.5.1.) IEEE 754 bit patterns. (a) float (b) double" >}}

<img src="/ltximg/IEEE754 float_3899792af295078e654a4e4b6b2f6f432dfb1a72.svg" alt="$N=(-1)^s\times 1.f\times 2^e$" class="org-svg" />

<img src="/ltximg/IEEE754 float_6b2a59a43e693029dd1966ec5eafaad32465b911.svg" alt="$bias = 2^{w-1}-1$" class="org-svg" />

where: s is the sign bit, f is the 23-bit fractional part of the significand, and e is the 8-bit exponent.

store a biased exponent as an unsigned int. The amount of the bias is one-half the range allocated for the exponent. In the case of an 8-bit exponent, the bias amount is 127.


## special cases (denormarlize) {#special-cases--denormarlize}

| E     | M        | Meaning                      |
|-------|----------|------------------------------|
| 1-254 | anything | normalized number            |
| 0     | anything | denormalized number (denorm) |
| 255   | zero     | infinity (∞)                 |
| 255   | nonzero  | not-a-number (NaN)           |

{{< figure src="/ox-hugo/2023-06-13_15-01-09_screenshot.png" >}}

{{< figure src="/ox-hugo/2023-06-13_14-57-53_screenshot.png" >}}


## Examples {#examples}

{{< figure src="/ox-hugo/2023-06-13_14-36-26_screenshot.png" >}}

{{< figure src="/ox-hugo/2023-06-13_15-04-16_screenshot.png" >}}
