import express from 'express';
import { createServer } from 'http';
import { Server as SocketIOServer } from 'socket.io';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { env } from './config/env';
import { errorHandler, notFound } from './middleware/errorHandler';
import { initGpsSocket } from './sockets/gps.socket';

import authRoutes from './modules/auth/auth.routes';
import usersRoutes from './modules/users/users.routes';
import missionsRoutes from './modules/missions/missions.routes';
import vehiclesRoutes from './modules/vehicles/vehicles.routes';
import ratingsRoutes from './modules/ratings/ratings.routes';
import adminRoutes from './modules/admin/admin.routes';

const app = express();
const httpServer = createServer(app);

const io = new SocketIOServer(httpServer, {
  cors: { origin: env.allowedOrigins, methods: ['GET', 'POST'], credentials: true },
});

initGpsSocket(io);

app.use(cors({ origin: env.allowedOrigins, credentials: true }));
app.use(helmet());
app.use(morgan(env.nodeEnv === 'production' ? 'combined' : 'dev'));
app.use(express.json({ limit: '5mb' }));
app.use(express.urlencoded({ extended: true }));

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', service: "JO'DRIVE API", version: '1.0.0' });
});

const API = '/api';
app.use(`${API}/auth`, authRoutes);
app.use(`${API}/users`, usersRoutes);
app.use(`${API}/missions`, missionsRoutes);
app.use(`${API}/vehicles`, vehiclesRoutes);
app.use(`${API}/ratings`, ratingsRoutes);
app.use(`${API}/admin`, adminRoutes);

app.use(notFound);
app.use(errorHandler);

httpServer.listen(env.port, () => {
  console.log('JO DRIVE API running on http://localhost:' + env.port);
});

export { app, httpServer };
