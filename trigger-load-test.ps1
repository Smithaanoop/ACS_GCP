#!/usr/bin/env pwsh
# Trigger Manual Load Test Workflow

param(
    [Parameter(Mandatory=$true)]
    [string]$Token,
    
    [string]$LoadType = "baseline",
    [string]$ConcurrentRequests = "100",
    [string]$DurationSeconds = "60"
)

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

Write-Host "🔄 Triggering Manual Load Test workflow..."
Write-Host "  Load Type: $LoadType"
Write-Host "  Concurrent Requests: $ConcurrentRequests"
Write-Host "  Duration: ${DurationSeconds}s"
Write-Host ""

try {
    $response = Invoke-RestMethod `
        -Uri "https://api.github.com/repos/rshambhavipillai/ACS_GCP/actions/workflows/manual-load-test.yml/dispatches" `
        -Method POST `
        -Headers $headers `
        -Body $body `
        -StatusCodeVariable "statusCode"
    
    if ($statusCode -eq 204) {
        Write-Host "✅ Load test triggered successfully!"
        Write-Host ""
        Write-Host "📊 View progress here:"
        Write-Host "https://github.com/rshambhavipillai/ACS_GCP/actions/workflows/manual-load-test.yml"
        Write-Host ""
        Write-Host "⏳ Results will include:"
        Write-Host "  • App Engine performance metrics"
        Write-Host "  • GKE performance metrics"
        Write-Host "  • Platform comparison report"
    } else {
        Write-Host "❌ Failed with status code: $statusCode"
        Write-Host "Response: $response"
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)"
    Write-Host "Make sure your token has repo and workflow scopes"
}
