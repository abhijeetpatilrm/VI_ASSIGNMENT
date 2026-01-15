# Design Document

## Database Schema

Built a simple relational model using TypeORM with SQLite. Here's what we have:

**Core entities:**
- `users` - basic user info (firstName, lastName, email)
- `posts` - user-created content with a userId foreign key
- `follows` - join table tracking who follows who (followerId, followingId)
- `likes` - join table linking users to posts they liked
- `hashtags` - normalized hashtag storage (just id and name)
- `post_hashtags` - join table linking posts to hashtags

**Why this structure:**
- Kept User simple - no password/auth stuff since that wasn't required
- Used explicit join tables (follows, likes, post_hashtags) instead of many-to-many because it's clearer and easier to query
- Hashtags are normalized so we don't store "#backend" 100 times
- All relationships use foreign keys with `NO ACTION` on delete (didn't add cascades to keep it predictable)

## Indexing Strategy

SQLite auto-indexes primary keys and foreign keys, which covers most of our queries. For this assignment scope, that's enough.

**If this were going to production, I'd add:**
- Index on `posts.userId` for faster feed queries
- Index on `follows.followerId` and `follows.followingId` separately
- Composite index on `post_hashtags(postId, hashtagId)` to prevent duplicates
- Index on `hashtags.name` for hashtag lookups

But for a few hundred test records, the default indexes work fine.

## API Design Decisions

**Query patterns:**
- Used TypeORM QueryBuilder for complex queries (feed, hashtags, followers) to avoid N+1 problems
- Kept simple CRUD operations using basic repository methods
- Added pagination with `limit` and `offset` on all list endpoints (defaulting to 10)

**Activity endpoint:**
- Fetches posts, likes, and follows separately then merges in memory
- Not the most efficient but keeps the code readable and easy to debug
- For a real app with lots of data, I'd use a proper activity log table instead

**Feed endpoint:**
- Joins through the follows table to get posts from followed users
- Aggregates like counts and hashtags in a single query using GROUP_CONCAT (SQLite-specific)
- Could be slow with thousands of posts, but works well for the assignment scope

## Scalability Thoughts

This is obviously not production-ready, but here's what I'd change for scale:

**Database:**
- Switch from SQLite to PostgreSQL (SQLite is single-file, not great for concurrent writes)
- Add proper indexes mentioned above
- Consider denormalizing like counts on posts table to avoid COUNT queries

**Caching:**
- Cache feed results per user (they don't change that often)
- Cache popular hashtag queries
- Use Redis or similar

**Architecture:**
- The hashtag parsing happens in the controller - in production I'd use a post-creation hook or background job
- Activity endpoint does too much work - would use an activity stream table that gets written to on each action
- No rate limiting or pagination cursors (offset gets slow with large datasets)

## What I Kept Simple

- No authentication/authorization - wasn't required
- No soft deletes - hard deletes are fine for this scope
- No data validation beyond Joi schemas - trusted the database constraints
- SQLite instead of Postgres - easier to run and test
- Migrations are timestamped and manual - didn't use auto-sync

## Testing Approach

Built PowerShell test scripts instead of unit tests because:
- Faster to verify endpoints work end-to-end
- Shows the API actually does what it should
- Easier to debug when something breaks

For production code I'd add proper tests with Jest/Mocha.
