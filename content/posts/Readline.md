+++
title = "Readline"
date = 2023-06-19T17:23:00+08:00
tags = ["cmd-line"]
draft = true
+++

## Readline {#readline}

-   你喜欢的话，可以执行 set -o vi 来使用 vi 风格的快捷键，而执行 set -o emacs 可以把它改回来。
-   为了便于编辑长命令，在设置你的默认编辑器后（例如 export EDITOR=vim），ctrl-x ctrl-e 会打开一个编辑器来编辑当前输入的命令。在 vi 风格下快捷键则是 escape-v。
-   键入 history 查看命令行历史记录，再用 !n（n 是命令编号）就可以再次执行。其中有许多缩写，最有用的大概就是 !$， 它用于指代上次键入的参数，而 !! 可以指代上次键入的命令了（参考 man 页面中的“HISTORY EXPANSION”）。不过这些功能，你也可以通过快捷键 ctrl-r 和 alt-. 来实现。

<!--listend-->

```shell
man readline
```


### Commands for Manipulating the History {#commands-for-manipulating-the-history}

-   accept-line (Newline, Return)
-   previous-history (C-p)
-   next-history (C-n)
-   beginning-of-history (M-&lt;)
-   end-of-history (M-&gt;)
-   operate-and-get-next (C-o)
-   fetch-history
-   reverse-search-history (C-r)
-   forward-search-history (C-s)
-   non-incremental-reverse-search-history (M-p)
-   non-incremental-forward-search-history (M-n)
-   history-search-backward
-   history-search-forward
-   history-substring-search-backward
-   history-substring-search-forward
-   yank-nth-arg (M-C-y)
-   **yank-last-arg (M-., M-_)**


### Commands for Changing Text {#commands-for-changing-text}

-   end-of-file (usually C-d)
-   delete-char (C-d)
-   backward-delete-char (Rubout)
-   forward-backward-delete-char
-   quoted-insert (C-q, C-v)
-   tab-insert (M-TAB)
-   self-insert (a, b, A, 1, !, ...)
-   transpose-chars (C-t)
-   transpose-words (M-t)
-   upcase-word (M-u)
-   downcase-word (M-l)
-   capitalize-word (M-c)
-   overwrite-mode


### Killing and Yanking {#killing-and-yanking}

-   kill-line (C-k)
-   backward-kill-line (C-x Rubout)
-   unix-line-discard (C-u)
-   kill-whole-line
-   kill-word (M-d)
-   backward-kill-word (M-Rubout)
-   unix-word-rubout (C-w)
-   unix-filename-rubout
-   delete-horizontal-space (M-\\)
-   kill-region
-   copy-region-as-kill
-   copy-backward-word
-   copy-forward-word
-   yank (C-y)
-   yank-pop (M-y)


### Numeric Arguments {#numeric-arguments}

-   digit-argument (M-0, M-1, ..., M--)
-   universal-argument


### Completing {#completing}

-   complete (TAB)
-   possible-completions (M-?)
-   insert-completions (M-\*)
-   menu-complete
-   menu-complete-backward
-   delete-char-or-list


### Keyboard Macros {#keyboard-macros}

-   start-kbd-macro (C-x ()
-   end-kbd-macro (C-x ))
-   call-last-kbd-macro (C-x e)
-   print-last-kbd-macro ()


### Miscellaneous {#miscellaneous}

-   re-read-init-file (C-x C-r)
-   abort (C-g)
-   do-lowercase-version (M-A, M-B, M-x, ...)
-   prefix-meta (ESC)
-   undo (C-_, C-x C-u)
-   revert-line (M-r)
-   tilde-expand (M-&amp;)
-   set-mark (C-@, M-&lt;space&gt;)
-   exchange-point-and-mark (C-x C-x)
-   character-search (C-])
-   character-search-backward (M-C-])
-   skip-csi-sequence
-   insert-comment (M-#)
-   dump-functions
-   dump-variables
-   dump-macros
-   emacs-editing-mode (C-e)
-   vi-editing-mode (M-C-j)


### Emacs Mode {#emacs-mode}


#### Emacs Standard bindings {#emacs-standard-bindings}

-   "C-@"  set-mark
-   "C-A"  beginning-of-line
-   "C-B"  backward-char
-   "C-D"  delete-char
-   "C-E"  end-of-line
-   "C-F"  forward-char
-   "C-G"  abort
-   "C-H"  backward-delete-char
-   "C-I"  complete
-   "C-J"  accept-line
-   "C-K"  kill-line
-   "C-L"  clear-screen
-   "C-M"  accept-line
-   "C-N"  next-history
-   "C-P"  previous-history
-   "C-Q"  quoted-insert
-   "C-R"  reverse-search-history
-   "C-S"  forward-search-history
-   "C-T"  transpose-chars
-   "C-U"  unix-line-discard
-   "C-V"  quoted-insert
-   "C-W"  unix-word-rubout
-   "C-Y"  yank
-   "C-]"  character-search
-   "C-_"  undo
-   " " to "/"  self-insert
-   "0"  to "9"  self-insert
-   ":"  to "~"  self-insert
-   "C-?"  backward-delete-char


#### Emacs Meta bindings {#emacs-meta-bindings}

-   "M-C-G"  abort
-   "M-C-H"  backward-kill-word
-   "M-C-I"  tab-insert
-   "M-C-J"  vi-editing-mode
-   "M-C-L"  clear-display
-   "M-C-M"  vi-editing-mode
-   "M-C-R"  revert-line
-   "M-C-Y"  yank-nth-arg
-   "M-C-["  complete
-   "M-C-]"  character-search-backward
-   "M-space"  set-mark
-   "M-#"  insert-comment
-   "M-&amp;"  tilde-expand
-   "M-\*"  insert-completions
-   "M--"  digit-argument
-   "M-."  yank-last-arg
-   "M-0"  digit-argument
-   "M-1"  digit-argument
-   "M-2"  digit-argument
-   "M-3"  digit-argument
-   "M-4"  digit-argument
-   "M-5"  digit-argument
-   "M-6"  digit-argument
-   "M-7"  digit-argument
-   "M-8"  digit-argument
-   "M-9"  digit-argument
-   "M-&lt;"  beginning-of-history
-   "M-="  possible-completions
-   "M-&gt;"  end-of-history
-   "M-?"  possible-completions
-   "M-B"  backward-word
-   "M-C"  capitalize-word
-   "M-D"  kill-word
-   "M-F"  forward-word
-   "M-L"  downcase-word
-   "M-N"  non-incremental-forward-search-history
-   "M-P"  non-incremental-reverse-search-history
-   "M-R"  revert-line
-   "M-T"  transpose-words
-   "M-U"  upcase-word
-   "M-Y"  yank-pop
-   "M-\\"  delete-horizontal-space
-   "M-~"  tilde-expand
-   "M-C-?"  backward-kill-word
-   "M-_"  yank-last-arg


#### Emacs Control-X bindings {#emacs-control-x-bindings}

-   "C-XC-G"  abort
-   "C-XC-R"  re-read-init-file
-   "C-XC-U"  undo
-   "C-XC-X"  exchange-point-and-mark
-   "C-X("  start-kbd-macro
-   "C-X)"  end-kbd-macro
-   "C-XE"  call-last-kbd-macro
-   "C-XC-?"  backward-kill-line


### Vi Mode Binding {#vi-mode-binding}
