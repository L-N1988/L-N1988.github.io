+++
title = "object files"
date = 2023-06-13T23:15:00+08:00
tags = ["CSAPP"]
draft = true
+++

Object files come in three forms:

-   Relocatable object file. Contains **binary** code and data in a form that can be combined with other relocatable object files at **compile time** to create an executable object file.
-   Executable object file. Contains **binary** code and data in a form that can be **copied directly** into memory and executed.
-   Shared object file. A special type of **relocatable object file** that can be loaded into memory and linked dynamically, **at either load time or run time**.

Object file formats vary from system to system.

-   The first Unix systems from Bell Labs used the a.out format.
-   Early versions of System V Unix used the Common Object File format (COFF).
-   Windows NT uses a variant of COFF called the Portable Executable (PE) format.
-   Modern Unix systems — such as Linux, later versions of System V Unix, BSD Unix variants,
    and Sun Solaris — use the Unix Executable and Linkable Format (ELF)[ELF format]({{< relref "ELF format.md" >}}).
