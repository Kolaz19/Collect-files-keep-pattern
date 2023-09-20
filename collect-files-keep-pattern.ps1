function checkContinue {

    $answerContinue = Read-Host "Continue? (y/n)"

    if ($answerContinue -ne "y" -or $answerContinue -ne "Y") {
	exit
    }

}

$patternToSearch = Read-Host "What common pattern do the files in the folders have?"
$patternToSearch = "*" + $patternToSearch + "*"

$files = Get-Childitem -Path $PSScriptRoot -Recurse -Filter $patternToSearch -File 

# Exit when no file with pattern found
if ($files.length -eq 0) {
    Read-Host "No match in folder - EXITING" 
    exit
}

# List files that match pattern
Write-Host "Files found with this pattern:"-ForegroundColor Yellow
$files = $files | Sort-Object -Property Name
forEach ($f in $files) {
    Write-Host $f.Name  
}

checkContinue

$newDirectoryName = Read-Host "Name of new directory"

$pattern = Read-Host "What pattern in the filename do you want to preserve? (Powershell regex allowed)"

# First check if all files have this pattern - otherwise exit
[System.Collections.ArrayList]$foundPatterns = @()
foreach ($file in $files) {
    $patternFound = $file.Name -match $pattern
    if (!$patternFound) {
    Read-Host "Not all files have this pattern! - EXITING" 
    exit
   }
   $null = $foundPatterns.Add($matches[0])
}
# Write all Found patterns
Write-Host "Found patterns:" -ForegroundColor Yellow
$foundPatterns

checkContinue

# Check if new folder already exists
$newDirectoryNameFull = ($PSScriptRoot + '\' + $newDirectoryName)
$checkFolder = Test-Path $newDirectoryNameFull 
# Create or get folder to work with it
if (!$checkFolder) {
    $null = New-Item -Path $newDirectoryNameFull -ItemType Directory
}

$fileNamePrefix = Read-Host "What should the new file name be (First part of name before preserved pattern)?"
$toLower = Read-Host "Should the pattern be lower case? (y/n)"

$index = 0
foreach ($file in $files) {
    if ($toLower -eq "y" -or $toLower -eq "Y") {
	$patternToWrite = $foundPatterns[$index].ToString().ToLower()
    }

    $file | Copy-Item -Destination ($newDirectoryNameFull + '\' + $fileNamePrefix + ' ' + $patternToWrite + $file.Extension)
    Write-Host "Copied: $file" -ForegroundColor Yellow
    $index++
}
