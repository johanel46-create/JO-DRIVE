import { Request, Response, NextFunction } from 'express';
import { ratingsService } from './ratings.service';

export const ratingsController = {
  async getUserRatings(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.params.userId ?? req.user!.userId;
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const result = await ratingsService.getUserRatings(userId, page, limit);
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async getRatingById(req: Request, res: Response, next: NextFunction) {
    try {
      const rating = await ratingsService.getRatingById(req.params.id);
      res.json({ success: true, data: rating });
    } catch (err) {
      next(err);
    }
  },
};
