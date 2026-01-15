# Test Like Feature

Write-Host "Testing Like APIs..." -ForegroundColor Cyan
Write-Host ""

Write-Host "Getting existing posts..." -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/posts" -Method GET -UseBasicParsing
Write-Host $response.Content
Write-Host ""

Write-Host "1. User 1 likes Post 1:" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"userId":1,"postId":1}' -UseBasicParsing
Write-Host $response.Content
Write-Host ""

Write-Host "2. Duplicate like (should fail with 400):" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"userId":1,"postId":1}' -UseBasicParsing
    Write-Host $response.Content
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host $reader.ReadToEnd()
}
Write-Host ""

Write-Host "3. User 2 likes Post 1:" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"userId":2,"postId":1}' -UseBasicParsing
Write-Host $response.Content
Write-Host ""

Write-Host "4. User 1 likes Post 2:" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"userId":1,"postId":2}' -UseBasicParsing
Write-Host $response.Content
Write-Host ""

Write-Host "5. User 1 unlikes Post 1:" -ForegroundColor Yellow
$response = Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method DELETE -Headers @{"Content-Type"="application/json"} -Body '{"userId":1,"postId":1}' -UseBasicParsing
Write-Host "Status: $($response.StatusCode) - Success"
Write-Host ""

Write-Host "6. Unlike again (should fail with 404):" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method DELETE -Headers @{"Content-Type"="application/json"} -Body '{"userId":1,"postId":1}' -UseBasicParsing
    Write-Host $response.Content
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host $reader.ReadToEnd()
}
Write-Host ""

Write-Host "7. Like non-existent post (should fail with 404):" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"userId":1,"postId":999}' -UseBasicParsing
    Write-Host $response.Content
} catch {
    Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Host $reader.ReadToEnd()
}
Write-Host ""

Write-Host "All tests completed!" -ForegroundColor Green
