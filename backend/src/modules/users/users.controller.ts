import { Request, Response, NextFunction } from 'express';
import { usersService } from './users.service';

export const usersController = {
  async getProfile(req: Request, res: Response, next: NextFunction) {
    try {
      const user = await usersService.getProfile(req.user!.userId);
      res.json({ success: true, data: user });
    } catch (err) {
      next(err);
    }
  },

  async updateProfile(req: Request, res: Response, next: NextFunction) {
    try {
      const user = await usersService.updateProfile(req.user!.userId, req.body);
      res.json({ success: true, data: user });
    } catch (err) {
      next(err);
    }
  },

  async getTransporteurs(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const result = await usersService.getTransporteurs({ page, limit });
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },
};
