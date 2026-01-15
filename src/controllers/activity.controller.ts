import { Request, Response } from 'express';
import { AppDataSource } from '../data-source';
import { Post } from '../entities/Post';
import { Like } from '../entities/Like';
import { Follow } from '../entities/Follow';

export class ActivityController {
  async getUserActivity(req: Request, res: Response) {
    try {
      const userId = parseInt(req.params.id, 10);
      if (Number.isNaN(userId)) {
        return res.status(400).json({ message: 'Invalid user id' });
      }

      const type = req.query.type as string | undefined;

      const from = req.query.from ? new Date(req.query.from as string) : undefined;
      const to = req.query.to ? new Date(req.query.to as string) : undefined;

      const validFrom = from instanceof Date && !isNaN(from.getTime()) ? from : undefined;
      const validTo = to instanceof Date && !isNaN(to.getTime()) ? to : undefined;

      const limit = parseInt(req.query.limit as string, 10) || 10;
      const offset = parseInt(req.query.offset as string, 10) || 0;

      const activities: {
        type: 'post' | 'like' | 'follow';
        createdAt: Date;
        data: any;
      }[] = [];

      // Posts created
      if (!type || type === 'post') {
        const postQuery = AppDataSource.getRepository(Post)
          .createQueryBuilder('post')
          .where('post.userId = :userId', { userId });

        if (validFrom) postQuery.andWhere('post.createdAt >= :from', { from: validFrom });
        if (validTo) postQuery.andWhere('post.createdAt <= :to', { to: validTo });

        const posts = await postQuery.getMany();

        posts.forEach((post) => {
          activities.push({
            type: 'post',
            createdAt: post.createdAt,
            data: {
              postId: post.id,
              content: post.content,
            },
          });
        });
      }

      // Likes given
      if (!type || type === 'like') {
        const likeQuery = AppDataSource.getRepository(Like)
          .createQueryBuilder('like')
          .leftJoinAndSelect('like.post', 'post')
          .where('like.userId = :userId', { userId });

        if (validFrom) likeQuery.andWhere('like.createdAt >= :from', { from: validFrom });
        if (validTo) likeQuery.andWhere('like.createdAt <= :to', { to: validTo });

        const likes = await likeQuery.getMany();

        likes.forEach((like) => {
          activities.push({
            type: 'like',
            createdAt: like.createdAt,
            data: {
              likeId: like.id,
              postId: like.postId,
              postContent: like.post?.content,
            },
          });
        });
      }

      // Follow actions
      if (!type || type === 'follow') {
        const followQuery = AppDataSource.getRepository(Follow)
          .createQueryBuilder('follow')
          .leftJoinAndSelect('follow.following', 'following')
          .where('follow.followerId = :userId', { userId });

        if (validFrom) followQuery.andWhere('follow.createdAt >= :from', { from: validFrom });
        if (validTo) followQuery.andWhere('follow.createdAt <= :to', { to: validTo });

        const follows = await followQuery.getMany();

        follows.forEach((follow) => {
          activities.push({
            type: 'follow',
            createdAt: follow.createdAt,
            data: {
              followId: follow.id,
              followingId: follow.followingId,
              followingUser: {
                id: follow.following.id,
                firstName: follow.following.firstName,
                lastName: follow.following.lastName,
              },
            },
          });
        });
      }

      // Sort newest first
      activities.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());

      const total = activities.length;
      const paginated = activities.slice(offset, offset + limit);

      res.json({
        total,
        activities: paginated,
      });
    } catch (error) {
      res.status(500).json({ message: 'Error fetching user activity', error });
    }
  }
}
