# Define file paths
$inputCsvPath  = "C:\Users\Manish\Documents\consolidate_result (2).csv"
$outputCsvPath = "C:\Users\Manish\Documents\consolidate_result_fixed.csv"
$reportDir     = "C:\Users\Manish\Documents\JMeterReport"


# Import the original CSV file
$data = Import-Csv -Path $inputCsvPath

# Process each row: Convert the timeStamp field to a 64-bit integer.
foreach ($row in $data) {
    $row.timeStamp = [int64]$row.timeStamp
}

$csvLines = $data | ConvertTo-Csv -NoTypeInformation
$header = $csvLines[0] -replace '"',''
$body = $csvLines[1..($csvLines.Count - 1)]
$fixedCsvLines = @($header) + $body
$fixedCsvLines | Out-File -FilePath $outputCsvPath -Encoding utf8

Write-Output "Fixed CSV saved to $outputCsvPath"

# Build the JMeter command using the fixed CSV file
$command = "jmeter -g `"$outputCsvPath`" -o `"$reportDir`""
Write-Output "Executing command: $command"

# Execute the JMeter command
Invoke-Expression $command

if ($LASTEXITCODE -eq 0) {
    Write-Output "JMeter HTML report generated successfully at: $reportDir"
} else {
    Write-Error "Failed to generate HTML report. Exit code: $LASTEXITCODE"
}
