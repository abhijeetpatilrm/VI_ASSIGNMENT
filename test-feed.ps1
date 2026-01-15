# Test Feed Endpoint

Write-Host "Testing Feed API..." -ForegroundColor Cyan
Write-Host ""

Write-Host "Setup: Creating test scenario..." -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Getting existing users..." -ForegroundColor Yellow
$users = Invoke-WebRequest -Uri "http://localhost:3000/api/users" -Method GET -UseBasicParsing
Write-Host "Users in database"
Write-Host ""

Write-Host "2. Creating follows..." -ForegroundColor Yellow
Write-Host "User 1 follows User 2"
try {
    Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"followerId":1,"followingId":2}' -UseBasicParsing | Out-Null
} catch { }

Write-Host "User 3 follows User 1"
try {
    Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"followerId":3,"followingId":1}' -UseBasicParsing | Out-Null
} catch { }

Write-Host "User 3 follows User 2"
try {
    Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"followerId":3,"followingId":2}' -UseBasicParsing | Out-Null
} catch { }
Write-Host "Follow relationships created"
Write-Host ""

Write-Host "3. Getting existing posts..." -ForegroundColor Yellow
$posts = Invoke-WebRequest -Uri "http://localhost:3000/api/posts" -Method GET -UseBasicParsing
Write-Host "Posts available in database"
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "TESTING FEED ENDPOINT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Test 1: Get feed for User 1 (follows User 2)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/feed?userId=1" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 2: Get feed for User 3 (follows User 1 and User 2)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/feed?userId=3" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 3: Feed with pagination - limit 2" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/feed?userId=3&limit=2" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 4: Feed with offset" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/feed?userId=3&limit=2&offset=1" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 5: User who doesn't follow anyone (User 2)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/feed?userId=2" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 6: Missing userId parameter (should fail)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/feed" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host $reader.ReadToEnd()
}
Write-Host ""

Write-Host "Test 7: Non-existent user" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/feed?userId=999" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "All tests completed!" -ForegroundColor Green
