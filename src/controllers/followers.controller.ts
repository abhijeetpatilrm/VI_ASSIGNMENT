import { Request, Response } from 'express';
import { AppDataSource } from '../data-source';
import { User } from '../entities/User';
import { Follow } from '../entities/Follow';

export class FollowersController {
  async getFollowers(req: Request, res: Response) {
    try {
      const userId = parseInt(req.params.id, 10);
      const limit = parseInt(req.query.limit as string, 10) || 10;
      const offset = parseInt(req.query.offset as string, 10) || 0;

      if (Number.isNaN(userId)) {
        return res.status(400).json({ message: 'Invalid user id' });
      }

      // Total follower count
      const totalCount = await AppDataSource.getRepository(Follow)
        .createQueryBuilder('follow')
        .where('follow.followingId = :userId', { userId })
        .getCount();

      // Followers list
      const query = AppDataSource.getRepository(User)
        .createQueryBuilder('user')
        .innerJoin(Follow, 'follow', 'follow.followerId = user.id')
        .where('follow.followingId = :userId', { userId })
        .select(['user.id', 'user.firstName', 'user.lastName'])
        .addSelect('follow.createdAt', 'followedAt')
        .orderBy('follow.createdAt', 'DESC')
        .limit(limit)
        .offset(offset);

      const { entities, raw } = await query.getRawAndEntities();

      const followers = entities.map((user, index) => ({
        id: user.id,
        firstName: user.firstName,
        lastName: user.lastName,
        followedAt: raw[index].followedAt,
      }));

      res.json({
        total: totalCount,
        followers,
      });
    } catch (error) {
      res.status(500).json({ message: 'Error fetching followers', error });
    }
  }
}
