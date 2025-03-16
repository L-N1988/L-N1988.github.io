param (
    [string]$BaseDir = ".",
    [string]$MatlabScriptPath = ".\Scripts\raw2data.m"
)

# Find all case folders
$caseFolders = Get-ChildItem -Path $BaseDir -Directory -Filter "Case_*"

foreach ($folder in $caseFolders) {
    $casePath = $folder.FullName
    Write-Host "Processing $casePath"
    
    # Call MATLAB non-interactively
    $matlabCmd = "matlab -nodisplay -nosplash -r `"try; $MatlabScriptPath('$casePath'); catch e; disp(e.message); end; exit`""
    Invoke-Expression $matlabCmd
}

Write-Host "Processing complete"
