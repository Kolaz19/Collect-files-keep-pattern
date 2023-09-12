Write-Host "What common pattern do the files in the folders have?"-ForegroundColor Yellow
$patternToSearch = Read-Host 
$patternToSearch = "*" + $patternToSearch + "*"

$files = Get-Childitem -Path $PSScriptRoot -Recurse -Include $patternToSearch -File 

# Exit when no file with pattern found
if ($files.length -eq 0) {
    Write-Host "No match in folder - EXITING" -ForegroundColor DarkRed
    Read-Host
    exit
}

# List files that match pattern
Write-Host "Files found with this pattern:"-ForegroundColor Yellow
forEach ($f in $files) {
    Write-Host $f.Name  
}

Write-Host "`nContinue?(y/n)"-ForegroundColor Yellow
$answerContinue = Read-Host 

if ($answerContinue -ne "y" -or $answerContinue -ne "Y") {
    exit
}

Write-Host "`nName of new directory:" -ForegroundColor Yellow
$directoryName = Read-Host 
