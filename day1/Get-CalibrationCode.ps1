<#
.SYNOPSIS
   This script calculates a calibration value based on numerical values extracted from a file.

.DESCRIPTION
   This script reads an input file and extracts the first and last numbers from each line. 
   It then calculates a calibration value by summing up these numerical values.

.PARAMETER InputFile
   Specifies the path of the input file. Defaults to '.\input.txt' if not provided.

.INPUTS
   Input file containing lines with numerical values.

.OUTPUTS
   Final Calibration Value.

.NOTES
   - This script uses 'Get-FirstNumber' and 'Get-LastNumber' functions to extract the first and last numbers from a string.
   - Modify the 'InputFile' parameter to specify a different file path.

#>

[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $InputFile = '.\input.txt'
)

# Read the content of the input file
$inputFileContent = Get-Content $InputFile

# Initialize the calibration value
$calibrationValue = $null

# Loop through each line in the input file to calculate the calibration value
foreach ($line in $inputFileContent) {

    Write-Verbose "`$[original]line: $line"
    # Replace any number words with digits
    try {
        $line = Replace-FirstLastNumberWordsWithDigits $line
    }
    catch {
        Write-Error "error with $line"
    }
    
    # Get the first and last numbers from the line and calculate the line value
    $lineValue = (Get-FirstNumber $line) + (Get-LastNumber $line)
    
    # Output details for each line (Verbose output)
    Write-Verbose "`$[changed]line: $line`n`$lineValue: $lineValue`n`$runningTotal: $calibrationValue"
    
    # Calculate the running total (calibration value)
    $calibrationValue = $calibrationValue += [int]$lineValue
    Write-Verbose "`$runningTotal: $calibrationValue`n"
}

# Output the final calibration value
Write-Output "Final Calibration Value: $calibrationValue"

# Function to extract the first number from a string
function Get-FirstNumber ($inputString) {
    $firstNumber = [regex]::Matches($inputString, '\d').Value[0]
    return $firstNumber
}

# Function to extract the last number from a string
function Get-LastNumber ($inputString) {
    $lastNumber = ""
    for ($i = $inputString.Length - 1; $i -ge 0; $i--) {
        $char = $inputString[$i]
        if ($char -match '\d') {
            $lastNumber = $char
            break
        }
    }
    return $lastNumber
}

<# function Replace-NumberWordsWithDigits ($inputString) {

    $numberWordsToDigits = @{
        'one' = '1'
        'two' = '2'
        'three' = '3'
        'four' = '4'
        'five' = '5'
        'six' = '6'
        'seven' = '7'
        'eight' = '8'
        'nine' = '9'
    }

    $numberWordsToDigits.Keys | ForEach-Object { 
        $inputString = $inputString.Replace($_, $numberWordsToDigits["$_"])   
    }
    return $InputString
} #>

function Replace-FirstLastNumberWordsWithDigits ($inputString) {

    $numberWordsToDigits = @{
        'one' = '1'
        'two' = '2'
        'three' = '3'
        'four' = '4'
        'five' = '5'
        'six' = '6'
        'seven' = '7'
        'eight' = '8'
        'nine' = '9'
    }

    $firstIndex = $null
    $lastIndex = $null

    $numberWordsToDigits.Keys | ForEach-Object {
        $numberWord = $_
        $index = $inputString.IndexOf($numberWord)
        if ($index -ge 0) {
            if (-not $firstIndex) {
                $firstIndex = $index
                $inputString = $inputString.Substring(0, $index) + $numberWordsToDigits[$numberWord] + $inputString.Substring($index + $numberWord.Length)
            }
            $lastIndex = $index
        }
    }

    $lastNumberWord = $numberWordsToDigits.Keys | Where-Object { $inputString.Contains($_) } | Select-Object -Last 1
    if ($lastIndex -ne $null -and $lastIndex -ne $firstIndex) {
        $inputString = $inputString.Substring(0, $lastIndex) + $numberWordsToDigits[$lastNumberWord] + $inputString.Substring($lastIndex + $lastNumberWord.Length)
    }

    return $inputString
}