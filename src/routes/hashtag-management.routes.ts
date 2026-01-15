import { Router } from 'express';
import { HashtagManagementController } from '../controllers/hashtag-management.controller';

export const hashtagManagementRouter = Router();
const controller = new HashtagManagementController();

hashtagManagementRouter.post('/', controller.createHashtag.bind(controller));
