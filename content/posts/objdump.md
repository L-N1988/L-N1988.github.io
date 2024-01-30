+++
title = "objdump"
date = 2023-06-13T23:15:00+08:00
draft = true
+++

-   objdump -h &lt;objectfile&gt; to display the section headers of the object file.
    This will show you the names, sizes, and memory addresses of each section in the file.
-   objdump -s &lt;sectionname&gt; &lt;objectfile&gt; to display the contents of a specific section in the object file.
-   objdump -r &lt;objectfile&gt; to display the relocation information for the object file.
    This will show you the names, memory addresses, and types of each relocation entry in the file.
-   -t option: symbol table entry.
-   -d option with objdump to disassemble the contents of the object file and view the machine instructions.
