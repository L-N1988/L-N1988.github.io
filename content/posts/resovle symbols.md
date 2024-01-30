+++
title = "resovle symbols"
date = 2023-06-13T23:15:00+08:00
draft = true
+++

Functions and initialized global variables get strong symbols.

Uninitialized global variables get weak symbols.

-   Rule 1: Multiple strong symbols are not allowed.
-   Rule 2: Given a strong symbol and multiple weak symbols, choose the strong symbol.
-   Rule 3: Given multiple weak symbols, choose any of the weak symbols.

{{< figure src="/ox-hugo/2023-06-13_11-59-16_screenshot.png" >}}

On an IA32/Linux machine, doubles are 8 bytes and ints are 4 bytes. Thus, the assignment x = -0.0 in line 6 of bar5.c will overwrite the memory locations for x and y (lines 5 and 6 in foo5.c) with the double-precision floating-point representation of negative zero!

```shell
linux> gcc -o foobar5 foo5.c bar5.c
linux> ./foobar5
x = 0x0 y = 0x80000000
```

according to [IEEE754 float]({{< relref "IEEE754 float.md" >}}), -0.0=0x80000000 00000000 in double, and IA32 is little endian.


## linker bug detective {#linker-bug-detective}

When in doubt, invoke the linker with a flag such as the GCC <span class="underline">-fno-common</span> flag, which triggers an error if it encounters multiply-defined global symbols.


## linker static libs {#linker-static-libs}

In practice, all compilation systems provide a mechanism for packaging related object modules into a single file called a static library (see [archive lib file]({{< relref "archive lib file.md" >}})), which can then be supplied as input to the linker. When it builds the output executable, the linker copies only the object modules in the library that are referenced by the application program.

On Unix systems, static libraries are stored on disk in a particular file format known as an [archive lib file]({{< relref "archive lib file.md" >}}).

An archive is a collection of concatenated relocatable object files, with a header that describes the size and location of each member object file.
