import { Router } from 'express';
import { validate } from '../middleware/validation.middleware';
import { createLikeSchema, deleteLikeSchema } from '../validations/like.validation';
import { LikeController } from '../controllers/like.controller';

export const likeRouter = Router();
const likeController = new LikeController();

// Like a post
likeRouter.post('/', validate(createLikeSchema), likeController.likePost.bind(likeController));

// Unlike a post
likeRouter.delete('/', validate(deleteLikeSchema), likeController.unlikePost.bind(likeController));
