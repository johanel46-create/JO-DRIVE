import express from 'express';
import { createServer } from 'http';
import { Server as SocketIOServer } from 'socket.io';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { env } from './config/env';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import { initGpsSocket } from './sockets/gps.socket';

// ─── Route imports ────────────────────────────────────────────────────────────
import authRoutes from './modules/auth/auth.routes';
import usersRoutes from './modules/users/users.routes';
import missionsRoutes from './modules/missions/missions.routes';
import vehiclesRoutes from './modules/vehicles/vehicles.routes';
import ratingsRoutes from './modules/ratings/ratings.routes';
import adminRoutes from './modules/admin/admin.routes';

// ─── App setup ────────────────────────────────────────────────────────────────
const app = express();
const httpServer = createServer(app);

// ─── Socket.io ───────────────────────────────────────────────────────────────
const io = new SocketIOServer(httpServer, {
  cors: {
    origin: env.allowedOrigins,
    methods: ['GET', 'POST'],
    credentials: true,
  },
});

initGpsSocket(io);

// ─── Middleware ───────────────────────────────────────────────────────────────
app.use(
  cors({
    origin: env.allowedOrigins,
    credentials: true,
  }),
);
app.use(helmet());
app.use(morgan(env.nodeEnv === 'production' ? 'combined' : 'dev'));
app.use(express.json({ limit: '5mb' }));
app.use(express.urlencoded({ extended: true }));

// ─── Health check ─────────────────────────────────────────────────────────────
app.get('/health', (_req, res) => {
  res.json({
    status: 'ok',
    service: "JO'DRIVE API",
    version: '1.0.0',
    timestamp: new Date().toISOString(),
  });
});

// ─── API Routes ───────────────────────────────────────────────────────────────
const API_PREFIX = '/api';

app.use(`${API_PREFIX}/auth`, authRoutes);
app.use(`${API_PREFIX}/users`, usersRoutes);
app.use(`${API_PREFIX}/missions`, missionsRoutes);
app.use(`${API_PREFIX}/vehicles`, vehiclesRoutes);
app.use(`${API_PREFIX}/ratings`, ratingsRoutes);
app.use(`${API_PREFIX}/admin`, adminRoutes);

// ─── 404 & Error handlers ─────────────────────────────────────────────────────
app.use(notFoundHandler);
app.use(errorHandler);

// ─── Start ───────────────────────────────────────────────────────────────────
httpServer.listen(env.port, () => {
  console.log(`
  ╔══════════════════════════════════╗
  ║       JO'DRIVE API SERVER        ║
  ║  Transport & Livraison - Guyane  ║
  ╚══════════════════════════════════╝
  🚀 Running on http://localhost:${env.port}
  🌿 Environment: ${env.nodeEnv}
  📡 Socket.io ready
  `);
});

export { app, httpServer };
