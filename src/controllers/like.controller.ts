import { Request, Response } from 'express';
import { Like } from '../entities/Like';
import { User } from '../entities/User';
import { Post } from '../entities/Post';
import { AppDataSource } from '../data-source';

export class LikeController {
  private likeRepository = AppDataSource.getRepository(Like);
  private userRepository = AppDataSource.getRepository(User);
  private postRepository = AppDataSource.getRepository(Post);

  async likePost(req: Request, res: Response) {
    try {
      const { userId, postId } = req.body;

      const user = await this.userRepository.findOneBy({ id: userId });
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      const post = await this.postRepository.findOneBy({ id: postId });
      if (!post) {
        return res.status(404).json({ message: 'Post not found' });
      }

      const existingLike = await this.likeRepository.findOneBy({
        userId,
        postId,
      });
      if (existingLike) {
        return res.status(400).json({ message: 'Already liked this post' });
      }

      const like = this.likeRepository.create({ userId, postId });
      const result = await this.likeRepository.save(like);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ message: 'Error liking post', error });
    }
  }

  async unlikePost(req: Request, res: Response) {
    try {
      const { userId, postId } = req.body;

      const existingLike = await this.likeRepository.findOneBy({
        userId,
        postId,
      });
      if (!existingLike) {
        return res.status(404).json({ message: 'Like not found' });
      }

      await this.likeRepository.remove(existingLike);
      res.status(204).send();
    } catch (error) {
      res.status(500).json({ message: 'Error unliking post', error });
    }
  }
}
