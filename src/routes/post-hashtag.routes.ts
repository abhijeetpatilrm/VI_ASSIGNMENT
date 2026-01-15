import { Router } from 'express';
import { HashtagManagementController } from '../controllers/hashtag-management.controller';

export const postHashtagRouter = Router();
const controller = new HashtagManagementController();

postHashtagRouter.post('/', controller.linkPostHashtag.bind(controller));
