import { Request, Response } from 'express';
import { AppDataSource } from '../data-source';
import { Post } from '../entities/Post';
import { Follow } from '../entities/Follow';
import { Like } from '../entities/Like';
import { PostHashtag } from '../entities/PostHashtag';
import { Hashtag } from '../entities/Hashtag';

export class FeedController {
  async getFeed(req: Request, res: Response) {
    try {
      const userId = parseInt(req.query.userId as string, 10);
      const limit = parseInt(req.query.limit as string, 10) || 10;
      const offset = parseInt(req.query.offset as string, 10) || 0;

      if (Number.isNaN(userId)) {
        return res.status(400).json({ message: 'userId is required' });
      }

      const query = AppDataSource.getRepository(Post)
        .createQueryBuilder('post')
        .innerJoin(Follow, 'follow', 'follow.followingId = post.userId')
        .leftJoinAndSelect('post.author', 'author')
        .leftJoin(Like, 'like', 'like.postId = post.id')
        .leftJoin(PostHashtag, 'ph', 'ph.postId = post.id')
        .leftJoin(Hashtag, 'hashtag', 'hashtag.id = ph.hashtagId')
        .where('follow.followerId = :userId', { userId })
        .select([
          'post.id',
          'post.content',
          'post.createdAt',
          'author.id',
          'author.firstName',
          'author.lastName',
        ])
        .addSelect('COUNT(DISTINCT like.id)', 'likeCount')
        // GROUP_CONCAT is used here because the project uses SQLite
        .addSelect('GROUP_CONCAT(DISTINCT hashtag.name)', 'hashtags')
        .groupBy('post.id')
        .addGroupBy('author.id')
        .orderBy('post.createdAt', 'DESC')
        .limit(limit)
        .offset(offset);

      const { entities, raw } = await query.getRawAndEntities();

      const response = entities.map((post, index) => ({
        id: post.id,
        content: post.content,
        createdAt: post.createdAt,
        author: {
          id: post.author.id,
          firstName: post.author.firstName,
          lastName: post.author.lastName,
        },
        likeCount: Number(raw[index].likeCount) || 0,
        hashtags: raw[index].hashtags ? raw[index].hashtags.split(',') : [],
      }));

      res.json(response);
    } catch (error) {
      res.status(500).json({ message: 'Error fetching feed', error });
    }
  }
}
