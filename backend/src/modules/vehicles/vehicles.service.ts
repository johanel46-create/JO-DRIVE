import { prisma } from '../../config/database';
import { AppError } from '../../middleware/errorHandler';

export const vehiclesService = {
  async getMyVehicles(transporteurId: string) {
    return prisma.vehicle.findMany({
      where: { transporteurId },
      orderBy: { createdAt: 'desc' },
    });
  },

  async getVehicleById(id: string, transporteurId: string) {
    const vehicle = await prisma.vehicle.findFirst({
      where: { id, transporteurId },
    });
    if (!vehicle) throw new AppError('Véhicule introuvable', 404);
    return vehicle;
  },

  async createVehicle(
    transporteurId: string,
    data: {
      type: 'UTILITAIRE' | 'FOURGON' | 'CAMION';
      brand: string;
      model: string;
      year: number;
      licensePlate: string;
      color: string;
      capacity: number;
      maxWeight: number;
    },
  ) {
    const existing = await prisma.vehicle.findUnique({
      where: { licensePlate: data.licensePlate },
    });
    if (existing) throw new AppError("Cette plaque d'immatriculation est déjà enregistrée", 409);

    return prisma.vehicle.create({
      data: { ...data, transporteurId, photos: [] },
    });
  },

  async updateVehicle(
    id: string,
    transporteurId: string,
    data: Partial<{
      brand: string;
      model: string;
      color: string;
      isActive: boolean;
    }>,
  ) {
    const vehicle = await prisma.vehicle.findFirst({ where: { id, transporteurId } });
    if (!vehicle) throw new AppError('Véhicule introuvable', 404);

    return prisma.vehicle.update({ where: { id }, data });
  },

  async deleteVehicle(id: string, transporteurId: string) {
    const vehicle = await prisma.vehicle.findFirst({ where: { id, transporteurId } });
    if (!vehicle) throw new AppError('Véhicule introuvable', 404);

    const activeMission = await prisma.mission.findFirst({
      where: {
        vehicleId: id,
        status: { in: ['ACCEPTED', 'IN_PROGRESS'] },
      },
    });
    if (activeMission) throw new AppError('Ce véhicule est assigné à une mission en cours', 400);

    await prisma.vehicle.delete({ where: { id } });
  },
};
