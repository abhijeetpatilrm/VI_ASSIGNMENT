import { Router } from 'express';
import { ActivityController } from '../controllers/activity.controller';

export const activityRouter = Router();
const activityController = new ActivityController();

// Get user activity
activityRouter.get('/:id/activity', activityController.getUserActivity.bind(activityController));
