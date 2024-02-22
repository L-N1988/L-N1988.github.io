---
title: "Spectrum Analysis"
date: 2024-02-01T11:44:42+08:00
# bookComments: false
# bookSearchExclude: false
---

# 写在前面
手册一般分为操作手册和原理手册，一般将前者称为指南，后者对应地称为指北。教科书往往兼顾两者，但是更加偏向原理讲解，绕了一大圈才道出问题的解决方法。在互联网论坛中存在一类“TL;DR”文化，即文本“Too long; Don't read”，因此发帖人往往将操作讲解放在开头方便浏览者迅速找到问题的解决办法。

时间序列谱分析可以很复杂，先数学后物理再编程；也可以很简单，五六行代码便得到结果。本节是TL;DR的版本。

```matlab
rng default
% Sample rate 1000Hz
Fs = 1000; t = 0:1/Fs:1;
% A signal with 200Hz cosine and 100Hz sine and noise
x = cos(2*pi*t*200) + sin(2*pi*t*100) + randn(size(t));

[pxx, f] = pwelch(x, [], [], [], Fs);
plot(f, 10*log10(pxx))
legend('Pxx by welch')
```

# 随机过程
## 定义
流场分析采用雷诺分解瞬时流速$u(t)$为时均流速$U=\left\langle u\right\rangle$和脉动流速$u\'(t)$，即
$$u(t)=\left\langle u \right\rangle+u\'(t).$$

其中，$t\in\\{t_1, t_2,\ldots, t_N\\}$，$U = \left\langle u\right\rangle\triangleq\lim_{N\to \infty}\frac{1}{N}\sum_{i=1}^{N}u(t_i).$ 后续的谱分析对象为脉动流速$u\'(t)$。

后文为叙述方便用$\\{X(t)\\}$指代时间序列$u\'(t)$。

{{< hint info >}}
**Definition**

In probability theory and related fields, a stochastic (/stəˈkæstɪk/) or random process is a mathematical object usually defined as a sequence of random variables in a probability space, where the index of the sequence often has the interpretation of time.[Wikipedia](https://en.wikipedia.org/wiki/Stochastic_process)
{{< /hint >}}

$\\{X(t)\\}$满足随机过程的定义，且满足如下性质：
$$\begin{cases}
	E(X) = 0, \\\\
	Var(X)=E(X^2).
\end{cases}$$

## 湍流统计假设：平稳假设
平稳（stationarity）假设保证物理量的统计均值$E(X)$不随采样开始时刻的变化而变化，
$$
E(X(t))=E(X(t+\tau))=\mu_X=\rm Constant.
$$
因此任何时间点开始测量都能得到相同的统计实验结果。

平稳假设同时保证自相关函数$R_X(t, t+\tau)\triangleq E[X(t)X(t+\tau)]$只是时间差$\tau$的函数，记为$R_X(\tau)$。注意到$R_X(0)=Var(X)$也与开始时刻$t$无关。

这里讨论自相关函数$R_X(\tau)$是为了保证假设的完整性和后续讨论功率谱密度$S(\omega)$，统计假设两节内容可以不关注这一统计量。

综上，满足平稳假设的两个条件：
- 均值与时间无关;
- 自相关函数仅是时间差的函数。

## 湍流统计假设：遍历假设

现实中只能通过采样获得时间序列的离散值，因此离散时间序列的时均量是否能够依概率收敛到真实的均值便成为了一个问题。这个问题可重新描述为：
$$
\left\langle X \right\rangle \stackrel{?}{=} E(X)
$$
在何种条件下成立？

这个问题的形式类似大数定律：“Given a sample of independent and identically distributed values, the sample mean converges to the true mean.”，但是二者的侧重点完全不同。

{{< hint warning >}}
**个人看法**

上述等式在满足遍历假设时才成立，一次长时间采样得到的样本能够遍历整个样本空间，即长时间采样得到的样本能够包含样本空间中的所有值。大数定律在要求样本独立同分布时保证了遍历假设，独立同分布的样本一定能够遍历整个样本空间。

因此，遍历假设重点在于样本的分布；而大数定律重点在于样本均值的收敛性。
{{< /hint >}}

**在满足平稳假设的两个条件下**，满足遍历（ergodic）假设需要对应的两个条件：
- $\left\langle X(t)\right\rangle = E(X(t))$以**概率1**成立，则随机过程的均值具有遍历性；
- $\left\langle X(t)X(t+\tau)\right\rangle = R_X(\tau)$以**概率1**成立，则随机过程的自相关函数具有遍历性。

综上，若$X(t)$的均值函数和自相关函数都具有遍历性,则称$X(t)$满足遍历假设。

## 平稳假设和遍历假设的关系
遍历假设成立时平稳假设必然成立，但反之不一定。

{{< details "**反例：满足平稳假设但不满足遍历假设**" close >}}
设$\\{X(t)=Y;-\infty<t<\infty\\}$，其中$Y$为随机变量，分布为$P(Y=1)=P(Y=0)=\frac{1}{2}$。

**解：**

$E(X(t))=E(Y)=\frac{1}{2}$与时间无关；$E(X(t)X(t+\tau))=E(Y^2)=\frac{1}{2}=R_X(\tau)$仅是时间差的函数；因此满足平稳假设。

但是一次采样得到的一系列样本值始终是相同的常数，始终为1或者始终为0，这个样本的分布（除了第一个采样值）已经不是$Y$的二项分布；因此无论采样多长时间都无法使得样本均值趋于真实的均值，不满足遍历假设。

这个例子类似于薛定谔的猫，随机变量$Y$代表了猫的死活状态。在没有观测之前，猫有50%的概率活着（$Y=1 $）和50%的概率死去（$Y=0 $）。一经观测，猫的死活状态便确定了。因此，无论后续观测多长时间，观测到的状态都是相同($Y$始终为1或者始终为0)。在不能进行多元宇宙观测的情况下，不可能观测到猫既死又活的状态。
{{< /details >}}

平稳假设保证了物理统计量的存在性，遍历假设保证了物理统计量的可测性。

# 谱分析
## 功率谱密度$S(\omega)$
湍流在满足平稳假设和遍历假设后，实验得到的统计量才有意义。我们做谱分析最初是为了分析湍流中能量（这里采用功率来描述能量，可能是由于无限能量、有限功率的信号更加常见，因此采用功率谱描述更合适）关于频率的分布。

连续随机信号$X(t)$的平均功率（power）为：
$$
\overline{X^2}=\lim_{T\to\infty}\frac{1}{2T}\int_{-T}^T\|X(t)\|^2dt.
$$

分析功率关于频率$\omega$的分布需要借助Fourier变换，本文采用的Fourier变换对为：
$$\begin{cases}
	\hat{X}(\omega)=\int_{-\infty}^{\infty} X(t)e^{-it\omega} dt,\\\\
	X(t)=\frac{1}{2\pi}\int_{-\infty}^{\infty} \hat{X}(\omega)e^{\\,it\omega} d\omega.
\end{cases}$$

采用不同的Fourier变换对得到的结果仅存在系数$\frac{1}{2\pi}$上的差异，并不影响物理量关系。

根据[Parseval–Plancherel identity](https://en.wikipedia.org/wiki/Plancherel_theorem)（类比Fourier级数的[帕塞瓦尔恒等式](https://en.wikipedia.org/wiki/Parseval%27s_identity)）：

{{< hint info >}}
**Parseval-Plancherel identity**

Integral of a function's squared modulus is equal to the integral of the squared modulus of its frequency spectrum. [Proof](https://math.stackexchange.com/questions/1353893/how-to-prove-plancherels-formula).
{{< /hint >}}


$$
\int_{-\infty}^{\infty}  |X(t)|^2dt=\frac{1}{2\pi}\int_{-\infty}^{\infty} |\hat{X}(\omega)|^2d\omega.
$$

将上式带入平均功率的定义式得到
$$
\overline{X^2}=\frac{1}{2\pi}\cdot\lim_{T\to\infty}\frac{1}{2T}\int_{-\infty}^\infty\|\hat{X}(\omega)\|^2d\omega
$$
因此，很自然地将功率谱密度$S(\omega)$定义为：
$$S(\omega)\triangleq \lim_{T\to\infty}\frac{1}{2T}|\hat{X}(\omega)|^2,$$
功率谱密度$S(\omega)$（power spectrum density, PSD）描述了信号功率关于频率$\omega$的分布，使得平均功率满足$ \overline{X^2}=\frac{1}{2\pi}\cdot \int_{-\infty}^{\infty}S(\omega)d\omega. $

## 功率谱密度$S(\omega)$与自相关函数$R_X(t)$的关系
$X(t)$在满足平稳性和遍历性假设的情况下，自相关函数$R_X(t)=E(X(\tau)X(\tau+t))$可重新写作：
$$
\begin{aligned}
R_X(t)&=\left\langle X(\tau)X(\tau+t)\right\rangle \text{, ergodic}\\\\
&=\lim_{T\to\infty}\frac{1}{2T}\int_{-T}^{T-t} X(\tau)X(\tau+t)d\tau \\\\
&=\lim_{T \to \infty} \frac{1}{2T} \int_{-\infty}^{\infty} X(\tau)X(\tau+t)d\tau \\\\
&=\lim_{T \to \infty} \frac{1}{2T}\int_{-\infty}^\infty X(\tau-t)X(\tau)d\tau \text{, stationarity}\\\\
&=\lim_{T \to \infty} \frac{1}{2T}\int_{-\infty}^\infty X(\tau)X(-(t-\tau))d\tau \\\\
&=\lim_{T\to\infty}\frac{1}{2T}X(t)\*X(-t)
.\end{aligned}
$$

实值函数的Fourier变换满足：$X(-t)\stackrel{\mathcal{F}}{\to}\overline{\hat{X}(\omega)}$，此处的横线表示复数的共轭，
$$
\int_{-\infty}^{\infty} X(-t)e^{-it\omega}dt=\int_{-\infty}^{\infty} X(t)e^{\\,it\omega} dt=\overline{\hat{X}(\omega)}.
$$

口算即可得到自相关函数$R_X(t)$的Fourier变换为功率谱密度$S(\omega)$：
$$
\begin{aligned}
\mathcal{F}[R_X(t)] &= \lim_{T \to \infty} \mathcal{F}[X(t)]\cdot \mathcal{F}[X(-t)] \\\\
&=\lim_{T \to \infty} \frac{1}{2T}\hat{X}(\omega)\cdot \overline{\hat{X}(\omega)} \\\\
&=\lim_{T \to \infty} \frac{1}{2T}|\hat{X}(\omega)|^2 \\\\
&= S(\omega)
.\end{aligned}
$$

综上，自相关函数$R_X(t)$与功率谱密度$S(\omega)$为一组Fourier变换对，这个结论被称为[维纳-辛钦定理](https://en.wikipedia.org/wiki/Wiener%E2%80%93Khinchin_theorem)。
{{< hint info >}}
**维纳-辛钦定理**

宽平稳随机过程（即满足平稳性假设的随机过程）的功率谱密度是其自相关函数的傅里叶变换。
{{< /hint >}}

## 功率谱密度$S(\omega)$变换为波数谱$S(k)$
波数$k\triangleq \frac{2\pi}{\lambda}$，$\lambda$表示波长。

湍流中存在统计上稳定的有序空间结构称为相干结构，如床面附近稳定的涡体。与功率谱$S(\omega)$描述功率在频率域的分布类似，波数谱$S(k)$描述了功率在波数域（即空间尺度）的分布。通过波数谱$S(k)$能够判断不同尺度的相干结构贡献的能量占比，进而找到湍流中起主导作用的相干结构。

但是相干结构的大小一般远大于试验设备能够测量的空间范围，因此无法直接在空间上一次性测量完整的相干结构。

为了弥补空间量程上的不足，实验测量通过延长测量时间得到更广频率域范围的功率谱$S(\omega)$，再通过泰勒冻结界定将功率谱变换为波数谱。

泰勒冻结假定的变换方法只是进行一次变量替换，$t=\frac{x}{U}\implies k=\frac{\omega}{U}$：
$$
\begin{aligned}
R_X(t)=R_X(\frac{x}{U})&=\frac{1}{2\pi}\int_{-\infty}^{\infty} S(\omega)e^{\\,i\omega\cdot \frac{x}{U}} d\omega \\\\
&=\frac{1}{2\pi}\int_{-\infty}^{\infty} US(\omega)e^{\\,i \frac{\omega}{U}\cdot x} d\left( \frac{\omega}{U} \right) \\\\
&= \frac{1}{2\pi}\int_{-\infty}^{\infty} [US(Uk)]e^{\\,ik\cdot x} dk
.\end{aligned}
$$

因此，功率谱密度$S_1(\omega)$变换为对应的波数谱$S(k)\triangleq U\cdot S_1(Uk)$。

文献中常用到的预乘谱（pre-multiplied spectrum）更加简单。只是将纵坐标变量改为$kS(k)$，并保持线性坐标，横坐标$k$改为对数坐标。

# 离散信号谱分析
## DFT形式的功率谱密度
谱分析最重要的是得到功率谱密度$S(f)$。本章节为了对称性，采用数学上常用的频率$f$为自变量的功率谱密度$S(f)$，而不是工程常用的角频率$\omega$为自变量的功率谱密度$S(\omega)$。

这种数学上的对称性来自于Fourier变换对形式的对称性（替换$\omega=2\pi f$消除了系数$\frac{1}{2\pi}$）：
$$\begin{cases}
	\hat{X}(f)=\int_{-\infty}^{\infty} X(t)e^{-2\pi itf} dt,\\\\
	X(t)=\int_{-\infty}^{\infty} \hat{X}(\omega)e^{\\,2\pi itf} df.
\end{cases}$$

因此，前述结论可重新写作：
- Paserval-Plancherel identity：$ \int_{-\infty}^{\infty}  |X(t)|^2dt=\int_{-\infty}^{\infty} |\hat{X}(f)|^2df;$
- 功率谱密度$S(f)$：
$$S(f)\triangleq \lim_{T\to\infty}\frac{1}{2T}|\hat{X}(f)|^2\implies \overline{X^2}=\int_{-\infty}^{\infty} S(f)df;$$

上述表达式借助离散Fourier（DFT）变换推广为离散形式（此处为单边形式$0\sim N-1$，因此系数分母中无2），得到功率谱密度$S(f)$的计算方法为：
$$
S(f_k)= \lim_{N\to\infty}\frac{1}{N}|\hat{X}(f_k)\Delta t|^2,
$$
其中$T=(N-1)\Delta t$，$\hat{X}(f_k)=\sum_{n=0}^{N-1}X(t_n)\cdot e^{-2\pi i t_n f_k}$。由于$t_n=\Delta t\cdot n,~f_k=\frac{k}{N\cdot \Delta t}$，采用的DFT可简化为：
$$
\hat{X}(f_k)=\hat{X_k}=\sum_{n=0}^{N-1}X_n\cdot e^{-2\pi i n \frac{k}{N}}.
$$

## Window 函数
实际测量的序列不可能是无限长的，$T$或者$N$都无法达到无穷的极限，因此在信号处理上往往将采样的数据$X_T(t)$视作无限长信号信号$X(t)$叠加了[rectangular window](https://ccrma.stanford.edu/~jos/sasp/Rectangular_Window.html)的截断（cut-off）结果：
$$
X_T(t)=X(t)\cdot \rm window
$$

<embed img src="/figures/window3.svg" height="60%" alt="window" class="org-svg" />

采用实验数据实际计算的功率谱密度是
$$
S(f_k)=\frac{\Delta t^2}{N}|\hat{X_T}(f_k)|^2 = \frac{\Delta t^2}{N}|\hat{X}(f_k)\* \hat{W}(f_k)|^2.
$$

直觉上，window函数的Fourier变换$\hat{W}(f)$越接近$\delta$函数，得到的功率谱越真实。关于各种类型window的讨论，见
- [slide](http://www.ee.ic.ac.uk/pcheung/teaching/de2_ee/Lecture%205%20-%20DFT%20&%20Windowing%20(x2).pdf),
- [standford researchher page](https://ccrma.stanford.edu/~jos/sasp/Spectrum_Analysis_Windows.html),
- Discrete-Time Signal Processing by Alan V. Oppenheim and Ronald W. Schafer: **section 2.2 and 3.3** in Chapter 10. Fourier Analysis of Signals Using the Discrete Fourier Transform.

## 计算方法一：Periodogram

[code blog](https://scicoding.com/calculating-power-spectral-density-in-python/)

```python
import matplotlib.pyplot as plt
import numpy as np 

# f is the requested frequency
# signal is the time series data
# Fs is the sampling frequency in Hz
def Sxx(f, signal, Fs):
    t = 1/Fs # Sample spacing
    T = len(signal) # Signal duration
    
    s = np.sum([signal[i] * np.exp(-1j*2*np.pi*f*i*t) for i in range(T)])
    
    return t**2 / T * np.abs(s)**2

# Use Sxx to calculate PSD for f in [0, 100]
S = [Sxx(f, signal, fs) for f in range(100)]

plt.semilogy([f for f in range(100)], S)
plt.xlim([0, 100])
plt.xlabel('frequency [Hz]')
plt.ylabel('PSD [V**2/Hz]')
plt.show()
```

Ref(s)
- Discrete-Time Signal Processing by Alan V. Oppenheim and Ronald W. Schafer: **section 5** in Chapter 10. Fourier Analysis of Signals Using the Discrete Fourier Transform.
- [SciPy source code](https://github.com/scipy/scipy/blob/v1.12.0/scipy/signal/_spectral_py.py#L156-L293)

### Segment periodogram：Welch's method
- [stanford researchher page: welch's method](https://ccrma.stanford.edu/~jos/sasp/Welch_s_Method.html)(简单明了，推荐)
- [pwelch octave code](https://github.com/CyclotronResearchCentre/FASST/blob/master/SPTfunctions/pwelch.m)(注释极详细，本节代码来源于此文件)
- [PSD computations using Welch's method by Solomon](https://www.osti.gov/servlets/purl/5688766)
- [Trying to understand the nperseg effect of Welch method](https://dsp.stackexchange.com/a/81653/65250)

```matlab
%% ...
%% Nfft        %% [integer scalar] Length of FFT.  The default is the length
%%             %%       of the "window" vector or has the same value as the
%%             %%       scalar "window" argument.  If Nfft is larger than the
%%             %%       segment length, "seg_len", the data segment is padded
%%             %%       with "Nfft-seg_len" zeros.  The default is no padding.
%%             %%       Nfft values smaller than the length of the data
%%             %%       segment (or window) are ignored silently.
%%
%% Fs          %% [real scalar] sampling frequency (Hertz); default=1.0
%%
%% minimum FFT length is seg_len
Nfft = max( Nfft, seg_len );
%% Mean square of window is required for normalising PSD amplitude.
win_meansq = (window.' * window) / seg_len;
%%
%% Set default or check overlap.
if ( isempty(overlap) )
	overlap = fix(seg_len /2);
elseif ( overlap >= seg_len )
	error( 'pwelch: arg (overlap=%d) too big. Must be <length(window)=%d',...
		overlap, seg_len );
end
%%
%% MAIN CALCULATIONS
%% ...
%% 
%% Calculate and accumulate periodograms
%%   xx and yy are padded data segments
%%   Pxx is periodogram sum
xx = zeros(Nfft,1);
Pxx = xx;
n_ffts = 0;
for start_seg = [1:seg_len-overlap:x_len-seg_len+1]
	end_seg = start_seg+seg_len-1;
	%% Don't truncate/remove the zero padding in xx and yy
	xx(1:seg_len) = window .* x(start_seg:end_seg);
	fft_x = fft(xx);
	%% force Pxx to be real; pgram = periodogram
	pgram = real(fft_x .* conj(fft_x));
	Pxx = Pxx + pgram;
	n_ffts = n_ffts +1;
end
psd_len = Nfft;
%% end MAIN CALCULATIONS
%%
%% SCALING AND OUTPUT
%%   Pxx is sum of periodogram, so "n_ffts"
%%   in the scale factor converts them into averages
spectra    = zeros(psd_len);
scale = n_ffts * seg_len * Fs * win_meansq;

spectra(:) = Pxx / scale;
freq = [0:psd_len-1].' * ( Fs / Nfft );
```

<img src="/figures/welch.png" width="100%" alt="welch" class="png" />

## 计算方法二：Autocorrelation
Ref(s)
- Discrete-Time Signal Processing by Alan V. Oppenheim and Ronald W. Schafer: **section 6** in Chapter 10. Fourier Analysis of Signals Using the Discrete Fourier Transform.

