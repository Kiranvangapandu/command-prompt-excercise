# Copyright: NCR Corporation Proprietary technical artifact.
# @author      Ratnakar, MVS
# @name        &TimelySync
# @command     powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" -configFile "%CONFIG_FILE_PATH%"
# @description Periodically scans for changes in the given patterned filePattern in the src directory and copies to dst directory.
# @version     1.0.0
# @require     Windows Robocopy

param (
    # Input parameters - source directory, destination directory, file pattern
    [Parameter(Mandatory=$true)]
    [string]
    $srcDir,
    [Parameter(Mandatory=$true)]
    [string]
    $destDir,
    [Parameter(Mandatory=$false)]
    [string]
    $filePattern="",
    [Parameter(Mandatory=$false)]
    [string]
    $additionalOptions="",
    [Parameter(Mandatory=$false)]
    [int]
    $defaultInterval=1
)

# Use the '-Debug' flag to see debug information in case required. Below condition, will suppress the debug confirmation with in the scope of this script execution.
If ($PSBoundParameters['Debug']) {
    $DebugPreference = 'Continue'
}
function isValidPath {
    param (
        # Directory path provided as .Parameter
        [string]$paramName
    )
    if(![string]::IsNullOrWhiteSpace($paramName))
    {
        if(Test-Path $paramName)
        {
            return $true
        }    
    }
    return $false
}

if(!(isValidPath($srcDir))) {
    Write-Host "Source provided: $($srcDir) is not a valid path."
}
elseif (!(isValidPath($destDir))) {
    Write-Host "Destination provided: $($srcDir) is not a valid path."
}
else {
    Write-Host "Sync Service: Initialization started...$(Get-Date -Format 'yyyyMMdd_HHmmss_fff')"
    $interval = '/MOT:'+$defaultInterval
    $roboCopyOptions = @('/NJH','/NJS','/NDL','/NC','/NS','/NP','/NFL', $additionalOptions) + $interval
    $CmdLine = @($srcDir, $destDir, $filePattern) + $roboCopyOptions
    & 'robocopy.exe' $CmdLine
}