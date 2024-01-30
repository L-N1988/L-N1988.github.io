+++
title = "symbols and symbol tables"
date = 2023-06-13T23:15:00+08:00
tags = ["symbol-table", "CSAPP"]
draft = true
+++

Refs:

-   [https://www.youtube.com/watch?v=Dd3DWRpqI40](https://www.youtube.com/watch?v=Dd3DWRpqI40)
-   <http://www.linker-aliens.org/blogs/ali/entry/inside_elf_symbol_tables/>

In the context of a linker, there are three different kinds of symbols:

-   Global symbols that are defined by module m and that can be referenced by other modules. Global

linker symbols correspond to <span class="underline">nonstatic C functions</span> and global variables that are defined <span class="underline">without the</span>
<span class="underline">C static attribute</span>.

-   Global symbols that are referenced by module m but defined by some other module. Such symbols

are called <span class="underline">externals</span> and correspond to C functions and variables that are defined in <span class="underline">other</span> modules.

-   Local symbols that are defined and referenced exclusively by module m. Some local linker symbols

correspond to C functions and global variables that are defined with the <span class="underline">static</span> attribute. These
symbols are <span class="underline">visible anywhere within module m, but cannot be referenced by other modules</span>. The
sections in an object file and the name of the source file that corresponds to module m also get local
symbols.


## ELF symbol table entry {#elf-symbol-table-entry}

use [objdump]({{< relref "objdump.md" >}}) -t option to display the symbol table entries for the file.

{{< figure src="/ox-hugo/2023-06-12_17-22-56_screenshot.png" >}}

| Num: | Value | Size | Type   | Bind   | Ot | Ndx | Name |
|------|-------|------|--------|--------|----|-----|------|
| 8:   | 0     | 8    | OBJECT | GLOBAL | 0  | 3   | buf  |
| 9:   | 0     | 17   | FUNC   | GLOBAL | 0  | 1   | main |
| 10:  | 0     | 0    | NOTYPE | GLOBAL | 0  | UND | swap |

Ndx = 1: .text section, Ndx = 3: .data section.


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
