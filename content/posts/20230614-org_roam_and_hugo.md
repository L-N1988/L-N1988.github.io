+++
title = "org-roam and hugo"
date = 2023-06-14T00:52:00+08:00
draft = false
+++

## export latex snippet in svg {#export-latex-snippet-in-svg}

```org-mode
#+options: tex:dvisvgm
... text ...
\[ a + b \]
... text ...
```

Note:
default output markdown use &lt;img&gt; tag to show math equation svg, something like:

```text
<img src="/ltximg/IEEE754 float_6b2a59a43e693029dd1966ec5eafaad32465b911.svg" alt="$bias = 2^{w-1}-1$" class="org-svg" />
```

but hugo markdown parser does not support &lt;img&gt; tag, see [&lt;img&gt; tag does not work - support - HUGO](https://discourse.gohugo.io/t/img-tag-does-not-work/40918).

so, change config.toml (indentation matters):

```toml
[markup.goldmark.renderer]
unsafe = true
```


## config search button {#config-search-button}

create search.md in content folder.

add following to config.toml

```toml
[[languages.en.menu.main]]
name = "search"
url = "search/"
weight = 10
```

Refs:

-   [Features | PaperMod: Search Page](https://adityatelange.github.io/hugo-PaperMod/posts/papermod/papermod-features/#search-page)
-   [hugo-PaperMod/config.yml](https://github.com/adityatelange/hugo-PaperMod/blob/exampleSite/config.yml)
