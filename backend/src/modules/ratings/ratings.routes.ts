import { Router } from 'express';
import { ratingsController } from './ratings.controller';
import { authenticate } from '../../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/me', ratingsController.getUserRatings);
router.get('/user/:userId', ratingsController.getUserRatings);
router.get('/:id', ratingsController.getRatingById);

export default router;
