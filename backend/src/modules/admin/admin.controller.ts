import { Request, Response, NextFunction } from 'express';
import { adminService } from './admin.service';

export const adminController = {
  async getDashboard(req: Request, res: Response, next: NextFunction) {
    try {
      const stats = await adminService.getDashboardStats();
      res.json({ success: true, data: stats });
    } catch (err) {
      next(err);
    }
  },

  async getAllUsers(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const role = req.query.role as string | undefined;
      const result = await adminService.getAllUsers({ page, limit, role });
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async getAllMissions(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const status = req.query.status as string | undefined;
      const result = await adminService.getAllMissions({ page, limit, status });
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async toggleUserStatus(req: Request, res: Response, next: NextFunction) {
    try {
      const { isActive } = req.body;
      const user = await adminService.toggleUserStatus(req.params.userId, isActive);
      res.json({ success: true, data: user });
    } catch (err) {
      next(err);
    }
  },

  async getCommissions(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const isPaid = req.query.isPaid !== undefined ? req.query.isPaid === 'true' : undefined;
      const result = await adminService.getCommissions({ page, limit, isPaid });
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async markCommissionPaid(req: Request, res: Response, next: NextFunction) {
    try {
      const commission = await adminService.markCommissionPaid(req.params.id);
      res.json({ success: true, data: commission });
    } catch (err) {
      next(err);
    }
  },
};
