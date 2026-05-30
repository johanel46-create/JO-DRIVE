import { useCallback } from 'react';
import { useAppDispatch, useAppSelector } from '../store';
import {
  fetchMissions,
  fetchMissionById,
  createMission,
  fetchAvailableMissions,
  acceptMission,
  startMission,
  completeMission,
} from '../store/missions.slice';
import { CreateMissionPayload } from '../types';

export function useMissions() {
  const dispatch = useAppDispatch();
  const { list, current, available, isLoading, error, total, page } =
    useAppSelector((state) => state.missions);

  const loadMissions = useCallback(
    (p?: number) => dispatch(fetchMissions({ page: p })),
    [dispatch],
  );

  const loadMission = useCallback(
    (id: string) => dispatch(fetchMissionById(id)),
    [dispatch],
  );

  const newMission = useCallback(
    (payload: CreateMissionPayload) => dispatch(createMission(payload)),
    [dispatch],
  );

  const loadAvailable = useCallback(
    () => dispatch(fetchAvailableMissions()),
    [dispatch],
  );

  const accept = useCallback(
    (id: string, vehicleId: string) => dispatch(acceptMission({ id, vehicleId })),
    [dispatch],
  );

  const start = useCallback(
    (id: string) => dispatch(startMission(id)),
    [dispatch],
  );

  const complete = useCallback(
    (id: string) => dispatch(completeMission(id)),
    [dispatch],
  );

  return {
    list,
    current,
    available,
    isLoading,
    error,
    total,
    page,
    loadMissions,
    loadMission,
    newMission,
    loadAvailable,
    accept,
    start,
    complete,
  };
}
