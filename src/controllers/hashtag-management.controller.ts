import { Request, Response } from 'express';
import { Hashtag } from '../entities/Hashtag';
import { PostHashtag } from '../entities/PostHashtag';
import { AppDataSource } from '../data-source';

export class HashtagManagementController {
  private hashtagRepository = AppDataSource.getRepository(Hashtag);
  private postHashtagRepository = AppDataSource.getRepository(PostHashtag);

  async createHashtag(req: Request, res: Response) {
    try {
      const { name } = req.body;
      const hashtag = this.hashtagRepository.create({ name: name.toLowerCase() });
      const result = await this.hashtagRepository.save(hashtag);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ message: 'Error creating hashtag', error });
    }
  }

  async linkPostHashtag(req: Request, res: Response) {
    try {
      const { postId, hashtagId } = req.body;
      const postHashtag = this.postHashtagRepository.create({ postId, hashtagId });
      const result = await this.postHashtagRepository.save(postHashtag);
      res.status(201).json(result);
    } catch (error) {
      res.status(500).json({ message: 'Error linking post to hashtag', error });
    }
  }
}
