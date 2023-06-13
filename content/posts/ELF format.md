+++
title = "ELF format"
date = 2023-06-13T23:15:00+08:00
tags = ["CSAPP"]
draft = false
+++

{{< figure src="/ox-hugo/2023-06-12_15-50-59_screenshot.png" >}}

{{< figure src="/ox-hugo/2023-06-13_11-23-48_screenshot.png" >}}

To check relocatable object file, use [objdump]({{< relref "objdump.md" >}}).

The **ELF header** begins with a 16-byte sequence that describes the word size and byte ordering of the system that generated the file. The rest of the ELF header contains information that allows a linker to parse and interpret the object file. This includes the size of the ELF header, the object file type (e.g., relocatable, executable, or shared), the machine type (e.g., IA32) the file offset of the section header table, and the size and number of entries in the section header table.

The locations and sizes of the various sections are described by the **section header table**, which contains a fixed sized entry for each section in the object file.

-   .text: The machine code of the compiled program.
-   .rodata: Read-only data such as the format strings in printf statements,
    and jump tables for switch statements (see Problem 7.14).
-   .data: Initialized global C variables. Local C variables are maintained at run time on the stack,
    and do not appear in either the .data or .bss sections.
-   .bss: Uninitialized global C variables. See also: [bss vs COMMON]({{< relref "bss vs COMMON.md" >}})
    This section occupies no actual space in the object file; it is merely a place holder.
    Object file formats distinguish between initialized and uninitialized variables for space efficiency:
    uninitialized variables do not have to occupy any actual disk space in the object file.
-   .symtab: [symbols and symbol tables]({{< relref "symbols and symbol tables.md" >}})
    A symbol table with information about functions and global variables that are defined and referenced in the program.
    Some programmers mistakenly believe that a program must be compiled with the -g option to get symbol table information.
    In fact, every relocatable object file has a symbol table in .symtab.
    However, unlike the symbol table inside a compiler, the .symtab symbol table does not contain entries for local variables.
-   .rel.text: A list of locations in the .text section that will need to be modified when the linker combines this object file with others. In general, any instruction that calls an external function or references a global variable will need to be modified. On the other hand, instructions that call local functions do not need to be modified. Note that relocation information is not needed in executable object files, and is usually omitted unless the user explicitly instructs the linker to include it.
-   .rel.data: Relocation information for any global variables that are referenced or defined by the mod- ule. In general, any initialized global variable whose initial value is the address of a global variable or externally defined function will need to be modified.
-   .debug: A debugging symbol table with entries for local variables and typedefs defined in the program, global variables defined and referenced in the program, and the original C source file. It is only present if the compiler driver is invoked with the -g option.
-   .line: A mapping between line numbers in the original C source program and machine code instructions in the .text section. It is only present if the compiler driver is invoked with the -g option.
-   .strtab: A string table for the symbol tables in the .symtab and .debug sections, and for the section names in the section headers. A string table is a sequence of null-terminated character strings.

See: [Analyse tools]({{< relref "symbols and symbol tables#analyse-tools" >}}) for ELF analyse.
