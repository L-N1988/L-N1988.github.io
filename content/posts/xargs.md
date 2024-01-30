+++
title = "xargs"
date = 2023-06-19T17:26:00+08:00
draft = true
+++

使用 xargs （ 或 parallel）。他们非常给力。注意到你可以控制每行参数个数（-L）和最大并行数（-P）。如果你不确定它们是否会按你想的那样工作，先使用 xargs echo 查看一下。此外，使用 -I{} 会很方便。例如：

```shell
find . -name '*.py' | xargs grep some_function
cat hosts | xargs -I{} ssh root@{} hostname
```
