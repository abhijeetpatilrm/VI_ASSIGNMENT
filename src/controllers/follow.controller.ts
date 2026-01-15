import { Request, Response } from 'express';
import { Follow } from '../entities/Follow';
import { User } from '../entities/User';
import { AppDataSource } from '../data-source';

export class FollowController {
  private followRepository = AppDataSource.getRepository(Follow);
  private userRepository = AppDataSource.getRepository(User);

  async followUser(req: Request, res: Response) {
    try {
      const { followerId, followingId } = req.body;

      const follower = await this.userRepository.findOneBy({ id: followerId });
      if (!follower) {
        return res.status(404).json({ message: 'Follower user not found' });
      }

      const following = await this.userRepository.findOneBy({ id: followingId });
      if (!following) {
        return res.status(404).json({ message: 'Following user not found' });
      }

      const existingFollow = await this.followRepository.findOneBy({
        followerId,
        followingId,
      });
      if (existingFollow) {
        return res.status(400).json({ message: 'Already following this user' });
      }

      const follow = this.followRepository.create({ followerId, followingId });
      const result = await this.followRepository.save(follow);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ message: 'Error following user', error });
    }
  }

  async unfollowUser(req: Request, res: Response) {
    try {
      const { followerId, followingId } = req.body;

      const existingFollow = await this.followRepository.findOneBy({
        followerId,
        followingId,
      });
      if (!existingFollow) {
        return res.status(404).json({ message: 'Follow relationship not found' });
      }

      await this.followRepository.remove(existingFollow);
      res.status(204).send();
    } catch (error) {
      res.status(500).json({ message: 'Error unfollowing user', error });
    }
  }
}
