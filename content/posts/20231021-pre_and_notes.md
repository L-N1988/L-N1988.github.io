+++
title = "Pre and Notes"
date = 2023-10-21T00:20:00+08:00
draft = true
+++

## 谱分析 {#谱分析}

See slide: [谱分析](/ox-hugo/SpectrumAnalysis.pdf).

对于随机实信号 <embed img src="/ltximg/20231021-pre_and_notes_4eee744bfd0712d2c272148512da7526dc6ada0c.svg" alt="$f(t)$" class="org-svg" /> ：

-   平均功率 <embed img src="/ltximg/20231021-pre_and_notes_f6f3e07438b5a02465b461cda546a7b874f628af.svg" alt="$\displaystyle\overline{f^2}(t)=\lim_{T \to \infty} \frac{1}{2T}\int_{-T}^{T} |f(t)|^2dt$" class="org-svg" /> 与功率谱密度 <embed img src="/ltximg/20231021-pre_and_notes_01234ef47d2591719cb8284aab9969128985e092.svg" alt="$S(\omega)$" class="org-svg" /> 的关系

    <embed img src="/ltximg/20231021-pre_and_notes_a96ecd1aafaa0c15471d9643d66288b8baf61320.svg" alt="\begin{align*}
    	\overline{f^2}(t) = \frac{1}{2\pi}\int_{-\infty}^{\infty} S(\omega) d\omega
    .\end{align*}
    " class="org-svg" />
    </span>
    </div>
-   功率谱密度 <embed img src="/ltximg/20231021-pre_and_notes_01234ef47d2591719cb8284aab9969128985e092.svg" alt="$S(\omega)$" class="org-svg" /> 与相关函数<embed img src="/ltximg/20231021-pre_and_notes_f74b58866526b4f00fe9c7f2f62d0cec895ed95c.svg" alt="$R(t)$" class="org-svg" /> 的关系:

    <embed img src="/ltximg/20231021-pre_and_notes_b8600a59b7cea264bc5957379e8791a4c29372fd.svg" alt="$$\mathcal{F}(R(t)) = S(\omega)$$" class="org-svg" />

    <embed img src="/ltximg/20231021-pre_and_notes_3ea5269b75385591f2741942b50019285b3a3b42.svg" alt="$$\mathcal{F^{-1}}(S(\omega)) &amp;amp;= R(t)$$" class="org-svg" />
