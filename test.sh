#!/bin/bash

# Base URLs
USERS_URL="http://localhost:3000/api/users"
POSTS_URL="http://localhost:3000/api/posts"
FOLLOWS_URL="http://localhost:3000/api/follows"
LIKES_URL="http://localhost:3000/api/likes"
FEED_URL="http://localhost:3000/api/feed"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${GREEN}=== $1 ===${NC}"
}

# Function to make API requests
make_request() {
    local method=$1
    local endpoint=$2
    local data=$3
    
    echo "Request: $method $endpoint"
    if [ -n "$data" ]; then
        echo "Data: $data"
    fi
    
    if [ "$method" = "GET" ]; then
        curl -s -X $method "$endpoint" | python -m json.tool 2>/dev/null || curl -s -X $method "$endpoint"
    else
        curl -s -X $method "$endpoint" -H "Content-Type: application/json" -d "$data" | python -m json.tool 2>/dev/null || curl -s -X $method "$endpoint" -H "Content-Type: application/json" -d "$data"
    fi
    echo ""
}

# User-related functions
test_get_all_users() {
    print_header "Testing GET all users"
    make_request "GET" "$USERS_URL"
}

test_get_user() {
    print_header "Testing GET user by ID"
    read -p "Enter user ID: " user_id
    make_request "GET" "$USERS_URL/$user_id"
}

test_create_user() {
    print_header "Testing POST create user"
    read -p "Enter first name: " firstName
    read -p "Enter last name: " lastName
    read -p "Enter email: " email
    
    local user_data=$(cat <<EOF
{
    "firstName": "$firstName",
    "lastName": "$lastName",
    "email": "$email"
}
EOF
)
    make_request "POST" "$USERS_URL" "$user_data"
}

test_update_user() {
    print_header "Testing PUT update user"
    read -p "Enter user ID to update: " user_id
    read -p "Enter new first name (press Enter to keep current): " firstName
    read -p "Enter new last name (press Enter to keep current): " lastName
    read -p "Enter new email (press Enter to keep current): " email
    
    local update_data="{"
    local has_data=false
    
    if [ -n "$firstName" ]; then
        update_data+="\"firstName\": \"$firstName\""
        has_data=true
    fi
    
    if [ -n "$lastName" ]; then
        if [ "$has_data" = true ]; then
            update_data+=","
        fi
        update_data+="\"lastName\": \"$lastName\""
        has_data=true
    fi
    
    if [ -n "$email" ]; then
        if [ "$has_data" = true ]; then
            update_data+=","
        fi
        update_data+="\"email\": \"$email\""
        has_data=true
    fi
    
    update_data+="}"
    
    make_request "PUT" "$USERS_URL/$user_id" "$update_data"
}

test_delete_user() {
    print_header "Testing DELETE user"
    read -p "Enter user ID to delete: " user_id
    make_request "DELETE" "$USERS_URL/$user_id"
}

# Post-related functions
test_get_all_posts() {
    print_header "Testing GET all posts"
    make_request "GET" "$POSTS_URL"
}

test_get_post() {
    print_header "Testing GET post by ID"
    read -p "Enter post ID: " post_id
    make_request "GET" "$POSTS_URL/$post_id"
}

test_create_post() {
    print_header "Testing POST create post"
    read -p "Enter content: " content
    read -p "Enter userId: " userId
    
    local post_data=$(cat <<EOF
{
    "content": "$content",
    "userId": $userId
}
EOF
)
    make_request "POST" "$POSTS_URL" "$post_data"
}

test_update_post() {
    print_header "Testing PUT update post"
    read -p "Enter post ID to update: " post_id
    read -p "Enter new content: " content
    
    local update_data=$(cat <<EOF
{
    "content": "$content"
}
EOF
)
    make_request "PUT" "$POSTS_URL/$post_id" "$update_data"
}

test_delete_post() {
    print_header "Testing DELETE post"
    read -p "Enter post ID to delete: " post_id
    make_request "DELETE" "$POSTS_URL/$post_id"
}

# Follow-related functions
test_follow_user() {
    print_header "Testing POST follow user"
    read -p "Enter follower user ID: " followerId
    read -p "Enter following user ID: " followingId
    
    local follow_data=$(cat <<EOF
{
    "followerId": $followerId,
    "followingId": $followingId
}
EOF
)
    make_request "POST" "$FOLLOWS_URL" "$follow_data"
}

test_unfollow_user() {
    print_header "Testing DELETE unfollow user"
    read -p "Enter follower user ID: " followerId
    read -p "Enter following user ID: " followingId
    
    local unfollow_data=$(cat <<EOF
{
    "followerId": $followerId,
    "followingId": $followingId
}
EOF
)
    make_request "DELETE" "$FOLLOWS_URL" "$unfollow_data"
}

# Like-related functions
test_like_post() {
    print_header "Testing POST like post"
    read -p "Enter user ID: " userId
    read -p "Enter post ID: " postId
    
    local like_data=$(cat <<EOF
{
    "userId": $userId,
    "postId": $postId
}
EOF
)
    make_request "POST" "$LIKES_URL" "$like_data"
}

test_unlike_post() {
    print_header "Testing DELETE unlike post"
    read -p "Enter user ID: " userId
    read -p "Enter post ID: " postId
    
    local unlike_data=$(cat <<EOF
{
    "userId": $userId,
    "postId": $postId
}
EOF
)
    make_request "DELETE" "$LIKES_URL" "$unlike_data"
}

# Special endpoint functions
test_get_feed() {
    print_header "Testing GET user feed"
    read -p "Enter user ID: " userId
    read -p "Enter limit (press Enter for default 10): " limit
    read -p "Enter offset (press Enter for default 0): " offset
    
    local url="$FEED_URL?userId=$userId"
    [ -n "$limit" ] && url+="&limit=$limit"
    [ -n "$offset" ] && url+="&offset=$offset"
    
    make_request "GET" "$url"
}

test_get_posts_by_hashtag() {
    print_header "Testing GET posts by hashtag"
    read -p "Enter hashtag (without #): " tag
    read -p "Enter limit (press Enter for default 10): " limit
    read -p "Enter offset (press Enter for default 0): " offset
    
    local url="$POSTS_URL/hashtag/$tag"
    local params=""
    [ -n "$limit" ] && params+="limit=$limit"
    [ -n "$offset" ] && [ -n "$params" ] && params+="&offset=$offset" || [ -n "$offset" ] && params+="offset=$offset"
    [ -n "$params" ] && url+="?$params"
    
    make_request "GET" "$url"
}

test_get_followers() {
    print_header "Testing GET user followers"
    read -p "Enter user ID: " user_id
    read -p "Enter limit (press Enter for default 10): " limit
    read -p "Enter offset (press Enter for default 0): " offset
    
    local url="$USERS_URL/$user_id/followers"
    local params=""
    [ -n "$limit" ] && params+="limit=$limit"
    [ -n "$offset" ] && [ -n "$params" ] && params+="&offset=$offset" || [ -n "$offset" ] && params+="offset=$offset"
    [ -n "$params" ] && url+="?$params"
    
    make_request "GET" "$url"
}

test_get_user_activity() {
    print_header "Testing GET user activity"
    read -p "Enter user ID: " user_id
    read -p "Enter type filter (post/like/follow, press Enter for all): " type
    read -p "Enter limit (press Enter for default 10): " limit
    read -p "Enter offset (press Enter for default 0): " offset
    
    local url="$USERS_URL/$user_id/activity"
    local params=""
    [ -n "$type" ] && params+="type=$type"
    [ -n "$limit" ] && [ -n "$params" ] && params+="&limit=$limit" || [ -n "$limit" ] && params+="limit=$limit"
    [ -n "$offset" ] && [ -n "$params" ] && params+="&offset=$offset" || [ -n "$offset" ] && params+="offset=$offset"
    [ -n "$params" ] && url+="?$params"
    
    make_request "GET" "$url"
}

# Submenu functions
show_users_menu() {
    echo -e "\n${GREEN}Users Menu${NC}"
    echo "1. Get all users"
    echo "2. Get user by ID"
    echo "3. Create new user"
    echo "4. Update user"
    echo "5. Delete user"
    echo "6. Back to main menu"
    echo -n "Enter your choice (1-6): "
}

show_posts_menu() {
    echo -e "\n${GREEN}Posts Menu${NC}"
    echo "1. Get all posts"
    echo "2. Get post by ID"
    echo "3. Create new post"
    echo "4. Update post"
    echo "5. Delete post"
    echo "6. Back to main menu"
    echo -n "Enter your choice (1-6): "
}

show_follows_menu() {
    echo -e "\n${GREEN}Follows Menu${NC}"
    echo "1. Follow a user"
    echo "2. Unfollow a user"
    echo "3. Back to main menu"
    echo -n "Enter your choice (1-3): "
}

show_likes_menu() {
    echo -e "\n${GREEN}Likes Menu${NC}"
    echo "1. Like a post"
    echo "2. Unlike a post"
    echo "3. Back to main menu"
    echo -n "Enter your choice (1-3): "
}

show_special_menu() {
    echo -e "\n${GREEN}Special Endpoints Menu${NC}"
    echo "1. Get user feed"
    echo "2. Get posts by hashtag"
    echo "3. Get user followers"
    echo "4. Get user activity"
    echo "5. Back to main menu"
    echo -n "Enter your choice (1-5): "
}

# Main menu
show_main_menu() {
    echo -e "\n${GREEN}API Testing Menu${NC}"
    echo "1. Users"
    echo "2. Posts"
    echo "3. Follows"
    echo "4. Likes"
    echo "5. Special Endpoints"
    echo "6. Exit"
    echo -n "Enter your choice (1-6): "
}

# Main loop
while true; do
    show_main_menu
    read choice
    case $choice in
        1)
            while true; do
                show_users_menu
                read user_choice
                case $user_choice in
                    1) test_get_all_users ;;
                    2) test_get_user ;;
                    3) test_create_user ;;
                    4) test_update_user ;;
                    5) test_delete_user ;;
                    6) break ;;
                    *) echo "Invalid choice. Please try again." ;;
                esac
            done
            ;;
        2)
            while true; do
                show_posts_menu
                read post_choice
                case $post_choice in
                    1) test_get_all_posts ;;
                    2) test_get_post ;;
                    3) test_create_post ;;
                    4) test_update_post ;;
                    5) test_delete_post ;;
                    6) break ;;
                    *) echo "Invalid choice. Please try again." ;;
                esac
            done
            ;;
        3)
            while true; do
                show_follows_menu
                read follow_choice
                case $follow_choice in
                    1) test_follow_user ;;
                    2) test_unfollow_user ;;
                    3) break ;;
                    *) echo "Invalid choice. Please try again." ;;
                esac
            done
            ;;
        4)
            while true; do
                show_likes_menu
                read like_choice
                case $like_choice in
                    1) test_like_post ;;
                    2) test_unlike_post ;;
                    3) break ;;
                    *) echo "Invalid choice. Please try again." ;;
                esac
            done
            ;;
        5)
            while true; do
                show_special_menu
                read special_choice
                case $special_choice in
                    1) test_get_feed ;;
                    2) test_get_posts_by_hashtag ;;
                    3) test_get_followers ;;
                    4) test_get_user_activity ;;
                    5) break ;;
                    *) echo "Invalid choice. Please try again." ;;
                esac
            done
            ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done 