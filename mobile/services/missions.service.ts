import { api } from './api';
import { CreateMissionPayload, Mission, PaginatedResponse } from '../types';

export const MissionsService = {
  async getMyMissions(page = 1, limit = 20): Promise<PaginatedResponse<Mission>> {
    const res = await api.get<PaginatedResponse<Mission>>(
      `/missions?page=${page}&limit=${limit}`,
    );
    return res.data;
  },

  async getMissionById(id: string): Promise<Mission> {
    const res = await api.get<Mission>(`/missions/${id}`);
    return res.data;
  },

  async createMission(payload: CreateMissionPayload): Promise<Mission> {
    const res = await api.post<Mission>('/missions', payload);
    return res.data;
  },

  async acceptMission(id: string, vehicleId: string): Promise<Mission> {
    const res = await api.patch<Mission>(`/missions/${id}/accept`, { vehicleId });
    return res.data;
  },

  async startMission(id: string): Promise<Mission> {
    const res = await api.patch<Mission>(`/missions/${id}/start`, {});
    return res.data;
  },

  async completeMission(id: string): Promise<Mission> {
    const res = await api.patch<Mission>(`/missions/${id}/complete`, {});
    return res.data;
  },

  async cancelMission(id: string, reason?: string): Promise<Mission> {
    const res = await api.patch<Mission>(`/missions/${id}/cancel`, { reason });
    return res.data;
  },

  async getAvailableMissions(): Promise<Mission[]> {
    const res = await api.get<Mission[]>('/missions/available');
    return res.data;
  },

  async rateMission(missionId: string, score: number, comment?: string): Promise<void> {
    await api.post(`/missions/${missionId}/rate`, { score, comment });
  },
};
