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
    # Get the first and last numbers from the line and calculate the line value
    $lineValue = (Get-FirstNumber $line) + (Get-LastNumber $line)
    
    # Output details for each line (Verbose output)
    Write-Verbose "`$line: $line`n`$lineValue: $lineValue`n`$runningTotal: $calibrationValue"
    
    # Calculate the running total (calibration value)
    $calibrationValue = $calibrationValue += [int]$lineValue
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