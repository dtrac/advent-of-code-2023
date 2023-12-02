<#
.SYNOPSIS
Calculates the sum of game IDs based on cube constraints.

.DESCRIPTION
This script reads an input file containing game data with cube counts (red, green, blue). It verifies that each game adheres to the predefined maximum counts for each color. Games meeting these criteria have their IDs added together to calculate a final sum.

.PARAMETER inputFilePath
Specifies the path to the input file.

.NOTES
#>
[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $InputFile = '.\input.txt',
    [Parameter()]
    [int]
    $maxRed = 12,
    [Parameter()]
    [int]
    $maxGreen = 13,
    [Parameter()]
    [int]
    $maxBlue = 14
)
# Read the content of the input file
$inputFileContent = Get-Content $InputFile

$sumPossible = 0

foreach ($line in $inputFileContent) {

    # Extracts the game ID from the line
    $gameId = [int](($line -split ":")[0] -replace "[^0-9]", '')

    # Splits cubes by semicolon, trims the string, and splits cubes into individual items
    $cubes = ($line -split ": ")[1] -replace ";", "," -split ","
    $isGamePossible = $true

    foreach ($cube in $cubes) {
        # Extracts the numeric value from the cube description
        $value = [int]($cube -replace "[^0-9]", '')

        switch -Regex ($cube) {
            'red' {
                # Checks if the red cube count exceeds the maximum
                if ($value -gt $maxRed) {
                    $isGamePossible = $false
                    break
                }
            }
            'green' {
                # Checks if the green cube count exceeds the maximum
                if ($value -gt $maxGreen) {
                    $isGamePossible = $false
                    break
                }
            }
            'blue' {
                # Checks if the blue cube count exceeds the maximum
                if ($value -gt $maxBlue) {
                    $isGamePossible = $false
                    break
                }
            }
        }
    }

    # Adds the game ID to the total if all cube counts are within limits
    if ($isGamePossible) {
        $sumPossible += $gameId
    }
}

Write-Host "Sum of Possible Game IDs: $sumPossible"