# Code for PIVLab processing

## powershell batch processing

- Create a new blank experiment data folder: [ps1 code](./PIV-processing/new_blank_project.ps1)

```ps1
.\new_blank_project.ps1 -BaseDir "C:\Experiments" -CaseName "Case_1"
```

- TODO: Batch run matlab data processing scripts: [ps1 code](./PIV-processing/batch_pivlab_data.ps1)

## MATLAB code data processing

1. Extract raw PIVLab.mat to normalised data:  [view](./PIV-processing/raw2data.html) | [download](./PIV-processing/raw2data.m)
2. Plot turbulence statistical: [view](./PIV-processing/pivPlot.html) | [download](./PIV-processing/pivPlot.m)
3. Estimate power spectral density in vertical centre line of FOV: [view](./PIV-processing/PSD.html) | [download](./PIV-processing/PSD.m)
4. Plot power spectral density contour: [view](./PIV-processing/pxxPlot.html) | [download](./PIV-processing/pxxPlot.m)
5. Merged PSD from different PSD series: [view](./PIV-processing/mergePSD.html) | [download](./PIV-processing/mergePSD.m)
6. Plot 2D vertical distribution PSD contour: [view](./PIV-processing/mergePxxPlot.html) | [download](./PIV-processing/mergePxxPlot.m)
