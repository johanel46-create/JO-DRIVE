import { Router } from 'express';
import { usersController } from './users.controller';
import { authenticate } from '../../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/me', usersController.getProfile);
router.patch('/me', usersController.updateProfile);
router.get('/transporteurs', usersController.getTransporteurs);

export default router;
