import { Request, Response } from 'express';
import { AppDataSource } from '../data-source';
import { Post } from '../entities/Post';
import { PostHashtag } from '../entities/PostHashtag';
import { Hashtag } from '../entities/Hashtag';
import { Like } from '../entities/Like';

export class HashtagController {
  async getPostsByHashtag(req: Request, res: Response) {
    try {
      const tag = req.params.tag.toLowerCase();
      const limit = parseInt(req.query.limit as string) || 10;
      const offset = parseInt(req.query.offset as string) || 0;

      const query = AppDataSource.getRepository(Post)
        .createQueryBuilder('post')
        .innerJoin(PostHashtag, 'ph', 'ph.postId = post.id')
        .innerJoin(Hashtag, 'h', 'h.id = ph.hashtagId')
        .leftJoinAndSelect('post.author', 'author')
        .leftJoin(Like, 'like', 'like.postId = post.id')
        .where('LOWER(h.name) = :tag', { tag })
        .select([
          'post.id',
          'post.content',
          'post.createdAt',
          'author.id',
          'author.firstName',
          'author.lastName',
        ])
        .addSelect('COUNT(like.id)', 'likeCount')
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
      }));

      res.json(response);
    } catch (error) {
      res.status(500).json({ message: 'Error fetching posts by hashtag', error });
    }
  }
}
