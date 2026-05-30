import { useEffect, useRef, useCallback } from 'react';
import { io, Socket } from 'socket.io-client';
import { useAppDispatch } from '../store';
import { updateMissionInList } from '../store/missions.slice';
import { StorageService } from '../services/storage.service';
import { GPSLocation, MissionStatus } from '../types';

const SOCKET_URL = process.env.EXPO_PUBLIC_SOCKET_URL ?? 'http://localhost:3000';

export function useSocket() {
  const socketRef = useRef<Socket | null>(null);
  const dispatch = useAppDispatch();

  const connect = useCallback(async () => {
    const token = await StorageService.getAccessToken();
    if (!token) return;

    socketRef.current = io(SOCKET_URL, {
      auth: { token },
      transports: ['websocket'],
    });

    socketRef.current.on('connect', () => {
      console.log('[Socket] Connected:', socketRef.current?.id);
    });

    socketRef.current.on('disconnect', () => {
      console.log('[Socket] Disconnected');
    });

    socketRef.current.on(
      'mission:statusChanged',
      (data: { missionId: string; status: MissionStatus }) => {
        dispatch(
          updateMissionInList({ id: data.missionId, status: data.status }),
        );
      },
    );
  }, [dispatch]);

  const disconnect = useCallback(() => {
    socketRef.current?.disconnect();
    socketRef.current = null;
  }, []);

  const subscribeToMission = useCallback((missionId: string) => {
    socketRef.current?.emit('gps:subscribe', missionId);
  }, []);

  const onGpsUpdate = useCallback(
    (missionId: string, cb: (location: GPSLocation) => void) => {
      socketRef.current?.on('gps:update', (data) => {
        if (data.missionId === missionId) cb(data.location);
      });
    },
    [],
  );

  const emitGpsUpdate = useCallback(
    (missionId: string, location: GPSLocation) => {
      socketRef.current?.emit('gps:update', { missionId, location });
    },
    [],
  );

  useEffect(() => {
    return () => {
      disconnect();
    };
  }, [disconnect]);

  return {
    connect,
    disconnect,
    subscribeToMission,
    onGpsUpdate,
    emitGpsUpdate,
    socket: socketRef.current,
  };
}
