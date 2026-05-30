import { prisma } from '../../config/database';
import { AppError } from '../../middleware/errorHandler';

export const usersService = {
  async getProfile(userId: string) {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        phone: true,
        firstName: true,
        lastName: true,
        role: true,
        avatar: true,
        isVerified: true,
        createdAt: true,
        _count: {
          select: {
            missionsAsClient: true,
            missionsAsTransporteur: true,
          },
        },
        ratingsReceived: {
          select: { score: true },
        },
      },
    });

    if (!user) {
      throw new AppError('Utilisateur introuvable', 404);
    }

    const avgRating =
      user.ratingsReceived.length > 0
        ? user.ratingsReceived.reduce((acc, r) => acc + r.score, 0) / user.ratingsReceived.length
        : null;

    return {
      ...user,
      avgRating,
      ratingsCount: user.ratingsReceived.length,
      ratingsReceived: undefined,
    };
  },

  async updateProfile(
    userId: string,
    data: { firstName?: string; lastName?: string; phone?: string; avatar?: string }
  ) {
    const user = await prisma.user.update({
      where: { id: userId },
      data,
      select: {
        id: true,
        email: true,
        phone: true,
        firstName: true,
        lastName: true,
        role: true,
        avatar: true,
        isVerified: true,
        updatedAt: true,
      },
    });

    return user;
  },

  async getTransporteurs(params: { page?: number; limit?: number }) {
    const page = params.page || 1;
    const limit = params.limit || 20;
    const skip = (page - 1) * limit;

    const [transporteurs, total] = await Promise.all([
      prisma.user.findMany({
        where: { role: 'TRANSPORTEUR', isActive: true },
        select: {
          id: true,
          firstName: true,
          lastName: true,
          avatar: true,
          isVerified: true,
          vehicles: {
            where: { isActive: true },
            select: { id: true, type: true, brand: true, model: true, capacity: true },
          },
          ratingsReceived: {
            select: { score: true },
          },
        },
        skip,
        take: limit,
      }),
      prisma.user.count({ where: { role: 'TRANSPORTEUR', isActive: true } }),
    ]);

    const enriched = transporteurs.map((t) => ({
      ...t,
      avgRating:
        t.ratingsReceived.length > 0
          ? t.ratingsReceived.reduce((acc, r) => acc + r.score, 0) / t.ratingsReceived.length
          : null,
      ratingsCount: t.ratingsReceived.length,
      ratingsReceived: undefined,
    }));

    return {
      data: enriched,
      meta: { page, limit, total, totalPages: Math.ceil(total / limit) },
    };
  },
};
