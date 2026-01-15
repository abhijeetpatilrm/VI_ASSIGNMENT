@echo off
echo Testing User APIs...
echo.

echo Creating User 1:
curl.exe -X POST http://localhost:3000/api/users -H "Content-Type: application/json" -d "{\"firstName\":\"Alice\",\"lastName\":\"Smith\",\"email\":\"alice@test.com\"}"
echo.
echo.

echo Creating User 2:
curl.exe -X POST http://localhost:3000/api/users -H "Content-Type: application/json" -d "{\"firstName\":\"Bob\",\"lastName\":\"Jones\",\"email\":\"bob@test.com\"}"
echo.
echo.

echo Getting all users:
curl.exe -X GET http://localhost:3000/api/users
echo.
echo.

echo Testing Post APIs...
echo.

echo Creating Post for User 1:
curl.exe -X POST http://localhost:3000/api/posts -H "Content-Type: application/json" -d "{\"content\":\"Hello World! This is my first post.\",\"userId\":1}"
echo.
echo.

echo Creating Post for User 2:
curl.exe -X POST http://localhost:3000/api/posts -H "Content-Type: application/json" -d "{\"content\":\"Hey everyone! Nice to be here.\",\"userId\":2}"
echo.
echo.

echo Getting all posts:
curl.exe -X GET http://localhost:3000/api/posts
echo.
echo.

echo Testing Follow APIs...
echo.

echo User 1 follows User 2:
curl.exe -X POST http://localhost:3000/api/follows -H "Content-Type: application/json" -d "{\"followerId\":1,\"followingId\":2}"
echo.
echo.

echo Try to follow again (should fail):
curl.exe -X POST http://localhost:3000/api/follows -H "Content-Type: application/json" -d "{\"followerId\":1,\"followingId\":2}"
echo.
echo.

echo User 1 tries to follow themselves (should fail):
curl.exe -X POST http://localhost:3000/api/follows -H "Content-Type: application/json" -d "{\"followerId\":1,\"followingId\":1}"
echo.
echo.

echo User 1 unfollows User 2:
curl.exe -X DELETE http://localhost:3000/api/follows -H "Content-Type: application/json" -d "{\"followerId\":1,\"followingId\":2}"
echo.
echo.

echo Try to unfollow again (should fail - not found):
curl.exe -X DELETE http://localhost:3000/api/follows -H "Content-Type: application/json" -d "{\"followerId\":1,\"followingId\":2}"
echo.
echo.

echo All tests completed!
