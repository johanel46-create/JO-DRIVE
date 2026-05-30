import { prisma } from '../../config/database';
import { AppError } from '../../middleware/errorHandler';
import { env } from '../../config/env';

const COMMISSION_RATE = env.commissionRate;

function calculatePrice(distanceKm: number): number {
  const BASE_PRICE = 15;
  const PRICE_PER_KM = 2.5;
  return Math.round((BASE_PRICE + distanceKm * PRICE_PER_KM) * 100) / 100;
}

function calcDistance(lat1: number, lng1: number, lat2: number, lng2: number): number {
  const R = 6371;
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLng = ((lng2 - lng1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos((lat1 * Math.PI) / 180) * Math.cos((lat2 * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
  return R * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
}

const MISSION_SELECT = {
  id: true,
  status: true,
  pickupAddress: true,
  pickupLat: true,
  pickupLng: true,
  deliveryAddress: true,
  deliveryLat: true,
  deliveryLng: true,
  scheduledAt: true,
  startedAt: true,
  completedAt: true,
  estimatedPrice: true,
  finalPrice: true,
  distance: true,
  notes: true,
  createdAt: true,
  updatedAt: true,
  client: {
    select: { id: true, firstName: true, lastName: true, phone: true, avatar: true },
  },
  transporteur: {
    select: { id: true, firstName: true, lastName: true, phone: true, avatar: true },
  },
  vehicle: {
    select: { id: true, type: true, brand: true, model: true, licensePlate: true },
  },
  items: true,
  ratings: true,
  commission: true,
} as const;

export const missionsService = {
  async getClientMissions(clientId: string, page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [missions, total] = await Promise.all([
      prisma.mission.findMany({
        where: { clientId },
        select: MISSION_SELECT,
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.mission.count({ where: { clientId } }),
    ]);
    return { data: missions, total, page, limit, totalPages: Math.ceil(total / limit) };
  },

  async getTransporteurMissions(transporteurId: string, page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [missions, total] = await Promise.all([
      prisma.mission.findMany({
        where: { transporteurId },
        select: MISSION_SELECT,
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.mission.count({ where: { transporteurId } }),
    ]);
    return { data: missions, total, page, limit, totalPages: Math.ceil(total / limit) };
  },

  async getAvailableMissions() {
    return prisma.mission.findMany({
      where: { status: 'PENDING' },
      select: MISSION_SELECT,
      orderBy: { createdAt: 'asc' },
    });
  },

  async getMissionById(id: string, userId: string) {
    const mission = await prisma.mission.findUnique({
      where: { id },
      select: MISSION_SELECT,
    });

    if (!mission) throw new AppError('Mission introuvable', 404);

    const user = await prisma.user.findUnique({
      where: { id: userId },
      select: { role: true },
    });

    const isAdmin = user?.role === 'ADMIN';
    const isClient = mission.client.id === userId;
    const isTransporteur = mission.transporteur?.id === userId;

    if (!isAdmin && !isClient && !isTransporteur) {
      throw new AppError('Accès non autorisé', 403);
    }

    return mission;
  },

  async createMission(clientId: string, data: {
    pickupAddress: string;
    pickupLat: number;
    pickupLng: number;
    deliveryAddress: string;
    deliveryLat: number;
    deliveryLng: number;
    scheduledAt?: string;
    notes?: string;
    items: { description: string; quantity: number; estimatedWeight?: number }[];
  }) {
    const distance = calcDistance(data.pickupLat, data.pickupLng, data.deliveryLat, data.deliveryLng);
    const estimatedPrice = calculatePrice(distance);

    const mission = await prisma.mission.create({
      data: {
        clientId,
        pickupAddress: data.pickupAddress,
        pickupLat: data.pickupLat,
        pickupLng: data.pickupLng,
        deliveryAddress: data.deliveryAddress,
        deliveryLat: data.deliveryLat,
        deliveryLng: data.deliveryLng,
        scheduledAt: data.scheduledAt ? new Date(data.scheduledAt) : null,
        notes: data.notes,
        distance,
        estimatedPrice,
        items: {
          create: data.items.map((item) => ({
            name: item.description,
            description: item.description,
            quantity: item.quantity,
            weight: item.estimatedWeight,
          })),
        },
      },
      select: MISSION_SELECT,
    });

    return mission;
  },

  async acceptMission(missionId: string, transporteurId: string, vehicleId: string) {
    const mission = await prisma.mission.findUnique({ where: { id: missionId } });
    if (!mission) throw new AppError('Mission introuvable', 404);
    if (mission.status !== 'PENDING') throw new AppError('La mission ne peut plus être acceptée', 400);

    const vehicle = await prisma.vehicle.findFirst({
      where: { id: vehicleId, transporteurId, isActive: true },
    });
    if (!vehicle) throw new AppError('Véhicule introuvable', 404);

    return prisma.mission.update({
      where: { id: missionId },
      data: {
        status: 'ACCEPTED',
        transporteurId,
        vehicleId,
        acceptedAt: new Date(),
      },
      select: MISSION_SELECT,
    });
  },

  async startMission(missionId: string, transporteurId: string) {
    const mission = await prisma.mission.findUnique({ where: { id: missionId } });
    if (!mission) throw new AppError('Mission introuvable', 404);
    if (mission.transporteurId !== transporteurId) throw new AppError('Non autorisé', 403);
    if (mission.status !== 'ACCEPTED') throw new AppError('La mission ne peut pas être démarrée', 400);

    return prisma.mission.update({
      where: { id: missionId },
      data: { status: 'IN_PROGRESS', startedAt: new Date() },
      select: MISSION_SELECT,
    });
  },

  async completeMission(missionId: string, transporteurId: string) {
    const mission = await prisma.mission.findUnique({ where: { id: missionId } });
    if (!mission) throw new AppError('Mission introuvable', 404);
    if (mission.transporteurId !== transporteurId) throw new AppError('Non autorisé', 403);
    if (mission.status !== 'IN_PROGRESS') throw new AppError("La mission n'est pas en cours", 400);

    const finalPrice = mission.finalPrice ?? mission.estimatedPrice;
    const commissionAmount = Math.round(finalPrice * COMMISSION_RATE * 100) / 100;

    const updated = await prisma.mission.update({
      where: { id: missionId },
      data: {
        status: 'COMPLETED',
        completedAt: new Date(),
        finalPrice,
        commission: {
          create: {
            amount: commissionAmount,
            rate: COMMISSION_RATE,
            transporteurId,
          },
        },
      },
      select: MISSION_SELECT,
    });

    return updated;
  },

  async cancelMission(missionId: string, userId: string, reason?: string) {
    const mission = await prisma.mission.findUnique({
      where: { id: missionId },
      select: { clientId: true, transporteurId: true, status: true },
    });

    if (!mission) throw new AppError('Mission introuvable', 404);

    const isClient = mission.clientId === userId;
    const isTransporteur = mission.transporteurId === userId;

    if (!isClient && !isTransporteur) throw new AppError('Non autorisé', 403);

    const cancellableStatuses = ['PENDING', 'ACCEPTED'];
    if (!cancellableStatuses.includes(mission.status)) {
      throw new AppError('La mission ne peut pas être annulée à ce stade', 400);
    }

    return prisma.mission.update({
      where: { id: missionId },
      data: { status: 'CANCELLED' },
      select: MISSION_SELECT,
    });
  },

  async rateMission(missionId: string, fromUserId: string, score: number, comment?: string) {
    const mission = await prisma.mission.findUnique({
      where: { id: missionId },
      select: { clientId: true, transporteurId: true, status: true },
    });

    if (!mission) throw new AppError('Mission introuvable', 404);
    if (mission.status !== 'COMPLETED') throw new AppError('Seules les missions terminées peuvent être évaluées', 400);

    const isClient = mission.clientId === fromUserId;
    if (!isClient) throw new AppError('Seul le client peut évaluer cette mission', 403);

    const toUserId = mission.transporteurId!;

    const rating = await prisma.rating.create({
      data: { missionId, authorId: fromUserId, targetId: toUserId, score, comment },
    });

    return rating;
  },
};
