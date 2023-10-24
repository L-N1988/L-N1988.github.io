---
title: "Vim Plugin"
date: 2023-10-24T22:12:06+08:00
draft: true
---

- Source: [create a full plugin](https://learnvimscriptthehardway.stevelosh.com/chapters/41.html)
- Source: [writing vim plugin](https://vimways.org/2019/writing-vim-plugin/)
- :help write-plugin

# file structure
See [leanr vim script the hard way ch42](https://learnvimscriptthehardway.stevelosh.com/chapters/42.html).

load ordr: ~/.vim/ftdetect/ => ~/.vim/ftplugin/ => ... => ~/.vim/after/

Files in this `~/.vim/after/` will be loaded every time Vim starts, but after the files in ~/.vim/plugin/.

delay load: ~/.vim/autoload/. More info see [here](https://learnvimscriptthehardway.stevelosh.com/chapters/53.html).

## filetype file

- **~/.vim/ftdetect**: see [vim-mma](https://github.com/voldikss/vim-mma/blob/master/ftdetect/mma.vim).
- :help new-filetype
```viml
autocmd BufNewFile,BufRead *.wl  setfiletype mma
```

Notice that we didn't use an **autocommand group** like we usually would. Vim automatically wraps the contents of ftdetect/\*.vim files in autocommand groups for you, so you don't need to worry about it.

"au" stands for "autocmd", which is a way of defining commands that will be executed automatically in certain situations. In this case, the command is triggered when a new file is created or read.

"BufNewFile" and "BufRead" are events that trigger the command. "BufNewFile" is triggered when a new buffer (file) is created, while "BufRead" is triggered when a buffer is read from disk.

### diffs in setfiletype and set filetype

```viml
au BufRead,BufNewFile *.mine		set filetype=mine
au BufRead,BufNewFile *.txt		setfiletype text
```
`setfiletype` works like `set filetype` above, but instead of setting 'filetype' unconditionally use ":setfiletype".  This will only set 'filetype' if no file type was detected yet. 

You can also use the already detected file type in your command.  For example, to use the file type "mypascal" when "pascal" has been detected: > 

```viml
au BufRead,BufNewFile *		if &ft == 'pascal' | set ft=mypascal | endif
```

Your filetype.vim will be sourced before the default FileType autocommands have been installed.  Your autocommands will match first, and the ":setfiletype" command will make sure that no other autocommands will set `filetype` after this.

## syntax highlight file

A [boilerplate](https://learnvimscriptthehardway.stevelosh.com/chapters/45.html).

- head and tail part:
```viml
if exists("b:current_syntax")
    finish
endif

echom "Our syntax highlighting code will go here."

let b:current_syntax = "potion"
```
- syntax part:
```viml
syntax keyword potionKeyword loop times to while
syntax keyword potionFunction print join string

highlight link potionKeyword Keyword
highlight link potionFunction Function
```
> Skim over :help syn-keyword. Pay close attention to the part that mentions iskeyword. 
>
> Read :help iskeyword. 
>
> Read :help group-name to get an idea of some common highlighting groups that color scheme authors frequently use.

# debug vim plugin

What if it looks like your plugin is not being loaded?  You can find out what
happens when Vim starts up by using the |-V| argument: >

    vim -V2

You will see a lot of messages, in between them is a remark about loading the
plugins.  It starts with:

	Searching for "plugin/**/*.vim" in ~

There you can see where Vim looks for your plugin scripts.

```shell
vim -V[N] file
```
**-V[N] Verbose.** Give messages about which files are sourced and for reading and writing a viminfo file. The optional number N is the value for 'verbose'.  Default is 10.

See also: 
- :help runtimepath
