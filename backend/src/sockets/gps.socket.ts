import { Server as SocketIOServer, Socket } from 'socket.io';
import jwt from 'jsonwebtoken';
import { env } from '../config/env';
import { JwtPayload } from '../middleware/auth';

interface GPSLocation {
  lat: number;
  lng: number;
  heading?: number;
  speed?: number;
  timestamp: number;
}

const driverPositions = new Map<string, GPSLocation>();

function authenticateSocket(socket: Socket): JwtPayload | null {
  try {
    const token = socket.handshake.auth?.token as string | undefined;
    if (!token) return null;
    return jwt.verify(token, env.jwt.secret) as JwtPayload;
  } catch {
    return null;
  }
}

export function initGpsSocket(io: SocketIOServer) {
  io.on('connection', (socket: Socket) => {
    const user = authenticateSocket(socket);

    if (!user) {
      socket.emit('error', { message: 'Authentication required' });
      socket.disconnect();
      return;
    }

    console.log(`[Socket] User connected: ${user.userId} (${user.role})`);

    socket.on('gps:subscribe', (missionId: string) => {
      socket.join(`mission:${missionId}`);
      console.log(`[Socket] User ${user.userId} subscribed to mission ${missionId}`);

      const lastPosition = driverPositions.get(missionId);
      if (lastPosition) {
        socket.emit('gps:update', { missionId, location: lastPosition });
      }
    });

    socket.on('gps:unsubscribe', (missionId: string) => {
      socket.leave(`mission:${missionId}`);
    });

    socket.on(
      'gps:update',
      (data: { missionId: string; location: GPSLocation }) => {
        if (user.role !== 'TRANSPORTEUR') {
          socket.emit('error', { message: 'Only transporteurs can emit GPS updates' });
          return;
        }

        const { missionId, location } = data;

        if (typeof location.lat !== 'number' || typeof location.lng !== 'number') {
          socket.emit('error', { message: 'Invalid location data' });
          return;
        }

        driverPositions.set(missionId, { ...location, timestamp: Date.now() });

        socket.to(`mission:${missionId}`).emit('gps:update', {
          missionId,
          location: driverPositions.get(missionId),
        });
      },
    );

    socket.on(
      'mission:statusChanged',
      (data: { missionId: string; status: string }) => {
        io.to(`mission:${data.missionId}`).emit('mission:statusChanged', data);
      },
    );

    socket.on('disconnect', () => {
      console.log(`[Socket] User disconnected: ${user.userId}`);
    });

    socket.on('error', (err) => {
      console.error(`[Socket] Error for user ${user.userId}:`, err);
    });
  });
}
