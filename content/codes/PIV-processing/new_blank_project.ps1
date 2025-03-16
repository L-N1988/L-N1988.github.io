param (
    [string]$BaseDir = "C:\Experiments",  # Root directory with raw files
    [string]$CaseName = "Case_1"          # Name of the experiment case
)

# Define folder structure
$CaseName = -join("Case_", $CaseName)
$mainFolder = Join-Path $BaseDir $CaseName
$subFolders = @("raw_data", "tif_figures", "normalized_data", "figure_data", "figure_templates", "scripts", "analysis_figures", "presentation_figures")

# Create folders if they don't exist
foreach ($folder in $subFolders) {
    $folderPath = Join-Path $mainFolder $folder
    if (-not (Test-Path $folderPath)) {
        New-Item -Path $folderPath -ItemType Directory | Out-Null
    }
}

# Generate readme
$readmePath = Join-Path $mainFolder "readme.txt"
$readmeContent = @"
Case: $CaseName
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Contains:
- raw_data: cine file
- tif_figures: cine exported 8x24 tif figures
- normalized_data: PIV_session.mat, PIVlab.mat exported from PIVlab
- figure_data: statistical data extracted from PIVlab.mat
- figure_templates: plot style template for matlab
- scripts: MATLAB data processing scripts
- analysis_figures: raw figure for analysis only
- presentation_figures: formal figure for article and presentation
"@
Set-Content -Path $readmePath -Value $readmeContent

Write-Host "Organized $CaseName in $mainFolder"
