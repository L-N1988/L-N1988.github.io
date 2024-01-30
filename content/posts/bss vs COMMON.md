+++
title = "bss vs COMMON"
date = 2023-06-13T23:15:00+08:00
draft = true
+++

<https://stackoverflow.com/questions/16835716/bss-vs-common-what-goes-where>

-   COMMON is for uninitialized data objects that are not yet allocated.
-   .bss: Uninitialized global C variables. Uninitialized variables do not have to occupy any actual disk space in the object file.

<!--listend-->

```C
// file a.c
// file-scope

int a = 0;  // goes into BSS
```

after compilation of a.c into object file a.o, a symbol goes into BSS section.

```C
// file b.c
// file-scope

int b;  // goes into COMMON section
```

after compilation of b.c into object file b.o, b symbol goes into COMMON section.

After linking of a.o and b.o, both a and b symbols goes into BSS section. Common symbols only exist in object files, not in executable files. The idea of COMMON symbols in Unix is to allow multiple external definitions of a same variable (in different compilation units) under a single common symbol under certain conditions.
