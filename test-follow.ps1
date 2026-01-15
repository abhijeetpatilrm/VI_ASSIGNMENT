# Test Follow Feature

Write-Host "Testing Follow APIs..." -ForegroundColor Cyan
Write-Host ""

Write-Host "1. User 1 follows User 2:" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"followerId":1,"followingId":2}'
Write-Host $response.Content
Write-Host ""

Write-Host "2. Duplicate follow (should fail with 400):" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"followerId":1,"followingId":2}'
    Write-Host $response.Content
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host $reader.ReadToEnd()
}
Write-Host ""

Write-Host "3. Self-follow (should fail with validation error):" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"followerId":1,"followingId":1}'
    Write-Host $response.Content
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host $reader.ReadToEnd()
}
Write-Host ""

Write-Host "4. User 3 follows User 4:" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"followerId":3,"followingId":4}'
Write-Host $response.Content
Write-Host ""

Write-Host "5. Unfollow User 2:" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method DELETE -Headers @{"Content-Type"="application/json"} -Body '{"followerId":1,"followingId":2}'
Write-Host "Status: $($response.StatusCode) - Success"
Write-Host ""

Write-Host "6. Unfollow again (should fail with 404):" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/follows" -Method DELETE -Headers @{"Content-Type"="application/json"} -Body '{"followerId":1,"followingId":2}'
    Write-Host $response.Content
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host $reader.ReadToEnd()
}
Write-Host ""

Write-Host "All tests completed!" -ForegroundColor Green
