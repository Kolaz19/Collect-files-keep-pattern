Write-Output "What common pattern do the files in the folders have?"
$patternToSearch = Read-Host 
$patternToSearch = "*" + $patternToSearch + "*"

$files = Get-Childitem -Path $PSScriptRoot -Recurse -Include $patternToSearch -File 

if ($files.length -eq 0) {
    Write-Output "No match in folder - EXITING" 
    Read-Host
    exit
}

forEach ($f in $files) {
    Write-Host $f.Name  
}

$patternToSearch = Read-Host 
