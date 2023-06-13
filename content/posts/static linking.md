+++
title = "static linking"
date = 2023-06-13T23:15:00+08:00
tags = ["linker", "CSAPP"]
draft = false
+++

[Anon ELF object file format](//select/items/1_HB8FFAHN)


## static linking {#static-linking}

static linking is the type of linking which is performed before execution, in static linking the linker takes a bunch of relocatable object file and args and generate fully object file which can be run. See also: [dynamic linking]({{< relref "dynamic linking.md" >}}).

See [resovle symbols]({{< relref "resovle symbols.md" >}}) for linking rules.

![](/ox-hugo/2023-06-12_15-34-05_screenshot.png)
Figure 7.2: Static linking. The linker combines relocatable object files to form an executable object file p.

```shell
unix> gcc -O2 -g -o p main.c swap.c
```

等价与：

```shell
cpp [other arguments] main.c /tmp/main.i
cc1 /tmp/main.i main.c -O2 [other arguments] -o /tmp/main.s
as [other arguments] -o /tmp/main.o /tmp/main.s
ld -o p [system object files and args] /tmp/main.o /tmp/swap.o
```

```fundamental
High Level Language
    |
 (Pre-Processor)
    |
    | Pure HLL
    |
 (Compiler)
    |
    | Assembly Language
    |
 (Assembler)
    |
    | Relocatable Machine Code
    |
  (Loader/Linker)
    |
 (Absolute Machine Code)
```


## linker tasks {#linker-tasks}

To build the executable, the linker must perform two main tasks:

-   [symbols and symbol tables]({{< relref "symbols and symbol tables.md" >}}) resolution. [object files]({{< relref "object files.md" >}}) define and reference symbols. The purpose of symbol resolution is to associate each symbol reference with exactly one symbol definition.
-   Relocation. Compilers and assemblers generate code and data sections that start at address 0. The linker relocates these sections by associating a memory location with each symbol definition, and then modifying all of the references to those symbols so that they point to this memory location.


## Analyse tools {#analyse-tools}

[A brief info on Linker, Loader, Symbol &amp; Symbol Tables | by RIXED LABS | RIXE...](https://medium.com/ax1al/a-brief-info-on-linker-loader-symbol-symbol-tables-2fed729eb490)

-   [objdump]({{< relref "objdump.md" >}}): display information from object files
-   file: determine file type
-   nm: list symbols from object files
-   strip: discard symbols and other data from object files
-   readelf: display information about ELF files

see [Bryant, R.E. &amp; O’Hallaron, D.R. (2016) (CSAPP) Computer systems: a programmer’s perspective](//select/items/1_W553JXNY) section 7.14.
the <span class="underline">GNU binutils package</span>:

-   ar. Creates static libraries, and inserts, deletes, lists, and extracts members.
-   strings. Lists all of the printable strings contained in an object file.
-   strip. Deletes symbol table information from an object file.
-   nm. Lists the symbols defined in the symbol table of an object file.
-   size. Lists the names and sizes of the sections in an object file.
-   readelf. Displays the complete structure of an object file, including all of the information encoded in the ELF header. Subsumes the functionality of size and nm.
-   objdump. The mother of all binary tools. Can display all of the information in an object file. Its most useful function is disassembling the binary instructions in the .text section.
-   ldd: Lists the shared libraries that an executable needs at run time.

See also: [loader]({{< relref "loader.md" >}})
