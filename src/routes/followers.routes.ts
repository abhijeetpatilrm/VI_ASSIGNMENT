import { Router } from 'express';
import { FollowersController } from '../controllers/followers.controller';

export const followersRouter = Router();
const followersController = new FollowersController();

// Get user followers
followersRouter.get('/:id/followers', followersController.getFollowers.bind(followersController));
