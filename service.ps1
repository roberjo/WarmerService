<#
.SYNOPSIS
    Makes HTTP requests to a list of URLs with either GET or POST methods in continuous cycles.

.DESCRIPTION
    This script reads a pipe-delimited text file containing URLs and request specifications.
    It processes the entire list of URLs without pausing between individual requests.
    After completing the entire list, it waits 3 seconds before starting the next cycle.
    The script continues to run in an infinite loop until manually stopped.
    For each request, it prints the time taken and HTTP status code.

.PARAMETER InputFile
    Path to the pipe-delimited text file containing URL specifications.
    Format for GET: URL|GET|Header Key,Value (optional)
    Format for POST: URL|POST|Body|Header Key,Value (optional)

.EXAMPLE
    .\url-requester.ps1 -InputFile "urls.txt"
#>

param (
    [Parameter(Mandatory=$true)]
    [string]$InputFile
)

# Check if input file exists
if (-not (Test-Path $InputFile)) {
    Write-Error "Input file not found: $InputFile"
    exit 1
}

# Function to parse headers
function Parse-Headers {
    param (
        [string]$headerString
    )
    
    if ([string]::IsNullOrWhiteSpace($headerString)) {
        return @{}
    }
    
    $headers = @{}
    $headerPairs = $headerString.Split(',')
    
    foreach ($pair in $headerPairs) {
        $keyValue = $pair.Split(':', 2)
        if ($keyValue.Length -eq 2) {
            $headers[$keyValue[0].Trim()] = $keyValue[1].Trim()
        }
    }
    
    return $headers
}

# Main infinite loop
$cycleCount = 0
Write-Host "Starting URL request cycles. Press Ctrl+C to stop." -ForegroundColor Cyan

try {
    while ($true) {
        $cycleCount++
        Write-Host "`n===== Starting Cycle #$cycleCount =====" -ForegroundColor Magenta
        
        # Read the contents of the input file on each cycle to allow for file updates
        $urlList = Get-Content -Path $InputFile
        $requestCount = 0
        
        # Process each URL in the list
        foreach ($line in $urlList) {
            # Skip empty lines
            if ([string]::IsNullOrWhiteSpace($line)) {
                continue
            }
            
            $parts = $line.Split('|')
            $url = $parts[0].Trim()
            $method = $parts[1].Trim().ToUpper()
            $requestCount++
            
            Write-Host "[$cycleCount.$requestCount] Processing: $url with method $method" -ForegroundColor Green
            
            # Initialize request parameters
            $params = @{
                Uri = $url
                Method = $method
            }
            
            try {
                # Measure time for the request
                $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
                
                # Handle based on request method
                if ($method -eq "GET") {
                    # Add headers if provided
                    if ($parts.Length -gt 2 -and -not [string]::IsNullOrWhiteSpace($parts[2])) {
                        $headers = Parse-Headers -headerString $parts[2]
                        $params.Headers = $headers
                    }
                    
                    # Make GET request but use Invoke-WebRequest to get status code
                    $webResponse = Invoke-WebRequest @params -UseBasicParsing
                    $statusCode = $webResponse.StatusCode
                    $response = $webResponse.Content
                }
                elseif ($method -eq "POST") {
                    # Add body if provided
                    if ($parts.Length -gt 2 -and -not [string]::IsNullOrWhiteSpace($parts[2])) {
                        $params.Body = $parts[2].Trim()
                    }
                    
                    # Add headers if provided
                    if ($parts.Length -gt 3 -and -not [string]::IsNullOrWhiteSpace($parts[3])) {
                        $headers = Parse-Headers -headerString $parts[3]
                        $params.Headers = $headers
                    }
                    
                    # Make POST request but use Invoke-WebRequest to get status code
                    $webResponse = Invoke-WebRequest @params -UseBasicParsing
                    $statusCode = $webResponse.StatusCode
                    $response = $webResponse.Content
                }
                else {
                    Write-Host "[$cycleCount.$requestCount] Unsupported method: $method. Skipping." -ForegroundColor Yellow
                    continue
                }
                
                # Stop the timer
                $stopwatch.Stop()
                $timeElapsed = $stopwatch.Elapsed.TotalMilliseconds
                
                # Print status and timing information
                Write-Host "[$cycleCount.$requestCount] Status: $statusCode | Time: $($timeElapsed.ToString('0.00')) ms" -ForegroundColor Cyan
                
                # Output response (optional, can be commented out for less verbose output)
                Write-Host "[$cycleCount.$requestCount] Response:" -ForegroundColor Cyan
                $response
            }
            catch {
                # For errors, try to get the status code if available
                $statusCode = $_.Exception.Response.StatusCode.value__
                if ($statusCode) {
                    Write-Host "[$cycleCount.$requestCount] Error processing $url - Status: $statusCode - $($_.Exception.Message)" -ForegroundColor Red
                } else {
                    Write-Host "[$cycleCount.$requestCount] Error processing $url - $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }
        
        Write-Host "`nCompleted cycle #$cycleCount with $requestCount requests" -ForegroundColor Green
        Write-Host "Waiting 3 seconds before starting next cycle..." -ForegroundColor Gray
        Start-Sleep -Seconds 3
    }
}
catch {
    # This will catch Ctrl+C and other termination signals
    Write-Host "`nScript execution interrupted after $cycleCount cycles." -ForegroundColor Yellow
}
finally {
    Write-Host "URL requester stopped." -ForegroundColor Magenta
}
