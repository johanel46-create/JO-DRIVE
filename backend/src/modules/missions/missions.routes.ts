import { Router } from 'express';
import { missionsController } from './missions.controller';
import { authenticate, authorize } from '../../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/available', authorize('TRANSPORTEUR', 'ADMIN'), missionsController.getAvailable);
router.get('/', missionsController.getMyMissions);
router.get('/:id', missionsController.getMissionById);
router.post('/', authorize('CLIENT'), missionsController.createMission);
router.patch('/:id/accept', authorize('TRANSPORTEUR'), missionsController.acceptMission);
router.patch('/:id/start', authorize('TRANSPORTEUR'), missionsController.startMission);
router.patch('/:id/complete', authorize('TRANSPORTEUR'), missionsController.completeMission);
router.patch('/:id/cancel', missionsController.cancelMission);
router.post('/:id/rate', authorize('CLIENT'), missionsController.rateMission);

export default router;
