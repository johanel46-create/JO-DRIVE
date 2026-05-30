import { prisma } from '../../config/database';
import { AppError } from '../../middleware/errorHandler';

export const adminService = {
  async getDashboardStats() {
    const [
      totalUsers,
      totalMissions,
      totalTransporteurs,
      pendingMissions,
      completedMissions,
      cancelledMissions,
      totalRevenue,
      totalCommissions,
    ] = await Promise.all([
      prisma.user.count(),
      prisma.mission.count(),
      prisma.user.count({ where: { role: 'TRANSPORTEUR' } }),
      prisma.mission.count({ where: { status: 'PENDING' } }),
      prisma.mission.count({ where: { status: 'COMPLETED' } }),
      prisma.mission.count({ where: { status: 'CANCELLED' } }),
      prisma.mission.aggregate({
        where: { status: 'COMPLETED' },
        _sum: { finalPrice: true },
      }),
      prisma.commission.aggregate({
        _sum: { amount: true },
      }),
    ]);

    return {
      users: { total: totalUsers, transporteurs: totalTransporteurs },
      missions: {
        total: totalMissions,
        pending: pendingMissions,
        completed: completedMissions,
        cancelled: cancelledMissions,
      },
      revenue: {
        total: totalRevenue._sum.finalPrice ?? 0,
        commissions: totalCommissions._sum.amount ?? 0,
      },
    };
  },

  async getAllUsers(params: { page?: number; limit?: number; role?: string }) {
    const page = params.page ?? 1;
    const limit = params.limit ?? 20;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (params.role) where.role = params.role;

    const [users, total] = await Promise.all([
      prisma.user.findMany({
        where,
        select: {
          id: true,
          email: true,
          phone: true,
          firstName: true,
          lastName: true,
          role: true,
          isVerified: true,
          isActive: true,
          createdAt: true,
          _count: {
            select: { missionsAsClient: true, missionsAsTransporteur: true },
          },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.user.count({ where }),
    ]);

    return { data: users, total, page, limit, totalPages: Math.ceil(total / limit) };
  },

  async getAllMissions(params: { page?: number; limit?: number; status?: string }) {
    const page = params.page ?? 1;
    const limit = params.limit ?? 20;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (params.status) where.status = params.status;

    const [missions, total] = await Promise.all([
      prisma.mission.findMany({
        where,
        include: {
          client: { select: { id: true, firstName: true, lastName: true } },
          transporteur: { select: { id: true, firstName: true, lastName: true } },
          items: true,
          commission: true,
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.mission.count({ where }),
    ]);

    return { data: missions, total, page, limit, totalPages: Math.ceil(total / limit) };
  },

  async toggleUserStatus(userId: string, isActive: boolean) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new AppError('Utilisateur introuvable', 404);
    if (user.role === 'ADMIN') throw new AppError('Impossible de désactiver un administrateur', 403);

    return prisma.user.update({
      where: { id: userId },
      data: { isActive },
      select: { id: true, email: true, isActive: true, role: true },
    });
  },

  async getCommissions(params: { page?: number; limit?: number; isPaid?: boolean }) {
    const page = params.page ?? 1;
    const limit = params.limit ?? 20;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (params.isPaid !== undefined) where.isPaid = params.isPaid;

    const [commissions, total] = await Promise.all([
      prisma.commission.findMany({
        where,
        include: {
          mission: {
            select: { id: true, pickupAddress: true, deliveryAddress: true, finalPrice: true },
          },
          transporteur: { select: { id: true, firstName: true, lastName: true } },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.commission.count({ where }),
    ]);

    const totalAmount = await prisma.commission.aggregate({
      where,
      _sum: { amount: true },
    });

    return {
      data: commissions,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      totalAmount: totalAmount._sum.amount ?? 0,
    };
  },

  async markCommissionPaid(id: string) {
    const commission = await prisma.commission.findUnique({ where: { id } });
    if (!commission) throw new AppError('Commission introuvable', 404);
    if (commission.isPaid) throw new AppError('Commission déjà payée', 400);

    return prisma.commission.update({
      where: { id },
      data: { isPaid: true, paidAt: new Date() },
    });
  },
};
