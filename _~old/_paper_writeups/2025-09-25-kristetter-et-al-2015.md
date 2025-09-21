# Probabilistic precipitation rate estimates with ground-based radar network

### Background

The Multi-Radar Multi-System (MRMS) dataset is a rapidly updating, high-resolution (i.e., 5min/1km) offering from the National Severe Storm Labortory (NSSL). Quantiative Precipitation Estimatation (QPE) products in MRMS provide both-time (radar-only) and offline (gauge-adjusted) estimates of rainfall on a $1 \times 1$ kilometer grid across the CONUS. While radar-only QPE provides an accurate, live prediction of precipitation, offline products which incorperate surface rainfall observations are generally considered more precise. Moreover, deterministic algorithms defining the Z-R (reflectivity-rainfall) relationship fail to capture the inherent uncertainty that arrises when converting from reflectivity to rainfall.

Deterministic QPE is modeled using three parameters: precipitation type (e.g., stratiform, convective, tropical, snow, hail, or brightband (the point at which the radar beam intersects the melting layer)), the ???, and the exponent. Beyond lacking uncertain estimation, the MRMS baseline algorithm also tends to overestimate tropical and underestimate hail precipitation. Throughout this paper, the authors will use the gauge-injested QPE variant (pass @1/2), which applies an isotropic (direction-invarient) bias correction to radar-only QPE and is available ~1 hour after the aforementioned product.

### Problem Statement

Bridge the gap between online, slipshod radar-only estimations and offline, gauge-injested products by introducing a Probabilistic QPE (PQPE) framework - opperating at radar resolution (i.e., 5min/1km).

### Method

The authors introduce **PRORATE**: a PQPE method that models true precipitation rates ($R_{ref}$) as a function of precipitation type and radar reflectivity ($Z$) using probability distributions (e.g., lognormal, gamma) to capture the inherent uncertainty when estimating rainfall from radar. 

We begin by collecting a historical dataset of radar reflectivity ($Z$) and corresponding gauge-injested rainfall rates ($R_{ref}$). These datapoints will form the empirical distribution we will fit our models to later. Next, we stratify, these data by rainfall type. We calculate the parameters $\mu$ and $\sigma$ from each type-specific subset in order to fit either a lognormal or a gamma distribution. It is important to note that $\mu$ and $\sigma$ have different meanings in the context of a lognormal/gamma distribution; gamma is usually parameterized in terms of shape $\alpha$ and scale $\theta$. Still, $\mu$ can be thought of as being related to the first moment of each function, and $\sigma$ to the second moment (i.e., modulating the *variance* of each distribution). The type of distribution we use for each precipitation type is determined using a best-fit package in R.

We define some density function $f(R_{ref} \ge R_{thresh} | R_{thresh}) \in [0, 1]$, where $f$ models the probability that some precipitation value $R_{ref}$ exceeds a threshold $R_{thresh}$, implicitly conditioned on precipitation type but **not** on reflectivity. Now, we define $q = f^-1$ to be the quantile range that some $R_{ref}$ falls into; $q_{50}$ is the median, $q_{75}$ is the third quartile, etc. Constrast the expressivity of a probability density function to the deterministic approach used to calculate the MRMS radar-only baseline. We can now model the distribution of true precipitation values $R_{ref}$ for a given precipitation type.

### Evaluations

The authors construct a historical dataset of $(Z, Z_{ref})$ pairs from high-impact weather events (e.g., the Iowa-Wisconsin 2011 Tornado Outbreak). These data include ~70k rain ~1k snow and snow-related samples. Both the baseline, deterministic MRMS QPE and proposed PQPE algorithms are compared across two meterics: relative bias $f_{bias}$ and uncertainty $f_{uncertainty}$.

---

$$
f_{bias} = \frac{R_{pred} - m}{m}
$$

$$
f_{uncertainty} = \frac{q_{75} - q_{25}}{m} * 100
$$

---

Here, $R_{pred}$ is the predicted rainfall rate given some reflectivity value $Z$. When using PQPE algorithms, we select either the *mean* or *median* values from the distribution of rainfall rates for a given $z$. $m$ is the *mean* $R_{ref}$ value at $Z$. Evaluations are logically stratified by precipitation typology (type). The authors demonstrate that PQPE models selected using *mean* $R_{ref}$ values achieve the strongest performance out of all groups. In particular, using a probabilistic approach we notice gains on types that MRMS overestimates (tropical, stratiform*) and underestimates (hail). A key note is that PQPE outperforms MRMS on deterministic metrics, **and** provides uncertainty estimation.

Additionally, we evaluate the "transferability" of PQPE by deriving 1H products from raw (5 min) resolution data. The authors evaluate two approachs assuming either first, temporally independent intervals, or second, temporally dependent intervals. In the former case, distributions corresponding to sequential timesteps over an hour $\{ t_{i}, ..., t_{i + 19} \}$ are combined using a convolution. In the ladder case, we calculate median? statistics from all timesteps, creating a representative distribution typically with higher variability. The authors employ rank-histograms to visualize distribution fits under each assumption. Intuitively, the broader distributions calculated assuming temporal *independence* are most representive.

### Future Work and Conclusions

This work presents PRORATE: a probabilistic framework for QPE. By embracing direct uncertainty modeling, PQPE can achieve better deterministic results than the MRMS baseline, while providing a granular portrait of possible outcomes. This last point is particularly relevant when forecasting the probability of return-rates (e.g., 2-year, 5-year events, etc) and flash flooding.

While effective, the models employed in this paper use simple, two-parameter schemes. No efforts are taken to model space (i.e., storm-relative) and temporal influences on the ZR relationship. Moreover, future work may probe radar-site parameters (e.g., distance from radar, vertical profile of reflectivity (VPR), beam blockage, orthographic effects, etc). Translating probabilistic guidance for meterologistis and other end-users is also outside the scope of this study.