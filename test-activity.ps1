# Test Activity Endpoint

Write-Host "Testing Activity API..." -ForegroundColor Cyan
Write-Host ""

Write-Host "Setup: User activities in database..." -ForegroundColor Yellow
Write-Host "User 1:"
Write-Host "- Created posts: #1, #3, #5"
Write-Host "- Liked posts: #2"
Write-Host "- Follows: User 2"
Write-Host ""
Write-Host "User 2:"
Write-Host "- Created posts: #2, #4, #6"
Write-Host "- No likes recorded"
Write-Host "- No follows"
Write-Host ""
Write-Host "User 3:"
Write-Host "- No posts"
Write-Host "- Liked posts: #1, #4"
Write-Host "- Follows: User 1, User 2"
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "TESTING ACTIVITY ENDPOINT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Test 1: Get all activities for User 1" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/1/activity" -Method GET -UseBasicParsing
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

Write-Host "Test 2: Get all activities for User 3" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/3/activity" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 3: Filter by type - only posts for User 1" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/1/activity?type=post" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 4: Filter by type - only likes for User 3" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/3/activity?type=like" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 5: Filter by type - only follows for User 3" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/3/activity?type=follow" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 6: Pagination - limit 2 for User 1" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/1/activity?limit=2" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 7: Pagination - offset 2, limit 2 for User 1" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/1/activity?limit=2&offset=2" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 8: User with no activities (User 2)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/2/activity" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 9: Non-existent user" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/users/999/activity" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "All tests completed!" -ForegroundColor Green
