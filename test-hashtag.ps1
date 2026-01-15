# Test Hashtag Endpoint

Write-Host "Testing Hashtag API..." -ForegroundColor Cyan
Write-Host ""

Write-Host "Setup: Creating test data..." -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Creating users..." -ForegroundColor Yellow
$user1 = Invoke-WebRequest -Uri "http://localhost:3000/api/users" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"firstName":"Alice","lastName":"Developer","email":"alice.dev@test.com"}' -UseBasicParsing
Write-Host $user1.Content
$user2 = Invoke-WebRequest -Uri "http://localhost:3000/api/users" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"firstName":"Bob","lastName":"Engineer","email":"bob.eng@test.com"}' -UseBasicParsing
Write-Host $user2.Content
Write-Host ""

Write-Host "2. Creating posts with hashtags..." -ForegroundColor Yellow
Write-Host "Post 1: #backend #nodejs"
$post1 = Invoke-WebRequest -Uri "http://localhost:3000/api/posts" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"content":"Learning backend development #backend #nodejs","userId":1}' -UseBasicParsing
Write-Host $post1.Content
Start-Sleep -Milliseconds 500

Write-Host "Post 2: #backend #typescript"
$post2 = Invoke-WebRequest -Uri "http://localhost:3000/api/posts" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"content":"TypeScript is awesome #backend #typescript","userId":2}' -UseBasicParsing
Write-Host $post2.Content
Start-Sleep -Milliseconds 500

Write-Host "Post 3: #frontend #react"
$post3 = Invoke-WebRequest -Uri "http://localhost:3000/api/posts" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"content":"Building UIs with React #frontend #react","userId":1}' -UseBasicParsing
Write-Host $post3.Content
Start-Sleep -Milliseconds 500

Write-Host "Post 4: #backend #database"
$post4 = Invoke-WebRequest -Uri "http://localhost:3000/api/posts" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"content":"Database design patterns #backend #database","userId":2}' -UseBasicParsing
Write-Host $post4.Content
Write-Host ""

Write-Host "3. Creating hashtags in database..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "http://localhost:3000/api/hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"backend"}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"nodejs"}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"typescript"}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"frontend"}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"react"}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"name":"database"}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Write-Host "Hashtags created"
Write-Host ""

Write-Host "4. Linking posts to hashtags..." -ForegroundColor Yellow
# Post 1 -> backend, nodejs
Invoke-WebRequest -Uri "http://localhost:3000/api/post-hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"postId":1,"hashtagId":1}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/post-hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"postId":1,"hashtagId":2}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
# Post 2 -> backend, typescript
Invoke-WebRequest -Uri "http://localhost:3000/api/post-hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"postId":2,"hashtagId":1}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/post-hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"postId":2,"hashtagId":3}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
# Post 3 -> frontend, react
Invoke-WebRequest -Uri "http://localhost:3000/api/post-hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"postId":3,"hashtagId":4}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/post-hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"postId":3,"hashtagId":5}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
# Post 4 -> backend, database
Invoke-WebRequest -Uri "http://localhost:3000/api/post-hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"postId":4,"hashtagId":1}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/post-hashtags" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"postId":4,"hashtagId":6}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Write-Host "Post-hashtag links created"
Write-Host ""

Write-Host "5. Adding some likes..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"userId":1,"postId":2}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"userId":2,"postId":1}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Invoke-WebRequest -Uri "http://localhost:3000/api/likes" -Method POST -Headers @{"Content-Type"="application/json"} -Body '{"userId":2,"postId":4}' -UseBasicParsing -ErrorAction SilentlyContinue | Out-Null
Write-Host "Likes added"
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "TESTING HASHTAG ENDPOINT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Test 1: Get posts with #backend hashtag" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/posts/hashtag/backend" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 2: Case-insensitive (#BACKEND)" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/posts/hashtag/BACKEND" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 3: Pagination - limit 2" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/posts/hashtag/backend?limit=2" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 4: Pagination - offset 1, limit 2" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/posts/hashtag/backend?limit=2&offset=1" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "Test 5: Non-existent hashtag" -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/api/posts/hashtag/nonexistent" -Method GET -UseBasicParsing
    Write-Host "Status: $($response.StatusCode)"
    Write-Host $response.Content
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

Write-Host "All tests completed!" -ForegroundColor Green
