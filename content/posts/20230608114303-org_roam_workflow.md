+++
title = "org-roam workflow"
tags = ["note-taking"]
draft = false
+++

source:

1.  <https://jethrokuan.github.io/org-roam-guide/>
2.  <https://www.orgroam.com/manual.html#Getting-Started>
3.  <https://www.orgroam.com/>
4.  <https://develop.spacemacs.org/layers/%2Bemacs/org/README.html#org-roam-support>
5.  <http://lgmoneda.github.io/2023/04/08/semantic-search-for-org-roam.html>
6.  <https://www.karsdorp.io/posts/dotemacs/>


## Features: {#features}


### A [pomodoro method](https://cirillocompany.de/pages/pomodoro-technique) integration via [org-pomodoro](https://github.com/lolownia/org-pomodoro) {#a-pomodoro-method-integration-via-org-pomodoro}


### Presentation mode via [org-present](https://github.com/rlister/org-present) {#presentation-mode-via-org-present}

-   left/right for movement
-   C-c C-= for large txt
-   C-c C-- for small text
-   C-c C-q for quit (which will return you back to vanilla org-mode)
-   C-c &lt; and C-c &gt; to jump to first/last slide
-   C-c C-r for buffer read-only
-   C-c C-w for buffer read/write
-   C-c C-1 for one big page showing all slides


### Insertion of images via [org-download](https://github.com/abo-abo/org-download) {#insertion-of-images-via-org-download}

-   org-download-clipboard: org-download-image + Url in clipboard
-   org-download-screenshot: Capture screenshot and insert the resulting file.
    Note: I use self-written [screen shot script](~/.scripts/showNclip.sh), which pipes shot image to xclip.
    Therefore, I should config screenshot tool in ‘org-download-screenshot-method’ to 'xclip'.


### Project-specific TODOs via [org-projectile](https://github.com/IvanMalison/org-projectile) {#project-specific-todos-via-org-projectile}


### Easy insert of URLs from clipboard with org format via [org-cliplink](https://github.com/rexim/org-cliplink) {#easy-insert-of-urls-from-clipboard-with-org-format-via-org-cliplink}

-   generate org-mode format url reference
-   before org-clip can fetch website name from url, I must set proxy for emacs.
    [Emacs behind HTTP proxy - Stack Overflow](https://stackoverflow.com/questions/1595418/emacs-behind-http-proxy)
    ```emacs
    (setq url-proxy-services '(("no_proxy" . "work\\.com")
                              ("http" . "proxy.work.com:911")))
    ```


### Rich insert of code (into a source block with highlighting, and a link) from other buffers via [org-rich-yank](https://github.com/unhammer/org-rich-yank) {#rich-insert-of-code--into-a-source-block-with-highlighting-and-a-link--from-other-buffers-via-org-rich-yank}

-   nothing special


### Pixel-perfect visual alignment for Org and Markdown tables via [valign](https://github.com/casouri/valign) {#pixel-perfect-visual-alignment-for-org-and-markdown-tables-via-valign}

| 我靠  | this package is so awesome. |
|-----|-----------------------------|
| can't | wait to try this.           |


### Text transclusion via [org-transclusion](https://nobiot.github.io/org-transclusion) {#text-transclusion-via-org-transclusion}


## Creating and Linking Nodes {#creating-and-linking-nodes}

-   org-roam-node-insert: creates a node if it does not exist, and inserts a link to the node at point.
-   org-roam-node-find: creates a node if it does not exist, and visits the node.
-   org-roam-capture: creates a node if it does not exist, and **restores** the current window configuration upon completion.


## Config org-roam-capture template {#config-org-roam-capture-template}

1.  <https://systemcrafters.net/build-a-second-brain-in-emacs/capturing-notes-efficiently/>
2.  <https://www.orgroam.com/manual.html#Template-Walkthrough>
3.  [org-roam-capture-templates](~/.spacemacs)


## Issuses {#issuses}


### org-roam-node-find always create new node &amp;&amp; org-roam-graph always show no node {#org-roam-node-find-always-create-new-node-and-and-org-roam-graph-always-show-no-node}

```org
Is it because you haven't run org-roam-db-sync since the capture?
```

[org-roam-node-find starts capture instead #15936](https://github.com/syl20bnr/spacemacs/issues/15936)
