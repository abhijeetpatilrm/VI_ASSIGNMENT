import { Router } from 'express';
import { HashtagController } from '../controllers/hashtag.controller';

export const hashtagRouter = Router();
const hashtagController = new HashtagController();

// Get posts by hashtag
hashtagRouter.get('/hashtag/:tag', hashtagController.getPostsByHashtag.bind(hashtagController));
