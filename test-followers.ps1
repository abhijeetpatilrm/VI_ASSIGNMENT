# Test Followers Endpoint

Write-Host "Testing Followers API..." -ForegroundColor Cyan
Write-Host ""

Write-Host "Setup: Checking follow relationships..." -ForegroundColor Yellow
Write-Host "Current follows:"
Write-Host "- User 1 follows User 2"
Write-Host "- User 3 follows User 1"
Write-Host "- User 3 follows User 2"
Write-Host ""

Write-Host "Expected results:"
Write-Host "- User 1 has 1 follower (User 3)"
Write-Host "- User 2 has 2 followers (User 1, User 3)"
Write-Host "- User 3 has 0 followers"
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "TESTING FOLLOWERS ENDPOINT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Test 1: Get followers for User 1 (should have User 3)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/1/followers" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        Write-Host $reader.ReadToEnd()
    }
}
Write-Host ""

Write-Host "Test 2: Get followers for User 2 (should have User 1 and User 3)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/2/followers" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 3: Get followers for User 3 (should have 0 followers)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/3/followers" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 4: Pagination - Get User 2's followers with limit 1" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/2/followers?limit=1" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 5: Pagination - Get User 2's followers with offset 1" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/2/followers?limit=1&offset=1" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 6: Non-existent user" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/999/followers" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "All tests completed!" -ForegroundColor Green
