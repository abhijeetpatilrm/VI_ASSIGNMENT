import { Router } from 'express';
import { FeedController } from '../controllers/feed.controller';

export const feedRouter = Router();
const feedController = new FeedController();

// Get user feed
feedRouter.get('/', feedController.getFeed.bind(feedController));
