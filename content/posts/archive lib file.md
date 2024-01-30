+++
title = "archive lib file"
date = 2023-06-13T23:15:00+08:00
draft = true
+++

## View archive lib file {#view-archive-lib-file}

Run the following command to list the contents of the archive:

```shell
ar tv <filename>.a
```

This will print a list of all the files contained in the archive along with their metadata (e.g., size, modification time).

```text
rw-r--r-- 0/0   1992 Jan  1 08:00 1970 init-first.o
rw-r--r-- 0/0  22592 Jan  1 08:00 1970 libc-start.o
rw-r--r-- 0/0    656 Jan  1 08:00 1970 sysdep.o
rw-r--r-- 0/0   2680 Jan  1 08:00 1970 version.o
......
```

To inspect the contents of a specific file within the archive, run the following command:

```shell
ar xv <filename>.a <file_within_archive>
```

This will extract the specified file from the archive and place it in the current directory.
You can then open the file using a text editor or other appropriate tool for inspection.


## Create archive lib file {#create-archive-lib-file}

```shell
unix> gcc -c addvec.c multvec.c
unix> ar rcs libvector.a addvec.o multvec.o
```

use archive lib file:

```shell
unix> gcc -O2 -c main2.c
unix> gcc -static -o p2 main2.o ./libvector.a
```

At link time, the linker will only copy the object modules that are referenced by the program, which reduces
the size of the executable on disk and in memory.
