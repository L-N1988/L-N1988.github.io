---
title: "Spectrum Analysis"
date: 2024-02-01T11:44:42+08:00
# bookComments: false
# bookSearchExclude: false
---

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

采用不同的Fourier变化对得到的结果仅存在系数$\frac{1}{2\pi}$上的差异，并不影响物理量关系。

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

泰勒冻结假定的变换方法只是进行一次变量替换，$t=\frac{x}{U}\iff k=\frac{\omega}{U}$：
$$
\begin{aligned}
R_X(t)=R_X(\frac{x}{U})&=\frac{1}{2\pi}\int_{-\infty}^{\infty} S(\omega)e^{\\,i\omega\cdot \frac{x}{U}} d\omega \\\\
&=\frac{1}{2\pi}\int_{-\infty}^{\infty} US(\omega)e^{\\,i \frac{\omega}{U}\cdot x} d\left( \frac{\omega}{U} \right) \\\\
&= \frac{1}{2\pi}\int_{-\infty}^{\infty} [US(Uk)]e^{\\,ik\cdot x} dk
.\end{aligned}
$$

因此，功率谱密度$S_1(\omega)$变换为对应的波数谱$S(k)\triangleq U\cdot S_1(Uk)$。

文献中常用到的预乘谱（pre-multiplied spectrum）更加简单。只是将纵坐标变量改为$kS(k)$，并保持线性坐标，横坐标$k$改为对数坐标。

## 代码实现
