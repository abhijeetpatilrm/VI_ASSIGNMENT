import { Router } from 'express';
import { validate } from '../middleware/validation.middleware';
import { createFollowSchema, deleteFollowSchema } from '../validations/follow.validation';
import { FollowController } from '../controllers/follow.controller';

export const followRouter = Router();
const followController = new FollowController();

// Follow a user
followRouter.post('/', validate(createFollowSchema), followController.followUser.bind(followController));

// Unfollow a user
followRouter.delete('/', validate(deleteFollowSchema), followController.unfollowUser.bind(followController));
