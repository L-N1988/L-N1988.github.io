---
title: "Pre(s) and Note(s)"
date: 2023-10-21T01:03:38+08:00
draft: false
url: "/"
---

# Pres and Notes
|Topic|file|
|-----|----|
|谱分析|[pdf](./SpectrumAnalysis.pdf)|
|超大尺度涡|[pdf](./超大尺度涡.pdf) [jupyter notebook](./预乘谱讨论.pdf)|
|$\LaTeX{}$简介|[slide](./LaTeX简介.pdf) [lecture note](./noteLaTeX简介.pdf)|

- [了那WiKi: mkdocs playground](https://l-n1988.github.io/open-channel/)

## 谱分析小结

- 功率与功率谱密度关系
$$
\begin{align*}
    \overline{f^2}(t) = \frac{1}{2\pi}\int_{-\infty}^{\infty} S(\omega) d\omega
.\end{align*}
$$

- 功率谱密度与相关函数关系

$$
\begin{align*}
	R(t) \overset{\mathcal{F}}{\Longrightarrow}S(\omega)
.\end{align*}
$$

- 相关函数与随机信号关系

$$
R(t)=\lim_{T \to \infty} \frac{1}{2T} \int_{-T}^{T} f(\tau)f(\tau+t)d\tau.
$$

此处使用的傅里叶变换对为:
$$
\begin{cases}
\hat{f}(\omega) = \int_{-\infty}^{\infty} f(t)e^{-j\omega t} dt \\\\
f(t) = \frac{1}{2\pi}\int_{-\infty}^{\infty} \hat{f}(\omega) e^{~j\omega t} d\omega. 
\end{cases}
$$
