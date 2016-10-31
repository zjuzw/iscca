# ISCCA
To optimally extract neurophsyiological processes that are common across subjects, we propose an analysis method called the Inter-Subject 
Coherent Component Analysis (ISCCA). The ISCCA decomposes the multi-channel MEG recordings of each subject into components and maximizes 
the inter-subject correlation of each component. Each ISCCA component is extracted by a spatial filter and can be viewed as the recording 
from a virtual sensor spatially tuned to a cortical network that shows coherent neural activity over subjects. The ISCCA spatial filters 
are subject-specific and normalize individual differences in response topography. Since the ISCCA components are maximally correlated over
subjects, they can be directly averaged for group level analysis. 

It designs spatial filters in two steps. The first step is applied independently for different subjects, using the denoising source separation (DSS) (de Cheveigné and Parra, 2014; de Cheveigné and Simon, 2008).The Matlab code is available at http://audition.ens.fr/adc/NoiseTools/. The second step relies on the multi-set canonical component analysis (mCCA) (Kettenring, 1971).

# Example
- [isc_demo.m](https://github.com/zju_zw/iscca/isc_demo.m) - A demo for ISCCA.
- [msetcca.m](https://github.com/zju_zw/iscca/msetcca.m) - multi-set CCA function.
