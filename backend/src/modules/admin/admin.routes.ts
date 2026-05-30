import { Router } from 'express';
import { adminController } from './admin.controller';
import { authenticate, authorize } from '../../middleware/auth';

const router = Router();

router.use(authenticate, authorize('ADMIN'));

router.get('/dashboard', adminController.getDashboard);
router.get('/users', adminController.getAllUsers);
router.patch('/users/:userId/status', adminController.toggleUserStatus);
router.get('/missions', adminController.getAllMissions);
router.get('/commissions', adminController.getCommissions);
router.patch('/commissions/:id/pay', adminController.markCommissionPaid);

export default router;
