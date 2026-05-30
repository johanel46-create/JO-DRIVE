import { prisma } from '../../config/database';
import { AppError } from '../../middleware/errorHandler';

export const ratingsService = {
  async getUserRatings(userId: string, page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [ratings, total] = await Promise.all([
      prisma.rating.findMany({
        where: { targetId: userId },
        include: {
          author: {
            select: { id: true, firstName: true, lastName: true, avatar: true },
          },
          mission: {
            select: { id: true, pickupAddress: true, deliveryAddress: true },
          },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.rating.count({ where: { targetId: userId } }),
    ]);

    const avgScore =
      ratings.length > 0
        ? ratings.reduce((acc, r) => acc + r.score, 0) / ratings.length
        : null;

    return { data: ratings, total, page, limit, totalPages: Math.ceil(total / limit), avgScore };
  },

  async getRatingById(id: string) {
    const rating = await prisma.rating.findUnique({
      where: { id },
      include: {
        author: { select: { id: true, firstName: true, lastName: true } },
        target: { select: { id: true, firstName: true, lastName: true } },
        mission: true,
      },
    });
    if (!rating) throw new AppError('Évaluation introuvable', 404);
    return rating;
  },
};
