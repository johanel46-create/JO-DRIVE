import { Router } from 'express';
import { vehiclesController } from './vehicles.controller';
import { authenticate, authorize } from '../../middleware/auth';

const router = Router();

router.use(authenticate, authorize('TRANSPORTEUR', 'ADMIN'));

router.get('/', vehiclesController.getMyVehicles);
router.get('/:id', vehiclesController.getVehicleById);
router.post('/', vehiclesController.createVehicle);
router.patch('/:id', vehiclesController.updateVehicle);
router.delete('/:id', vehiclesController.deleteVehicle);

export default router;
