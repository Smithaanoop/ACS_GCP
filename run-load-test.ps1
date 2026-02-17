param(
    [Parameter(Mandatory=$true)]
    [string]$Token,
    [string]$LoadType = "baseline",
    [string]$ConcurrentRequests = "100",
    [string]$DurationSeconds = "60"
)

Write-Host "Triggering Manual Load Test workflow..."
Write-Host "Load Type: $LoadType"
Write-Host "Concurrent Requests: $ConcurrentRequests"
Write-Host "Duration: ${DurationSeconds}s"

$headers = @{
    "Authorization" = "token $Token"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
}

$body = @{
    "ref" = "main"
    "inputs" = @{
        "load_type" = $LoadType
        "concurrent_requests" = $ConcurrentRequests
        "duration_seconds" = $DurationSeconds
    }
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest `
        -Uri "https://api.github.com/repos/rshambhavipillai/ACS_GCP/actions/workflows/manual-load-test.yml/dispatches" `
        -Method POST `
        -Headers $headers `
        -Body $body
    
    if ($response.StatusCode -eq 204) {
        Write-Host "Success! Load test triggered."
        Write-Host "View progress: https://github.com/rshambhavipillai/ACS_GCP/actions/workflows/manual-load-test.yml"
    } else {
        Write-Host "Error: Status code $($response.StatusCode)"
    }
} catch {
    Write-Host "Error: $($_.Exception.Response.StatusCode)"
    try {
        $streamReader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
        $responseBody = $streamReader.ReadToEnd()
        Write-Host "Details: $responseBody"
    } catch { }
}
