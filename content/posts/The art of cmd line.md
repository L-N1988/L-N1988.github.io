+++
title = "The art of cmd line"
date = 2023-06-19T16:52:00+08:00
tags = ["cmd-line"]
draft = false
+++

## [Readline]({{< relref "Readline.md" >}}) {#readline--readline-dot-md}


## [xargs]({{< relref "xargs.md" >}}) {#xargs--xargs-dot-md}


## Miscellaneous {#miscellaneous}

-   使用 nohup 或 disown 使一个后台进程持续运行。
-   在 Bash 脚本中，使用 set -x 去调试输出（或者使用它的变体 set -v，它会记录原始输入，包括多余的参数和注释）。尽可能地使用严格模式：使用 set -e 令脚本在发生错误时退出而不是继续运行；使用 set -u 来检查是否使用了未赋值的变量；试试 set -o pipefail，它可以监测管道中的错误。当牵扯到很多脚本时，使用 trap 来检测 ERR 和 EXIT。一个好的习惯是在脚本文件开头这样写，这会使它能够检测一些错误，并在错误发生时中断程序并输出信息：
    ```shell
    set -euo pipefail
    trap "echo 'error: Script failed: see failed command above'" ERR
    ```
-   在 Bash 中，变量有许多的扩展方式。
    ```text
    ${name:?error message} 用于检查变量是否存在。

    此外，当 Bash 脚本只需要一个参数时，可以使用这样的代码 input_file=${1:?usage: $0 input_file}。

    在变量为空时使用默认值：${name:-default}。

    如果你要在之前的例子中再加一个（可选的）参数，可以使用类似这样的代码 output_file=${2:-logfile}，如果省略了 $2，它的值就为空，于是 output_file 就会被设为 logfile。

    数学表达式：i=$(( (i + 1) % 5 ))。序列：{1..10}。截断字符串：${var%suffix} 和 ${var#prefix}。例如，假设 var=foo.pdf，那么 echo ${var%.pdf}.txt 将输出 foo.txt。
    ```
-   编写脚本时，你可能会想要把代码都放在大括号里。缺少右括号的话，代码就会因为语法错误而无法执行。如果你的脚本是要放在网上分享供他人使用的，这样的写法就体现出它的好处了，因为这样可以防止下载不完全代码被执行。
    ```text
    {
          # 在这里写代码
    }
    ```
-   使用 jq 处理 JSON。
-   替换一个或多个文件中出现的字符串：

<!--listend-->

```shell
perl -pi.bak -e 's/old-string/new-string/g' my-files-*.txt
```

-   重命名文件

Given the files foo1, ..., foo9, foo10, ..., foo278, the commands

```shell
rename foo foo00 foo?
rename foo foo0 foo??
```

will turn them into foo001, ..., foo009, foo010, ..., foo278. And

```shell
rename .htm .html *.htm
```

will fix the extension of your html files. Provide an empty string for shortening:

```shell
rename '_with_long_name' '' file_with_long_name.*
```

will remove the substring in the filenames.

```shell
# 将文件、目录和内容全部重命名 foo -> bar:
repren --full --preserve-case --from foo --to bar .
# 还原所有备份文件 whatever.bak -> whatever:
repren --renames --from '(.*)\.bak' --to '\1' *.bak
# 用 rename 实现上述功能（若可用）:
rename 's/\.bak$//' *.bak
```

-   要处理 Excel 或 CSV 文件的话，csvkit 提供了 in2csv，csvcut，csvjoin，csvgrep 等方便易用的工具。
-   根据 man 页面的描述，rsync 是一个快速且非常灵活的文件复制工具。它闻名于设备之间的文件同步，但其实它在本地情况下也同样有用。在安全设置允许下，用 rsync 代替 scp 可以实现文件续传，而不用重新从头开始。它同时也是删除大量文件的最快方法之一：

<!--listend-->

```shell
mkdir empty && rsync -r --delete empty/ some-dir && rmdir some-dir
```

-   了解 sort 的参数。显示数字时，使用 -n 或者 -h 来显示更易读的数（例如 du -h 的输出）。明白排序时关键字的工作原理（-t 和 -k）。例如，注意到你需要 -k1，1 来仅按第一个域来排序，而 -k1 意味着按整行排序。稳定排序（sort -s）在某些情况下很有用。例如，以第二个域为主关键字，第一个域为次关键字进行排序，你可以使用 sort -k1，1 | sort -s -k2，2。
-   标准的源代码对比及合并工具是 diff 和 patch。使用 diffstat 查看变更总览数据。注意到 diff -r 对整个文件夹有效。使用 diff -r tree1 tree2 | diffstat 查看变更的统计数据。vimdiff 用于比对并编辑文件。
-   使用 zless、zmore、zcat 和 zgrep 对压缩过的文件进行操作。
-   文件属性可以通过 chattr 进行设置，它比文件权限更加底层。例如，为了保护文件不被意外删除，可以使用不可修改标记：sudo chattr +i /critical/directory/or/file
-   lshw，lscpu，lspci，lsusb 和 dmidecode：查看硬件信息，包括 CPU、BIOS、RAID、显卡、USB 设备等
-   lsmod 和 modinfo：列出内核模块，并显示其细节


## [二进制分析]({{< relref "二进制分析.md" >}}) {#二进制分析--二进制分析-dot-md}
