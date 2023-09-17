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

# Check if new folder already exists
$newFolderName = ($PSScriptRoot + '\' + $directoryName)
$checkFolder = Test-Path $newFolderName 

# Create or get folder to work with it
if ($checkFolder) {
    $folder = Get-Item -Path $newFolderName
} else {
    $folder = New-Item -Path $newFolderName -ItemType Directory
}

Write-Host "`nWhat pattern in the filename do you want to preserve? (Powershell regex allowed)" -ForegroundColor Yellow
$pattern = Read-Host 

# First check if all files have this pattern - otherwise exit
[System.Collections.ArrayList]$patterns = @()
foreach ($file in $files) {
    $patternFound = $file.Name -match $pattern
    if (!$patternFound) {
	Write-Host "`nNot all files have this pattern!"
	exit
   }
   $null = $patterns.Add($matches[0])
}
# Write all Found patterns
Write-Host "`nFound patterns:" -ForegroundColor Yellow
$patterns

Write-Host "`nContinue?(y/n)"-ForegroundColor Yellow
$answerContinue = Read-Host 

if ($answerContinue -ne "y" -or $answerContinue -ne "Y") {
    exit
}

Write-Host "`nWhat should the new file name be (First part of name before preserved pattern)?" -ForegroundColor Yellow
$fileNamePrefix = Read-Host 
$index = 0
foreach ($file in $files) {
    $file | Copy-Item -Destination ($newFolderName + '\' + $fileNamePrefix + ' ' + $patterns[$index] + $file.Extension)
    $index++
}
