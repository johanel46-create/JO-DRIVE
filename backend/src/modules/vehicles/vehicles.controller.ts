import { Request, Response, NextFunction } from 'express';
import { vehiclesService } from './vehicles.service';

export const vehiclesController = {
  async getMyVehicles(req: Request, res: Response, next: NextFunction) {
    try {
      const vehicles = await vehiclesService.getMyVehicles(req.user!.userId);
      res.json({ success: true, data: vehicles });
    } catch (err) {
      next(err);
    }
  },

  async getVehicleById(req: Request, res: Response, next: NextFunction) {
    try {
      const vehicle = await vehiclesService.getVehicleById(req.params.id, req.user!.userId);
      res.json({ success: true, data: vehicle });
    } catch (err) {
      next(err);
    }
  },

  async createVehicle(req: Request, res: Response, next: NextFunction) {
    try {
      const vehicle = await vehiclesService.createVehicle(req.user!.userId, req.body);
      res.status(201).json({ success: true, data: vehicle });
    } catch (err) {
      next(err);
    }
  },

  async updateVehicle(req: Request, res: Response, next: NextFunction) {
    try {
      const vehicle = await vehiclesService.updateVehicle(
        req.params.id,
        req.user!.userId,
        req.body,
      );
      res.json({ success: true, data: vehicle });
    } catch (err) {
      next(err);
    }
  },

  async deleteVehicle(req: Request, res: Response, next: NextFunction) {
    try {
      await vehiclesService.deleteVehicle(req.params.id, req.user!.userId);
      res.json({ success: true, message: 'Véhicule supprimé' });
    } catch (err) {
      next(err);
    }
  },
};
