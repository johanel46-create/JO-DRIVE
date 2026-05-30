import { Request, Response, NextFunction } from 'express';
import { missionsService } from './missions.service';

export const missionsController = {
  async getMyMissions(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const { userId, role } = req.user!;

      let result;
      if (role === 'CLIENT') {
        result = await missionsService.getClientMissions(userId, page, limit);
      } else {
        result = await missionsService.getTransporteurMissions(userId, page, limit);
      }

      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async getAvailable(req: Request, res: Response, next: NextFunction) {
    try {
      const missions = await missionsService.getAvailableMissions();
      res.json({ success: true, data: missions });
    } catch (err) {
      next(err);
    }
  },

  async getMissionById(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.getMissionById(req.params.id, req.user!.userId);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async createMission(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.createMission(req.user!.userId, req.body);
      res.status(201).json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async acceptMission(req: Request, res: Response, next: NextFunction) {
    try {
      const { vehicleId } = req.body;
      const mission = await missionsService.acceptMission(req.params.id, req.user!.userId, vehicleId);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async startMission(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.startMission(req.params.id, req.user!.userId);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async completeMission(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.completeMission(req.params.id, req.user!.userId);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async cancelMission(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.cancelMission(req.params.id, req.user!.userId, req.body.reason);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async rateMission(req: Request, res: Response, next: NextFunction) {
    try {
      const { score, comment } = req.body;
      const rating = await missionsService.rateMission(req.params.id, req.user!.userId, score, comment);
      res.status(201).json({ success: true, data: rating });
    } catch (err) {
      next(err);
    }
  },
};
