#!/bin/bash
set -e

# ── Directories ────────────────────────────────────────────────────────────────
mkdir -p backend/src/config
mkdir -p backend/src/middleware
mkdir -p backend/src/modules/auth
mkdir -p backend/src/modules/users
mkdir -p backend/src/modules/missions
mkdir -p backend/src/modules/vehicles
mkdir -p backend/src/modules/ratings
mkdir -p backend/src/modules/admin
mkdir -p backend/src/sockets
mkdir -p backend/prisma
mkdir -p mobile/app/\(auth\)
mkdir -p mobile/app/\(client\)/mission
mkdir -p mobile/app/\(transporteur\)/mission
mkdir -p mobile/app/\(admin\)
mkdir -p mobile/components/ui
mkdir -p mobile/components/mission
mkdir -p mobile/components/map
mkdir -p mobile/components/layout
mkdir -p mobile/constants
mkdir -p mobile/hooks
mkdir -p mobile/services
mkdir -p mobile/store
mkdir -p mobile/types

# ── README.md ─────────────────────────────────────────────────────────────────
cat > README.md << 'HEREDOC'
# JO'DRIVE — Mobilité • Livraison • Course

> Transport & livraison premium en Guyane (French Guiana)

---

## Stack technique

| Couche | Technologie |
|---|---|
| Mobile | React Native + Expo (TypeScript) |
| Backend | Node.js + Express + TypeScript |
| Base de données | PostgreSQL + Prisma ORM |
| Authentification | JWT + bcrypt |
| Temps réel | Socket.io (GPS) |
| Paiements | Stripe |
| State management | Redux Toolkit |

## Architecture

```
JO-DRIVE/
├── backend/          Node.js + Express API
│   ├── src/
│   │   ├── config/       Prisma & env
│   │   ├── middleware/   Auth, errors, validation
│   │   ├── modules/      auth, users, missions, vehicles, ratings, admin
│   │   └── sockets/      GPS Socket.io handler
│   └── prisma/       PostgreSQL schema
└── mobile/           Expo + Expo Router app
    ├── app/
    │   ├── (auth)/       Login, Register
    │   ├── (client)/     Client flows
    │   ├── (transporteur)/ Driver flows
    │   └── (admin)/      Admin panel
    ├── components/   Reusable UI
    ├── store/        Redux Toolkit slices
    ├── services/     API + socket clients
    └── hooks/        useAuth, useMissions, useSocket
```

## Rôles utilisateurs

- **Client** — Commande des livraisons, suit en temps réel
- **Transporteur** — Accepte et effectue les missions
- **Administrateur** — Gestion globale, commissions, statistiques

## Service V1

**Livraison** : Transport de meubles, électroménager, matériaux de construction

## Démarrage rapide

### Backend

```bash
cd backend
cp .env.example .env
# Remplissez les variables dans .env
npm install
npx prisma migrate dev
npm run dev
```

### Mobile

```bash
cd mobile
npm install
npx expo start
```

## Variables d'environnement (backend)

```
DATABASE_URL=postgresql://user:password@localhost:5432/jodrive
JWT_SECRET=<secret_fort>
JWT_REFRESH_SECRET=<autre_secret>
STRIPE_SECRET_KEY=sk_test_...
```

## Endpoints API principaux

| Méthode | Route | Description |
|---|---|---|
| POST | /api/auth/register | Inscription |
| POST | /api/auth/login | Connexion |
| POST | /api/auth/refresh | Renouveler token |
| GET | /api/missions | Mes missions |
| POST | /api/missions | Créer une mission |
| GET | /api/missions/available | Missions disponibles (transporteur) |
| PATCH | /api/missions/:id/accept | Accepter |
| PATCH | /api/missions/:id/start | Démarrer |
| PATCH | /api/missions/:id/complete | Terminer |
| GET | /api/vehicles | Mes véhicules |
| POST | /api/vehicles | Ajouter un véhicule |
| GET | /api/admin/dashboard | Stats admin |

## Socket.io Events

| Event | Direction | Description |
|---|---|---|
| `gps:subscribe` | Client → Server | Écouter les MAJ GPS d'une mission |
| `gps:update` | Transporteur → Server | Émettre position GPS |
| `gps:update` | Server → Client | Recevoir position du chauffeur |
| `mission:statusChanged` | Server → All | Changement de statut |

---

© 2024 JO'DRIVE — Guyane 🌿
HEREDOC

# ── backend/.env.example ───────────────────────────────────────────────────────
cat > backend/.env.example << 'HEREDOC'
# JO'DRIVE Backend - Environment Variables

# Server
PORT=3000
NODE_ENV=development

# Database
DATABASE_URL="postgresql://postgres:password@localhost:5432/jodrive_db"

# JWT
JWT_SECRET=your_super_secret_jwt_key_change_in_production
JWT_REFRESH_SECRET=your_super_secret_refresh_key_change_in_production
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# Stripe
STRIPE_SECRET_KEY=sk_test_your_stripe_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

# CORS
ALLOWED_ORIGINS=http://localhost:8081,exp://localhost:8081

# Admin
COMMISSION_RATE=0.15
HEREDOC

# ── backend/package.json ───────────────────────────────────────────────────────
cat > backend/package.json << 'HEREDOC'
{
  "name": "jodrive-backend",
  "version": "1.0.0",
  "description": "JO'DRIVE Backend API - Transport & Delivery Platform",
  "main": "dist/app.js",
  "scripts": {
    "dev": "ts-node-dev --respawn --transpile-only src/app.ts",
    "build": "tsc",
    "start": "node dist/app.js",
    "prisma:generate": "prisma generate",
    "prisma:migrate": "prisma migrate dev",
    "prisma:studio": "prisma studio",
    "prisma:seed": "ts-node prisma/seed.ts"
  },
  "dependencies": {
    "@prisma/client": "^5.7.0",
    "bcryptjs": "^2.4.3",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "express": "^4.18.2",
    "helmet": "^7.1.0",
    "jsonwebtoken": "^9.0.2",
    "morgan": "^1.10.0",
    "socket.io": "^4.6.1",
    "stripe": "^14.10.0",
    "zod": "^3.22.4"
  },
  "devDependencies": {
    "@types/bcryptjs": "^2.4.6",
    "@types/cors": "^2.8.17",
    "@types/express": "^4.17.21",
    "@types/jsonwebtoken": "^9.0.5",
    "@types/morgan": "^1.9.9",
    "@types/node": "^20.10.0",
    "prisma": "^5.7.0",
    "ts-node-dev": "^2.0.0",
    "typescript": "^5.3.2"
  }
}
HEREDOC

# ── backend/tsconfig.json ──────────────────────────────────────────────────────
cat > backend/tsconfig.json << 'HEREDOC'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
HEREDOC

# ── backend/prisma/schema.prisma ───────────────────────────────────────────────
cat > backend/prisma/schema.prisma << 'HEREDOC'
// JO'DRIVE - Prisma Schema
// Transport & Delivery Platform - French Guiana

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

enum Role {
  CLIENT
  TRANSPORTEUR
  ADMIN
}

enum VehicleType {
  UTILITAIRE
  FOURGON
  CAMION
}

enum MissionStatus {
  PENDING
  ACCEPTED
  IN_PROGRESS
  COMPLETED
  CANCELLED
}

enum PaymentStatus {
  PENDING
  PAID
  REFUNDED
  FAILED
}

model User {
  id            String    @id @default(cuid())
  email         String    @unique
  phone         String    @unique
  password      String
  firstName     String
  lastName      String
  role          Role      @default(CLIENT)
  avatar        String?
  isVerified    Boolean   @default(false)
  isActive      Boolean   @default(true)
  refreshToken  String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt

  // Client relations
  missionsAsClient      Mission[]  @relation("ClientMissions")
  ratingsGiven          Rating[]   @relation("RatingsGiven")

  // Transporteur relations
  missionsAsTransporteur Mission[] @relation("TransporteurMissions")
  vehicles               Vehicle[]
  ratingsReceived        Rating[]  @relation("RatingsReceived")
  commissions            Commission[]

  @@map("users")
}

model Vehicle {
  id           String      @id @default(cuid())
  type         VehicleType
  brand        String
  model        String
  year         Int
  licensePlate String      @unique
  color        String
  capacity     Float       // in m³
  maxWeight    Float       // in kg
  photos       String[]
  isActive     Boolean     @default(true)
  createdAt    DateTime    @default(now())
  updatedAt    DateTime    @updatedAt

  transporteurId String
  transporteur   User      @relation(fields: [transporteurId], references: [id], onDelete: Cascade)

  missions       Mission[]

  @@map("vehicles")
}

model Mission {
  id               String        @id @default(cuid())
  status           MissionStatus @default(PENDING)

  // Addresses
  pickupAddress    String
  pickupLat        Float
  pickupLng        Float
  deliveryAddress  String
  deliveryLat      Float
  deliveryLng      Float

  // Scheduling
  scheduledAt      DateTime?
  acceptedAt       DateTime?
  startedAt        DateTime?
  completedAt      DateTime?

  // Pricing
  estimatedPrice   Float
  finalPrice       Float?
  distance         Float         // in km

  // Payment
  paymentStatus    PaymentStatus @default(PENDING)
  stripePaymentId  String?

  // Notes
  notes            String?

  // GPS tracking
  currentLat       Float?
  currentLng       Float?

  createdAt        DateTime      @default(now())
  updatedAt        DateTime      @updatedAt

  // Relations
  clientId         String
  client           User          @relation("ClientMissions", fields: [clientId], references: [id])

  transporteurId   String?
  transporteur     User?         @relation("TransporteurMissions", fields: [transporteurId], references: [id])

  vehicleId        String?
  vehicle          Vehicle?      @relation(fields: [vehicleId], references: [id])

  items            MissionItem[]
  ratings          Rating[]
  commission       Commission?

  @@map("missions")
}

model MissionItem {
  id          String   @id @default(cuid())
  name        String
  description String?
  quantity    Int      @default(1)
  weight      Float?   // in kg
  width       Float?   // in cm
  height      Float?   // in cm
  depth       Float?   // in cm
  isFragile   Boolean  @default(false)
  photos      String[]

  missionId   String
  mission     Mission  @relation(fields: [missionId], references: [id], onDelete: Cascade)

  @@map("mission_items")
}

model Rating {
  id          String   @id @default(cuid())
  score       Int      // 1-5
  comment     String?
  createdAt   DateTime @default(now())

  missionId   String
  mission     Mission  @relation(fields: [missionId], references: [id])

  authorId    String
  author      User     @relation("RatingsGiven", fields: [authorId], references: [id])

  targetId    String
  target      User     @relation("RatingsReceived", fields: [targetId], references: [id])

  @@unique([missionId, authorId])
  @@map("ratings")
}

model Commission {
  id             String   @id @default(cuid())
  amount         Float    // amount in EUR
  rate           Float    // percentage (e.g. 0.15 = 15%)
  isPaid         Boolean  @default(false)
  paidAt         DateTime?
  createdAt      DateTime @default(now())

  missionId      String   @unique
  mission        Mission  @relation(fields: [missionId], references: [id])

  transporteurId String
  transporteur   User     @relation(fields: [transporteurId], references: [id])

  @@map("commissions")
}
HEREDOC


# ── backend/src/app.ts ─────────────────────────────────────────────────────────
cat > backend/src/app.ts << 'HEREDOC'
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
HEREDOC

# ── backend/src/config/database.ts ────────────────────────────────────────────
cat > backend/src/config/database.ts << 'HEREDOC'
import { PrismaClient } from '@prisma/client';
import { env } from './env';

declare global {
  // eslint-disable-next-line no-var
  var __prisma: PrismaClient | undefined;
}

// Prevent multiple instances in development (hot reload)
export const prisma =
  global.__prisma ||
  new PrismaClient({
    log: env.nodeEnv === 'development' ? ['query', 'error', 'warn'] : ['error'],
  });

if (env.nodeEnv !== 'production') {
  global.__prisma = prisma;
}

export async function connectDatabase(): Promise<void> {
  try {
    await prisma.$connect();
    console.log('✅ Database connected successfully');
  } catch (error) {
    console.error('❌ Database connection failed:', error);
    process.exit(1);
  }
}

export async function disconnectDatabase(): Promise<void> {
  await prisma.$disconnect();
  console.log('Database disconnected');
}
HEREDOC

# ── backend/src/config/env.ts ──────────────────────────────────────────────────
cat > backend/src/config/env.ts << 'HEREDOC'
import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const envSchema = z.object({
  PORT: z.string().default('3000'),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  DATABASE_URL: z.string(),
  JWT_SECRET: z.string(),
  JWT_REFRESH_SECRET: z.string(),
  JWT_EXPIRES_IN: z.string().default('15m'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('7d'),
  STRIPE_SECRET_KEY: z.string(),
  STRIPE_WEBHOOK_SECRET: z.string().optional(),
  ALLOWED_ORIGINS: z.string().default('http://localhost:8081'),
  COMMISSION_RATE: z.string().default('0.15'),
});

const parsed = envSchema.safeParse(process.env);

if (!parsed.success) {
  console.error('Invalid environment variables:', parsed.error.format());
  process.exit(1);
}

export const env = {
  port: parseInt(parsed.data.PORT, 10),
  nodeEnv: parsed.data.NODE_ENV,
  databaseUrl: parsed.data.DATABASE_URL,
  jwt: {
    secret: parsed.data.JWT_SECRET,
    refreshSecret: parsed.data.JWT_REFRESH_SECRET,
    expiresIn: parsed.data.JWT_EXPIRES_IN,
    refreshExpiresIn: parsed.data.JWT_REFRESH_EXPIRES_IN,
  },
  stripe: {
    secretKey: parsed.data.STRIPE_SECRET_KEY,
    webhookSecret: parsed.data.STRIPE_WEBHOOK_SECRET,
  },
  allowedOrigins: parsed.data.ALLOWED_ORIGINS.split(','),
  commissionRate: parseFloat(parsed.data.COMMISSION_RATE),
};
HEREDOC

# ── backend/src/middleware/auth.ts ─────────────────────────────────────────────
cat > backend/src/middleware/auth.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env';
import { prisma } from '../config/database';
import { Role } from '@prisma/client';

export interface JwtPayload {
  userId: string;
  role: Role;
  email: string;
}

declare global {
  namespace Express {
    interface Request {
      user?: JwtPayload;
    }
  }
}

export const authenticate = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({ success: false, message: 'Token manquant ou invalide' });
      return;
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, env.jwt.secret) as JwtPayload;

    // Verify user still exists and is active
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: { id: true, role: true, email: true, isActive: true },
    });

    if (!user || !user.isActive) {
      res.status(401).json({ success: false, message: 'Utilisateur introuvable ou désactivé' });
      return;
    }

    req.user = { userId: user.id, role: user.role, email: user.email };
    next();
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      res.status(401).json({ success: false, message: 'Token expiré' });
      return;
    }
    res.status(401).json({ success: false, message: 'Token invalide' });
  }
};

export const authorize = (...roles: Role[]) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({ success: false, message: 'Non authentifié' });
      return;
    }

    if (!roles.includes(req.user.role)) {
      res.status(403).json({ success: false, message: 'Accès refusé - permissions insuffisantes' });
      return;
    }

    next();
  };
};
HEREDOC

# ── backend/src/middleware/errorHandler.ts ─────────────────────────────────────
cat > backend/src/middleware/errorHandler.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import { ZodError } from 'zod';
import { Prisma } from '@prisma/client';

export class AppError extends Error {
  statusCode: number;
  isOperational: boolean;

  constructor(message: string, statusCode: number) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;
    Error.captureStackTrace(this, this.constructor);
  }
}

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  _next: NextFunction
): void => {
  console.error('Error:', err);

  // Zod validation error
  if (err instanceof ZodError) {
    res.status(400).json({
      success: false,
      message: 'Données invalides',
      errors: err.errors.map((e) => ({
        field: e.path.join('.'),
        message: e.message,
      })),
    });
    return;
  }

  // Prisma errors
  if (err instanceof Prisma.PrismaClientKnownRequestError) {
    if (err.code === 'P2002') {
      const field = (err.meta?.target as string[])?.[0] || 'champ';
      res.status(409).json({
        success: false,
        message: `Ce ${field} est déjà utilisé`,
      });
      return;
    }

    if (err.code === 'P2025') {
      res.status(404).json({
        success: false,
        message: 'Ressource introuvable',
      });
      return;
    }
  }

  // App errors
  if (err instanceof AppError) {
    res.status(err.statusCode).json({
      success: false,
      message: err.message,
    });
    return;
  }

  // Generic error
  res.status(500).json({
    success: false,
    message: 'Erreur interne du serveur',
  });
};

export const notFound = (req: Request, res: Response): void => {
  res.status(404).json({
    success: false,
    message: `Route ${req.originalUrl} introuvable`,
  });
};
HEREDOC

# ── backend/src/middleware/validate.ts ────────────────────────────────────────
cat > backend/src/middleware/validate.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import { ZodSchema } from 'zod';

export const validate = (schema: ZodSchema) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      schema.parse({
        body: req.body,
        query: req.query,
        params: req.params,
      });
      next();
    } catch (error) {
      next(error);
    }
  };
};
HEREDOC


# ── backend/src/modules/auth/auth.schema.ts ───────────────────────────────────
cat > backend/src/modules/auth/auth.schema.ts << 'HEREDOC'
import { z } from 'zod';

export const registerSchema = z.object({
  body: z.object({
    email: z.string().email('Email invalide'),
    phone: z
      .string()
      .min(10, 'Numéro de téléphone invalide')
      .regex(/^(\+594|0594|594)[0-9]{6}$|^0[67][0-9]{8}$/, 'Numéro de téléphone invalide'),
    password: z
      .string()
      .min(8, 'Le mot de passe doit contenir au moins 8 caractères')
      .regex(/(?=.*[A-Z])/, 'Le mot de passe doit contenir une majuscule')
      .regex(/(?=.*[0-9])/, 'Le mot de passe doit contenir un chiffre'),
    firstName: z.string().min(2, 'Prénom trop court').max(50),
    lastName: z.string().min(2, 'Nom trop court').max(50),
    role: z.enum(['CLIENT', 'TRANSPORTEUR']).default('CLIENT'),
  }),
});

export const loginSchema = z.object({
  body: z.object({
    email: z.string().email('Email invalide'),
    password: z.string().min(1, 'Mot de passe requis'),
  }),
});

export const refreshSchema = z.object({
  body: z.object({
    refreshToken: z.string().min(1, 'Refresh token requis'),
  }),
});

export const changePasswordSchema = z.object({
  body: z.object({
    currentPassword: z.string().min(1, 'Mot de passe actuel requis'),
    newPassword: z
      .string()
      .min(8, 'Le mot de passe doit contenir au moins 8 caractères')
      .regex(/(?=.*[A-Z])/, 'Le mot de passe doit contenir une majuscule')
      .regex(/(?=.*[0-9])/, 'Le mot de passe doit contenir un chiffre'),
  }),
});

export type RegisterInput = z.infer<typeof registerSchema>['body'];
export type LoginInput = z.infer<typeof loginSchema>['body'];
export type RefreshInput = z.infer<typeof refreshSchema>['body'];
export type ChangePasswordInput = z.infer<typeof changePasswordSchema>['body'];
HEREDOC

# ── backend/src/modules/auth/auth.service.ts ─────────────────────────────────
cat > backend/src/modules/auth/auth.service.ts << 'HEREDOC'
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../../config/database';
import { env } from '../../config/env';
import { AppError } from '../../middleware/errorHandler';
import { JwtPayload } from '../../middleware/auth';
import { RegisterInput, LoginInput } from './auth.schema';
import { Role } from '@prisma/client';

const SALT_ROUNDS = 12;

function generateTokens(payload: JwtPayload) {
  const accessToken = jwt.sign(payload, env.jwt.secret, {
    expiresIn: env.jwt.expiresIn as jwt.SignOptions['expiresIn'],
  });

  const refreshToken = jwt.sign(payload, env.jwt.refreshSecret, {
    expiresIn: env.jwt.refreshExpiresIn as jwt.SignOptions['expiresIn'],
  });

  return { accessToken, refreshToken };
}

export const authService = {
  async register(data: RegisterInput) {
    const existing = await prisma.user.findFirst({
      where: {
        OR: [{ email: data.email }, { phone: data.phone }],
      },
    });

    if (existing) {
      if (existing.email === data.email) {
        throw new AppError('Cet email est déjà utilisé', 409);
      }
      throw new AppError('Ce numéro de téléphone est déjà utilisé', 409);
    }

    const hashedPassword = await bcrypt.hash(data.password, SALT_ROUNDS);

    const user = await prisma.user.create({
      data: {
        email: data.email,
        phone: data.phone,
        password: hashedPassword,
        firstName: data.firstName,
        lastName: data.lastName,
        role: data.role as Role,
      },
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
      },
    });

    const tokens = generateTokens({
      userId: user.id,
      role: user.role,
      email: user.email,
    });

    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: tokens.refreshToken },
    });

    return { user, ...tokens };
  },

  async login(data: LoginInput) {
    const user = await prisma.user.findUnique({
      where: { email: data.email },
    });

    if (!user) {
      throw new AppError('Email ou mot de passe incorrect', 401);
    }

    if (!user.isActive) {
      throw new AppError('Votre compte a été désactivé', 403);
    }

    const isPasswordValid = await bcrypt.compare(data.password, user.password);

    if (!isPasswordValid) {
      throw new AppError('Email ou mot de passe incorrect', 401);
    }

    const tokens = generateTokens({
      userId: user.id,
      role: user.role,
      email: user.email,
    });

    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: tokens.refreshToken },
    });

    const { password, refreshToken: _, ...userWithoutSensitive } = user;

    return { user: userWithoutSensitive, ...tokens };
  },

  async refreshToken(token: string) {
    let decoded: JwtPayload;

    try {
      decoded = jwt.verify(token, env.jwt.refreshSecret) as JwtPayload;
    } catch {
      throw new AppError('Refresh token invalide ou expiré', 401);
    }

    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: { id: true, role: true, email: true, refreshToken: true, isActive: true },
    });

    if (!user || user.refreshToken !== token || !user.isActive) {
      throw new AppError('Refresh token invalide', 401);
    }

    const tokens = generateTokens({
      userId: user.id,
      role: user.role,
      email: user.email,
    });

    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken: tokens.refreshToken },
    });

    return tokens;
  },

  async logout(userId: string) {
    await prisma.user.update({
      where: { id: userId },
      data: { refreshToken: null },
    });
  },

  async changePassword(userId: string, currentPassword: string, newPassword: string) {
    const user = await prisma.user.findUnique({ where: { id: userId } });

    if (!user) {
      throw new AppError('Utilisateur introuvable', 404);
    }

    const isValid = await bcrypt.compare(currentPassword, user.password);

    if (!isValid) {
      throw new AppError('Mot de passe actuel incorrect', 400);
    }

    const hashedPassword = await bcrypt.hash(newPassword, SALT_ROUNDS);

    await prisma.user.update({
      where: { id: userId },
      data: { password: hashedPassword, refreshToken: null },
    });
  },
};
HEREDOC

# ── backend/src/modules/auth/auth.controller.ts ───────────────────────────────
cat > backend/src/modules/auth/auth.controller.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import { authService } from './auth.service';

export const authController = {
  async register(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await authService.register(req.body);
      res.status(201).json({
        success: true,
        message: 'Compte créé avec succès',
        data: result,
      });
    } catch (error) {
      next(error);
    }
  },

  async login(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const result = await authService.login(req.body);
      res.status(200).json({
        success: true,
        message: 'Connexion réussie',
        data: result,
      });
    } catch (error) {
      next(error);
    }
  },

  async refresh(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { refreshToken } = req.body;
      const tokens = await authService.refreshToken(refreshToken);
      res.status(200).json({
        success: true,
        data: tokens,
      });
    } catch (error) {
      next(error);
    }
  },

  async logout(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      await authService.logout(req.user!.userId);
      res.status(200).json({
        success: true,
        message: 'Déconnexion réussie',
      });
    } catch (error) {
      next(error);
    }
  },

  async changePassword(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const { currentPassword, newPassword } = req.body;
      await authService.changePassword(req.user!.userId, currentPassword, newPassword);
      res.status(200).json({
        success: true,
        message: 'Mot de passe modifié avec succès',
      });
    } catch (error) {
      next(error);
    }
  },

  async me(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      res.status(200).json({
        success: true,
        data: req.user,
      });
    } catch (error) {
      next(error);
    }
  },
};
HEREDOC

# ── backend/src/modules/auth/auth.routes.ts ───────────────────────────────────
cat > backend/src/modules/auth/auth.routes.ts << 'HEREDOC'
import { Router } from 'express';
import { authController } from './auth.controller';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import {
  registerSchema,
  loginSchema,
  refreshSchema,
  changePasswordSchema,
} from './auth.schema';

const router = Router();

// Public routes
router.post('/register', validate(registerSchema), authController.register);
router.post('/login', validate(loginSchema), authController.login);
router.post('/refresh', validate(refreshSchema), authController.refresh);

// Protected routes
router.post('/logout', authenticate, authController.logout);
router.get('/me', authenticate, authController.me);
router.put('/change-password', authenticate, validate(changePasswordSchema), authController.changePassword);

export default router;
HEREDOC


# ── backend/src/modules/users/* ───────────────────────────────────────────────
cat > backend/src/modules/users/users.service.ts << 'HEREDOC'
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
HEREDOC

cat > backend/src/modules/users/users.controller.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import { usersService } from './users.service';

export const usersController = {
  async getProfile(req: Request, res: Response, next: NextFunction) {
    try {
      const user = await usersService.getProfile(req.user!.userId);
      res.json({ success: true, data: user });
    } catch (err) {
      next(err);
    }
  },

  async updateProfile(req: Request, res: Response, next: NextFunction) {
    try {
      const user = await usersService.updateProfile(req.user!.userId, req.body);
      res.json({ success: true, data: user });
    } catch (err) {
      next(err);
    }
  },

  async getTransporteurs(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const result = await usersService.getTransporteurs({ page, limit });
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },
};
HEREDOC

cat > backend/src/modules/users/users.routes.ts << 'HEREDOC'
import { Router } from 'express';
import { usersController } from './users.controller';
import { authenticate } from '../../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/me', usersController.getProfile);
router.patch('/me', usersController.updateProfile);
router.get('/transporteurs', usersController.getTransporteurs);

export default router;
HEREDOC

# ── backend/src/modules/vehicles/* ───────────────────────────────────────────
cat > backend/src/modules/vehicles/vehicles.service.ts << 'HEREDOC'
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
HEREDOC

cat > backend/src/modules/vehicles/vehicles.controller.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import { vehiclesService } from './vehicles.service';

export const vehiclesController = {
  async getMyVehicles(req: Request, res: Response, next: NextFunction) {
    try {
      const vehicles = await vehiclesService.getMyVehicles(req.user!.userId);
      res.json({ success: true, data: vehicles });
    } catch (err) {
      next(err);
    }
  },

  async getVehicleById(req: Request, res: Response, next: NextFunction) {
    try {
      const vehicle = await vehiclesService.getVehicleById(req.params.id, req.user!.userId);
      res.json({ success: true, data: vehicle });
    } catch (err) {
      next(err);
    }
  },

  async createVehicle(req: Request, res: Response, next: NextFunction) {
    try {
      const vehicle = await vehiclesService.createVehicle(req.user!.userId, req.body);
      res.status(201).json({ success: true, data: vehicle });
    } catch (err) {
      next(err);
    }
  },

  async updateVehicle(req: Request, res: Response, next: NextFunction) {
    try {
      const vehicle = await vehiclesService.updateVehicle(
        req.params.id,
        req.user!.userId,
        req.body,
      );
      res.json({ success: true, data: vehicle });
    } catch (err) {
      next(err);
    }
  },

  async deleteVehicle(req: Request, res: Response, next: NextFunction) {
    try {
      await vehiclesService.deleteVehicle(req.params.id, req.user!.userId);
      res.json({ success: true, message: 'Véhicule supprimé' });
    } catch (err) {
      next(err);
    }
  },
};
HEREDOC

cat > backend/src/modules/vehicles/vehicles.routes.ts << 'HEREDOC'
import { Router } from 'express';
import { vehiclesController } from './vehicles.controller';
import { authenticate, authorize } from '../../middleware/auth';

const router = Router();

router.use(authenticate, authorize('TRANSPORTEUR', 'ADMIN'));

router.get('/', vehiclesController.getMyVehicles);
router.get('/:id', vehiclesController.getVehicleById);
router.post('/', vehiclesController.createVehicle);
router.patch('/:id', vehiclesController.updateVehicle);
router.delete('/:id', vehiclesController.deleteVehicle);

export default router;
HEREDOC


# ── backend/src/modules/missions/* ───────────────────────────────────────────
cat > backend/src/modules/missions/missions.service.ts << 'HEREDOC'
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
HEREDOC

cat > backend/src/modules/missions/missions.controller.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import { missionsService } from './missions.service';

export const missionsController = {
  async getMyMissions(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const { userId, role } = req.user!;

      let result;
      if (role === 'CLIENT') {
        result = await missionsService.getClientMissions(userId, page, limit);
      } else {
        result = await missionsService.getTransporteurMissions(userId, page, limit);
      }

      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async getAvailable(req: Request, res: Response, next: NextFunction) {
    try {
      const missions = await missionsService.getAvailableMissions();
      res.json({ success: true, data: missions });
    } catch (err) {
      next(err);
    }
  },

  async getMissionById(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.getMissionById(req.params.id, req.user!.userId);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async createMission(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.createMission(req.user!.userId, req.body);
      res.status(201).json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async acceptMission(req: Request, res: Response, next: NextFunction) {
    try {
      const { vehicleId } = req.body;
      const mission = await missionsService.acceptMission(req.params.id, req.user!.userId, vehicleId);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async startMission(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.startMission(req.params.id, req.user!.userId);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async completeMission(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.completeMission(req.params.id, req.user!.userId);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async cancelMission(req: Request, res: Response, next: NextFunction) {
    try {
      const mission = await missionsService.cancelMission(req.params.id, req.user!.userId, req.body.reason);
      res.json({ success: true, data: mission });
    } catch (err) {
      next(err);
    }
  },

  async rateMission(req: Request, res: Response, next: NextFunction) {
    try {
      const { score, comment } = req.body;
      const rating = await missionsService.rateMission(req.params.id, req.user!.userId, score, comment);
      res.status(201).json({ success: true, data: rating });
    } catch (err) {
      next(err);
    }
  },
};
HEREDOC

cat > backend/src/modules/missions/missions.routes.ts << 'HEREDOC'
import { Router } from 'express';
import { missionsController } from './missions.controller';
import { authenticate, authorize } from '../../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/available', authorize('TRANSPORTEUR', 'ADMIN'), missionsController.getAvailable);
router.get('/', missionsController.getMyMissions);
router.get('/:id', missionsController.getMissionById);
router.post('/', authorize('CLIENT'), missionsController.createMission);
router.patch('/:id/accept', authorize('TRANSPORTEUR'), missionsController.acceptMission);
router.patch('/:id/start', authorize('TRANSPORTEUR'), missionsController.startMission);
router.patch('/:id/complete', authorize('TRANSPORTEUR'), missionsController.completeMission);
router.patch('/:id/cancel', missionsController.cancelMission);
router.post('/:id/rate', authorize('CLIENT'), missionsController.rateMission);

export default router;
HEREDOC


# ── backend ratings, admin, sockets ───────────────────────────────────────────
cat > backend/src/modules/ratings/ratings.service.ts << 'HEREDOC'
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
HEREDOC

cat > backend/src/modules/ratings/ratings.controller.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import { ratingsService } from './ratings.service';

export const ratingsController = {
  async getUserRatings(req: Request, res: Response, next: NextFunction) {
    try {
      const userId = req.params.userId ?? req.user!.userId;
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const result = await ratingsService.getUserRatings(userId, page, limit);
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async getRatingById(req: Request, res: Response, next: NextFunction) {
    try {
      const rating = await ratingsService.getRatingById(req.params.id);
      res.json({ success: true, data: rating });
    } catch (err) {
      next(err);
    }
  },
};
HEREDOC

cat > backend/src/modules/ratings/ratings.routes.ts << 'HEREDOC'
import { Router } from 'express';
import { ratingsController } from './ratings.controller';
import { authenticate } from '../../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/me', ratingsController.getUserRatings);
router.get('/user/:userId', ratingsController.getUserRatings);
router.get('/:id', ratingsController.getRatingById);

export default router;
HEREDOC

cat > backend/src/modules/admin/admin.service.ts << 'HEREDOC'
import { prisma } from '../../config/database';
import { AppError } from '../../middleware/errorHandler';

export const adminService = {
  async getDashboardStats() {
    const [
      totalUsers,
      totalMissions,
      totalTransporteurs,
      pendingMissions,
      completedMissions,
      cancelledMissions,
      totalRevenue,
      totalCommissions,
    ] = await Promise.all([
      prisma.user.count(),
      prisma.mission.count(),
      prisma.user.count({ where: { role: 'TRANSPORTEUR' } }),
      prisma.mission.count({ where: { status: 'PENDING' } }),
      prisma.mission.count({ where: { status: 'COMPLETED' } }),
      prisma.mission.count({ where: { status: 'CANCELLED' } }),
      prisma.mission.aggregate({
        where: { status: 'COMPLETED' },
        _sum: { finalPrice: true },
      }),
      prisma.commission.aggregate({
        _sum: { amount: true },
      }),
    ]);

    return {
      users: { total: totalUsers, transporteurs: totalTransporteurs },
      missions: {
        total: totalMissions,
        pending: pendingMissions,
        completed: completedMissions,
        cancelled: cancelledMissions,
      },
      revenue: {
        total: totalRevenue._sum.finalPrice ?? 0,
        commissions: totalCommissions._sum.amount ?? 0,
      },
    };
  },

  async getAllUsers(params: { page?: number; limit?: number; role?: string }) {
    const page = params.page ?? 1;
    const limit = params.limit ?? 20;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (params.role) where.role = params.role;

    const [users, total] = await Promise.all([
      prisma.user.findMany({
        where,
        select: {
          id: true,
          email: true,
          phone: true,
          firstName: true,
          lastName: true,
          role: true,
          isVerified: true,
          isActive: true,
          createdAt: true,
          _count: {
            select: { missionsAsClient: true, missionsAsTransporteur: true },
          },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.user.count({ where }),
    ]);

    return { data: users, total, page, limit, totalPages: Math.ceil(total / limit) };
  },

  async getAllMissions(params: { page?: number; limit?: number; status?: string }) {
    const page = params.page ?? 1;
    const limit = params.limit ?? 20;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (params.status) where.status = params.status;

    const [missions, total] = await Promise.all([
      prisma.mission.findMany({
        where,
        include: {
          client: { select: { id: true, firstName: true, lastName: true } },
          transporteur: { select: { id: true, firstName: true, lastName: true } },
          items: true,
          commission: true,
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.mission.count({ where }),
    ]);

    return { data: missions, total, page, limit, totalPages: Math.ceil(total / limit) };
  },

  async toggleUserStatus(userId: string, isActive: boolean) {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new AppError('Utilisateur introuvable', 404);
    if (user.role === 'ADMIN') throw new AppError('Impossible de désactiver un administrateur', 403);

    return prisma.user.update({
      where: { id: userId },
      data: { isActive },
      select: { id: true, email: true, isActive: true, role: true },
    });
  },

  async getCommissions(params: { page?: number; limit?: number; isPaid?: boolean }) {
    const page = params.page ?? 1;
    const limit = params.limit ?? 20;
    const skip = (page - 1) * limit;

    const where: any = {};
    if (params.isPaid !== undefined) where.isPaid = params.isPaid;

    const [commissions, total] = await Promise.all([
      prisma.commission.findMany({
        where,
        include: {
          mission: {
            select: { id: true, pickupAddress: true, deliveryAddress: true, finalPrice: true },
          },
          transporteur: { select: { id: true, firstName: true, lastName: true } },
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
      prisma.commission.count({ where }),
    ]);

    const totalAmount = await prisma.commission.aggregate({
      where,
      _sum: { amount: true },
    });

    return {
      data: commissions,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit),
      totalAmount: totalAmount._sum.amount ?? 0,
    };
  },

  async markCommissionPaid(id: string) {
    const commission = await prisma.commission.findUnique({ where: { id } });
    if (!commission) throw new AppError('Commission introuvable', 404);
    if (commission.isPaid) throw new AppError('Commission déjà payée', 400);

    return prisma.commission.update({
      where: { id },
      data: { isPaid: true, paidAt: new Date() },
    });
  },
};
HEREDOC

cat > backend/src/modules/admin/admin.controller.ts << 'HEREDOC'
import { Request, Response, NextFunction } from 'express';
import { adminService } from './admin.service';

export const adminController = {
  async getDashboard(req: Request, res: Response, next: NextFunction) {
    try {
      const stats = await adminService.getDashboardStats();
      res.json({ success: true, data: stats });
    } catch (err) {
      next(err);
    }
  },

  async getAllUsers(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const role = req.query.role as string | undefined;
      const result = await adminService.getAllUsers({ page, limit, role });
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async getAllMissions(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const status = req.query.status as string | undefined;
      const result = await adminService.getAllMissions({ page, limit, status });
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async toggleUserStatus(req: Request, res: Response, next: NextFunction) {
    try {
      const { isActive } = req.body;
      const user = await adminService.toggleUserStatus(req.params.userId, isActive);
      res.json({ success: true, data: user });
    } catch (err) {
      next(err);
    }
  },

  async getCommissions(req: Request, res: Response, next: NextFunction) {
    try {
      const page = req.query.page ? parseInt(req.query.page as string) : 1;
      const limit = req.query.limit ? parseInt(req.query.limit as string) : 20;
      const isPaid = req.query.isPaid !== undefined ? req.query.isPaid === 'true' : undefined;
      const result = await adminService.getCommissions({ page, limit, isPaid });
      res.json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  },

  async markCommissionPaid(req: Request, res: Response, next: NextFunction) {
    try {
      const commission = await adminService.markCommissionPaid(req.params.id);
      res.json({ success: true, data: commission });
    } catch (err) {
      next(err);
    }
  },
};
HEREDOC

cat > backend/src/modules/admin/admin.routes.ts << 'HEREDOC'
import { Router } from 'express';
import { adminController } from './admin.controller';
import { authenticate, authorize } from '../../middleware/auth';

const router = Router();

router.use(authenticate, authorize('ADMIN'));

router.get('/dashboard', adminController.getDashboard);
router.get('/users', adminController.getAllUsers);
router.patch('/users/:userId/status', adminController.toggleUserStatus);
router.get('/missions', adminController.getAllMissions);
router.get('/commissions', adminController.getCommissions);
router.patch('/commissions/:id/pay', adminController.markCommissionPaid);

export default router;
HEREDOC

cat > backend/src/sockets/gps.socket.ts << 'HEREDOC'
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
HEREDOC


# ── mobile/package.json ────────────────────────────────────────────────────────
cat > mobile/package.json << 'HEREDOC'
{
  "name": "jodrive-mobile",
  "version": "1.0.0",
  "main": "expo-router/entry",
  "scripts": {
    "start": "expo start",
    "android": "expo start --android",
    "ios": "expo start --ios",
    "web": "expo start --web",
    "lint": "eslint . --ext .ts,.tsx"
  },
  "dependencies": {
    "@react-native-async-storage/async-storage": "1.23.1",
    "@react-navigation/bottom-tabs": "^6.6.1",
    "@react-navigation/native": "^6.1.18",
    "@reduxjs/toolkit": "^2.3.0",
    "expo": "~52.0.0",
    "expo-constants": "~17.0.3",
    "expo-font": "~13.0.1",
    "expo-linking": "~7.0.3",
    "expo-location": "~18.0.4",
    "expo-router": "~4.0.9",
    "expo-splash-screen": "~0.29.13",
    "expo-status-bar": "~2.0.0",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "react-native": "0.76.3",
    "react-native-maps": "1.20.1",
    "react-native-safe-area-context": "4.12.0",
    "react-native-screens": "~4.1.0",
    "react-redux": "^9.1.2",
    "socket.io-client": "^4.8.1"
  },
  "devDependencies": {
    "@babel/core": "^7.24.0",
    "@types/react": "~18.3.12",
    "@types/react-native": "^0.73.0",
    "typescript": "^5.3.3"
  },
  "private": true
}
HEREDOC

# ── mobile/tsconfig.json ───────────────────────────────────────────────────────
cat > mobile/tsconfig.json << 'HEREDOC'
{
  "extends": "expo/tsconfig.base",
  "compilerOptions": {
    "strict": true,
    "paths": {
      "@/*": ["./*"]
    }
  }
}
HEREDOC

# ── mobile/app.json ────────────────────────────────────────────────────────────
cat > mobile/app.json << 'HEREDOC'
{
  "expo": {
    "name": "JO'DRIVE",
    "slug": "jodrive",
    "version": "1.0.0",
    "orientation": "portrait",
    "icon": "./assets/icon.png",
    "userInterfaceStyle": "dark",
    "splash": {
      "image": "./assets/splash.png",
      "resizeMode": "contain",
      "backgroundColor": "#0A0A0A"
    },
    "ios": {
      "supportsTablet": false,
      "bundleIdentifier": "com.jodrive.app",
      "infoPlist": {
        "NSLocationWhenInUseUsageDescription": "JO'DRIVE utilise votre localisation pour le suivi GPS des missions.",
        "NSLocationAlwaysUsageDescription": "JO'DRIVE utilise votre localisation en arrière-plan pour mettre à jour votre position pendant une mission.",
        "NSCameraUsageDescription": "JO'DRIVE utilise la caméra pour prendre des photos des objets à transporter.",
        "NSPhotoLibraryUsageDescription": "JO'DRIVE accède à la galerie pour sélectionner des photos."
      }
    },
    "android": {
      "adaptiveIcon": {
        "foregroundImage": "./assets/adaptive-icon.png",
        "backgroundColor": "#0A0A0A"
      },
      "package": "com.jodrive.app",
      "permissions": [
        "ACCESS_FINE_LOCATION",
        "ACCESS_COARSE_LOCATION",
        "ACCESS_BACKGROUND_LOCATION",
        "CAMERA",
        "READ_EXTERNAL_STORAGE",
        "WRITE_EXTERNAL_STORAGE"
      ]
    },
    "web": {
      "favicon": "./assets/favicon.png"
    },
    "plugins": [
      "expo-router",
      [
        "expo-location",
        {
          "locationAlwaysAndWhenInUsePermission": "JO'DRIVE utilise la localisation pour le suivi GPS des missions."
        }
      ]
    ],
    "scheme": "jodrive",
    "extra": {
      "eas": {
        "projectId": "YOUR_EAS_PROJECT_ID"
      }
    }
  }
}
HEREDOC

# ── mobile/types/index.ts ──────────────────────────────────────────────────────
cat > mobile/types/index.ts << 'HEREDOC'
// ─── Enums ───────────────────────────────────────────────────────────────────

export type UserRole = 'CLIENT' | 'TRANSPORTEUR' | 'ADMIN';

export type VehicleType = 'UTILITAIRE' | 'FOURGON' | 'CAMION';

export type MissionStatus =
  | 'PENDING'
  | 'ACCEPTED'
  | 'IN_PROGRESS'
  | 'COMPLETED'
  | 'CANCELLED';

// ─── Models ──────────────────────────────────────────────────────────────────

export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phone: string;
  role: UserRole;
  avatar?: string;
  isVerified: boolean;
  createdAt: string;
}

export interface Vehicle {
  id: string;
  transporteurId: string;
  type: VehicleType;
  brand: string;
  model: string;
  licensePlate: string;
  year: number;
  maxWeight: number;
  volume: number;
  photos: string[];
  isActive: boolean;
  createdAt: string;
}

export interface MissionItem {
  id: string;
  missionId: string;
  description: string;
  quantity: number;
  estimatedWeight?: number;
  photos: string[];
}

export interface Mission {
  id: string;
  clientId: string;
  transporteurId?: string;
  vehicleId?: string;
  status: MissionStatus;
  pickupAddress: string;
  pickupLat: number;
  pickupLng: number;
  deliveryAddress: string;
  deliveryLat: number;
  deliveryLng: number;
  scheduledAt?: string;
  startedAt?: string;
  completedAt?: string;
  price: number;
  commission: number;
  distance?: number;
  notes?: string;
  items: MissionItem[];
  client?: User;
  transporteur?: User;
  vehicle?: Vehicle;
  rating?: Rating;
  createdAt: string;
  updatedAt: string;
}

export interface Rating {
  id: string;
  missionId: string;
  fromUserId: string;
  toUserId: string;
  score: number;
  comment?: string;
  createdAt: string;
}

export interface Commission {
  id: string;
  missionId: string;
  amount: number;
  rate: number;
  status: 'PENDING' | 'PAID';
  paidAt?: string;
  createdAt: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
}

export interface LoginPayload {
  email: string;
  password: string;
}

export interface RegisterPayload {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  phone: string;
  role: UserRole;
}

export interface CreateMissionPayload {
  pickupAddress: string;
  pickupLat: number;
  pickupLng: number;
  deliveryAddress: string;
  deliveryLat: number;
  deliveryLng: number;
  scheduledAt?: string;
  notes?: string;
  items: {
    description: string;
    quantity: number;
    estimatedWeight?: number;
  }[];
}

export interface GPSLocation {
  lat: number;
  lng: number;
  heading?: number;
  speed?: number;
  timestamp: number;
}

export interface SocketEvents {
  'gps:update': (data: { missionId: string; location: GPSLocation }) => void;
  'gps:subscribe': (missionId: string) => void;
  'mission:statusChanged': (data: { missionId: string; status: MissionStatus }) => void;
  'mission:accepted': (mission: Mission) => void;
}
HEREDOC

# ── mobile/constants/colors.ts ─────────────────────────────────────────────────
cat > mobile/constants/colors.ts << 'HEREDOC'
export const Colors = {
  PRIMARY: '#E30613',
  BACKGROUND: '#0A0A0A',
  SURFACE: '#1A1A1A',
  TEXT: '#FFFFFF',
  TEXT_SECONDARY: '#999999',
  BORDER: '#2A2A2A',
  SUCCESS: '#22C55E',
  WARNING: '#F59E0B',
  ERROR: '#EF4444',
  TRANSPARENT: 'transparent',
  WHITE: '#FFFFFF',
  BLACK: '#000000',
  OVERLAY: 'rgba(0,0,0,0.6)',
} as const;

export type ColorKey = keyof typeof Colors;
HEREDOC

# ── mobile/constants/theme.ts ──────────────────────────────────────────────────
cat > mobile/constants/theme.ts << 'HEREDOC'
import { Colors } from './colors';

export const Theme = {
  colors: Colors,

  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  },

  borderRadius: {
    sm: 6,
    md: 12,
    lg: 16,
    xl: 24,
    full: 9999,
  },

  typography: {
    h1: {
      fontSize: 32,
      fontWeight: '700' as const,
      color: Colors.TEXT,
      letterSpacing: -0.5,
    },
    h2: {
      fontSize: 24,
      fontWeight: '700' as const,
      color: Colors.TEXT,
    },
    h3: {
      fontSize: 20,
      fontWeight: '600' as const,
      color: Colors.TEXT,
    },
    body: {
      fontSize: 16,
      fontWeight: '400' as const,
      color: Colors.TEXT,
    },
    caption: {
      fontSize: 13,
      fontWeight: '400' as const,
      color: Colors.TEXT_SECONDARY,
    },
    label: {
      fontSize: 14,
      fontWeight: '500' as const,
      color: Colors.TEXT,
    },
  },

  shadows: {
    sm: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 1 },
      shadowOpacity: 0.3,
      shadowRadius: 4,
      elevation: 2,
    },
    md: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 0.4,
      shadowRadius: 8,
      elevation: 4,
    },
    lg: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 8 },
      shadowOpacity: 0.5,
      shadowRadius: 16,
      elevation: 8,
    },
  },
} as const;
HEREDOC


# ── mobile/services ────────────────────────────────────────────────────────────
cat > mobile/services/storage.service.ts << 'HEREDOC'
import AsyncStorage from '@react-native-async-storage/async-storage';
import { AuthTokens } from '../types';

const KEYS = {
  ACCESS_TOKEN: 'accessToken',
  REFRESH_TOKEN: 'refreshToken',
  USER: 'user',
} as const;

export const StorageService = {
  async saveTokens(tokens: AuthTokens): Promise<void> {
    await AsyncStorage.multiSet([
      [KEYS.ACCESS_TOKEN, tokens.accessToken],
      [KEYS.REFRESH_TOKEN, tokens.refreshToken],
    ]);
  },

  async getAccessToken(): Promise<string | null> {
    return AsyncStorage.getItem(KEYS.ACCESS_TOKEN);
  },

  async getRefreshToken(): Promise<string | null> {
    return AsyncStorage.getItem(KEYS.REFRESH_TOKEN);
  },

  async clearTokens(): Promise<void> {
    await AsyncStorage.multiRemove([KEYS.ACCESS_TOKEN, KEYS.REFRESH_TOKEN]);
  },

  async saveUser(user: object): Promise<void> {
    await AsyncStorage.setItem(KEYS.USER, JSON.stringify(user));
  },

  async getUser<T>(): Promise<T | null> {
    const raw = await AsyncStorage.getItem(KEYS.USER);
    return raw ? (JSON.parse(raw) as T) : null;
  },

  async clearAll(): Promise<void> {
    await AsyncStorage.clear();
  },
};
HEREDOC

cat > mobile/services/api.ts << 'HEREDOC'
import AsyncStorage from '@react-native-async-storage/async-storage';
import { ApiResponse } from '../types';

const BASE_URL = process.env.EXPO_PUBLIC_API_URL ?? 'http://localhost:3000/api';

class ApiClient {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  private async getHeaders(): Promise<Record<string, string>> {
    const token = await AsyncStorage.getItem('accessToken');
    return {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    };
  }

  private async request<T>(
    method: string,
    path: string,
    body?: unknown,
  ): Promise<ApiResponse<T>> {
    const headers = await this.getHeaders();
    const response = await fetch(`${this.baseUrl}${path}`, {
      method,
      headers,
      body: body ? JSON.stringify(body) : undefined,
    });

    const json = await response.json();

    if (!response.ok) {
      throw new Error(json.message ?? 'Une erreur est survenue');
    }

    return json as ApiResponse<T>;
  }

  get<T>(path: string) {
    return this.request<T>('GET', path);
  }

  post<T>(path: string, body: unknown) {
    return this.request<T>('POST', path, body);
  }

  put<T>(path: string, body: unknown) {
    return this.request<T>('PUT', path, body);
  }

  patch<T>(path: string, body: unknown) {
    return this.request<T>('PATCH', path, body);
  }

  delete<T>(path: string) {
    return this.request<T>('DELETE', path);
  }
}

export const api = new ApiClient(BASE_URL);
HEREDOC

cat > mobile/services/auth.service.ts << 'HEREDOC'
import { api } from './api';
import { StorageService } from './storage.service';
import { AuthTokens, LoginPayload, RegisterPayload, User } from '../types';

export const AuthService = {
  async login(payload: LoginPayload): Promise<{ user: User; tokens: AuthTokens }> {
    const res = await api.post<{ user: User; tokens: AuthTokens }>('/auth/login', payload);
    await StorageService.saveTokens(res.data.tokens);
    return res.data;
  },

  async register(payload: RegisterPayload): Promise<{ user: User; tokens: AuthTokens }> {
    const res = await api.post<{ user: User; tokens: AuthTokens }>('/auth/register', payload);
    await StorageService.saveTokens(res.data.tokens);
    return res.data;
  },

  async refreshToken(): Promise<AuthTokens> {
    const refreshToken = await StorageService.getRefreshToken();
    const res = await api.post<AuthTokens>('/auth/refresh', { refreshToken });
    await StorageService.saveTokens(res.data);
    return res.data;
  },

  async logout(): Promise<void> {
    await StorageService.clearTokens();
  },

  async getMe(): Promise<User> {
    const res = await api.get<User>('/auth/me');
    return res.data;
  },
};
HEREDOC

cat > mobile/services/missions.service.ts << 'HEREDOC'
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
HEREDOC

# ── mobile/store ───────────────────────────────────────────────────────────────
cat > mobile/store/index.ts << 'HEREDOC'
import { configureStore } from '@reduxjs/toolkit';
import { TypedUseSelectorHook, useDispatch, useSelector } from 'react-redux';
import authReducer from './auth.slice';
import missionsReducer from './missions.slice';

export const store = configureStore({
  reducer: {
    auth: authReducer,
    missions: missionsReducer,
  },
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({
      serializableCheck: false,
    }),
});

export type RootState = ReturnType<typeof store.getState>;
export type AppDispatch = typeof store.dispatch;

export const useAppDispatch = () => useDispatch<AppDispatch>();
export const useAppSelector: TypedUseSelectorHook<RootState> = useSelector;
HEREDOC

cat > mobile/store/auth.slice.ts << 'HEREDOC'
import { createAsyncThunk, createSlice, PayloadAction } from '@reduxjs/toolkit';
import { AuthService } from '../services/auth.service';
import { StorageService } from '../services/storage.service';
import { LoginPayload, RegisterPayload, User } from '../types';

interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
}

const initialState: AuthState = {
  user: null,
  isAuthenticated: false,
  isLoading: false,
  error: null,
};

export const login = createAsyncThunk(
  'auth/login',
  async (payload: LoginPayload, { rejectWithValue }) => {
    try {
      const result = await AuthService.login(payload);
      await StorageService.saveUser(result.user);
      return result.user;
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

export const register = createAsyncThunk(
  'auth/register',
  async (payload: RegisterPayload, { rejectWithValue }) => {
    try {
      const result = await AuthService.register(payload);
      await StorageService.saveUser(result.user);
      return result.user;
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

export const logout = createAsyncThunk('auth/logout', async () => {
  await AuthService.logout();
  await StorageService.clearAll();
});

export const hydrateAuth = createAsyncThunk('auth/hydrate', async () => {
  const token = await StorageService.getAccessToken();
  if (!token) return null;
  const user = await StorageService.getUser<User>();
  return user;
});

const authSlice = createSlice({
  name: 'auth',
  initialState,
  reducers: {
    setUser(state, action: PayloadAction<User>) {
      state.user = action.payload;
      state.isAuthenticated = true;
    },
    clearError(state) {
      state.error = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(login.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(login.fulfilled, (state, action) => {
        state.isLoading = false;
        state.user = action.payload;
        state.isAuthenticated = true;
      })
      .addCase(login.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      });

    builder
      .addCase(register.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(register.fulfilled, (state, action) => {
        state.isLoading = false;
        state.user = action.payload;
        state.isAuthenticated = true;
      })
      .addCase(register.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      });

    builder.addCase(logout.fulfilled, (state) => {
      state.user = null;
      state.isAuthenticated = false;
    });

    builder.addCase(hydrateAuth.fulfilled, (state, action) => {
      if (action.payload) {
        state.user = action.payload;
        state.isAuthenticated = true;
      }
    });
  },
});

export const { setUser, clearError } = authSlice.actions;
export default authSlice.reducer;
HEREDOC

cat > mobile/store/missions.slice.ts << 'HEREDOC'
import { createAsyncThunk, createSlice } from '@reduxjs/toolkit';
import { MissionsService } from '../services/missions.service';
import { CreateMissionPayload, Mission } from '../types';

interface MissionsState {
  list: Mission[];
  current: Mission | null;
  available: Mission[];
  isLoading: boolean;
  error: string | null;
  total: number;
  page: number;
}

const initialState: MissionsState = {
  list: [],
  current: null,
  available: [],
  isLoading: false,
  error: null,
  total: 0,
  page: 1,
};

export const fetchMissions = createAsyncThunk(
  'missions/fetchAll',
  async ({ page }: { page?: number } = {}, { rejectWithValue }) => {
    try {
      return await MissionsService.getMyMissions(page);
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

export const fetchMissionById = createAsyncThunk(
  'missions/fetchById',
  async (id: string, { rejectWithValue }) => {
    try {
      return await MissionsService.getMissionById(id);
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

export const createMission = createAsyncThunk(
  'missions/create',
  async (payload: CreateMissionPayload, { rejectWithValue }) => {
    try {
      return await MissionsService.createMission(payload);
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

export const fetchAvailableMissions = createAsyncThunk(
  'missions/fetchAvailable',
  async (_, { rejectWithValue }) => {
    try {
      return await MissionsService.getAvailableMissions();
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

export const acceptMission = createAsyncThunk(
  'missions/accept',
  async ({ id, vehicleId }: { id: string; vehicleId: string }, { rejectWithValue }) => {
    try {
      return await MissionsService.acceptMission(id, vehicleId);
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

export const startMission = createAsyncThunk(
  'missions/start',
  async (id: string, { rejectWithValue }) => {
    try {
      return await MissionsService.startMission(id);
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

export const completeMission = createAsyncThunk(
  'missions/complete',
  async (id: string, { rejectWithValue }) => {
    try {
      return await MissionsService.completeMission(id);
    } catch (err: any) {
      return rejectWithValue(err.message);
    }
  },
);

const missionsSlice = createSlice({
  name: 'missions',
  initialState,
  reducers: {
    updateMissionInList(state, action) {
      const idx = state.list.findIndex((m) => m.id === action.payload.id);
      if (idx !== -1) state.list[idx] = action.payload;
      if (state.current?.id === action.payload.id) state.current = action.payload;
    },
    clearCurrent(state) {
      state.current = null;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchMissions.pending, (state) => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchMissions.fulfilled, (state, action) => {
        state.isLoading = false;
        state.list = action.payload.data;
        state.total = action.payload.total;
        state.page = action.payload.page;
      })
      .addCase(fetchMissions.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      });

    builder
      .addCase(fetchMissionById.pending, (state) => {
        state.isLoading = true;
      })
      .addCase(fetchMissionById.fulfilled, (state, action) => {
        state.isLoading = false;
        state.current = action.payload;
      })
      .addCase(fetchMissionById.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.payload as string;
      });

    builder.addCase(createMission.fulfilled, (state, action) => {
      state.list.unshift(action.payload);
      state.current = action.payload;
    });

    builder.addCase(fetchAvailableMissions.fulfilled, (state, action) => {
      state.available = action.payload;
    });

    builder
      .addCase(acceptMission.fulfilled, (state, action) => {
        const idx = state.available.findIndex((m) => m.id === action.payload.id);
        if (idx !== -1) state.available.splice(idx, 1);
        state.current = action.payload;
      })
      .addCase(startMission.fulfilled, (state, action) => {
        state.current = action.payload;
      })
      .addCase(completeMission.fulfilled, (state, action) => {
        state.current = action.payload;
      });
  },
});

export const { updateMissionInList, clearCurrent } = missionsSlice.actions;
export default missionsSlice.reducer;
HEREDOC


# ── mobile/hooks ───────────────────────────────────────────────────────────────
cat > mobile/hooks/useAuth.ts << 'HEREDOC'
import { useCallback } from 'react';
import { useAppDispatch, useAppSelector } from '../store';
import {
  login,
  logout,
  register,
  clearError,
} from '../store/auth.slice';
import { LoginPayload, RegisterPayload } from '../types';

export function useAuth() {
  const dispatch = useAppDispatch();
  const { user, isAuthenticated, isLoading, error } = useAppSelector(
    (state) => state.auth,
  );

  const handleLogin = useCallback(
    (payload: LoginPayload) => dispatch(login(payload)),
    [dispatch],
  );

  const handleRegister = useCallback(
    (payload: RegisterPayload) => dispatch(register(payload)),
    [dispatch],
  );

  const handleLogout = useCallback(() => dispatch(logout()), [dispatch]);

  const handleClearError = useCallback(() => dispatch(clearError()), [dispatch]);

  return {
    user,
    isAuthenticated,
    isLoading,
    error,
    login: handleLogin,
    register: handleRegister,
    logout: handleLogout,
    clearError: handleClearError,
  };
}
HEREDOC

cat > mobile/hooks/useMissions.ts << 'HEREDOC'
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
HEREDOC

cat > mobile/hooks/useSocket.ts << 'HEREDOC'
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
HEREDOC

# ── mobile/app/_layout.tsx ─────────────────────────────────────────────────────
cat > mobile/app/_layout.tsx << 'HEREDOC'
import React, { useEffect } from 'react';
import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';
import { Provider } from 'react-redux';
import { store, useAppDispatch, useAppSelector } from '../store';
import { hydrateAuth } from '../store/auth.slice';

function RootNavigator() {
  const dispatch = useAppDispatch();
  const { isAuthenticated, user } = useAppSelector((s) => s.auth);

  useEffect(() => {
    dispatch(hydrateAuth());
  }, [dispatch]);

  return (
    <>
      <StatusBar style="light" backgroundColor="#0A0A0A" />
      <Stack screenOptions={{ headerShown: false }}>
        {!isAuthenticated ? (
          <Stack.Screen name="(auth)" />
        ) : user?.role === 'CLIENT' ? (
          <Stack.Screen name="(client)" />
        ) : user?.role === 'TRANSPORTEUR' ? (
          <Stack.Screen name="(transporteur)" />
        ) : (
          <Stack.Screen name="(admin)" />
        )}
      </Stack>
    </>
  );
}

export default function RootLayout() {
  return (
    <Provider store={store}>
      <RootNavigator />
    </Provider>
  );
}
HEREDOC

# ── mobile/app/(auth) ──────────────────────────────────────────────────────────
cat > 'mobile/app/(auth)/_layout.tsx' << 'HEREDOC'
import { Stack } from 'expo-router';

export default function AuthLayout() {
  return (
    <Stack
      screenOptions={{
        headerShown: false,
        animation: 'slide_from_right',
      }}
    />
  );
}
HEREDOC


# ── mobile/app/(auth)/login.tsx ────────────────────────────────────────────────
cat > 'mobile/app/(auth)/login.tsx' << 'HEREDOC'
import React, { useEffect, useState } from 'react';
import {
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useAuth } from '../../hooks/useAuth';
import { Button } from '../../components/ui/Button';
import { Input } from '../../components/ui/Input';
import { Colors } from '../../constants/colors';

export default function LoginScreen() {
  const router = useRouter();
  const { login, isLoading, error, clearError, isAuthenticated, user } = useAuth();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  useEffect(() => {
    if (isAuthenticated && user) {
      if (user.role === 'CLIENT') router.replace('/(client)/');
      else if (user.role === 'TRANSPORTEUR') router.replace('/(transporteur)/dashboard');
      else router.replace('/(admin)/dashboard');
    }
  }, [isAuthenticated, user]);

  useEffect(() => {
    if (error) {
      Alert.alert('Erreur de connexion', error, [{ text: 'OK', onPress: clearError }]);
    }
  }, [error]);

  const handleLogin = async () => {
    if (!email.trim() || !password.trim()) {
      Alert.alert('Champs requis', 'Veuillez remplir tous les champs.');
      return;
    }
    await login({ email: email.trim().toLowerCase(), password });
  };

  return (
    <KeyboardAvoidingView
      style={styles.flex}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
    >
      <ScrollView
        contentContainerStyle={styles.container}
        keyboardShouldPersistTaps="handled"
      >
        <View style={styles.logoSection}>
          <View style={styles.logoContainer}>
            <Text style={styles.logoText}>JO</Text>
            <View style={styles.logoDivider} />
            <Text style={styles.logoTextWhite}>DRIVE</Text>
          </View>
          <Text style={styles.tagline}>Mobilité • Livraison • Course</Text>
        </View>

        <View style={styles.formSection}>
          <Text style={styles.title}>Connexion</Text>
          <Text style={styles.subtitle}>Bienvenue sur JO'DRIVE Guyane</Text>

          <Input
            label="Adresse e-mail"
            value={email}
            onChangeText={setEmail}
            placeholder="nom@exemple.com"
            keyboardType="email-address"
            autoCapitalize="none"
            autoComplete="email"
          />

          <Input
            label="Mot de passe"
            value={password}
            onChangeText={setPassword}
            placeholder="••••••••"
            secureTextEntry={!showPassword}
            rightIcon={
              <Text style={styles.showPassword}>
                {showPassword ? 'Masquer' : 'Voir'}
              </Text>
            }
            onRightIconPress={() => setShowPassword((v) => !v)}
          />

          <TouchableOpacity style={styles.forgotRow}>
            <Text style={styles.forgot}>Mot de passe oublié ?</Text>
          </TouchableOpacity>

          <Button
            title="Se connecter"
            onPress={handleLogin}
            loading={isLoading}
            fullWidth
            size="lg"
            style={styles.loginBtn}
          />
        </View>

        <View style={styles.footer}>
          <Text style={styles.footerText}>Pas encore de compte ? </Text>
          <TouchableOpacity onPress={() => router.push('/(auth)/register')}>
            <Text style={styles.footerLink}>S'inscrire</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  flex: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: {
    flexGrow: 1,
    paddingHorizontal: 24,
    paddingTop: 80,
    paddingBottom: 40,
  },
  logoSection: {
    alignItems: 'center',
    marginBottom: 56,
  },
  logoContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 0,
    marginBottom: 10,
  },
  logoText: {
    fontSize: 40,
    fontWeight: '900',
    color: Colors.PRIMARY,
    letterSpacing: -1,
  },
  logoDivider: {
    width: 3,
    height: 40,
    backgroundColor: Colors.WHITE,
    marginHorizontal: 6,
  },
  logoTextWhite: {
    fontSize: 40,
    fontWeight: '900',
    color: Colors.WHITE,
    letterSpacing: -1,
  },
  tagline: {
    fontSize: 13,
    color: Colors.TEXT_SECONDARY,
    letterSpacing: 1.5,
  },
  formSection: {
    flex: 1,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    color: Colors.TEXT,
    marginBottom: 6,
  },
  subtitle: {
    fontSize: 15,
    color: Colors.TEXT_SECONDARY,
    marginBottom: 32,
  },
  forgotRow: {
    alignSelf: 'flex-end',
    marginTop: -8,
    marginBottom: 24,
  },
  forgot: {
    color: Colors.PRIMARY,
    fontSize: 14,
    fontWeight: '500',
  },
  loginBtn: {
    marginTop: 8,
  },
  showPassword: {
    color: Colors.PRIMARY,
    fontSize: 13,
    fontWeight: '600',
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: 32,
  },
  footerText: {
    color: Colors.TEXT_SECONDARY,
    fontSize: 14,
  },
  footerLink: {
    color: Colors.PRIMARY,
    fontSize: 14,
    fontWeight: '600',
  },
});
HEREDOC


# ── mobile/app/(auth)/register.tsx ────────────────────────────────────────────
cat > 'mobile/app/(auth)/register.tsx' << 'HEREDOC'
import React, { useEffect, useState } from 'react';
import {
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useAuth } from '../../hooks/useAuth';
import { Button } from '../../components/ui/Button';
import { Input } from '../../components/ui/Input';
import { Colors } from '../../constants/colors';
import { UserRole } from '../../types';

export default function RegisterScreen() {
  const router = useRouter();
  const { register, isLoading, error, clearError, isAuthenticated, user } = useAuth();

  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<UserRole>('CLIENT');

  useEffect(() => {
    if (isAuthenticated && user) {
      if (user.role === 'CLIENT') router.replace('/(client)/');
      else if (user.role === 'TRANSPORTEUR') router.replace('/(transporteur)/dashboard');
    }
  }, [isAuthenticated, user]);

  useEffect(() => {
    if (error) {
      Alert.alert("Erreur d'inscription", error, [{ text: 'OK', onPress: clearError }]);
    }
  }, [error]);

  const handleRegister = async () => {
    if (!firstName || !lastName || !email || !phone || !password) {
      Alert.alert('Champs requis', 'Veuillez remplir tous les champs.');
      return;
    }
    if (password.length < 8) {
      Alert.alert('Mot de passe', 'Le mot de passe doit contenir au moins 8 caractères.');
      return;
    }
    await register({
      firstName,
      lastName,
      email: email.trim().toLowerCase(),
      phone,
      password,
      role,
    });
  };

  return (
    <KeyboardAvoidingView
      style={styles.flex}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
    >
      <ScrollView
        contentContainerStyle={styles.container}
        keyboardShouldPersistTaps="handled"
      >
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backText}>← Retour</Text>
        </TouchableOpacity>

        <Text style={styles.title}>Créer un compte</Text>
        <Text style={styles.subtitle}>Rejoignez JO'DRIVE dès maintenant</Text>

        <View style={styles.roleSection}>
          <Text style={styles.roleLabel}>Je suis :</Text>
          <View style={styles.roleRow}>
            {(['CLIENT', 'TRANSPORTEUR'] as UserRole[]).map((r) => (
              <TouchableOpacity
                key={r}
                style={[styles.roleBtn, role === r && styles.roleBtnActive]}
                onPress={() => setRole(r)}
                activeOpacity={0.8}
              >
                <Text style={styles.roleIcon}>
                  {r === 'CLIENT' ? '👤' : '🚚'}
                </Text>
                <Text
                  style={[styles.roleBtnText, role === r && styles.roleBtnTextActive]}
                >
                  {r === 'CLIENT' ? 'Client' : 'Transporteur'}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        <View style={styles.row}>
          <View style={styles.flex}>
            <Input
              label="Prénom"
              value={firstName}
              onChangeText={setFirstName}
              placeholder="Jean"
              autoCapitalize="words"
            />
          </View>
          <View style={styles.flex}>
            <Input
              label="Nom"
              value={lastName}
              onChangeText={setLastName}
              placeholder="Dupont"
              autoCapitalize="words"
            />
          </View>
        </View>

        <Input
          label="E-mail"
          value={email}
          onChangeText={setEmail}
          placeholder="jean@exemple.com"
          keyboardType="email-address"
          autoCapitalize="none"
        />

        <Input
          label="Téléphone"
          value={phone}
          onChangeText={setPhone}
          placeholder="+594 ..."
          keyboardType="phone-pad"
        />

        <Input
          label="Mot de passe"
          value={password}
          onChangeText={setPassword}
          placeholder="Minimum 8 caractères"
          secureTextEntry
          hint="Au moins 8 caractères, avec chiffres et lettres."
        />

        <Button
          title="Créer mon compte"
          onPress={handleRegister}
          loading={isLoading}
          fullWidth
          size="lg"
          style={styles.registerBtn}
        />

        <View style={styles.footer}>
          <Text style={styles.footerText}>Déjà inscrit ? </Text>
          <TouchableOpacity onPress={() => router.back()}>
            <Text style={styles.footerLink}>Se connecter</Text>
          </TouchableOpacity>
        </View>

        <Text style={styles.legal}>
          En vous inscrivant, vous acceptez nos Conditions Générales d'Utilisation
          et notre Politique de Confidentialité.
        </Text>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  flex: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { flexGrow: 1, paddingHorizontal: 24, paddingTop: 56, paddingBottom: 40 },
  backBtn: { marginBottom: 24 },
  backText: { color: Colors.TEXT_SECONDARY, fontSize: 15 },
  title: { fontSize: 28, fontWeight: '700', color: Colors.TEXT, marginBottom: 6 },
  subtitle: { fontSize: 15, color: Colors.TEXT_SECONDARY, marginBottom: 28 },
  roleSection: { marginBottom: 24 },
  roleLabel: { fontSize: 14, color: Colors.TEXT_SECONDARY, fontWeight: '600', marginBottom: 10, textTransform: 'uppercase', letterSpacing: 0.5 },
  roleRow: { flexDirection: 'row', gap: 12 },
  roleBtn: {
    flex: 1,
    backgroundColor: Colors.SURFACE,
    borderRadius: 14,
    padding: 16,
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: Colors.BORDER,
    gap: 6,
  },
  roleBtnActive: { borderColor: Colors.PRIMARY, backgroundColor: 'rgba(227,6,19,0.06)' },
  roleIcon: { fontSize: 24 },
  roleBtnText: { color: Colors.TEXT_SECONDARY, fontWeight: '600', fontSize: 14 },
  roleBtnTextActive: { color: Colors.PRIMARY },
  row: { flexDirection: 'row', gap: 12 },
  registerBtn: { marginTop: 8 },
  footer: { flexDirection: 'row', justifyContent: 'center', marginTop: 24 },
  footerText: { color: Colors.TEXT_SECONDARY, fontSize: 14 },
  footerLink: { color: Colors.PRIMARY, fontSize: 14, fontWeight: '600' },
  legal: { fontSize: 11, color: Colors.TEXT_SECONDARY, textAlign: 'center', marginTop: 20, lineHeight: 17 },
});
HEREDOC


# ── mobile/app/(client)/_layout.tsx ───────────────────────────────────────────
cat > 'mobile/app/(client)/_layout.tsx' << 'HEREDOC'
import { Tabs } from 'expo-router';
import { Colors } from '../../constants/colors';
import { Text } from 'react-native';

function TabIcon({ emoji, focused }: { emoji: string; focused: boolean }) {
  return (
    <Text style={{ fontSize: 22, opacity: focused ? 1 : 0.5 }}>{emoji}</Text>
  );
}

export default function ClientLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: Colors.SURFACE,
          borderTopColor: Colors.BORDER,
          borderTopWidth: 1,
          paddingBottom: 20,
          paddingTop: 10,
          height: 70,
        },
        tabBarActiveTintColor: Colors.PRIMARY,
        tabBarInactiveTintColor: Colors.TEXT_SECONDARY,
        tabBarLabelStyle: { fontSize: 11, fontWeight: '600' },
      }}
    >
      <Tabs.Screen
        name="index"
        options={{
          title: 'Accueil',
          tabBarIcon: ({ focused }) => <TabIcon emoji="🏠" focused={focused} />,
        }}
      />
      <Tabs.Screen
        name="nouvelle-mission"
        options={{
          title: 'Mission',
          tabBarIcon: ({ focused }) => <TabIcon emoji="📦" focused={focused} />,
        }}
      />
      <Tabs.Screen
        name="historique"
        options={{
          title: 'Historique',
          tabBarIcon: ({ focused }) => <TabIcon emoji="📋" focused={focused} />,
        }}
      />
      <Tabs.Screen
        name="profil"
        options={{
          title: 'Profil',
          tabBarIcon: ({ focused }) => <TabIcon emoji="👤" focused={focused} />,
        }}
      />
      <Tabs.Screen
        name="mission/[id]"
        options={{ href: null }}
      />
    </Tabs>
  );
}
HEREDOC

# ── mobile/app/(transporteur)/_layout.tsx ─────────────────────────────────────
cat > 'mobile/app/(transporteur)/_layout.tsx' << 'HEREDOC'
import { Tabs } from 'expo-router';
import { Text } from 'react-native';
import { Colors } from '../../constants/colors';

function TabIcon({ emoji, focused }: { emoji: string; focused: boolean }) {
  return <Text style={{ fontSize: 22, opacity: focused ? 1 : 0.5 }}>{emoji}</Text>;
}

export default function TransporteurLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: Colors.SURFACE,
          borderTopColor: Colors.BORDER,
          borderTopWidth: 1,
          paddingBottom: 20,
          paddingTop: 10,
          height: 70,
        },
        tabBarActiveTintColor: Colors.PRIMARY,
        tabBarInactiveTintColor: Colors.TEXT_SECONDARY,
        tabBarLabelStyle: { fontSize: 11, fontWeight: '600' },
      }}
    >
      <Tabs.Screen name="dashboard" options={{ title: 'Tableau', tabBarIcon: ({ focused }) => <TabIcon emoji="📊" focused={focused} /> }} />
      <Tabs.Screen name="missions" options={{ title: 'Missions', tabBarIcon: ({ focused }) => <TabIcon emoji="📦" focused={focused} /> }} />
      <Tabs.Screen name="vehicules" options={{ title: 'Véhicules', tabBarIcon: ({ focused }) => <TabIcon emoji="🚚" focused={focused} /> }} />
      <Tabs.Screen name="revenus" options={{ title: 'Revenus', tabBarIcon: ({ focused }) => <TabIcon emoji="💰" focused={focused} /> }} />
      <Tabs.Screen name="profil" options={{ title: 'Profil', tabBarIcon: ({ focused }) => <TabIcon emoji="👤" focused={focused} /> }} />
      <Tabs.Screen name="mission/[id]" options={{ href: null }} />
    </Tabs>
  );
}
HEREDOC

# ── mobile/app/(admin)/_layout.tsx ────────────────────────────────────────────
cat > 'mobile/app/(admin)/_layout.tsx' << 'HEREDOC'
import { Tabs } from 'expo-router';
import { Text } from 'react-native';
import { Colors } from '../../constants/colors';

function TabIcon({ emoji, focused }: { emoji: string; focused: boolean }) {
  return <Text style={{ fontSize: 22, opacity: focused ? 1 : 0.5 }}>{emoji}</Text>;
}

export default function AdminLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: Colors.SURFACE,
          borderTopColor: Colors.BORDER,
          borderTopWidth: 1,
          paddingBottom: 20,
          paddingTop: 10,
          height: 70,
        },
        tabBarActiveTintColor: Colors.PRIMARY,
        tabBarInactiveTintColor: Colors.TEXT_SECONDARY,
        tabBarLabelStyle: { fontSize: 10, fontWeight: '600' },
      }}
    >
      <Tabs.Screen name="dashboard" options={{ title: 'Dashboard', tabBarIcon: ({ focused }) => <TabIcon emoji="📊" focused={focused} /> }} />
      <Tabs.Screen name="utilisateurs" options={{ title: 'Utilisateurs', tabBarIcon: ({ focused }) => <TabIcon emoji="👥" focused={focused} /> }} />
      <Tabs.Screen name="missions" options={{ title: 'Missions', tabBarIcon: ({ focused }) => <TabIcon emoji="📦" focused={focused} /> }} />
      <Tabs.Screen name="commissions" options={{ title: 'Commissions', tabBarIcon: ({ focused }) => <TabIcon emoji="💳" focused={focused} /> }} />
      <Tabs.Screen name="statistiques" options={{ title: 'Stats', tabBarIcon: ({ focused }) => <TabIcon emoji="📈" focused={focused} /> }} />
    </Tabs>
  );
}
HEREDOC



# ─── Screen files (base64-encoded to avoid heredoc conflicts) ───────────────
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsKICBBY3Rpdml0eUluZGljYXRvciwKICBTdHlsZVNoZWV0LAogIFRleHQsCiAgVG91Y2hhYmxlT3BhY2l0eSwKICBUb3VjaGFibGVPcGFjaXR5UHJvcHMsCiAgVmlld1N0eWxlLAp9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwoKdHlwZSBWYXJpYW50ID0gJ3ByaW1hcnknIHwgJ3NlY29uZGFyeScgfCAnb3V0bGluZScgfCAnZ2hvc3QnIHwgJ2Rhbmdlcic7CnR5cGUgU2l6ZSA9ICdzbScgfCAnbWQnIHwgJ2xnJzsKCmludGVyZmFjZSBCdXR0b25Qcm9wcyBleHRlbmRzIFRvdWNoYWJsZU9wYWNpdHlQcm9wcyB7CiAgdGl0bGU6IHN0cmluZzsKICB2YXJpYW50PzogVmFyaWFudDsKICBzaXplPzogU2l6ZTsKICBsb2FkaW5nPzogYm9vbGVhbjsKICBmdWxsV2lkdGg/OiBib29sZWFuOwogIHN0eWxlPzogVmlld1N0eWxlOwp9CgpleHBvcnQgZnVuY3Rpb24gQnV0dG9uKHsKICB0aXRsZSwKICB2YXJpYW50ID0gJ3ByaW1hcnknLAogIHNpemUgPSAnbWQnLAogIGxvYWRpbmcgPSBmYWxzZSwKICBmdWxsV2lkdGggPSBmYWxzZSwKICBzdHlsZSwKICBkaXNhYmxlZCwKICAuLi5yZXN0Cn06IEJ1dHRvblByb3BzKSB7CiAgY29uc3QgaXNEaXNhYmxlZCA9IGRpc2FibGVkIHx8IGxvYWRpbmc7CgogIHJldHVybiAoCiAgICA8VG91Y2hhYmxlT3BhY2l0eQogICAgICBzdHlsZT17WwogICAgICAgIHN0eWxlcy5iYXNlLAogICAgICAgIHN0eWxlc1t2YXJpYW50XSwKICAgICAgICBzdHlsZXNbc2l6ZV0sCiAgICAgICAgZnVsbFdpZHRoICYmIHN0eWxlcy5mdWxsV2lkdGgsCiAgICAgICAgaXNEaXNhYmxlZCAmJiBzdHlsZXMuZGlzYWJsZWQsCiAgICAgICAgc3R5bGUsCiAgICAgIF19CiAgICAgIGRpc2FibGVkPXtpc0Rpc2FibGVkfQogICAgICBhY3RpdmVPcGFjaXR5PXswLjh9CiAgICAgIHsuLi5yZXN0fQogICAgPgogICAgICB7bG9hZGluZyA/ICgKICAgICAgICA8QWN0aXZpdHlJbmRpY2F0b3IKICAgICAgICAgIHNpemU9InNtYWxsIgogICAgICAgICAgY29sb3I9e3ZhcmlhbnQgPT09ICdvdXRsaW5lJyB8fCB2YXJpYW50ID09PSAnZ2hvc3QnID8gQ29sb3JzLlBSSU1BUlkgOiBDb2xvcnMuV0hJVEV9CiAgICAgICAgLz4KICAgICAgKSA6ICgKICAgICAgICA8VGV4dCBzdHlsZT17W3N0eWxlcy50ZXh0LCBzdHlsZXNbYHRleHRfJHt2YXJpYW50fWBdLCBzdHlsZXNbYHRleHRfJHtzaXplfWBdXX0+CiAgICAgICAgICB7dGl0bGV9CiAgICAgICAgPC9UZXh0PgogICAgICApfQogICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICk7Cn0KCmNvbnN0IHN0eWxlcyA9IFN0eWxlU2hlZXQuY3JlYXRlKHsKICBiYXNlOiB7CiAgICBmbGV4RGlyZWN0aW9uOiAncm93JywKICAgIGFsaWduSXRlbXM6ICdjZW50ZXInLAogICAganVzdGlmeUNvbnRlbnQ6ICdjZW50ZXInLAogICAgYm9yZGVyUmFkaXVzOiAxMiwKICB9LAogIHByaW1hcnk6IHsgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuUFJJTUFSWSB9LAogIHNlY29uZGFyeTogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5TVVJGQUNFIH0sCiAgb3V0bGluZTogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5UUkFOU1BBUkVOVCwgYm9yZGVyV2lkdGg6IDEuNSwgYm9yZGVyQ29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgZ2hvc3Q6IHsgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuVFJBTlNQQVJFTlQgfSwKICBkYW5nZXI6IHsgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuRVJST1IgfSwKICBzbTogeyBwYWRkaW5nSG9yaXpvbnRhbDogMTIsIHBhZGRpbmdWZXJ0aWNhbDogOCB9LAogIG1kOiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ1ZlcnRpY2FsOiAxNCB9LAogIGxnOiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyOCwgcGFkZGluZ1ZlcnRpY2FsOiAxOCB9LAogIGRpc2FibGVkOiB7IG9wYWNpdHk6IDAuNSB9LAogIGZ1bGxXaWR0aDogeyB3aWR0aDogJzEwMCUnIH0sCiAgdGV4dDogeyBmb250V2VpZ2h0OiAnNjAwJywgbGV0dGVyU3BhY2luZzogMC4zIH0sCiAgdGV4dF9wcmltYXJ5OiB7IGNvbG9yOiBDb2xvcnMuV0hJVEUgfSwKICB0ZXh0X3NlY29uZGFyeTogeyBjb2xvcjogQ29sb3JzLlRFWFQgfSwKICB0ZXh0X291dGxpbmU6IHsgY29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgdGV4dF9naG9zdDogeyBjb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKICB0ZXh0X2RhbmdlcjogeyBjb2xvcjogQ29sb3JzLldISVRFIH0sCiAgdGV4dF9zbTogeyBmb250U2l6ZTogMTMgfSwKICB0ZXh0X21kOiB7IGZvbnRTaXplOiAxNSB9LAogIHRleHRfbGc6IHsgZm9udFNpemU6IDE3IH0sCn0pOwo=" | base64 -d > 'mobile/components/ui/Button.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZVN0YXRlIH0gZnJvbSAncmVhY3QnOwppbXBvcnQgewogIFN0eWxlU2hlZXQsCiAgVGV4dCwKICBUZXh0SW5wdXQsCiAgVGV4dElucHV0UHJvcHMsCiAgVG91Y2hhYmxlT3BhY2l0eSwKICBWaWV3LAp9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwoKaW50ZXJmYWNlIElucHV0UHJvcHMgZXh0ZW5kcyBUZXh0SW5wdXRQcm9wcyB7CiAgbGFiZWw/OiBzdHJpbmc7CiAgZXJyb3I/OiBzdHJpbmc7CiAgaGludD86IHN0cmluZzsKICBsZWZ0SWNvbj86IFJlYWN0LlJlYWN0Tm9kZTsKICByaWdodEljb24/OiBSZWFjdC5SZWFjdE5vZGU7CiAgb25SaWdodEljb25QcmVzcz86ICgpID0+IHZvaWQ7Cn0KCmV4cG9ydCBmdW5jdGlvbiBJbnB1dCh7CiAgbGFiZWwsCiAgZXJyb3IsCiAgaGludCwKICBsZWZ0SWNvbiwKICByaWdodEljb24sCiAgb25SaWdodEljb25QcmVzcywKICBzdHlsZSwKICAuLi5yZXN0Cn06IElucHV0UHJvcHMpIHsKICBjb25zdCBbZm9jdXNlZCwgc2V0Rm9jdXNlZF0gPSB1c2VTdGF0ZShmYWxzZSk7CgogIHJldHVybiAoCiAgICA8VmlldyBzdHlsZT17c3R5bGVzLmNvbnRhaW5lcn0+CiAgICAgIHtsYWJlbCAmJiA8VGV4dCBzdHlsZT17c3R5bGVzLmxhYmVsfT57bGFiZWx9PC9UZXh0Pn0KCiAgICAgIDxWaWV3CiAgICAgICAgc3R5bGU9e1sKICAgICAgICAgIHN0eWxlcy5pbnB1dFdyYXBwZXIsCiAgICAgICAgICBmb2N1c2VkICYmIHN0eWxlcy5pbnB1dFdyYXBwZXJGb2N1c2VkLAogICAgICAgICAgISFlcnJvciAmJiBzdHlsZXMuaW5wdXRXcmFwcGVyRXJyb3IsCiAgICAgICAgXX0KICAgICAgPgogICAgICAgIHtsZWZ0SWNvbiAmJiA8VmlldyBzdHlsZT17c3R5bGVzLmxlZnRJY29ufT57bGVmdEljb259PC9WaWV3Pn0KCiAgICAgICAgPFRleHRJbnB1dAogICAgICAgICAgc3R5bGU9e1tzdHlsZXMuaW5wdXQsIGxlZnRJY29uID8gc3R5bGVzLmlucHV0V2l0aExlZnQgOiBudWxsLCBzdHlsZV19CiAgICAgICAgICBwbGFjZWhvbGRlclRleHRDb2xvcj17Q29sb3JzLlRFWFRfU0VDT05EQVJZfQogICAgICAgICAgb25Gb2N1cz17KCkgPT4gc2V0Rm9jdXNlZCh0cnVlKX0KICAgICAgICAgIG9uQmx1cj17KCkgPT4gc2V0Rm9jdXNlZChmYWxzZSl9CiAgICAgICAgICB7Li4ucmVzdH0KICAgICAgICAvPgoKICAgICAgICB7cmlnaHRJY29uICYmICgKICAgICAgICAgIDxUb3VjaGFibGVPcGFjaXR5CiAgICAgICAgICAgIG9uUHJlc3M9e29uUmlnaHRJY29uUHJlc3N9CiAgICAgICAgICAgIHN0eWxlPXtzdHlsZXMucmlnaHRJY29ufQogICAgICAgICAgICBhY3RpdmVPcGFjaXR5PXswLjd9CiAgICAgICAgICA+CiAgICAgICAgICAgIHtyaWdodEljb259CiAgICAgICAgICA8L1RvdWNoYWJsZU9wYWNpdHk+CiAgICAgICAgKX0KICAgICAgPC9WaWV3PgoKICAgICAge2Vycm9yID8gKAogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZXJyb3J9PntlcnJvcn08L1RleHQ+CiAgICAgICkgOiBoaW50ID8gKAogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuaGludH0+e2hpbnR9PC9UZXh0PgogICAgICApIDogbnVsbH0KICAgIDwvVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgY29udGFpbmVyOiB7IG1hcmdpbkJvdHRvbTogMTYgfSwKICBsYWJlbDogewogICAgZm9udFNpemU6IDEzLAogICAgZm9udFdlaWdodDogJzYwMCcsCiAgICBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLAogICAgbWFyZ2luQm90dG9tOiA2LAogICAgdGV4dFRyYW5zZm9ybTogJ3VwcGVyY2FzZScsCiAgICBsZXR0ZXJTcGFjaW5nOiAwLjUsCiAgfSwKICBpbnB1dFdyYXBwZXI6IHsKICAgIGZsZXhEaXJlY3Rpb246ICdyb3cnLAogICAgYWxpZ25JdGVtczogJ2NlbnRlcicsCiAgICBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5TVVJGQUNFLAogICAgYm9yZGVyUmFkaXVzOiAxMiwKICAgIGJvcmRlcldpZHRoOiAxLjUsCiAgICBib3JkZXJDb2xvcjogQ29sb3JzLkJPUkRFUiwKICB9LAogIGlucHV0V3JhcHBlckZvY3VzZWQ6IHsgYm9yZGVyQ29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgaW5wdXRXcmFwcGVyRXJyb3I6IHsgYm9yZGVyQ29sb3I6IENvbG9ycy5FUlJPUiB9LAogIGlucHV0OiB7CiAgICBmbGV4OiAxLAogICAgcGFkZGluZ0hvcml6b250YWw6IDE2LAogICAgcGFkZGluZ1ZlcnRpY2FsOiAxNCwKICAgIGZvbnRTaXplOiAxNSwKICAgIGNvbG9yOiBDb2xvcnMuVEVYVCwKICB9LAogIGlucHV0V2l0aExlZnQ6IHsgcGFkZGluZ0xlZnQ6IDggfSwKICBsZWZ0SWNvbjogeyBwYWRkaW5nTGVmdDogMTQgfSwKICByaWdodEljb246IHsgcGFkZGluZ1JpZ2h0OiAxNCB9LAogIGVycm9yOiB7IGZvbnRTaXplOiAxMiwgY29sb3I6IENvbG9ycy5FUlJPUiwgbWFyZ2luVG9wOiA0LCBtYXJnaW5MZWZ0OiA0IH0sCiAgaGludDogeyBmb250U2l6ZTogMTIsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIG1hcmdpblRvcDogNCwgbWFyZ2luTGVmdDogNCB9LAp9KTsK" | base64 -d > 'mobile/components/ui/Input.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgU3R5bGVTaGVldCwgVmlldywgVmlld1Byb3BzLCBWaWV3U3R5bGUgfSBmcm9tICdyZWFjdC1uYXRpdmUnOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKCmludGVyZmFjZSBDYXJkUHJvcHMgZXh0ZW5kcyBWaWV3UHJvcHMgewogIGNoaWxkcmVuOiBSZWFjdC5SZWFjdE5vZGU7CiAgc3R5bGU/OiBWaWV3U3R5bGU7CiAgcGFkZGluZz86ICdub25lJyB8ICdzbScgfCAnbWQnIHwgJ2xnJzsKICBlbGV2YXRlZD86IGJvb2xlYW47Cn0KCmV4cG9ydCBmdW5jdGlvbiBDYXJkKHsKICBjaGlsZHJlbiwKICBzdHlsZSwKICBwYWRkaW5nID0gJ21kJywKICBlbGV2YXRlZCA9IGZhbHNlLAogIC4uLnJlc3QKfTogQ2FyZFByb3BzKSB7CiAgcmV0dXJuICgKICAgIDxWaWV3CiAgICAgIHN0eWxlPXtbCiAgICAgICAgc3R5bGVzLmNhcmQsCiAgICAgICAgc3R5bGVzW2BwYWRkaW5nXyR7cGFkZGluZ31gXSwKICAgICAgICBlbGV2YXRlZCAmJiBzdHlsZXMuZWxldmF0ZWQsCiAgICAgICAgc3R5bGUsCiAgICAgIF19CiAgICAgIHsuLi5yZXN0fQogICAgPgogICAgICB7Y2hpbGRyZW59CiAgICA8L1ZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIGNhcmQ6IHsKICAgIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsCiAgICBib3JkZXJSYWRpdXM6IDE2LAogICAgYm9yZGVyV2lkdGg6IDEsCiAgICBib3JkZXJDb2xvcjogQ29sb3JzLkJPUkRFUiwKICB9LAogIHBhZGRpbmdfbm9uZTogeyBwYWRkaW5nOiAwIH0sCiAgcGFkZGluZ19zbTogeyBwYWRkaW5nOiAxMiB9LAogIHBhZGRpbmdfbWQ6IHsgcGFkZGluZzogMTYgfSwKICBwYWRkaW5nX2xnOiB7IHBhZGRpbmc6IDI0IH0sCiAgZWxldmF0ZWQ6IHsKICAgIHNoYWRvd0NvbG9yOiAnIzAwMCcsCiAgICBzaGFkb3dPZmZzZXQ6IHsgd2lkdGg6IDAsIGhlaWdodDogNCB9LAogICAgc2hhZG93T3BhY2l0eTogMC40LAogICAgc2hhZG93UmFkaXVzOiA4LAogICAgZWxldmF0aW9uOiA0LAogIH0sCn0pOwo=" | base64 -d > 'mobile/components/ui/Card.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgSW1hZ2UsIFN0eWxlU2hlZXQsIFRleHQsIFZpZXcsIFZpZXdTdHlsZSB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwoKdHlwZSBBdmF0YXJTaXplID0gJ3NtJyB8ICdtZCcgfCAnbGcnIHwgJ3hsJzsKCmludGVyZmFjZSBBdmF0YXJQcm9wcyB7CiAgdXJpPzogc3RyaW5nOwogIG5hbWU/OiBzdHJpbmc7CiAgc2l6ZT86IEF2YXRhclNpemU7CiAgc3R5bGU/OiBWaWV3U3R5bGU7Cn0KCmNvbnN0IHNpemVzOiBSZWNvcmQ8QXZhdGFyU2l6ZSwgbnVtYmVyPiA9IHsKICBzbTogMzIsCiAgbWQ6IDQ0LAogIGxnOiA1NiwKICB4bDogODAsCn07CgpmdW5jdGlvbiBnZXRJbml0aWFscyhuYW1lPzogc3RyaW5nKTogc3RyaW5nIHsKICBpZiAoIW5hbWUpIHJldHVybiAnPyc7CiAgY29uc3QgcGFydHMgPSBuYW1lLnRyaW0oKS5zcGxpdCgnICcpOwogIGlmIChwYXJ0cy5sZW5ndGggPT09IDEpIHJldHVybiBwYXJ0c1swXVswXS50b1VwcGVyQ2FzZSgpOwogIHJldHVybiAocGFydHNbMF1bMF0gKyBwYXJ0c1twYXJ0cy5sZW5ndGggLSAxXVswXSkudG9VcHBlckNhc2UoKTsKfQoKZXhwb3J0IGZ1bmN0aW9uIEF2YXRhcih7IHVyaSwgbmFtZSwgc2l6ZSA9ICdtZCcsIHN0eWxlIH06IEF2YXRhclByb3BzKSB7CiAgY29uc3QgZGltID0gc2l6ZXNbc2l6ZV07CgogIGlmICh1cmkpIHsKICAgIHJldHVybiAoCiAgICAgIDxJbWFnZQogICAgICAgIHNvdXJjZT17eyB1cmkgfX0KICAgICAgICBzdHlsZT17W3N0eWxlcy5hdmF0YXIsIHsgd2lkdGg6IGRpbSwgaGVpZ2h0OiBkaW0sIGJvcmRlclJhZGl1czogZGltIC8gMiB9LCBzdHlsZV19CiAgICAgIC8+CiAgICApOwogIH0KCiAgcmV0dXJuICgKICAgIDxWaWV3CiAgICAgIHN0eWxlPXtbCiAgICAgICAgc3R5bGVzLnBsYWNlaG9sZGVyLAogICAgICAgIHsgd2lkdGg6IGRpbSwgaGVpZ2h0OiBkaW0sIGJvcmRlclJhZGl1czogZGltIC8gMiB9LAogICAgICAgIHN0eWxlLAogICAgICBdfQogICAgPgogICAgICA8VGV4dCBzdHlsZT17W3N0eWxlcy5pbml0aWFscywgeyBmb250U2l6ZTogZGltICogMC4zOCB9XX0+CiAgICAgICAge2dldEluaXRpYWxzKG5hbWUpfQogICAgICA8L1RleHQ+CiAgICA8L1ZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIGF2YXRhcjogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIgfSwKICBwbGFjZWhvbGRlcjogewogICAgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuUFJJTUFSWSwKICAgIGFsaWduSXRlbXM6ICdjZW50ZXInLAogICAganVzdGlmeUNvbnRlbnQ6ICdjZW50ZXInLAogIH0sCiAgaW5pdGlhbHM6IHsgY29sb3I6IENvbG9ycy5XSElURSwgZm9udFdlaWdodDogJzcwMCcgfSwKfSk7Cg==" | base64 -d > 'mobile/components/ui/Avatar.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgU3R5bGVTaGVldCwgVGV4dCwgVmlldywgVmlld1N0eWxlIH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgQ29sb3JzIH0gZnJvbSAnLi4vLi4vY29uc3RhbnRzL2NvbG9ycyc7CmltcG9ydCB7IE1pc3Npb25TdGF0dXMgfSBmcm9tICcuLi8uLi90eXBlcyc7Cgp0eXBlIEJhZGdlVmFyaWFudCA9ICdkZWZhdWx0JyB8ICdzdWNjZXNzJyB8ICd3YXJuaW5nJyB8ICdlcnJvcicgfCAnaW5mbyc7CgppbnRlcmZhY2UgQmFkZ2VQcm9wcyB7CiAgbGFiZWw6IHN0cmluZzsKICB2YXJpYW50PzogQmFkZ2VWYXJpYW50OwogIHN0eWxlPzogVmlld1N0eWxlOwp9CgpleHBvcnQgZnVuY3Rpb24gQmFkZ2UoeyBsYWJlbCwgdmFyaWFudCA9ICdkZWZhdWx0Jywgc3R5bGUgfTogQmFkZ2VQcm9wcykgewogIHJldHVybiAoCiAgICA8VmlldyBzdHlsZT17W3N0eWxlcy5iYWRnZSwgc3R5bGVzW3ZhcmlhbnRdLCBzdHlsZV19PgogICAgICA8VGV4dCBzdHlsZT17W3N0eWxlcy50ZXh0LCBzdHlsZXNbYHRleHRfJHt2YXJpYW50fWBdXX0+e2xhYmVsfTwvVGV4dD4KICAgIDwvVmlldz4KICApOwp9CgpleHBvcnQgZnVuY3Rpb24gTWlzc2lvblN0YXR1c0JhZGdlKHsgc3RhdHVzIH06IHsgc3RhdHVzOiBNaXNzaW9uU3RhdHVzIH0pIHsKICBjb25zdCBtYXA6IFJlY29yZDxNaXNzaW9uU3RhdHVzLCB7IGxhYmVsOiBzdHJpbmc7IHZhcmlhbnQ6IEJhZGdlVmFyaWFudCB9PiA9IHsKICAgIFBFTkRJTkc6IHsgbGFiZWw6ICdFbiBhdHRlbnRlJywgdmFyaWFudDogJ3dhcm5pbmcnIH0sCiAgICBBQ0NFUFRFRDogeyBsYWJlbDogJ0FjY2VwdMOpZScsIHZhcmlhbnQ6ICdpbmZvJyB9LAogICAgSU5fUFJPR1JFU1M6IHsgbGFiZWw6ICdFbiBjb3VycycsIHZhcmlhbnQ6ICdpbmZvJyB9LAogICAgQ09NUExFVEVEOiB7IGxhYmVsOiAnVGVybWluw6llJywgdmFyaWFudDogJ3N1Y2Nlc3MnIH0sCiAgICBDQU5DRUxMRUQ6IHsgbGFiZWw6ICdBbm51bMOpZScsIHZhcmlhbnQ6ICdlcnJvcicgfSwKICB9OwogIGNvbnN0IHsgbGFiZWwsIHZhcmlhbnQgfSA9IG1hcFtzdGF0dXNdOwogIHJldHVybiA8QmFkZ2UgbGFiZWw9e2xhYmVsfSB2YXJpYW50PXt2YXJpYW50fSAvPjsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIGJhZGdlOiB7CiAgICBwYWRkaW5nSG9yaXpvbnRhbDogMTAsCiAgICBwYWRkaW5nVmVydGljYWw6IDQsCiAgICBib3JkZXJSYWRpdXM6IDk5OSwKICAgIGFsaWduU2VsZjogJ2ZsZXgtc3RhcnQnLAogIH0sCiAgdGV4dDogeyBmb250U2l6ZTogMTIsIGZvbnRXZWlnaHQ6ICc2MDAnIH0sCiAgZGVmYXVsdDogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIgfSwKICBzdWNjZXNzOiB7IGJhY2tncm91bmRDb2xvcjogJ3JnYmEoMzQsMTk3LDk0LDAuMTUpJyB9LAogIHdhcm5pbmc6IHsgYmFja2dyb3VuZENvbG9yOiAncmdiYSgyNDUsMTU4LDExLDAuMTUpJyB9LAogIGVycm9yOiB7IGJhY2tncm91bmRDb2xvcjogJ3JnYmEoMjM5LDY4LDY4LDAuMTUpJyB9LAogIGluZm86IHsgYmFja2dyb3VuZENvbG9yOiAncmdiYSgyMjcsNiwxOSwwLjE1KScgfSwKICB0ZXh0X2RlZmF1bHQ6IHsgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSB9LAogIHRleHRfc3VjY2VzczogeyBjb2xvcjogQ29sb3JzLlNVQ0NFU1MgfSwKICB0ZXh0X3dhcm5pbmc6IHsgY29sb3I6IENvbG9ycy5XQVJOSU5HIH0sCiAgdGV4dF9lcnJvcjogeyBjb2xvcjogQ29sb3JzLkVSUk9SIH0sCiAgdGV4dF9pbmZvOiB7IGNvbG9yOiBDb2xvcnMuUFJJTUFSWSB9LAp9KTsK" | base64 -d > 'mobile/components/ui/Badge.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgU3R5bGVTaGVldCwgVGV4dCwgVG91Y2hhYmxlT3BhY2l0eSwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwppbXBvcnQgeyBNaXNzaW9uIH0gZnJvbSAnLi4vLi4vdHlwZXMnOwppbXBvcnQgeyBDYXJkIH0gZnJvbSAnLi4vdWkvQ2FyZCc7CmltcG9ydCB7IE1pc3Npb25TdGF0dXNCYWRnZSB9IGZyb20gJy4uL3VpL0JhZGdlJzsKCmludGVyZmFjZSBNaXNzaW9uQ2FyZFByb3BzIHsKICBtaXNzaW9uOiBNaXNzaW9uOwogIG9uUHJlc3M6IChtaXNzaW9uOiBNaXNzaW9uKSA9PiB2b2lkOwp9CgpmdW5jdGlvbiBmb3JtYXREYXRlKGRhdGVTdHI6IHN0cmluZyk6IHN0cmluZyB7CiAgY29uc3QgZCA9IG5ldyBEYXRlKGRhdGVTdHIpOwogIHJldHVybiBkLnRvTG9jYWxlRGF0ZVN0cmluZygnZnItRlInLCB7CiAgICBkYXk6ICcyLWRpZ2l0JywKICAgIG1vbnRoOiAnc2hvcnQnLAogICAgaG91cjogJzItZGlnaXQnLAogICAgbWludXRlOiAnMi1kaWdpdCcsCiAgfSk7Cn0KCmV4cG9ydCBmdW5jdGlvbiBNaXNzaW9uQ2FyZCh7IG1pc3Npb24sIG9uUHJlc3MgfTogTWlzc2lvbkNhcmRQcm9wcykgewogIHJldHVybiAoCiAgICA8VG91Y2hhYmxlT3BhY2l0eSBvblByZXNzPXsoKSA9PiBvblByZXNzKG1pc3Npb24pfSBhY3RpdmVPcGFjaXR5PXswLjh9PgogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLmNhcmR9IGVsZXZhdGVkPgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaGVhZGVyfT4KICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaWRSb3d9PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmlkVGV4dH0+I3ttaXNzaW9uLmlkLnNsaWNlKDAsIDgpLnRvVXBwZXJDYXNlKCl9PC9UZXh0PgogICAgICAgICAgICA8TWlzc2lvblN0YXR1c0JhZGdlIHN0YXR1cz17bWlzc2lvbi5zdGF0dXN9IC8+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnByaWNlfT57bWlzc2lvbi5wcmljZS50b0ZpeGVkKDIpfSDigqw8L1RleHQ+CiAgICAgICAgPC9WaWV3PgoKICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnJvdXRlfT4KICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMucm91dGVSb3d9PgogICAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmRvdH0gLz4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5hZGRyZXNzfSBudW1iZXJPZkxpbmVzPXsxfT57bWlzc2lvbi5waWNrdXBBZGRyZXNzfTwvVGV4dD4KICAgICAgICAgIDwvVmlldz4KICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMucm91dGVMaW5lfSAvPgogICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5yb3V0ZVJvd30+CiAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtbc3R5bGVzLmRvdCwgc3R5bGVzLmRvdERlc3RpbmF0aW9uXX0gLz4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5hZGRyZXNzfSBudW1iZXJPZkxpbmVzPXsxfT57bWlzc2lvbi5kZWxpdmVyeUFkZHJlc3N9PC9UZXh0PgogICAgICAgICAgPC9WaWV3PgogICAgICAgIDwvVmlldz4KCiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5mb290ZXJ9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5tZXRhfT57bWlzc2lvbi5pdGVtcy5sZW5ndGh9IG9iamV0e21pc3Npb24uaXRlbXMubGVuZ3RoID4gMSA/ICdzJyA6ICcnfTwvVGV4dD4KICAgICAgICAgIHttaXNzaW9uLmRpc3RhbmNlICE9IG51bGwgJiYgKAogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLm1ldGF9PnttaXNzaW9uLmRpc3RhbmNlLnRvRml4ZWQoMSl9IGttPC9UZXh0PgogICAgICAgICAgKX0KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMubWV0YX0+e2Zvcm1hdERhdGUobWlzc2lvbi5jcmVhdGVkQXQpfTwvVGV4dD4KICAgICAgICA8L1ZpZXc+CiAgICAgIDwvQ2FyZD4KICAgIDwvVG91Y2hhYmxlT3BhY2l0eT4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgY2FyZDogeyBtYXJnaW5Cb3R0b206IDEyIH0sCiAgaGVhZGVyOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBqdXN0aWZ5Q29udGVudDogJ3NwYWNlLWJldHdlZW4nLCBhbGlnbkl0ZW1zOiAnZmxleC1zdGFydCcsIG1hcmdpbkJvdHRvbTogMTQgfSwKICBpZFJvdzogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYWxpZ25JdGVtczogJ2NlbnRlcicsIGdhcDogOCB9LAogIGlkVGV4dDogeyBmb250U2l6ZTogMTIsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIGZvbnRXZWlnaHQ6ICc2MDAnIH0sCiAgcHJpY2U6IHsgZm9udFNpemU6IDE4LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgcm91dGU6IHsgbWFyZ2luQm90dG9tOiAxNCB9LAogIHJvdXRlUm93OiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgZ2FwOiAxMCB9LAogIHJvdXRlTGluZTogeyB3aWR0aDogMiwgaGVpZ2h0OiAxOCwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQk9SREVSLCBtYXJnaW5MZWZ0OiA3LCBtYXJnaW5WZXJ0aWNhbDogMiB9LAogIGRvdDogeyB3aWR0aDogMTQsIGhlaWdodDogMTQsIGJvcmRlclJhZGl1czogNywgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VDQ0VTUywgYm9yZGVyV2lkdGg6IDIsIGJvcmRlckNvbG9yOiBDb2xvcnMuU1VSRkFDRSB9LAogIGRvdERlc3RpbmF0aW9uOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKICBhZGRyZXNzOiB7IGZsZXg6IDEsIGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhULCBmb250V2VpZ2h0OiAnNTAwJyB9LAogIGZvb3RlcjogeyBmbGV4RGlyZWN0aW9uOiAncm93JywganVzdGlmeUNvbnRlbnQ6ICdzcGFjZS1iZXR3ZWVuJywgYm9yZGVyVG9wV2lkdGg6IDEsIGJvcmRlclRvcENvbG9yOiBDb2xvcnMuQk9SREVSLCBwYWRkaW5nVG9wOiAxMiB9LAogIG1ldGE6IHsgZm9udFNpemU6IDEyLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCn0pOwo=" | base64 -d > 'mobile/components/mission/MissionCard.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgU3R5bGVTaGVldCwgVGV4dCwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwppbXBvcnQgeyBNaXNzaW9uU3RhdHVzIGFzIE1pc3Npb25TdGF0dXNUeXBlIH0gZnJvbSAnLi4vLi4vdHlwZXMnOwoKaW50ZXJmYWNlIFN0ZXAgewogIGtleTogTWlzc2lvblN0YXR1c1R5cGU7CiAgbGFiZWw6IHN0cmluZzsKfQoKY29uc3QgU1RFUFM6IFN0ZXBbXSA9IFsKICB7IGtleTogJ1BFTkRJTkcnLCBsYWJlbDogJ0VuIGF0dGVudGUnIH0sCiAgeyBrZXk6ICdBQ0NFUFRFRCcsIGxhYmVsOiAnQWNjZXB0w6llJyB9LAogIHsga2V5OiAnSU5fUFJPR1JFU1MnLCBsYWJlbDogJ0VuIGNvdXJzJyB9LAogIHsga2V5OiAnQ09NUExFVEVEJywgbGFiZWw6ICdUZXJtaW7DqWUnIH0sCl07Cgpjb25zdCBPUkRFUjogTWlzc2lvblN0YXR1c1R5cGVbXSA9IFsnUEVORElORycsICdBQ0NFUFRFRCcsICdJTl9QUk9HUkVTUycsICdDT01QTEVURUQnXTsKCmludGVyZmFjZSBQcm9wcyB7IHN0YXR1czogTWlzc2lvblN0YXR1c1R5cGU7IH0KCmV4cG9ydCBmdW5jdGlvbiBNaXNzaW9uU3RhdHVzVHJhY2tlcih7IHN0YXR1cyB9OiBQcm9wcykgewogIGlmIChzdGF0dXMgPT09ICdDQU5DRUxMRUQnKSB7CiAgICByZXR1cm4gKAogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmNhbmNlbGxlZH0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5jYW5jZWxsZWRUZXh0fT5NaXNzaW9uIGFubnVsw6llPC9UZXh0PgogICAgICA8L1ZpZXc+CiAgICApOwogIH0KCiAgY29uc3QgY3VycmVudElkeCA9IE9SREVSLmluZGV4T2Yoc3RhdHVzKTsKCiAgcmV0dXJuICgKICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuY29udGFpbmVyfT4KICAgICAge1NURVBTLm1hcCgoc3RlcCwgaWR4KSA9PiB7CiAgICAgICAgY29uc3QgZG9uZSA9IGlkeCA8IGN1cnJlbnRJZHg7CiAgICAgICAgY29uc3QgYWN0aXZlID0gaWR4ID09PSBjdXJyZW50SWR4OwogICAgICAgIHJldHVybiAoCiAgICAgICAgICA8UmVhY3QuRnJhZ21lbnQga2V5PXtzdGVwLmtleX0+CiAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuc3RlcH0+CiAgICAgICAgICAgICAgPFZpZXcgc3R5bGU9e1tzdHlsZXMuY2lyY2xlLCBkb25lICYmIHN0eWxlcy5jaXJjbGVEb25lLCBhY3RpdmUgJiYgc3R5bGVzLmNpcmNsZUFjdGl2ZV19PgogICAgICAgICAgICAgICAge2RvbmUgPyAoCiAgICAgICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuY2hlY2ttYXJrfT7inJM8L1RleHQ+CiAgICAgICAgICAgICAgICApIDogKAogICAgICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17W3N0eWxlcy5zdGVwTnVtYmVyLCBhY3RpdmUgJiYgc3R5bGVzLnN0ZXBOdW1iZXJBY3RpdmVdfT57aWR4ICsgMX08L1RleHQ+CiAgICAgICAgICAgICAgICApfQogICAgICAgICAgICAgIDwvVmlldz4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17W3N0eWxlcy5zdGVwTGFiZWwsIGFjdGl2ZSAmJiBzdHlsZXMuc3RlcExhYmVsQWN0aXZlLCBkb25lICYmIHN0eWxlcy5zdGVwTGFiZWxEb25lXX0+CiAgICAgICAgICAgICAgICB7c3RlcC5sYWJlbH0KICAgICAgICAgICAgICA8L1RleHQ+CiAgICAgICAgICAgIDwvVmlldz4KICAgICAgICAgICAge2lkeCA8IFNURVBTLmxlbmd0aCAtIDEgJiYgKAogICAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtbc3R5bGVzLmxpbmUsIGRvbmUgJiYgc3R5bGVzLmxpbmVEb25lXX0gLz4KICAgICAgICAgICAgKX0KICAgICAgICAgIDwvUmVhY3QuRnJhZ21lbnQ+CiAgICAgICAgKTsKICAgICAgfSl9CiAgICA8L1ZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIGNvbnRhaW5lcjogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYWxpZ25JdGVtczogJ2ZsZXgtc3RhcnQnLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicsIHBhZGRpbmdWZXJ0aWNhbDogMTYgfSwKICBzdGVwOiB7IGFsaWduSXRlbXM6ICdjZW50ZXInLCB3aWR0aDogNzIgfSwKICBjaXJjbGU6IHsgd2lkdGg6IDMyLCBoZWlnaHQ6IDMyLCBib3JkZXJSYWRpdXM6IDE2LCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicsIG1hcmdpbkJvdHRvbTogNiB9LAogIGNpcmNsZURvbmU6IHsgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VDQ0VTUyB9LAogIGNpcmNsZUFjdGl2ZTogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgY2hlY2ttYXJrOiB7IGNvbG9yOiBDb2xvcnMuV0hJVEUsIGZvbnRTaXplOiAxNCwgZm9udFdlaWdodDogJzcwMCcgfSwKICBzdGVwTnVtYmVyOiB7IGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIGZvbnRTaXplOiAxMywgZm9udFdlaWdodDogJzYwMCcgfSwKICBzdGVwTnVtYmVyQWN0aXZlOiB7IGNvbG9yOiBDb2xvcnMuV0hJVEUgfSwKICBzdGVwTGFiZWw6IHsgZm9udFNpemU6IDExLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCB0ZXh0QWxpZ246ICdjZW50ZXInIH0sCiAgc3RlcExhYmVsQWN0aXZlOiB7IGNvbG9yOiBDb2xvcnMuUFJJTUFSWSwgZm9udFdlaWdodDogJzYwMCcgfSwKICBzdGVwTGFiZWxEb25lOiB7IGNvbG9yOiBDb2xvcnMuU1VDQ0VTUyB9LAogIGxpbmU6IHsgZmxleDogMSwgaGVpZ2h0OiAyLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIsIG1hcmdpblRvcDogMTUgfSwKICBsaW5lRG9uZTogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5TVUNDRVNTIH0sCiAgY2FuY2VsbGVkOiB7IGJhY2tncm91bmRDb2xvcjogJ3JnYmEoMjM5LDY4LDY4LDAuMSknLCBib3JkZXJSYWRpdXM6IDEyLCBwYWRkaW5nVmVydGljYWw6IDE0LCBhbGlnbkl0ZW1zOiAnY2VudGVyJyB9LAogIGNhbmNlbGxlZFRleHQ6IHsgY29sb3I6IENvbG9ycy5FUlJPUiwgZm9udFdlaWdodDogJzYwMCcsIGZvbnRTaXplOiAxNSB9LAp9KTsK" | base64 -d > 'mobile/components/mission/MissionStatus.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgU2Nyb2xsVmlldywgU3R5bGVTaGVldCwgVGV4dCwgVG91Y2hhYmxlT3BhY2l0eSwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwppbXBvcnQgeyBWZWhpY2xlLCBWZWhpY2xlVHlwZSB9IGZyb20gJy4uLy4uL3R5cGVzJzsKCmludGVyZmFjZSBWZWhpY2xlU2VsZWN0b3JQcm9wcyB7CiAgdmVoaWNsZXM6IFZlaGljbGVbXTsKICBzZWxlY3RlZD86IHN0cmluZzsKICBvblNlbGVjdDogKHZlaGljbGVJZDogc3RyaW5nKSA9PiB2b2lkOwp9Cgpjb25zdCBWRUhJQ0xFX0lDT05TOiBSZWNvcmQ8VmVoaWNsZVR5cGUsIHN0cmluZz4gPSB7CiAgVVRJTElUQUlSRTogJ/CfmpAnLAogIEZPVVJHT046ICfwn5qaJywKICBDQU1JT046ICfwn4+X77iPJywKfTsKCmNvbnN0IFZFSElDTEVfTEFCRUxTOiBSZWNvcmQ8VmVoaWNsZVR5cGUsIHN0cmluZz4gPSB7CiAgVVRJTElUQUlSRTogJ1V0aWxpdGFpcmUnLAogIEZPVVJHT046ICdGb3VyZ29uJywKICBDQU1JT046ICdDYW1pb24nLAp9OwoKZXhwb3J0IGZ1bmN0aW9uIFZlaGljbGVTZWxlY3Rvcih7IHZlaGljbGVzLCBzZWxlY3RlZCwgb25TZWxlY3QgfTogVmVoaWNsZVNlbGVjdG9yUHJvcHMpIHsKICByZXR1cm4gKAogICAgPFZpZXc+CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VjdGlvblRpdGxlfT5DaG9pc2lyIHVuIHbDqWhpY3VsZTwvVGV4dD4KICAgICAgPFNjcm9sbFZpZXcgaG9yaXpvbnRhbCBzaG93c0hvcml6b250YWxTY3JvbGxJbmRpY2F0b3I9e2ZhbHNlfSBjb250ZW50Q29udGFpbmVyU3R5bGU9e3N0eWxlcy5zY3JvbGx9PgogICAgICAgIHt2ZWhpY2xlcy5tYXAoKHYpID0+IHsKICAgICAgICAgIGNvbnN0IGlzU2VsZWN0ZWQgPSBzZWxlY3RlZCA9PT0gdi5pZDsKICAgICAgICAgIHJldHVybiAoCiAgICAgICAgICAgIDxUb3VjaGFibGVPcGFjaXR5CiAgICAgICAgICAgICAga2V5PXt2LmlkfQogICAgICAgICAgICAgIHN0eWxlPXtbc3R5bGVzLmNhcmQsIGlzU2VsZWN0ZWQgJiYgc3R5bGVzLmNhcmRTZWxlY3RlZF19CiAgICAgICAgICAgICAgb25QcmVzcz17KCkgPT4gb25TZWxlY3Qodi5pZCl9CiAgICAgICAgICAgICAgYWN0aXZlT3BhY2l0eT17MC44fQogICAgICAgICAgICA+CiAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5pY29ufT57VkVISUNMRV9JQ09OU1t2LnR5cGVdfTwvVGV4dD4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17W3N0eWxlcy50eXBlLCBpc1NlbGVjdGVkICYmIHN0eWxlcy50eXBlU2VsZWN0ZWRdfT57VkVISUNMRV9MQUJFTFNbdi50eXBlXX08L1RleHQ+CiAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5kZXRhaWx9Pnt2LmJyYW5kfSB7di5tb2RlbH08L1RleHQ+CiAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5wbGF0ZX0+e3YubGljZW5zZVBsYXRlfTwvVGV4dD4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmNhcGFjaXR5fT57di5tYXhXZWlnaHR9IGtnIOKAoiB7di52b2x1bWV9IG3CszwvVGV4dD4KICAgICAgICAgICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICAgICAgICAgKTsKICAgICAgICB9KX0KICAgICAgPC9TY3JvbGxWaWV3PgogICAgPC9WaWV3PgogICk7Cn0KCmNvbnN0IHN0eWxlcyA9IFN0eWxlU2hlZXQuY3JlYXRlKHsKICBzZWN0aW9uVGl0bGU6IHsgZm9udFNpemU6IDE2LCBmb250V2VpZ2h0OiAnNjAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDEyIH0sCiAgc2Nyb2xsOiB7IGdhcDogMTIsIHBhZGRpbmdCb3R0b206IDQgfSwKICBjYXJkOiB7IHdpZHRoOiAxNDAsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsIGJvcmRlclJhZGl1czogMTQsIHBhZGRpbmc6IDE0LCBib3JkZXJXaWR0aDogMS41LCBib3JkZXJDb2xvcjogQ29sb3JzLkJPUkRFUiB9LAogIGNhcmRTZWxlY3RlZDogeyBib3JkZXJDb2xvcjogQ29sb3JzLlBSSU1BUlksIGJhY2tncm91bmRDb2xvcjogJ3JnYmEoMjI3LDYsMTksMC4wNSknIH0sCiAgaWNvbjogeyBmb250U2l6ZTogMjgsIG1hcmdpbkJvdHRvbTogOCB9LAogIHR5cGU6IHsgZm9udFNpemU6IDE0LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDIgfSwKICB0eXBlU2VsZWN0ZWQ6IHsgY29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgZGV0YWlsOiB7IGZvbnRTaXplOiAxMiwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luQm90dG9tOiA0IH0sCiAgcGxhdGU6IHsgZm9udFNpemU6IDEyLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBmb250V2VpZ2h0OiAnNjAwJywgbWFyZ2luQm90dG9tOiA4IH0sCiAgY2FwYWNpdHk6IHsgZm9udFNpemU6IDExLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCn0pOwo=" | base64 -d > 'mobile/components/mission/VehicleSelector.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZUVmZmVjdCwgdXNlUmVmIH0gZnJvbSAncmVhY3QnOwppbXBvcnQgeyBTdHlsZVNoZWV0LCBWaWV3LCBUZXh0IH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IE1hcFZpZXcsIHsgTWFya2VyLCBQb2x5bGluZSwgUFJPVklERVJfR09PR0xFIH0gZnJvbSAncmVhY3QtbmF0aXZlLW1hcHMnOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgR1BTTG9jYXRpb24gfSBmcm9tICcuLi8uLi90eXBlcyc7CgppbnRlcmZhY2UgVHJhY2tpbmdNYXBQcm9wcyB7CiAgcGlja3VwTGF0OiBudW1iZXI7CiAgcGlja3VwTG5nOiBudW1iZXI7CiAgZGVsaXZlcnlMYXQ6IG51bWJlcjsKICBkZWxpdmVyeUxuZzogbnVtYmVyOwogIGRyaXZlckxvY2F0aW9uPzogR1BTTG9jYXRpb247CiAgcm91dGVDb29yZHM/OiB7IGxhdGl0dWRlOiBudW1iZXI7IGxvbmdpdHVkZTogbnVtYmVyIH1bXTsKfQoKZXhwb3J0IGZ1bmN0aW9uIFRyYWNraW5nTWFwKHsKICBwaWNrdXBMYXQsCiAgcGlja3VwTG5nLAogIGRlbGl2ZXJ5TGF0LAogIGRlbGl2ZXJ5TG5nLAogIGRyaXZlckxvY2F0aW9uLAogIHJvdXRlQ29vcmRzLAp9OiBUcmFja2luZ01hcFByb3BzKSB7CiAgY29uc3QgbWFwUmVmID0gdXNlUmVmPE1hcFZpZXc+KG51bGwpOwoKICB1c2VFZmZlY3QoKCkgPT4gewogICAgaWYgKGRyaXZlckxvY2F0aW9uICYmIG1hcFJlZi5jdXJyZW50KSB7CiAgICAgIG1hcFJlZi5jdXJyZW50LmFuaW1hdGVUb1JlZ2lvbigKICAgICAgICB7CiAgICAgICAgICBsYXRpdHVkZTogZHJpdmVyTG9jYXRpb24ubGF0LAogICAgICAgICAgbG9uZ2l0dWRlOiBkcml2ZXJMb2NhdGlvbi5sbmcsCiAgICAgICAgICBsYXRpdHVkZURlbHRhOiAwLjAyLAogICAgICAgICAgbG9uZ2l0dWRlRGVsdGE6IDAuMDIsCiAgICAgICAgfSwKICAgICAgICA2MDAsCiAgICAgICk7CiAgICB9CiAgfSwgW2RyaXZlckxvY2F0aW9uXSk7CgogIGNvbnN0IGluaXRpYWxSZWdpb24gPSB7CiAgICBsYXRpdHVkZTogKHBpY2t1cExhdCArIGRlbGl2ZXJ5TGF0KSAvIDIsCiAgICBsb25naXR1ZGU6IChwaWNrdXBMbmcgKyBkZWxpdmVyeUxuZykgLyAyLAogICAgbGF0aXR1ZGVEZWx0YTogTWF0aC5hYnMocGlja3VwTGF0IC0gZGVsaXZlcnlMYXQpICogMiArIDAuMDIsCiAgICBsb25naXR1ZGVEZWx0YTogTWF0aC5hYnMocGlja3VwTG5nIC0gZGVsaXZlcnlMbmcpICogMiArIDAuMDIsCiAgfTsKCiAgcmV0dXJuICgKICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuY29udGFpbmVyfT4KICAgICAgPE1hcFZpZXcKICAgICAgICByZWY9e21hcFJlZn0KICAgICAgICBzdHlsZT17U3R5bGVTaGVldC5hYnNvbHV0ZUZpbGxPYmplY3R9CiAgICAgICAgcHJvdmlkZXI9e1BST1ZJREVSX0dPT0dMRX0KICAgICAgICBpbml0aWFsUmVnaW9uPXtpbml0aWFsUmVnaW9ufQogICAgICAgIGN1c3RvbU1hcFN0eWxlPXtEQVJLX01BUF9TVFlMRX0KICAgICAgPgogICAgICAgIDxNYXJrZXIgY29vcmRpbmF0ZT17eyBsYXRpdHVkZTogcGlja3VwTGF0LCBsb25naXR1ZGU6IHBpY2t1cExuZyB9fSB0aXRsZT0iRW5sw6h2ZW1lbnQiPgogICAgICAgICAgPFZpZXcgc3R5bGU9e1tzdHlsZXMubWFya2VyQ29udGFpbmVyLCBzdHlsZXMubWFya2VyUGlja3VwXX0+CiAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMubWFya2VyVGV4dH0+QTwvVGV4dD4KICAgICAgICAgIDwvVmlldz4KICAgICAgICA8L01hcmtlcj4KCiAgICAgICAgPE1hcmtlciBjb29yZGluYXRlPXt7IGxhdGl0dWRlOiBkZWxpdmVyeUxhdCwgbG9uZ2l0dWRlOiBkZWxpdmVyeUxuZyB9fSB0aXRsZT0iTGl2cmFpc29uIj4KICAgICAgICAgIDxWaWV3IHN0eWxlPXtbc3R5bGVzLm1hcmtlckNvbnRhaW5lciwgc3R5bGVzLm1hcmtlckRlbGl2ZXJ5XX0+CiAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMubWFya2VyVGV4dH0+QjwvVGV4dD4KICAgICAgICAgIDwvVmlldz4KICAgICAgICA8L01hcmtlcj4KCiAgICAgICAge2RyaXZlckxvY2F0aW9uICYmICgKICAgICAgICAgIDxNYXJrZXIgY29vcmRpbmF0ZT17eyBsYXRpdHVkZTogZHJpdmVyTG9jYXRpb24ubGF0LCBsb25naXR1ZGU6IGRyaXZlckxvY2F0aW9uLmxuZyB9fSB0aXRsZT0iVHJhbnNwb3J0ZXVyIj4KICAgICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5kcml2ZXJNYXJrZXJ9PgogICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZHJpdmVyRW1vaml9PvCfmpo8L1RleHQ+CiAgICAgICAgICAgIDwvVmlldz4KICAgICAgICAgIDwvTWFya2VyPgogICAgICAgICl9CgogICAgICAgIHtyb3V0ZUNvb3JkcyAmJiByb3V0ZUNvb3Jkcy5sZW5ndGggPiAxICYmICgKICAgICAgICAgIDxQb2x5bGluZSBjb29yZGluYXRlcz17cm91dGVDb29yZHN9IHN0cm9rZUNvbG9yPXtDb2xvcnMuUFJJTUFSWX0gc3Ryb2tlV2lkdGg9ezN9IGxpbmVEYXNoUGF0dGVybj17WzgsIDRdfSAvPgogICAgICAgICl9CiAgICAgIDwvTWFwVmlldz4KICAgIDwvVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgY29udGFpbmVyOiB7IGZsZXg6IDEsIGJvcmRlclJhZGl1czogMTYsIG92ZXJmbG93OiAnaGlkZGVuJywgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VSRkFDRSB9LAogIG1hcmtlckNvbnRhaW5lcjogeyB3aWR0aDogMzIsIGhlaWdodDogMzIsIGJvcmRlclJhZGl1czogMTYsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicsIGJvcmRlcldpZHRoOiAyLCBib3JkZXJDb2xvcjogQ29sb3JzLldISVRFIH0sCiAgbWFya2VyUGlja3VwOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVQ0NFU1MgfSwKICBtYXJrZXJEZWxpdmVyeTogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgbWFya2VyVGV4dDogeyBjb2xvcjogQ29sb3JzLldISVRFLCBmb250V2VpZ2h0OiAnNzAwJywgZm9udFNpemU6IDE0IH0sCiAgZHJpdmVyTWFya2VyOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsIGJvcmRlclJhZGl1czogMjAsIHBhZGRpbmc6IDQsIGJvcmRlcldpZHRoOiAyLCBib3JkZXJDb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKICBkcml2ZXJFbW9qaTogeyBmb250U2l6ZTogMjAgfSwKfSk7Cgpjb25zdCBEQVJLX01BUF9TVFlMRSA9IFsKICB7IGVsZW1lbnRUeXBlOiAnZ2VvbWV0cnknLCBzdHlsZXJzOiBbeyBjb2xvcjogJyMxYTFhMWEnIH1dIH0sCiAgeyBlbGVtZW50VHlwZTogJ2xhYmVscy50ZXh0LnN0cm9rZScsIHN0eWxlcnM6IFt7IGNvbG9yOiAnIzBhMGEwYScgfV0gfSwKICB7IGVsZW1lbnRUeXBlOiAnbGFiZWxzLnRleHQuZmlsbCcsIHN0eWxlcnM6IFt7IGNvbG9yOiAnIzc1NzU3NScgfV0gfSwKICB7IGZlYXR1cmVUeXBlOiAncm9hZCcsIGVsZW1lbnRUeXBlOiAnZ2VvbWV0cnknLCBzdHlsZXJzOiBbeyBjb2xvcjogJyMyYTJhMmEnIH1dIH0sCiAgeyBmZWF0dXJlVHlwZTogJ3JvYWQnLCBlbGVtZW50VHlwZTogJ2dlb21ldHJ5LnN0cm9rZScsIHN0eWxlcnM6IFt7IGNvbG9yOiAnIzIxMjEyMScgfV0gfSwKICB7IGZlYXR1cmVUeXBlOiAnd2F0ZXInLCBlbGVtZW50VHlwZTogJ2dlb21ldHJ5Jywgc3R5bGVyczogW3sgY29sb3I6ICcjMGQxMTE3JyB9XSB9LAogIHsgZmVhdHVyZVR5cGU6ICdwb2knLCBlbGVtZW50VHlwZTogJ2xhYmVscycsIHN0eWxlcnM6IFt7IHZpc2liaWxpdHk6ICdvZmYnIH1dIH0sCl07Cg==" | base64 -d > 'mobile/components/map/TrackingMap.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgUGxhdGZvcm0sIFN0YXR1c0JhciwgU3R5bGVTaGVldCwgVGV4dCwgVG91Y2hhYmxlT3BhY2l0eSwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IHVzZVJvdXRlciB9IGZyb20gJ2V4cG8tcm91dGVyJzsKaW1wb3J0IHsgQ29sb3JzIH0gZnJvbSAnLi4vLi4vY29uc3RhbnRzL2NvbG9ycyc7CgppbnRlcmZhY2UgSGVhZGVyUHJvcHMgewogIHRpdGxlOiBzdHJpbmc7CiAgc3VidGl0bGU/OiBzdHJpbmc7CiAgc2hvd0JhY2s/OiBib29sZWFuOwogIHJpZ2h0QWN0aW9uPzogeyBsYWJlbDogc3RyaW5nOyBvblByZXNzOiAoKSA9PiB2b2lkIH07Cn0KCmV4cG9ydCBmdW5jdGlvbiBIZWFkZXIoeyB0aXRsZSwgc3VidGl0bGUsIHNob3dCYWNrID0gZmFsc2UsIHJpZ2h0QWN0aW9uIH06IEhlYWRlclByb3BzKSB7CiAgY29uc3Qgcm91dGVyID0gdXNlUm91dGVyKCk7CgogIHJldHVybiAoCiAgICA8VmlldyBzdHlsZT17c3R5bGVzLmNvbnRhaW5lcn0+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMubGVmdH0+CiAgICAgICAge3Nob3dCYWNrICYmICgKICAgICAgICAgIDxUb3VjaGFibGVPcGFjaXR5IG9uUHJlc3M9eygpID0+IHJvdXRlci5iYWNrKCl9IHN0eWxlPXtzdHlsZXMuYmFja0J0bn0gYWN0aXZlT3BhY2l0eT17MC43fT4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5iYWNrSWNvbn0+4oaQPC9UZXh0PgogICAgICAgICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICAgICAgICl9CiAgICAgICAgPFZpZXc+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnRpdGxlfT57dGl0bGV9PC9UZXh0PgogICAgICAgICAge3N1YnRpdGxlICYmIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3VidGl0bGV9PntzdWJ0aXRsZX08L1RleHQ+fQogICAgICAgIDwvVmlldz4KICAgICAgPC9WaWV3PgogICAgICB7cmlnaHRBY3Rpb24gJiYgKAogICAgICAgIDxUb3VjaGFibGVPcGFjaXR5IG9uUHJlc3M9e3JpZ2h0QWN0aW9uLm9uUHJlc3N9IGFjdGl2ZU9wYWNpdHk9ezAuN30+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnJpZ2h0TGFiZWx9PntyaWdodEFjdGlvbi5sYWJlbH08L1RleHQ+CiAgICAgICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICAgICApfQogICAgPC9WaWV3PgogICk7Cn0KCmNvbnN0IFNUQVRVU19CQVJfSEVJR0hUID0gUGxhdGZvcm0uT1MgPT09ICdhbmRyb2lkJyA/IFN0YXR1c0Jhci5jdXJyZW50SGVpZ2h0ID8/IDAgOiAwOwoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIGNvbnRhaW5lcjogewogICAgZmxleERpcmVjdGlvbjogJ3JvdycsCiAgICBhbGlnbkl0ZW1zOiAnY2VudGVyJywKICAgIGp1c3RpZnlDb250ZW50OiAnc3BhY2UtYmV0d2VlbicsCiAgICBwYWRkaW5nVG9wOiBTVEFUVVNfQkFSX0hFSUdIVCArIDEyLAogICAgcGFkZGluZ0JvdHRvbTogMTIsCiAgICBwYWRkaW5nSG9yaXpvbnRhbDogMjAsCiAgICBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CQUNLR1JPVU5ELAogICAgYm9yZGVyQm90dG9tV2lkdGg6IDEsCiAgICBib3JkZXJCb3R0b21Db2xvcjogQ29sb3JzLkJPUkRFUiwKICB9LAogIGxlZnQ6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBnYXA6IDEyIH0sCiAgYmFja0J0bjogeyB3aWR0aDogMzYsIGhlaWdodDogMzYsIGJvcmRlclJhZGl1czogMTgsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicgfSwKICBiYWNrSWNvbjogeyBjb2xvcjogQ29sb3JzLlRFWFQsIGZvbnRTaXplOiAxOCwgZm9udFdlaWdodDogJzcwMCcgfSwKICB0aXRsZTogeyBmb250U2l6ZTogMjAsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQgfSwKICBzdWJ0aXRsZTogeyBmb250U2l6ZTogMTMsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIG1hcmdpblRvcDogMSB9LAogIHJpZ2h0TGFiZWw6IHsgZm9udFNpemU6IDE1LCBjb2xvcjogQ29sb3JzLlBSSU1BUlksIGZvbnRXZWlnaHQ6ICc2MDAnIH0sCn0pOwo=" | base64 -d > 'mobile/components/layout/Header.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgU3R5bGVTaGVldCwgVGV4dCwgVG91Y2hhYmxlT3BhY2l0eSwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IEJvdHRvbVRhYkJhclByb3BzIH0gZnJvbSAnQHJlYWN0LW5hdmlnYXRpb24vYm90dG9tLXRhYnMnOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKCmV4cG9ydCBmdW5jdGlvbiBUYWJCYXIoeyBzdGF0ZSwgZGVzY3JpcHRvcnMsIG5hdmlnYXRpb24gfTogQm90dG9tVGFiQmFyUHJvcHMpIHsKICByZXR1cm4gKAogICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5jb250YWluZXJ9PgogICAgICB7c3RhdGUucm91dGVzLm1hcCgocm91dGUsIGluZGV4KSA9PiB7CiAgICAgICAgY29uc3QgeyBvcHRpb25zIH0gPSBkZXNjcmlwdG9yc1tyb3V0ZS5rZXldOwogICAgICAgIGNvbnN0IGxhYmVsID0KICAgICAgICAgIG9wdGlvbnMudGFiQmFyTGFiZWwgIT09IHVuZGVmaW5lZAogICAgICAgICAgICA/IG9wdGlvbnMudGFiQmFyTGFiZWwKICAgICAgICAgICAgOiBvcHRpb25zLnRpdGxlICE9PSB1bmRlZmluZWQKICAgICAgICAgICAgPyBvcHRpb25zLnRpdGxlCiAgICAgICAgICAgIDogcm91dGUubmFtZTsKCiAgICAgICAgY29uc3QgaXNGb2N1c2VkID0gc3RhdGUuaW5kZXggPT09IGluZGV4OwoKICAgICAgICBjb25zdCBvblByZXNzID0gKCkgPT4gewogICAgICAgICAgY29uc3QgZXZlbnQgPSBuYXZpZ2F0aW9uLmVtaXQoewogICAgICAgICAgICB0eXBlOiAndGFiUHJlc3MnLAogICAgICAgICAgICB0YXJnZXQ6IHJvdXRlLmtleSwKICAgICAgICAgICAgY2FuUHJldmVudERlZmF1bHQ6IHRydWUsCiAgICAgICAgICB9KTsKICAgICAgICAgIGlmICghaXNGb2N1c2VkICYmICFldmVudC5kZWZhdWx0UHJldmVudGVkKSB7CiAgICAgICAgICAgIG5hdmlnYXRpb24ubmF2aWdhdGUocm91dGUubmFtZSk7CiAgICAgICAgICB9CiAgICAgICAgfTsKCiAgICAgICAgcmV0dXJuICgKICAgICAgICAgIDxUb3VjaGFibGVPcGFjaXR5IGtleT17cm91dGUua2V5fSBvblByZXNzPXtvblByZXNzfSBzdHlsZT17c3R5bGVzLnRhYn0gYWN0aXZlT3BhY2l0eT17MC44fT4KICAgICAgICAgICAge29wdGlvbnMudGFiQmFySWNvbj8uKHsKICAgICAgICAgICAgICBmb2N1c2VkOiBpc0ZvY3VzZWQsCiAgICAgICAgICAgICAgY29sb3I6IGlzRm9jdXNlZCA/IENvbG9ycy5QUklNQVJZIDogQ29sb3JzLlRFWFRfU0VDT05EQVJZLAogICAgICAgICAgICAgIHNpemU6IDI0LAogICAgICAgICAgICB9KX0KICAgICAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMubGFiZWwsIGlzRm9jdXNlZCA/IHN0eWxlcy5sYWJlbEFjdGl2ZSA6IHN0eWxlcy5sYWJlbEluYWN0aXZlXX0+CiAgICAgICAgICAgICAge3R5cGVvZiBsYWJlbCA9PT0gJ3N0cmluZycgPyBsYWJlbCA6IHJvdXRlLm5hbWV9CiAgICAgICAgICAgIDwvVGV4dD4KICAgICAgICAgICAge2lzRm9jdXNlZCAmJiA8VmlldyBzdHlsZT17c3R5bGVzLmluZGljYXRvcn0gLz59CiAgICAgICAgICA8L1RvdWNoYWJsZU9wYWNpdHk+CiAgICAgICAgKTsKICAgICAgfSl9CiAgICA8L1ZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIGNvbnRhaW5lcjogewogICAgZmxleERpcmVjdGlvbjogJ3JvdycsCiAgICBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5TVVJGQUNFLAogICAgYm9yZGVyVG9wV2lkdGg6IDEsCiAgICBib3JkZXJUb3BDb2xvcjogQ29sb3JzLkJPUkRFUiwKICAgIHBhZGRpbmdCb3R0b206IDIwLAogICAgcGFkZGluZ1RvcDogMTAsCiAgfSwKICB0YWI6IHsgZmxleDogMSwgYWxpZ25JdGVtczogJ2NlbnRlcicsIGp1c3RpZnlDb250ZW50OiAnY2VudGVyJywgcG9zaXRpb246ICdyZWxhdGl2ZScsIGdhcDogNCB9LAogIGxhYmVsOiB7IGZvbnRTaXplOiAxMSwgZm9udFdlaWdodDogJzYwMCcgfSwKICBsYWJlbEFjdGl2ZTogeyBjb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKICBsYWJlbEluYWN0aXZlOiB7IGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlkgfSwKICBpbmRpY2F0b3I6IHsgcG9zaXRpb246ICdhYnNvbHV0ZScsIHRvcDogLTEwLCB3aWR0aDogNCwgaGVpZ2h0OiA0LCBib3JkZXJSYWRpdXM6IDIsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKfSk7Cg==" | base64 -d > 'mobile/components/layout/TabBar.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsKICBTY3JvbGxWaWV3LAogIFN0eWxlU2hlZXQsCiAgVGV4dCwKICBUb3VjaGFibGVPcGFjaXR5LAogIFZpZXcsCn0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgdXNlUm91dGVyIH0gZnJvbSAnZXhwby1yb3V0ZXInOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgdXNlQXV0aCB9IGZyb20gJy4uLy4uL2hvb2tzL3VzZUF1dGgnOwppbXBvcnQgeyBBdmF0YXIgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0F2YXRhcic7CmltcG9ydCB7IENhcmQgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0NhcmQnOwoKaW50ZXJmYWNlIFNlcnZpY2VDYXJkUHJvcHMgewogIGVtb2ppOiBzdHJpbmc7CiAgdGl0bGU6IHN0cmluZzsKICBkZXNjcmlwdGlvbjogc3RyaW5nOwogIGFjdGl2ZTogYm9vbGVhbjsKICBvblByZXNzOiAoKSA9PiB2b2lkOwp9CgpmdW5jdGlvbiBTZXJ2aWNlQ2FyZCh7IGVtb2ppLCB0aXRsZSwgZGVzY3JpcHRpb24sIGFjdGl2ZSwgb25QcmVzcyB9OiBTZXJ2aWNlQ2FyZFByb3BzKSB7CiAgcmV0dXJuICgKICAgIDxUb3VjaGFibGVPcGFjaXR5CiAgICAgIG9uUHJlc3M9e2FjdGl2ZSA/IG9uUHJlc3MgOiB1bmRlZmluZWR9CiAgICAgIGFjdGl2ZU9wYWNpdHk9e2FjdGl2ZSA/IDAuOCA6IDF9CiAgICA+CiAgICAgIDxDYXJkIHN0eWxlPXtbc3R5bGVzLnNlcnZpY2VDYXJkLCAhYWN0aXZlICYmIHN0eWxlcy5zZXJ2aWNlQ2FyZEluYWN0aXZlXX0gZWxldmF0ZWQ9e2FjdGl2ZX0+CiAgICAgICAgeyFhY3RpdmUgJiYgKAogICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5jb21pbmdTb29uQmFkZ2V9PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmNvbWluZ1Nvb25UZXh0fT5CaWVudMO0dDwvVGV4dD4KICAgICAgICAgIDwvVmlldz4KICAgICAgICApfQogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VydmljZUVtb2ppfT57ZW1vaml9PC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtbc3R5bGVzLnNlcnZpY2VUaXRsZSwgIWFjdGl2ZSAmJiBzdHlsZXMuc2VydmljZVRleHREaW1dfT4KICAgICAgICAgIHt0aXRsZX0KICAgICAgICA8L1RleHQ+CiAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMuc2VydmljZURlc2MsICFhY3RpdmUgJiYgc3R5bGVzLnNlcnZpY2VUZXh0RGltXX0+CiAgICAgICAgICB7ZGVzY3JpcHRpb259CiAgICAgICAgPC9UZXh0PgogICAgICAgIHthY3RpdmUgJiYgKAogICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5zZXJ2aWNlQXJyb3d9PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlcnZpY2VBcnJvd1RleHR9PkNvbW1hbmRlciDihpI8L1RleHQ+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgKX0KICAgICAgPC9DYXJkPgogICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICk7Cn0KCmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIENsaWVudEhvbWVTY3JlZW4oKSB7CiAgY29uc3Qgcm91dGVyID0gdXNlUm91dGVyKCk7CiAgY29uc3QgeyB1c2VyIH0gPSB1c2VBdXRoKCk7CgogIHJldHVybiAoCiAgICA8U2Nyb2xsVmlldwogICAgICBzdHlsZT17c3R5bGVzLnNjcmVlbn0KICAgICAgY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMuY29udGFpbmVyfQogICAgICBzaG93c1ZlcnRpY2FsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0KICAgID4KICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5oZWFkZXJ9PgogICAgICAgIDxWaWV3PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5ncmVldGluZ30+CiAgICAgICAgICAgIEJvbmpvdXIsIHt1c2VyPy5maXJzdE5hbWUgPz8gJ0NsaWVudCd9IPCfkYsKICAgICAgICAgIDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuaGVhZGVyU3VifT5RdWUgdm91bGV6LXZvdXMgZmFpcmUgYXVqb3VyZCdodWkgPzwvVGV4dD4KICAgICAgICA8L1ZpZXc+CiAgICAgICAgPEF2YXRhcgogICAgICAgICAgbmFtZT17YCR7dXNlcj8uZmlyc3ROYW1lID8/ICcnfSAke3VzZXI/Lmxhc3ROYW1lID8/ICcnfWB9CiAgICAgICAgICB1cmk9e3VzZXI/LmF2YXRhcn0KICAgICAgICAgIHNpemU9Im1kIgogICAgICAgIC8+CiAgICAgIDwvVmlldz4KCiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaGVyb0Jhbm5lcn0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5oZXJvVGl0bGV9PkpPJ0RSSVZFPC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuaGVyb1RhZ2xpbmV9Pk1vYmlsaXTDqSDigKIgTGl2cmFpc29uIOKAoiBDb3Vyc2U8L1RleHQ+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5oZXJvU3VifT5UcmFuc3BvcnQgZGUgY29uZmlhbmNlIGVuIEd1eWFuZTwvVGV4dD4KICAgICAgPC9WaWV3PgoKICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zZWN0aW9uVGl0bGV9Pk5vcyBzZXJ2aWNlczwvVGV4dD4KCiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuc2VydmljZXNHcmlkfT4KICAgICAgICA8U2VydmljZUNhcmQKICAgICAgICAgIGVtb2ppPSLwn5OmIgogICAgICAgICAgdGl0bGU9IkxpdnJhaXNvbiIKICAgICAgICAgIGRlc2NyaXB0aW9uPSJUcmFuc3BvcnQgZGUgbWV1Ymxlcywgw6lsZWN0cm9tw6luYWdlciwgbWF0w6lyaWF1eCIKICAgICAgICAgIGFjdGl2ZQogICAgICAgICAgb25QcmVzcz17KCkgPT4gcm91dGVyLnB1c2goJy8oY2xpZW50KS9ub3V2ZWxsZS1taXNzaW9uJyl9CiAgICAgICAgLz4KICAgICAgICA8U2VydmljZUNhcmQKICAgICAgICAgIGVtb2ppPSLwn5qWIgogICAgICAgICAgdGl0bGU9IlRyYW5zcG9ydCIKICAgICAgICAgIGRlc2NyaXB0aW9uPSJEw6lwbGFjZW1lbnRzIHBlcnNvbm5lbHMgZXQgcHJvZmVzc2lvbm5lbHMiCiAgICAgICAgICBhY3RpdmU9e2ZhbHNlfQogICAgICAgICAgb25QcmVzcz17KCkgPT4ge319CiAgICAgICAgLz4KICAgICAgICA8U2VydmljZUNhcmQKICAgICAgICAgIGVtb2ppPSLwn4+DIgogICAgICAgICAgdGl0bGU9IkNvdXJzZSByYXBpZGUiCiAgICAgICAgICBkZXNjcmlwdGlvbj0iTGl2cmFpc29uIGV4cHJlc3MgZGUgY29saXMgdXJnZW50cyIKICAgICAgICAgIGFjdGl2ZT17ZmFsc2V9CiAgICAgICAgICBvblByZXNzPXsoKSA9PiB7fX0KICAgICAgICAvPgogICAgICA8L1ZpZXc+CgogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlY3Rpb25UaXRsZX0+TWVzIG1pc3Npb25zPC9UZXh0PgogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0YXRzUm93fT4KICAgICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLnN0YXRDYXJkfT4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdFZhbHVlfT7igJQ8L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnN0YXRMYWJlbH0+RW4gY291cnM8L1RleHQ+CiAgICAgICAgPC9DYXJkPgogICAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMuc3RhdENhcmR9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zdGF0VmFsdWV9PuKAlDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdExhYmVsfT5UZXJtaW7DqWVzPC9UZXh0PgogICAgICAgIDwvQ2FyZD4KICAgICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLnN0YXRDYXJkfT4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdFZhbHVlfT7igJQ8L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnN0YXRMYWJlbH0+QW5udWzDqWVzPC9UZXh0PgogICAgICAgIDwvQ2FyZD4KICAgICAgPC9WaWV3PgogICAgPC9TY3JvbGxWaWV3PgogICk7Cn0KCmNvbnN0IHN0eWxlcyA9IFN0eWxlU2hlZXQuY3JlYXRlKHsKICBzY3JlZW46IHsgZmxleDogMSwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQkFDS0dST1VORCB9LAogIGNvbnRhaW5lcjogeyBwYWRkaW5nSG9yaXpvbnRhbDogMjAsIHBhZGRpbmdUb3A6IDYwLCBwYWRkaW5nQm90dG9tOiA0MCB9LAogIGhlYWRlcjogewogICAgZmxleERpcmVjdGlvbjogJ3JvdycsCiAgICBqdXN0aWZ5Q29udGVudDogJ3NwYWNlLWJldHdlZW4nLAogICAgYWxpZ25JdGVtczogJ2NlbnRlcicsCiAgICBtYXJnaW5Cb3R0b206IDI0LAogIH0sCiAgZ3JlZXRpbmc6IHsgZm9udFNpemU6IDIyLCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCiAgaGVhZGVyU3ViOiB7IGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luVG9wOiAyIH0sCiAgaGVyb0Jhbm5lcjogewogICAgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuUFJJTUFSWSwKICAgIGJvcmRlclJhZGl1czogMjAsCiAgICBwYWRkaW5nOiAyNCwKICAgIG1hcmdpbkJvdHRvbTogMzIsCiAgfSwKICBoZXJvVGl0bGU6IHsKICAgIGZvbnRTaXplOiAzNiwKICAgIGZvbnRXZWlnaHQ6ICc5MDAnLAogICAgY29sb3I6IENvbG9ycy5XSElURSwKICAgIGxldHRlclNwYWNpbmc6IC0xLAogIH0sCiAgaGVyb1RhZ2xpbmU6IHsKICAgIGZvbnRTaXplOiAxMywKICAgIGNvbG9yOiAncmdiYSgyNTUsMjU1LDI1NSwwLjgpJywKICAgIGxldHRlclNwYWNpbmc6IDEuNSwKICAgIG1hcmdpbkJvdHRvbTogOCwKICB9LAogIGhlcm9TdWI6IHsgZm9udFNpemU6IDE1LCBjb2xvcjogJ3JnYmEoMjU1LDI1NSwyNTUsMC45KScgfSwKICBzZWN0aW9uVGl0bGU6IHsKICAgIGZvbnRTaXplOiAxOCwKICAgIGZvbnRXZWlnaHQ6ICc3MDAnLAogICAgY29sb3I6IENvbG9ycy5URVhULAogICAgbWFyZ2luQm90dG9tOiAxNiwKICB9LAogIHNlcnZpY2VzR3JpZDogeyBnYXA6IDEyLCBtYXJnaW5Cb3R0b206IDMyIH0sCiAgc2VydmljZUNhcmQ6IHsgcG9zaXRpb246ICdyZWxhdGl2ZScsIG92ZXJmbG93OiAnaGlkZGVuJyB9LAogIHNlcnZpY2VDYXJkSW5hY3RpdmU6IHsgb3BhY2l0eTogMC42IH0sCiAgY29taW5nU29vbkJhZGdlOiB7CiAgICBwb3NpdGlvbjogJ2Fic29sdXRlJywKICAgIHRvcDogMTIsCiAgICByaWdodDogMTIsCiAgICBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIsCiAgICBwYWRkaW5nSG9yaXpvbnRhbDogMTAsCiAgICBwYWRkaW5nVmVydGljYWw6IDQsCiAgICBib3JkZXJSYWRpdXM6IDk5OSwKICB9LAogIGNvbWluZ1Nvb25UZXh0OiB7IGZvbnRTaXplOiAxMSwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgZm9udFdlaWdodDogJzYwMCcgfSwKICBzZXJ2aWNlRW1vamk6IHsgZm9udFNpemU6IDM2LCBtYXJnaW5Cb3R0b206IDEwIH0sCiAgc2VydmljZVRpdGxlOiB7IGZvbnRTaXplOiAxOCwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiA2IH0sCiAgc2VydmljZURlc2M6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBsaW5lSGVpZ2h0OiAyMCB9LAogIHNlcnZpY2VUZXh0RGltOiB7IG9wYWNpdHk6IDAuNyB9LAogIHNlcnZpY2VBcnJvdzogeyBtYXJnaW5Ub3A6IDE2IH0sCiAgc2VydmljZUFycm93VGV4dDogeyBjb2xvcjogQ29sb3JzLlBSSU1BUlksIGZvbnRXZWlnaHQ6ICc3MDAnLCBmb250U2l6ZTogMTQgfSwKICBzdGF0c1JvdzogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgZ2FwOiAxMiB9LAogIHN0YXRDYXJkOiB7IGZsZXg6IDEsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBwYWRkaW5nVmVydGljYWw6IDE4IH0sCiAgc3RhdFZhbHVlOiB7IGZvbnRTaXplOiAyMiwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiA0IH0sCiAgc3RhdExhYmVsOiB7IGZvbnRTaXplOiAxMiwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSB9LAp9KTsK" | base64 -d > 'mobile/app/(client)/index.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZUVmZmVjdCB9IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgQWN0aXZpdHlJbmRpY2F0b3IsIEZsYXRMaXN0LCBTdHlsZVNoZWV0LCBUZXh0LCBWaWV3IH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgdXNlUm91dGVyIH0gZnJvbSAnZXhwby1yb3V0ZXInOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgdXNlTWlzc2lvbnMgfSBmcm9tICcuLi8uLi9ob29rcy91c2VNaXNzaW9ucyc7CmltcG9ydCB7IE1pc3Npb25DYXJkIH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy9taXNzaW9uL01pc3Npb25DYXJkJzsKaW1wb3J0IHsgTWlzc2lvbiB9IGZyb20gJy4uLy4uL3R5cGVzJzsKCmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIEhpc3RvcmlxdWVTY3JlZW4oKSB7CiAgY29uc3Qgcm91dGVyID0gdXNlUm91dGVyKCk7CiAgY29uc3QgeyBsaXN0LCBpc0xvYWRpbmcsIGxvYWRNaXNzaW9ucyB9ID0gdXNlTWlzc2lvbnMoKTsKCiAgdXNlRWZmZWN0KCgpID0+IHsgbG9hZE1pc3Npb25zKCk7IH0sIFtdKTsKCiAgaWYgKGlzTG9hZGluZyAmJiBsaXN0Lmxlbmd0aCA9PT0gMCkgewogICAgcmV0dXJuICgKICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5jZW50ZXJ9PgogICAgICAgIDxBY3Rpdml0eUluZGljYXRvciBzaXplPSJsYXJnZSIgY29sb3I9e0NvbG9ycy5QUklNQVJZfSAvPgogICAgICA8L1ZpZXc+CiAgICApOwogIH0KCiAgcmV0dXJuICgKICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuc2NyZWVufT4KICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5oZWFkZXJTZWN0aW9ufT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnRpdGxlfT5NZXMgbWlzc2lvbnM8L1RleHQ+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zdWJ0aXRsZX0+e2xpc3QubGVuZ3RofSBtaXNzaW9ue2xpc3QubGVuZ3RoID4gMSA/ICdzJyA6ICcnfTwvVGV4dD4KICAgICAgPC9WaWV3PgoKICAgICAge2xpc3QubGVuZ3RoID09PSAwID8gKAogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuZW1wdHlDb250YWluZXJ9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5lbXB0eUVtb2ppfT7wn5OtPC9UZXh0PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5lbXB0eVRpdGxlfT5BdWN1bmUgbWlzc2lvbjwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZW1wdHlUZXh0fT5Wb3MgbWlzc2lvbnMgYXBwYXJhw650cm9udCBpY2kgdW5lIGZvaXMgcXVlIHZvdXMgZW4gYXVyZXogY3LDqcOpLjwvVGV4dD4KICAgICAgICA8L1ZpZXc+CiAgICAgICkgOiAoCiAgICAgICAgPEZsYXRMaXN0CiAgICAgICAgICBkYXRhPXtsaXN0fQogICAgICAgICAga2V5RXh0cmFjdG9yPXsoaXRlbSkgPT4gaXRlbS5pZH0KICAgICAgICAgIHJlbmRlckl0ZW09eyh7IGl0ZW0gfTogeyBpdGVtOiBNaXNzaW9uIH0pID0+ICgKICAgICAgICAgICAgPE1pc3Npb25DYXJkCiAgICAgICAgICAgICAgbWlzc2lvbj17aXRlbX0KICAgICAgICAgICAgICBvblByZXNzPXsobSkgPT4gcm91dGVyLnB1c2goYC8oY2xpZW50KS9taXNzaW9uLyR7bS5pZH1gKX0KICAgICAgICAgICAgLz4KICAgICAgICAgICl9CiAgICAgICAgICBjb250ZW50Q29udGFpbmVyU3R5bGU9e3N0eWxlcy5saXN0fQogICAgICAgICAgc2hvd3NWZXJ0aWNhbFNjcm9sbEluZGljYXRvcj17ZmFsc2V9CiAgICAgICAgICBvblJlZnJlc2g9eygpID0+IGxvYWRNaXNzaW9ucygpfQogICAgICAgICAgcmVmcmVzaGluZz17aXNMb2FkaW5nfQogICAgICAgIC8+CiAgICAgICl9CiAgICA8L1ZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIHNjcmVlbjogeyBmbGV4OiAxLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CQUNLR1JPVU5EIH0sCiAgY2VudGVyOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicgfSwKICBoZWFkZXJTZWN0aW9uOiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ1RvcDogNjAsIHBhZGRpbmdCb3R0b206IDIwIH0sCiAgdGl0bGU6IHsgZm9udFNpemU6IDI2LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCiAgc3VidGl0bGU6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBtYXJnaW5Ub3A6IDQgfSwKICBsaXN0OiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ0JvdHRvbTogNDAgfSwKICBlbXB0eUNvbnRhaW5lcjogeyBmbGV4OiAxLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywganVzdGlmeUNvbnRlbnQ6ICdjZW50ZXInLCBwYWRkaW5nSG9yaXpvbnRhbDogNDAgfSwKICBlbXB0eUVtb2ppOiB7IGZvbnRTaXplOiA1NiwgbWFyZ2luQm90dG9tOiAxNiB9LAogIGVtcHR5VGl0bGU6IHsgZm9udFNpemU6IDIwLCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDggfSwKICBlbXB0eVRleHQ6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCB0ZXh0QWxpZ246ICdjZW50ZXInLCBsaW5lSGVpZ2h0OiAyMCB9LAp9KTsK" | base64 -d > 'mobile/app/(client)/historique.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgQWxlcnQsIFNjcm9sbFZpZXcsIFN0eWxlU2hlZXQsIFRleHQsIFRvdWNoYWJsZU9wYWNpdHksIFZpZXcgfSBmcm9tICdyZWFjdC1uYXRpdmUnOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgdXNlQXV0aCB9IGZyb20gJy4uLy4uL2hvb2tzL3VzZUF1dGgnOwppbXBvcnQgeyBBdmF0YXIgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0F2YXRhcic7CmltcG9ydCB7IENhcmQgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0NhcmQnOwoKZnVuY3Rpb24gTWVudUl0ZW0oeyBlbW9qaSwgbGFiZWwsIG9uUHJlc3MsIGRhbmdlciB9OiB7IGVtb2ppOiBzdHJpbmc7IGxhYmVsOiBzdHJpbmc7IG9uUHJlc3M6ICgpID0+IHZvaWQ7IGRhbmdlcj86IGJvb2xlYW4gfSkgewogIHJldHVybiAoCiAgICA8VG91Y2hhYmxlT3BhY2l0eSBzdHlsZT17c3R5bGVzLm1lbnVJdGVtfSBvblByZXNzPXtvblByZXNzfSBhY3RpdmVPcGFjaXR5PXswLjd9PgogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLm1lbnVFbW9qaX0+e2Vtb2ppfTwvVGV4dD4KICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMubWVudUxhYmVsLCBkYW5nZXIgJiYgc3R5bGVzLm1lbnVMYWJlbERhbmdlcl19PntsYWJlbH08L1RleHQ+CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMubWVudUFycm93fT7igLo8L1RleHQ+CiAgICA8L1RvdWNoYWJsZU9wYWNpdHk+CiAgKTsKfQoKZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gQ2xpZW50UHJvZmlsU2NyZWVuKCkgewogIGNvbnN0IHsgdXNlciwgbG9nb3V0IH0gPSB1c2VBdXRoKCk7CgogIGNvbnN0IGhhbmRsZUxvZ291dCA9ICgpID0+IHsKICAgIEFsZXJ0LmFsZXJ0KCdEw6ljb25uZXhpb24nLCAnVm91bGV6LXZvdXMgdnJhaW1lbnQgdm91cyBkw6ljb25uZWN0ZXIgPycsIFsKICAgICAgeyB0ZXh0OiAnQW5udWxlcicsIHN0eWxlOiAnY2FuY2VsJyB9LAogICAgICB7IHRleHQ6ICdEw6ljb25uZXhpb24nLCBzdHlsZTogJ2Rlc3RydWN0aXZlJywgb25QcmVzczogKCkgPT4gbG9nb3V0KCkgfSwKICAgIF0pOwogIH07CgogIHJldHVybiAoCiAgICA8U2Nyb2xsVmlldyBzdHlsZT17c3R5bGVzLnNjcmVlbn0gY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMuY29udGFpbmVyfSBzaG93c1ZlcnRpY2FsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMucHJvZmlsZVNlY3Rpb259PgogICAgICAgIDxBdmF0YXIgbmFtZT17YCR7dXNlcj8uZmlyc3ROYW1lID8/ICcnfSAke3VzZXI/Lmxhc3ROYW1lID8/ICcnfWB9IHVyaT17dXNlcj8uYXZhdGFyfSBzaXplPSJ4bCIgc3R5bGU9e3N0eWxlcy5hdmF0YXJ9IC8+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5uYW1lfT57dXNlcj8uZmlyc3ROYW1lfSB7dXNlcj8ubGFzdE5hbWV9PC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZW1haWx9Pnt1c2VyPy5lbWFpbH08L1RleHQ+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5yb2xlQmFkZ2V9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5yb2xlQmFkZ2VUZXh0fT5DbGllbnQ8L1RleHQ+CiAgICAgICAgPC9WaWV3PgogICAgICA8L1ZpZXc+CgogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0YXRzUm93fT4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0YXRJdGVtfT48VGV4dCBzdHlsZT17c3R5bGVzLnN0YXRWYWx1ZX0+4oCUPC9UZXh0PjxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdExhYmVsfT5NaXNzaW9uczwvVGV4dD48L1ZpZXc+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5zdGF0RGl2aWRlcn0gLz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0YXRJdGVtfT48VGV4dCBzdHlsZT17c3R5bGVzLnN0YXRWYWx1ZX0+4oCUPC9UZXh0PjxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdExhYmVsfT5Ob3RlPC9UZXh0PjwvVmlldz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0YXREaXZpZGVyfSAvPgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuc3RhdEl0ZW19PjxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdFZhbHVlfT7igJQ8L1RleHQ+PFRleHQgc3R5bGU9e3N0eWxlcy5zdGF0TGFiZWx9PkTDqXBlbnNlczwvVGV4dD48L1ZpZXc+CiAgICAgIDwvVmlldz4KCiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VjdGlvblRpdGxlfT5Nb24gY29tcHRlPC9UZXh0PgogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLm1lbnVDYXJkfSBwYWRkaW5nPSJub25lIj4KICAgICAgICA8TWVudUl0ZW0gZW1vamk9IvCfkaQiIGxhYmVsPSJNb2RpZmllciBtb24gcHJvZmlsIiBvblByZXNzPXsoKSA9PiB7fX0gLz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLm1lbnVTZXBhcmF0b3J9IC8+CiAgICAgICAgPE1lbnVJdGVtIGVtb2ppPSLwn5SUIiBsYWJlbD0iTm90aWZpY2F0aW9ucyIgb25QcmVzcz17KCkgPT4ge319IC8+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5tZW51U2VwYXJhdG9yfSAvPgogICAgICAgIDxNZW51SXRlbSBlbW9qaT0i8J+SsyIgbGFiZWw9Ik1veWVucyBkZSBwYWllbWVudCIgb25QcmVzcz17KCkgPT4ge319IC8+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5tZW51U2VwYXJhdG9yfSAvPgogICAgICAgIDxNZW51SXRlbSBlbW9qaT0i8J+boe+4jyIgbGFiZWw9IlPDqWN1cml0w6kiIG9uUHJlc3M9eygpID0+IHt9fSAvPgogICAgICA8L0NhcmQ+CgogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlY3Rpb25UaXRsZX0+SW5mb3JtYXRpb25zPC9UZXh0PgogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLm1lbnVDYXJkfSBwYWRkaW5nPSJub25lIj4KICAgICAgICA8TWVudUl0ZW0gZW1vamk9IuKdkyIgbGFiZWw9IkFpZGUgJiBTdXBwb3J0IiBvblByZXNzPXsoKSA9PiB7fX0gLz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLm1lbnVTZXBhcmF0b3J9IC8+CiAgICAgICAgPE1lbnVJdGVtIGVtb2ppPSLwn5OEIiBsYWJlbD0iQ29uZGl0aW9ucyBkJ3V0aWxpc2F0aW9uIiBvblByZXNzPXsoKSA9PiB7fX0gLz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLm1lbnVTZXBhcmF0b3J9IC8+CiAgICAgICAgPE1lbnVJdGVtIGVtb2ppPSLwn5SSIiBsYWJlbD0iUG9saXRpcXVlIGRlIGNvbmZpZGVudGlhbGl0w6kiIG9uUHJlc3M9eygpID0+IHt9fSAvPgogICAgICA8L0NhcmQ+CgogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLm1lbnVDYXJkfSBwYWRkaW5nPSJub25lIj4KICAgICAgICA8TWVudUl0ZW0gZW1vamk9IvCfmqoiIGxhYmVsPSJTZSBkw6ljb25uZWN0ZXIiIG9uUHJlc3M9e2hhbmRsZUxvZ291dH0gZGFuZ2VyIC8+CiAgICAgIDwvQ2FyZD4KCiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMudmVyc2lvbn0+Sk8nRFJJVkUgdjEuMC4wIOKAoiBHdXlhbmUg8J+MvzwvVGV4dD4KICAgIDwvU2Nyb2xsVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgc2NyZWVuOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQgfSwKICBjb250YWluZXI6IHsgcGFkZGluZ0JvdHRvbTogNjAgfSwKICBwcm9maWxlU2VjdGlvbjogeyBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ1RvcDogNjAsIHBhZGRpbmdCb3R0b206IDI0LCBwYWRkaW5nSG9yaXpvbnRhbDogMjAgfSwKICBhdmF0YXI6IHsgbWFyZ2luQm90dG9tOiAxNiB9LAogIG5hbWU6IHsgZm9udFNpemU6IDIyLCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCiAgZW1haWw6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBtYXJnaW5Ub3A6IDQsIG1hcmdpbkJvdHRvbTogMTIgfSwKICByb2xlQmFkZ2U6IHsgYmFja2dyb3VuZENvbG9yOiAncmdiYSgyMjcsNiwxOSwwLjEyKScsIHBhZGRpbmdIb3Jpem9udGFsOiAxNCwgcGFkZGluZ1ZlcnRpY2FsOiA1LCBib3JkZXJSYWRpdXM6IDk5OSB9LAogIHJvbGVCYWRnZVRleHQ6IHsgY29sb3I6IENvbG9ycy5QUklNQVJZLCBmb250V2VpZ2h0OiAnNzAwJywgZm9udFNpemU6IDEzIH0sCiAgc3RhdHNSb3c6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsIG1hcmdpbkhvcml6b250YWw6IDIwLCBib3JkZXJSYWRpdXM6IDE2LCBwYWRkaW5nOiAyMCwgbWFyZ2luQm90dG9tOiAyOCwgYm9yZGVyV2lkdGg6IDEsIGJvcmRlckNvbG9yOiBDb2xvcnMuQk9SREVSIH0sCiAgc3RhdEl0ZW06IHsgZmxleDogMSwgYWxpZ25JdGVtczogJ2NlbnRlcicgfSwKICBzdGF0VmFsdWU6IHsgZm9udFNpemU6IDIwLCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDQgfSwKICBzdGF0TGFiZWw6IHsgZm9udFNpemU6IDEyLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCiAgc3RhdERpdmlkZXI6IHsgd2lkdGg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJPUkRFUiB9LAogIHNlY3Rpb25UaXRsZTogeyBmb250U2l6ZTogMTQsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCB0ZXh0VHJhbnNmb3JtOiAndXBwZXJjYXNlJywgbGV0dGVyU3BhY2luZzogMSwgcGFkZGluZ0hvcml6b250YWw6IDIwLCBtYXJnaW5Cb3R0b206IDEwLCBtYXJnaW5Ub3A6IDggfSwKICBtZW51Q2FyZDogeyBtYXJnaW5Ib3Jpem9udGFsOiAyMCwgbWFyZ2luQm90dG9tOiAxNiB9LAogIG1lbnVJdGVtOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ1ZlcnRpY2FsOiAxNiwgcGFkZGluZ0hvcml6b250YWw6IDE2LCBnYXA6IDE0IH0sCiAgbWVudUVtb2ppOiB7IGZvbnRTaXplOiAyMCB9LAogIG1lbnVMYWJlbDogeyBmbGV4OiAxLCBmb250U2l6ZTogMTUsIGNvbG9yOiBDb2xvcnMuVEVYVCwgZm9udFdlaWdodDogJzUwMCcgfSwKICBtZW51TGFiZWxEYW5nZXI6IHsgY29sb3I6IENvbG9ycy5FUlJPUiB9LAogIG1lbnVBcnJvdzogeyBmb250U2l6ZTogMjAsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlkgfSwKICBtZW51U2VwYXJhdG9yOiB7IGhlaWdodDogMSwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQk9SREVSLCBtYXJnaW5MZWZ0OiA1NCB9LAogIHZlcnNpb246IHsgdGV4dEFsaWduOiAnY2VudGVyJywgZm9udFNpemU6IDEyLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBtYXJnaW5Ub3A6IDggfSwKfSk7Cg==" | base64 -d > 'mobile/app/(client)/profil.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZVN0YXRlIH0gZnJvbSAncmVhY3QnOwppbXBvcnQgewogIEFsZXJ0LCBLZXlib2FyZEF2b2lkaW5nVmlldywgUGxhdGZvcm0sIFNjcm9sbFZpZXcsCiAgU3R5bGVTaGVldCwgVGV4dCwgVG91Y2hhYmxlT3BhY2l0eSwgVmlldywKfSBmcm9tICdyZWFjdC1uYXRpdmUnOwppbXBvcnQgeyB1c2VSb3V0ZXIgfSBmcm9tICdleHBvLXJvdXRlcic7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwppbXBvcnQgeyB1c2VNaXNzaW9ucyB9IGZyb20gJy4uLy4uL2hvb2tzL3VzZU1pc3Npb25zJzsKaW1wb3J0IHsgQnV0dG9uIH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy91aS9CdXR0b24nOwppbXBvcnQgeyBJbnB1dCB9IGZyb20gJy4uLy4uL2NvbXBvbmVudHMvdWkvSW5wdXQnOwppbXBvcnQgeyBDYXJkIH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy91aS9DYXJkJzsKCmludGVyZmFjZSBJdGVtRm9ybSB7CiAgZGVzY3JpcHRpb246IHN0cmluZzsKICBxdWFudGl0eTogc3RyaW5nOwogIGVzdGltYXRlZFdlaWdodDogc3RyaW5nOwp9CgpleHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBOb3V2ZWxsZU1pc3Npb25TY3JlZW4oKSB7CiAgY29uc3Qgcm91dGVyID0gdXNlUm91dGVyKCk7CiAgY29uc3QgeyBuZXdNaXNzaW9uLCBpc0xvYWRpbmcgfSA9IHVzZU1pc3Npb25zKCk7CgogIGNvbnN0IFtzdGVwLCBzZXRTdGVwXSA9IHVzZVN0YXRlKDEpOwogIGNvbnN0IFtwaWNrdXBBZGRyZXNzLCBzZXRQaWNrdXBBZGRyZXNzXSA9IHVzZVN0YXRlKCcnKTsKICBjb25zdCBbZGVsaXZlcnlBZGRyZXNzLCBzZXREZWxpdmVyeUFkZHJlc3NdID0gdXNlU3RhdGUoJycpOwogIGNvbnN0IFtub3Rlcywgc2V0Tm90ZXNdID0gdXNlU3RhdGUoJycpOwogIGNvbnN0IFtpdGVtcywgc2V0SXRlbXNdID0gdXNlU3RhdGU8SXRlbUZvcm1bXT4oW3sgZGVzY3JpcHRpb246ICcnLCBxdWFudGl0eTogJzEnLCBlc3RpbWF0ZWRXZWlnaHQ6ICcnIH1dKTsKCiAgY29uc3QgYWRkSXRlbSA9ICgpID0+IHNldEl0ZW1zKChwcmV2KSA9PiBbLi4ucHJldiwgeyBkZXNjcmlwdGlvbjogJycsIHF1YW50aXR5OiAnMScsIGVzdGltYXRlZFdlaWdodDogJycgfV0pOwogIGNvbnN0IHJlbW92ZUl0ZW0gPSAoaW5kZXg6IG51bWJlcikgPT4geyBpZiAoaXRlbXMubGVuZ3RoID09PSAxKSByZXR1cm47IHNldEl0ZW1zKChwcmV2KSA9PiBwcmV2LmZpbHRlcigoXywgaSkgPT4gaSAhPT0gaW5kZXgpKTsgfTsKICBjb25zdCB1cGRhdGVJdGVtID0gKGluZGV4OiBudW1iZXIsIGZpZWxkOiBrZXlvZiBJdGVtRm9ybSwgdmFsdWU6IHN0cmluZykgPT4gewogICAgc2V0SXRlbXMoKHByZXYpID0+IHByZXYubWFwKChpdGVtLCBpKSA9PiAoaSA9PT0gaW5kZXggPyB7IC4uLml0ZW0sIFtmaWVsZF06IHZhbHVlIH0gOiBpdGVtKSkpOwogIH07CgogIGNvbnN0IGhhbmRsZVN1Ym1pdCA9IGFzeW5jICgpID0+IHsKICAgIGlmICghcGlja3VwQWRkcmVzcyB8fCAhZGVsaXZlcnlBZGRyZXNzKSB7IEFsZXJ0LmFsZXJ0KCdBZHJlc3NlcyByZXF1aXNlcycsICdWZXVpbGxleiByZW5zZWlnbmVyIGxlcyBkZXV4IGFkcmVzc2VzLicpOyByZXR1cm47IH0KICAgIGlmIChpdGVtcy5zb21lKChpKSA9PiAhaS5kZXNjcmlwdGlvbikpIHsgQWxlcnQuYWxlcnQoJ09iamV0cyBpbmNvbXBsZXRzJywgJ0TDqWNyaXZleiBjaGFxdWUgb2JqZXQgw6AgdHJhbnNwb3J0ZXIuJyk7IHJldHVybjsgfQogICAgY29uc3QgcmVzdWx0ID0gYXdhaXQgbmV3TWlzc2lvbih7CiAgICAgIHBpY2t1cEFkZHJlc3MsIHBpY2t1cExhdDogNC45MjIsIHBpY2t1cExuZzogLTUyLjMxMywKICAgICAgZGVsaXZlcnlBZGRyZXNzLCBkZWxpdmVyeUxhdDogNC45MywgZGVsaXZlcnlMbmc6IC01Mi4zMywKICAgICAgbm90ZXM6IG5vdGVzIHx8IHVuZGVmaW5lZCwKICAgICAgaXRlbXM6IGl0ZW1zLm1hcCgoaSkgPT4gKHsKICAgICAgICBkZXNjcmlwdGlvbjogaS5kZXNjcmlwdGlvbiwKICAgICAgICBxdWFudGl0eTogcGFyc2VJbnQoaS5xdWFudGl0eSwgMTApIHx8IDEsCiAgICAgICAgZXN0aW1hdGVkV2VpZ2h0OiBpLmVzdGltYXRlZFdlaWdodCA/IHBhcnNlRmxvYXQoaS5lc3RpbWF0ZWRXZWlnaHQpIDogdW5kZWZpbmVkLAogICAgICB9KSksCiAgICB9KTsKICAgIGlmIChyZXN1bHQubWV0YS5yZXF1ZXN0U3RhdHVzID09PSAnZnVsZmlsbGVkJykgewogICAgICByb3V0ZXIucHVzaChgLyhjbGllbnQpL21pc3Npb24vJHsocmVzdWx0LnBheWxvYWQgYXMgYW55KS5pZH1gKTsKICAgIH0KICB9OwoKICByZXR1cm4gKAogICAgPEtleWJvYXJkQXZvaWRpbmdWaWV3IHN0eWxlPXtzdHlsZXMuZmxleH0gYmVoYXZpb3I9e1BsYXRmb3JtLk9TID09PSAnaW9zJyA/ICdwYWRkaW5nJyA6IHVuZGVmaW5lZH0+CiAgICAgIDxTY3JvbGxWaWV3IHN0eWxlPXtzdHlsZXMuZmxleH0gY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMuY29udGFpbmVyfSBrZXlib2FyZFNob3VsZFBlcnNpc3RUYXBzPSJoYW5kbGVkIiBzaG93c1ZlcnRpY2FsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5oZWFkZXJ9PgogICAgICAgICAgPFRvdWNoYWJsZU9wYWNpdHkgb25QcmVzcz17KCkgPT4gcm91dGVyLmJhY2soKX0+PFRleHQgc3R5bGU9e3N0eWxlcy5iYWNrfT7ihpA8L1RleHQ+PC9Ub3VjaGFibGVPcGFjaXR5PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy50aXRsZX0+Tm91dmVsbGUgbGl2cmFpc29uPC9UZXh0PgogICAgICAgICAgPFZpZXcgc3R5bGU9e3sgd2lkdGg6IDI0IH19IC8+CiAgICAgICAgPC9WaWV3PgoKICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0ZXBzfT4KICAgICAgICAgIHtbMSwgMl0ubWFwKChzKSA9PiAoCiAgICAgICAgICAgIDxSZWFjdC5GcmFnbWVudCBrZXk9e3N9PgogICAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtbc3R5bGVzLnN0ZXBEb3QsIHN0ZXAgPj0gcyAmJiBzdHlsZXMuc3RlcERvdEFjdGl2ZV19PgogICAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMuc3RlcE51bSwgc3RlcCA+PSBzICYmIHN0eWxlcy5zdGVwTnVtQWN0aXZlXX0+e3N9PC9UZXh0PgogICAgICAgICAgICAgIDwvVmlldz4KICAgICAgICAgICAgICB7cyA8IDIgJiYgPFZpZXcgc3R5bGU9e1tzdHlsZXMuc3RlcExpbmUsIHN0ZXAgPiBzICYmIHN0eWxlcy5zdGVwTGluZURvbmVdfSAvPn0KICAgICAgICAgICAgPC9SZWFjdC5GcmFnbWVudD4KICAgICAgICAgICkpfQogICAgICAgIDwvVmlldz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0ZXBMYWJlbHN9PgogICAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMuc3RlcExhYmVsLCBzdGVwID09PSAxICYmIHN0eWxlcy5zdGVwTGFiZWxBY3RpdmVdfT5BZHJlc3NlczwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtbc3R5bGVzLnN0ZXBMYWJlbCwgc3RlcCA9PT0gMiAmJiBzdHlsZXMuc3RlcExhYmVsQWN0aXZlXX0+T2JqZXRzPC9UZXh0PgogICAgICAgIDwvVmlldz4KCiAgICAgICAge3N0ZXAgPT09IDEgPyAoCiAgICAgICAgICA8Vmlldz4KICAgICAgICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5hZGRyZXNzQ2FyZH0+CiAgICAgICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5hZGRyZXNzUm93fT4KICAgICAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuZ3JlZW5Eb3R9IC8+CiAgICAgICAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmZsZXh9PgogICAgICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmFkZHJlc3NMYWJlbH0+UG9pbnQgZCdlbmzDqHZlbWVudDwvVGV4dD4KICAgICAgICAgICAgICAgICAgPElucHV0IHZhbHVlPXtwaWNrdXBBZGRyZXNzfSBvbkNoYW5nZVRleHQ9e3NldFBpY2t1cEFkZHJlc3N9IHBsYWNlaG9sZGVyPSJBZHJlc3NlIGRlIGTDqXBhcnQiIC8+CiAgICAgICAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICAgICAgPC9WaWV3PgogICAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMudmVydGljYWxEaXZpZGVyfSAvPgogICAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuYWRkcmVzc1Jvd30+CiAgICAgICAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnJlZERvdH0gLz4KICAgICAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuZmxleH0+CiAgICAgICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYWRkcmVzc0xhYmVsfT5Qb2ludCBkZSBsaXZyYWlzb248L1RleHQ+CiAgICAgICAgICAgICAgICAgIDxJbnB1dCB2YWx1ZT17ZGVsaXZlcnlBZGRyZXNzfSBvbkNoYW5nZVRleHQ9e3NldERlbGl2ZXJ5QWRkcmVzc30gcGxhY2Vob2xkZXI9IkFkcmVzc2UgZGUgZGVzdGluYXRpb24iIC8+CiAgICAgICAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICAgICAgPC9WaWV3PgogICAgICAgICAgICA8L0NhcmQ+CgogICAgICAgICAgICA8SW5wdXQgbGFiZWw9Ik5vdGVzIHBvdXIgbGUgdHJhbnNwb3J0ZXVyIChvcHRpb25uZWwpIiB2YWx1ZT17bm90ZXN9IG9uQ2hhbmdlVGV4dD17c2V0Tm90ZXN9IHBsYWNlaG9sZGVyPSJJbnN0cnVjdGlvbnMgcGFydGljdWxpw6hyZXMsIMOpdGFnZSwgY29kZSwgZXRjLiIgbXVsdGlsaW5lIG51bWJlck9mTGluZXM9ezN9IC8+CgogICAgICAgICAgICA8QnV0dG9uIHRpdGxlPSJTdWl2YW50IOKGkiBEw6lmaW5pciBsZXMgb2JqZXRzIiBvblByZXNzPXsoKSA9PiB7CiAgICAgICAgICAgICAgaWYgKCFwaWNrdXBBZGRyZXNzIHx8ICFkZWxpdmVyeUFkZHJlc3MpIHsgQWxlcnQuYWxlcnQoJ1JlcXVpcycsICdSZW5zZWlnbmV6IGxlcyBkZXV4IGFkcmVzc2VzLicpOyByZXR1cm47IH0KICAgICAgICAgICAgICBzZXRTdGVwKDIpOwogICAgICAgICAgICB9fSBmdWxsV2lkdGggc2l6ZT0ibGciIC8+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgKSA6ICgKICAgICAgICAgIDxWaWV3PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlY3Rpb25UaXRsZX0+T2JqZXRzIMOgIHRyYW5zcG9ydGVyPC9UZXh0PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlY3Rpb25TdWJ9PkTDqWNyaXZleiBsZXMgb2JqZXRzIHBvdXIgYWlkZXIgbGUgdHJhbnNwb3J0ZXVyIMOgIHByw6lwYXJlciBsZSBib24gdsOpaGljdWxlLjwvVGV4dD4KCiAgICAgICAgICAgIHtpdGVtcy5tYXAoKGl0ZW0sIGluZGV4KSA9PiAoCiAgICAgICAgICAgICAgPENhcmQga2V5PXtpbmRleH0gc3R5bGU9e3N0eWxlcy5pdGVtQ2FyZH0+CiAgICAgICAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLml0ZW1IZWFkZXJ9PgogICAgICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLml0ZW1OdW19Pk9iamV0IHtpbmRleCArIDF9PC9UZXh0PgogICAgICAgICAgICAgICAgICB7aXRlbXMubGVuZ3RoID4gMSAmJiAoCiAgICAgICAgICAgICAgICAgICAgPFRvdWNoYWJsZU9wYWNpdHkgb25QcmVzcz17KCkgPT4gcmVtb3ZlSXRlbShpbmRleCl9PgogICAgICAgICAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5yZW1vdmVUZXh0fT5TdXBwcmltZXI8L1RleHQ+CiAgICAgICAgICAgICAgICAgICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICAgICAgICAgICAgICAgICApfQogICAgICAgICAgICAgICAgPC9WaWV3PgogICAgICAgICAgICAgICAgPElucHV0IGxhYmVsPSJEZXNjcmlwdGlvbiIgdmFsdWU9e2l0ZW0uZGVzY3JpcHRpb259IG9uQ2hhbmdlVGV4dD17KHYpID0+IHVwZGF0ZUl0ZW0oaW5kZXgsICdkZXNjcmlwdGlvbicsIHYpfSBwbGFjZWhvbGRlcj0iZXg6IENhbmFww6kgMyBwbGFjZXMsIFLDqWZyaWfDqXJhdGV1ci4uLiIgLz4KICAgICAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaXRlbVJvd30+CiAgICAgICAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuZmxleH0+CiAgICAgICAgICAgICAgICAgICAgPElucHV0IGxhYmVsPSJRdWFudGl0w6kiIHZhbHVlPXtpdGVtLnF1YW50aXR5fSBvbkNoYW5nZVRleHQ9eyh2KSA9PiB1cGRhdGVJdGVtKGluZGV4LCAncXVhbnRpdHknLCB2KX0ga2V5Ym9hcmRUeXBlPSJudW1lcmljIiBwbGFjZWhvbGRlcj0iMSIgLz4KICAgICAgICAgICAgICAgICAgPC9WaWV3PgogICAgICAgICAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmZsZXh9PgogICAgICAgICAgICAgICAgICAgIDxJbnB1dCBsYWJlbD0iUG9pZHMgZXN0aW3DqSAoa2cpIiB2YWx1ZT17aXRlbS5lc3RpbWF0ZWRXZWlnaHR9IG9uQ2hhbmdlVGV4dD17KHYpID0+IHVwZGF0ZUl0ZW0oaW5kZXgsICdlc3RpbWF0ZWRXZWlnaHQnLCB2KX0ga2V5Ym9hcmRUeXBlPSJkZWNpbWFsLXBhZCIgcGxhY2Vob2xkZXI9ImV4OiA4MCIgLz4KICAgICAgICAgICAgICAgICAgPC9WaWV3PgogICAgICAgICAgICAgICAgPC9WaWV3PgogICAgICAgICAgICAgIDwvQ2FyZD4KICAgICAgICAgICAgKSl9CgogICAgICAgICAgICA8VG91Y2hhYmxlT3BhY2l0eSBvblByZXNzPXthZGRJdGVtfSBzdHlsZT17c3R5bGVzLmFkZEl0ZW1CdG59PgogICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYWRkSXRlbVRleHR9PisgQWpvdXRlciB1biBvYmpldDwvVGV4dD4KICAgICAgICAgICAgPC9Ub3VjaGFibGVPcGFjaXR5PgoKICAgICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5hY3Rpb25Sb3d9PgogICAgICAgICAgICAgIDxCdXR0b24gdGl0bGU9IlJldG91ciIgdmFyaWFudD0ib3V0bGluZSIgb25QcmVzcz17KCkgPT4gc2V0U3RlcCgxKX0gc3R5bGU9e3N0eWxlcy5mbGV4IGFzIGFueX0gLz4KICAgICAgICAgICAgICA8QnV0dG9uIHRpdGxlPSJQdWJsaWVyIGxhIG1pc3Npb24iIG9uUHJlc3M9e2hhbmRsZVN1Ym1pdH0gbG9hZGluZz17aXNMb2FkaW5nfSBzdHlsZT17c3R5bGVzLmZsZXggYXMgYW55fSAvPgogICAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgKX0KICAgICAgPC9TY3JvbGxWaWV3PgogICAgPC9LZXlib2FyZEF2b2lkaW5nVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgZmxleDogeyBmbGV4OiAxIH0sCiAgY29udGFpbmVyOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQsIHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ1RvcDogNTYsIHBhZGRpbmdCb3R0b206IDQwIH0sCiAgaGVhZGVyOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywganVzdGlmeUNvbnRlbnQ6ICdzcGFjZS1iZXR3ZWVuJywgbWFyZ2luQm90dG9tOiAyOCB9LAogIGJhY2s6IHsgZm9udFNpemU6IDIyLCBjb2xvcjogQ29sb3JzLlRFWFQsIGZvbnRXZWlnaHQ6ICc3MDAnIH0sCiAgdGl0bGU6IHsgZm9udFNpemU6IDE4LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCiAgc3RlcHM6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicsIG1hcmdpbkJvdHRvbTogOCB9LAogIHN0ZXBEb3Q6IHsgd2lkdGg6IDMyLCBoZWlnaHQ6IDMyLCBib3JkZXJSYWRpdXM6IDE2LCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicgfSwKICBzdGVwRG90QWN0aXZlOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKICBzdGVwTnVtOiB7IGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIGZvbnRXZWlnaHQ6ICc3MDAnLCBmb250U2l6ZTogMTQgfSwKICBzdGVwTnVtQWN0aXZlOiB7IGNvbG9yOiBDb2xvcnMuV0hJVEUgfSwKICBzdGVwTGluZTogeyB3aWR0aDogODAsIGhlaWdodDogMiwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQk9SREVSLCBtYXJnaW5Ib3Jpem9udGFsOiA4IH0sCiAgc3RlcExpbmVEb25lOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKICBzdGVwTGFiZWxzOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBqdXN0aWZ5Q29udGVudDogJ3NwYWNlLWFyb3VuZCcsIG1hcmdpbkJvdHRvbTogMjggfSwKICBzdGVwTGFiZWw6IHsgZm9udFNpemU6IDEzLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBmb250V2VpZ2h0OiAnNTAwJyB9LAogIHN0ZXBMYWJlbEFjdGl2ZTogeyBjb2xvcjogQ29sb3JzLlBSSU1BUlksIGZvbnRXZWlnaHQ6ICc3MDAnIH0sCiAgYWRkcmVzc0NhcmQ6IHsgbWFyZ2luQm90dG9tOiAyMCB9LAogIGFkZHJlc3NSb3c6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGFsaWduSXRlbXM6ICdmbGV4LXN0YXJ0JywgZ2FwOiAxMiB9LAogIGdyZWVuRG90OiB7IHdpZHRoOiAxNCwgaGVpZ2h0OiAxNCwgYm9yZGVyUmFkaXVzOiA3LCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5TVUNDRVNTLCBtYXJnaW5Ub3A6IDI4IH0sCiAgcmVkRG90OiB7IHdpZHRoOiAxNCwgaGVpZ2h0OiAxNCwgYm9yZGVyUmFkaXVzOiA3LCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5QUklNQVJZLCBtYXJnaW5Ub3A6IDI4IH0sCiAgYWRkcmVzc0xhYmVsOiB7IGZvbnRTaXplOiAxMywgZm9udFdlaWdodDogJzYwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIHRleHRUcmFuc2Zvcm06ICd1cHBlcmNhc2UnLCBsZXR0ZXJTcGFjaW5nOiAwLjUsIG1hcmdpbkJvdHRvbTogNCB9LAogIHZlcnRpY2FsRGl2aWRlcjogeyB3aWR0aDogMiwgaGVpZ2h0OiAxNiwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQk9SREVSLCBtYXJnaW5MZWZ0OiA2LCBtYXJnaW5WZXJ0aWNhbDogLTQgfSwKICBzZWN0aW9uVGl0bGU6IHsgZm9udFNpemU6IDE4LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDYgfSwKICBzZWN0aW9uU3ViOiB7IGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luQm90dG9tOiAyMCwgbGluZUhlaWdodDogMjAgfSwKICBpdGVtQ2FyZDogeyBtYXJnaW5Cb3R0b206IDE2IH0sCiAgaXRlbUhlYWRlcjogeyBmbGV4RGlyZWN0aW9uOiAncm93JywganVzdGlmeUNvbnRlbnQ6ICdzcGFjZS1iZXR3ZWVuJywgYWxpZ25JdGVtczogJ2NlbnRlcicsIG1hcmdpbkJvdHRvbTogMTIgfSwKICBpdGVtTnVtOiB7IGZvbnRTaXplOiAxNSwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIHJlbW92ZVRleHQ6IHsgZm9udFNpemU6IDEzLCBjb2xvcjogQ29sb3JzLkVSUk9SLCBmb250V2VpZ2h0OiAnNjAwJyB9LAogIGl0ZW1Sb3c6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGdhcDogMTIgfSwKICBhZGRJdGVtQnRuOiB7IGJvcmRlcldpZHRoOiAxLjUsIGJvcmRlckNvbG9yOiBDb2xvcnMuUFJJTUFSWSwgYm9yZGVyUmFkaXVzOiAxMiwgcGFkZGluZ1ZlcnRpY2FsOiAxNCwgYWxpZ25JdGVtczogJ2NlbnRlcicsIG1hcmdpbkJvdHRvbTogMjQsIGJvcmRlclN0eWxlOiAnZGFzaGVkJyB9LAogIGFkZEl0ZW1UZXh0OiB7IGNvbG9yOiBDb2xvcnMuUFJJTUFSWSwgZm9udFdlaWdodDogJzYwMCcsIGZvbnRTaXplOiAxNSB9LAogIGFjdGlvblJvdzogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgZ2FwOiAxMiB9LAp9KTsK" | base64 -d > 'mobile/app/(client)/nouvelle-mission.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZUVmZmVjdCwgdXNlU3RhdGUgfSBmcm9tICdyZWFjdCc7CmltcG9ydCB7IEFjdGl2aXR5SW5kaWNhdG9yLCBTY3JvbGxWaWV3LCBTdHlsZVNoZWV0LCBUZXh0LCBUb3VjaGFibGVPcGFjaXR5LCBWaWV3IH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgdXNlTG9jYWxTZWFyY2hQYXJhbXMsIHVzZVJvdXRlciB9IGZyb20gJ2V4cG8tcm91dGVyJzsKaW1wb3J0IHsgQ29sb3JzIH0gZnJvbSAnLi4vLi4vLi4vY29uc3RhbnRzL2NvbG9ycyc7CmltcG9ydCB7IHVzZU1pc3Npb25zIH0gZnJvbSAnLi4vLi4vLi4vaG9va3MvdXNlTWlzc2lvbnMnOwppbXBvcnQgeyB1c2VTb2NrZXQgfSBmcm9tICcuLi8uLi8uLi9ob29rcy91c2VTb2NrZXQnOwppbXBvcnQgeyBHUFNMb2NhdGlvbiB9IGZyb20gJy4uLy4uLy4uL3R5cGVzJzsKaW1wb3J0IHsgTWlzc2lvblN0YXR1c1RyYWNrZXIgfSBmcm9tICcuLi8uLi8uLi9jb21wb25lbnRzL21pc3Npb24vTWlzc2lvblN0YXR1cyc7CmltcG9ydCB7IENhcmQgfSBmcm9tICcuLi8uLi8uLi9jb21wb25lbnRzL3VpL0NhcmQnOwppbXBvcnQgeyBCdXR0b24gfSBmcm9tICcuLi8uLi8uLi9jb21wb25lbnRzL3VpL0J1dHRvbic7CmltcG9ydCB7IFRyYWNraW5nTWFwIH0gZnJvbSAnLi4vLi4vLi4vY29tcG9uZW50cy9tYXAvVHJhY2tpbmdNYXAnOwoKZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gQ2xpZW50TWlzc2lvbkRldGFpbFNjcmVlbigpIHsKICBjb25zdCB7IGlkIH0gPSB1c2VMb2NhbFNlYXJjaFBhcmFtczx7IGlkOiBzdHJpbmcgfT4oKTsKICBjb25zdCByb3V0ZXIgPSB1c2VSb3V0ZXIoKTsKICBjb25zdCB7IGN1cnJlbnQsIGxvYWRNaXNzaW9uLCBpc0xvYWRpbmcgfSA9IHVzZU1pc3Npb25zKCk7CiAgY29uc3QgeyBjb25uZWN0LCBzdWJzY3JpYmVUb01pc3Npb24sIG9uR3BzVXBkYXRlLCBkaXNjb25uZWN0IH0gPSB1c2VTb2NrZXQoKTsKICBjb25zdCBbZHJpdmVyTG9jYXRpb24sIHNldERyaXZlckxvY2F0aW9uXSA9IHVzZVN0YXRlPEdQU0xvY2F0aW9uIHwgdW5kZWZpbmVkPigpOwoKICB1c2VFZmZlY3QoKCkgPT4geyBpZiAoaWQpIGxvYWRNaXNzaW9uKGlkKTsgfSwgW2lkXSk7CgogIHVzZUVmZmVjdCgoKSA9PiB7CiAgICBpZiAoIWlkKSByZXR1cm47CiAgICBjb25uZWN0KCkudGhlbigoKSA9PiB7CiAgICAgIHN1YnNjcmliZVRvTWlzc2lvbihpZCk7CiAgICAgIG9uR3BzVXBkYXRlKGlkLCAobG9jKSA9PiBzZXREcml2ZXJMb2NhdGlvbihsb2MpKTsKICAgIH0pOwogICAgcmV0dXJuICgpID0+IGRpc2Nvbm5lY3QoKTsKICB9LCBbaWRdKTsKCiAgaWYgKGlzTG9hZGluZyB8fCAhY3VycmVudCkgewogICAgcmV0dXJuICgKICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5jZW50ZXJ9PgogICAgICAgIDxBY3Rpdml0eUluZGljYXRvciBzaXplPSJsYXJnZSIgY29sb3I9e0NvbG9ycy5QUklNQVJZfSAvPgogICAgICA8L1ZpZXc+CiAgICApOwogIH0KCiAgY29uc3QgbWlzc2lvbiA9IGN1cnJlbnQ7CgogIHJldHVybiAoCiAgICA8U2Nyb2xsVmlldyBzdHlsZT17c3R5bGVzLnNjcmVlbn0gY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMuY29udGFpbmVyfSBzaG93c1ZlcnRpY2FsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaGVhZGVyfT4KICAgICAgICA8VG91Y2hhYmxlT3BhY2l0eSBvblByZXNzPXsoKSA9PiByb3V0ZXIuYmFjaygpfSBzdHlsZT17c3R5bGVzLmJhY2tCdG59PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5iYWNrVGV4dH0+4oaQPC9UZXh0PgogICAgICAgIDwvVG91Y2hhYmxlT3BhY2l0eT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnRpdGxlfT5TdWl2aSBkZSBtaXNzaW9uPC9UZXh0PgogICAgICAgIDxWaWV3IHN0eWxlPXt7IHdpZHRoOiA0MCB9fSAvPgogICAgICA8L1ZpZXc+CgogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLm1hcENvbnRhaW5lcn0+CiAgICAgICAgPFRyYWNraW5nTWFwCiAgICAgICAgICBwaWNrdXBMYXQ9e21pc3Npb24ucGlja3VwTGF0fQogICAgICAgICAgcGlja3VwTG5nPXttaXNzaW9uLnBpY2t1cExuZ30KICAgICAgICAgIGRlbGl2ZXJ5TGF0PXttaXNzaW9uLmRlbGl2ZXJ5TGF0fQogICAgICAgICAgZGVsaXZlcnlMbmc9e21pc3Npb24uZGVsaXZlcnlMbmd9CiAgICAgICAgICBkcml2ZXJMb2NhdGlvbj17ZHJpdmVyTG9jYXRpb259CiAgICAgICAgLz4KICAgICAgPC9WaWV3PgoKICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5zZWN0aW9ufT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlY3Rpb25UaXRsZX0+QXZhbmNlbWVudDwvVGV4dD4KICAgICAgICA8TWlzc2lvblN0YXR1c1RyYWNrZXIgc3RhdHVzPXttaXNzaW9uLnN0YXR1c30gLz4KICAgICAgPC9DYXJkPgoKICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5zZWN0aW9ufT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlY3Rpb25UaXRsZX0+RMOpdGFpbHMgZGUgbGEgbWlzc2lvbjwvVGV4dD4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmRldGFpbFJvd30+CiAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmdyZWVuRG90fSAvPgogICAgICAgICAgPFZpZXc+CiAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZGV0YWlsTGFiZWx9PkVubMOodmVtZW50PC9UZXh0PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmRldGFpbFZhbHVlfT57bWlzc2lvbi5waWNrdXBBZGRyZXNzfTwvVGV4dD4KICAgICAgICAgIDwvVmlldz4KICAgICAgICA8L1ZpZXc+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5yb3V0ZUxpbmV9IC8+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5kZXRhaWxSb3d9PgogICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5yZWREb3R9IC8+CiAgICAgICAgICA8Vmlldz4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5kZXRhaWxMYWJlbH0+TGl2cmFpc29uPC9UZXh0PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmRldGFpbFZhbHVlfT57bWlzc2lvbi5kZWxpdmVyeUFkZHJlc3N9PC9UZXh0PgogICAgICAgICAgPC9WaWV3PgogICAgICAgIDwvVmlldz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmRpdmlkZXJ9IC8+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5tZXRhR3JpZH0+CiAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLm1ldGFJdGVtfT4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5tZXRhTGFiZWx9PlByaXg8L1RleHQ+CiAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMubWV0YVZhbHVlfT57bWlzc2lvbi5wcmljZS50b0ZpeGVkKDIpfSDigqw8L1RleHQ+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICB7bWlzc2lvbi5kaXN0YW5jZSAmJiAoCiAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMubWV0YUl0ZW19PgogICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMubWV0YUxhYmVsfT5EaXN0YW5jZTwvVGV4dD4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLm1ldGFWYWx1ZX0+e21pc3Npb24uZGlzdGFuY2UudG9GaXhlZCgxKX0ga208L1RleHQ+CiAgICAgICAgICAgIDwvVmlldz4KICAgICAgICAgICl9CiAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLm1ldGFJdGVtfT4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5tZXRhTGFiZWx9Pk9iamV0czwvVGV4dD4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5tZXRhVmFsdWV9PnttaXNzaW9uLml0ZW1zLmxlbmd0aH08L1RleHQ+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgPC9WaWV3PgogICAgICA8L0NhcmQ+CgogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLnNlY3Rpb259PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VjdGlvblRpdGxlfT5PYmpldHMgdHJhbnNwb3J0w6lzPC9UZXh0PgogICAgICAgIHttaXNzaW9uLml0ZW1zLm1hcCgoaXRlbSwgaSkgPT4gKAogICAgICAgICAgPFZpZXcga2V5PXtpdGVtLmlkfSBzdHlsZT17W3N0eWxlcy5pdGVtUm93LCBpID4gMCAmJiBzdHlsZXMuaXRlbUJvcmRlcl19PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLml0ZW1FbW9qaX0+8J+TpjwvVGV4dD4KICAgICAgICAgICAgPFZpZXcgc3R5bGU9e3sgZmxleDogMSB9fT4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLml0ZW1EZXNjfT57aXRlbS5kZXNjcmlwdGlvbn08L1RleHQ+CiAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5pdGVtTWV0YX0+UXTDqToge2l0ZW0ucXVhbnRpdHl9e2l0ZW0uZXN0aW1hdGVkV2VpZ2h0ID8gYCDigKIgJHtpdGVtLmVzdGltYXRlZFdlaWdodH0ga2dgIDogJyd9PC9UZXh0PgogICAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgKSl9CiAgICAgIDwvQ2FyZD4KCiAgICAgIHttaXNzaW9uLnRyYW5zcG9ydGV1ciAmJiAoCiAgICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5zZWN0aW9ufT4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VjdGlvblRpdGxlfT5Wb3RyZSB0cmFuc3BvcnRldXI8L1RleHQ+CiAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnRyYW5zcG9ydGV1clJvd30+CiAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMudHJhbnNwb3J0ZXVyQXZhdGFyfT4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnRyYW5zcG9ydGV1ckluaXRpYWx9PnttaXNzaW9uLnRyYW5zcG9ydGV1ci5maXJzdE5hbWVbMF19PC9UZXh0PgogICAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICAgIDxWaWV3PgogICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMudHJhbnNwb3J0ZXVyTmFtZX0+e21pc3Npb24udHJhbnNwb3J0ZXVyLmZpcnN0TmFtZX0ge21pc3Npb24udHJhbnNwb3J0ZXVyLmxhc3ROYW1lfTwvVGV4dD4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnRyYW5zcG9ydGV1clBob25lfT57bWlzc2lvbi50cmFuc3BvcnRldXIucGhvbmV9PC9UZXh0PgogICAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgPC9DYXJkPgogICAgICApfQoKICAgICAge21pc3Npb24uc3RhdHVzID09PSAnQ09NUExFVEVEJyAmJiAhbWlzc2lvbi5yYXRpbmcgJiYgKAogICAgICAgIDxCdXR0b24gdGl0bGU9IuKtkCDDiXZhbHVlciBsYSBtaXNzaW9uIiB2YXJpYW50PSJvdXRsaW5lIiBmdWxsV2lkdGggb25QcmVzcz17KCkgPT4ge319IHN0eWxlPXtzdHlsZXMucmF0ZUJ0bn0gLz4KICAgICAgKX0KICAgIDwvU2Nyb2xsVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgc2NyZWVuOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQgfSwKICBjb250YWluZXI6IHsgcGFkZGluZ0hvcml6b250YWw6IDIwLCBwYWRkaW5nVG9wOiA1NiwgcGFkZGluZ0JvdHRvbTogNDAgfSwKICBjZW50ZXI6IHsgZmxleDogMSwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQkFDS0dST1VORCwgYWxpZ25JdGVtczogJ2NlbnRlcicsIGp1c3RpZnlDb250ZW50OiAnY2VudGVyJyB9LAogIGhlYWRlcjogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYWxpZ25JdGVtczogJ2NlbnRlcicsIGp1c3RpZnlDb250ZW50OiAnc3BhY2UtYmV0d2VlbicsIG1hcmdpbkJvdHRvbTogMjAgfSwKICBiYWNrQnRuOiB7IHdpZHRoOiA0MCwgaGVpZ2h0OiA0MCwgYm9yZGVyUmFkaXVzOiAyMCwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VSRkFDRSwgYWxpZ25JdGVtczogJ2NlbnRlcicsIGp1c3RpZnlDb250ZW50OiAnY2VudGVyJyB9LAogIGJhY2tUZXh0OiB7IGNvbG9yOiBDb2xvcnMuVEVYVCwgZm9udFNpemU6IDE4LCBmb250V2VpZ2h0OiAnNzAwJyB9LAogIHRpdGxlOiB7IGZvbnRTaXplOiAxNywgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIG1hcENvbnRhaW5lcjogeyBoZWlnaHQ6IDIyMCwgYm9yZGVyUmFkaXVzOiAxNiwgb3ZlcmZsb3c6ICdoaWRkZW4nLCBtYXJnaW5Cb3R0b206IDE2IH0sCiAgc2VjdGlvbjogeyBtYXJnaW5Cb3R0b206IDE2IH0sCiAgc2VjdGlvblRpdGxlOiB7IGZvbnRTaXplOiAxNSwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiAxNCB9LAogIGRldGFpbFJvdzogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYWxpZ25JdGVtczogJ2ZsZXgtc3RhcnQnLCBnYXA6IDEyIH0sCiAgZ3JlZW5Eb3Q6IHsgd2lkdGg6IDE0LCBoZWlnaHQ6IDE0LCBib3JkZXJSYWRpdXM6IDcsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVQ0NFU1MsIG1hcmdpblRvcDogNCB9LAogIHJlZERvdDogeyB3aWR0aDogMTQsIGhlaWdodDogMTQsIGJvcmRlclJhZGl1czogNywgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuUFJJTUFSWSwgbWFyZ2luVG9wOiA0IH0sCiAgZGV0YWlsTGFiZWw6IHsgZm9udFNpemU6IDEyLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBmb250V2VpZ2h0OiAnNjAwJywgbWFyZ2luQm90dG9tOiAyIH0sCiAgZGV0YWlsVmFsdWU6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFQsIGxpbmVIZWlnaHQ6IDIwIH0sCiAgcm91dGVMaW5lOiB7IHdpZHRoOiAyLCBoZWlnaHQ6IDIwLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIsIG1hcmdpbkxlZnQ6IDYsIG1hcmdpblZlcnRpY2FsOiA0IH0sCiAgZGl2aWRlcjogeyBoZWlnaHQ6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJPUkRFUiwgbWFyZ2luVmVydGljYWw6IDE2IH0sCiAgbWV0YUdyaWQ6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGdhcDogMTYgfSwKICBtZXRhSXRlbToge30sCiAgbWV0YUxhYmVsOiB7IGZvbnRTaXplOiAxMiwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSB9LAogIG1ldGFWYWx1ZTogeyBmb250U2l6ZTogMTYsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQgfSwKICBpdGVtUm93OiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgZ2FwOiAxMiwgcGFkZGluZ1ZlcnRpY2FsOiAxMCB9LAogIGl0ZW1Cb3JkZXI6IHsgYm9yZGVyVG9wV2lkdGg6IDEsIGJvcmRlclRvcENvbG9yOiBDb2xvcnMuQk9SREVSIH0sCiAgaXRlbUVtb2ppOiB7IGZvbnRTaXplOiAyMiB9LAogIGl0ZW1EZXNjOiB7IGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhULCBmb250V2VpZ2h0OiAnNTAwJyB9LAogIGl0ZW1NZXRhOiB7IGZvbnRTaXplOiAxMiwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luVG9wOiAyIH0sCiAgdHJhbnNwb3J0ZXVyUm93OiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgZ2FwOiAxNCB9LAogIHRyYW5zcG9ydGV1ckF2YXRhcjogeyB3aWR0aDogNDgsIGhlaWdodDogNDgsIGJvcmRlclJhZGl1czogMjQsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlBSSU1BUlksIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicgfSwKICB0cmFuc3BvcnRldXJJbml0aWFsOiB7IGNvbG9yOiBDb2xvcnMuV0hJVEUsIGZvbnRTaXplOiAyMCwgZm9udFdlaWdodDogJzcwMCcgfSwKICB0cmFuc3BvcnRldXJOYW1lOiB7IGZvbnRTaXplOiAxNiwgZm9udFdlaWdodDogJzYwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIHRyYW5zcG9ydGV1clBob25lOiB7IGZvbnRTaXplOiAxMywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luVG9wOiAyIH0sCiAgcmF0ZUJ0bjogeyBtYXJnaW5Ub3A6IDQgfSwKfSk7Cg==" | base64 -d > 'mobile/app/(client)/mission/[id].tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZUVmZmVjdCwgdXNlU3RhdGUgfSBmcm9tICdyZWFjdCc7CmltcG9ydCB7IFNjcm9sbFZpZXcsIFN0eWxlU2hlZXQsIFN3aXRjaCwgVGV4dCwgVG91Y2hhYmxlT3BhY2l0eSwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IHVzZVJvdXRlciB9IGZyb20gJ2V4cG8tcm91dGVyJzsKaW1wb3J0IHsgQ29sb3JzIH0gZnJvbSAnLi4vLi4vY29uc3RhbnRzL2NvbG9ycyc7CmltcG9ydCB7IHVzZUF1dGggfSBmcm9tICcuLi8uLi9ob29rcy91c2VBdXRoJzsKaW1wb3J0IHsgdXNlTWlzc2lvbnMgfSBmcm9tICcuLi8uLi9ob29rcy91c2VNaXNzaW9ucyc7CmltcG9ydCB7IE1pc3Npb25DYXJkIH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy9taXNzaW9uL01pc3Npb25DYXJkJzsKaW1wb3J0IHsgQ2FyZCB9IGZyb20gJy4uLy4uL2NvbXBvbmVudHMvdWkvQ2FyZCc7CmltcG9ydCB7IEF2YXRhciB9IGZyb20gJy4uLy4uL2NvbXBvbmVudHMvdWkvQXZhdGFyJzsKCmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIFRyYW5zcG9ydGV1ckRhc2hib2FyZCgpIHsKICBjb25zdCByb3V0ZXIgPSB1c2VSb3V0ZXIoKTsKICBjb25zdCB7IHVzZXIgfSA9IHVzZUF1dGgoKTsKICBjb25zdCB7IGF2YWlsYWJsZSwgbG9hZEF2YWlsYWJsZSwgaXNMb2FkaW5nIH0gPSB1c2VNaXNzaW9ucygpOwogIGNvbnN0IFtpc09ubGluZSwgc2V0SXNPbmxpbmVdID0gdXNlU3RhdGUoZmFsc2UpOwoKICB1c2VFZmZlY3QoKCkgPT4geyBpZiAoaXNPbmxpbmUpIGxvYWRBdmFpbGFibGUoKTsgfSwgW2lzT25saW5lXSk7CgogIHJldHVybiAoCiAgICA8U2Nyb2xsVmlldyBzdHlsZT17c3R5bGVzLnNjcmVlbn0gY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMuY29udGFpbmVyfSBzaG93c1ZlcnRpY2FsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaGVhZGVyfT4KICAgICAgICA8QXZhdGFyIG5hbWU9e2Ake3VzZXI/LmZpcnN0TmFtZSA/PyAnJ30gJHt1c2VyPy5sYXN0TmFtZSA/PyAnJ31gfSB1cmk9e3VzZXI/LmF2YXRhcn0gc2l6ZT0ibWQiIC8+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5oZWFkZXJJbmZvfT4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZ3JlZXRpbmd9PkJvbmpvdXIsIHt1c2VyPy5maXJzdE5hbWV9PC9UZXh0PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5yb2xlfT5UcmFuc3BvcnRldXI8L1RleHQ+CiAgICAgICAgPC9WaWV3PgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMub25saW5lVG9nZ2xlfT4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtbc3R5bGVzLm9ubGluZUxhYmVsLCBpc09ubGluZSAmJiBzdHlsZXMub25saW5lTGFiZWxBY3RpdmVdfT4KICAgICAgICAgICAge2lzT25saW5lID8gJ0VuIGxpZ25lJyA6ICdIb3JzIGxpZ25lJ30KICAgICAgICAgIDwvVGV4dD4KICAgICAgICAgIDxTd2l0Y2ggdmFsdWU9e2lzT25saW5lfSBvblZhbHVlQ2hhbmdlPXtzZXRJc09ubGluZX0gdHJhY2tDb2xvcj17eyBmYWxzZTogQ29sb3JzLkJPUkRFUiwgdHJ1ZTogQ29sb3JzLlNVQ0NFU1MgfX0gdGh1bWJDb2xvcj17Q29sb3JzLldISVRFfSAvPgogICAgICAgIDwvVmlldz4KICAgICAgPC9WaWV3PgoKICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5zdGF0c0dyaWR9PgogICAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMuc3RhdENhcmR9PjxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdEVtb2ppfT7wn5qAPC9UZXh0PjxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdFZhbHVlfT7igJQ8L1RleHQ+PFRleHQgc3R5bGU9e3N0eWxlcy5zdGF0TGFiZWx9PkF1am91cmQnaHVpPC9UZXh0PjwvQ2FyZD4KICAgICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLnN0YXRDYXJkfT48VGV4dCBzdHlsZT17c3R5bGVzLnN0YXRFbW9qaX0+8J+SsDwvVGV4dD48VGV4dCBzdHlsZT17c3R5bGVzLnN0YXRWYWx1ZX0+4oCUIOKCrDwvVGV4dD48VGV4dCBzdHlsZT17c3R5bGVzLnN0YXRMYWJlbH0+UmV2ZW51czwvVGV4dD48L0NhcmQ+CiAgICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5zdGF0Q2FyZH0+PFRleHQgc3R5bGU9e3N0eWxlcy5zdGF0RW1vaml9PuKtkDwvVGV4dD48VGV4dCBzdHlsZT17c3R5bGVzLnN0YXRWYWx1ZX0+4oCUPC9UZXh0PjxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdExhYmVsfT5Ob3RlIG1veS48L1RleHQ+PC9DYXJkPgogICAgICA8L1ZpZXc+CgogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnNlY3Rpb25IZWFkZXJ9PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VjdGlvblRpdGxlfT4KICAgICAgICAgIHtpc09ubGluZSA/IGAke2F2YWlsYWJsZS5sZW5ndGh9IG1pc3Npb24ke2F2YWlsYWJsZS5sZW5ndGggPiAxID8gJ3MnIDogJyd9IGRpc3BvbmlibGUke2F2YWlsYWJsZS5sZW5ndGggPiAxID8gJ3MnIDogJyd9YCA6ICdNaXNzaW9ucyBkaXNwb25pYmxlcyd9CiAgICAgICAgPC9UZXh0PgogICAgICAgIHthdmFpbGFibGUubGVuZ3RoID4gMCAmJiAoCiAgICAgICAgICA8VG91Y2hhYmxlT3BhY2l0eSBvblByZXNzPXsoKSA9PiByb3V0ZXIucHVzaCgnLyh0cmFuc3BvcnRldXIpL21pc3Npb25zJyl9PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlZUFsbH0+Vm9pciB0b3V0PC9UZXh0PgogICAgICAgICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICAgICAgICl9CiAgICAgIDwvVmlldz4KCiAgICAgIHshaXNPbmxpbmUgPyAoCiAgICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5vZmZsaW5lQ2FyZH0+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLm9mZmxpbmVFbW9qaX0+8J+SpDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMub2ZmbGluZVRpdGxlfT5Wb3VzIMOqdGVzIGhvcnMgbGlnbmU8L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLm9mZmxpbmVUZXh0fT5BY3RpdmV6IHZvdHJlIGRpc3BvbmliaWxpdMOpIHBvdXIgcmVjZXZvaXIgZGVzIG1pc3Npb25zLjwvVGV4dD4KICAgICAgICA8L0NhcmQ+CiAgICAgICkgOiBhdmFpbGFibGUubGVuZ3RoID09PSAwID8gKAogICAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMub2ZmbGluZUNhcmR9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5vZmZsaW5lRW1vaml9PvCflI08L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLm9mZmxpbmVUaXRsZX0+QXVjdW5lIG1pc3Npb24gZGlzcG9uaWJsZTwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMub2ZmbGluZVRleHR9PlJlc3RleiBjb25uZWN0w6ksIHVuZSBtaXNzaW9uIHBldXQgYXJyaXZlciDDoCB0b3V0IG1vbWVudC48L1RleHQ+CiAgICAgICAgPC9DYXJkPgogICAgICApIDogKAogICAgICAgIGF2YWlsYWJsZS5zbGljZSgwLCAzKS5tYXAoKG0pID0+ICgKICAgICAgICAgIDxNaXNzaW9uQ2FyZCBrZXk9e20uaWR9IG1pc3Npb249e219IG9uUHJlc3M9eyhtaXNzaW9uKSA9PiByb3V0ZXIucHVzaChgLyh0cmFuc3BvcnRldXIpL21pc3Npb24vJHttaXNzaW9uLmlkfWApfSAvPgogICAgICAgICkpCiAgICAgICl9CiAgICA8L1Njcm9sbFZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIHNjcmVlbjogeyBmbGV4OiAxLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CQUNLR1JPVU5EIH0sCiAgY29udGFpbmVyOiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ1RvcDogNjAsIHBhZGRpbmdCb3R0b206IDQwIH0sCiAgaGVhZGVyOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgZ2FwOiAxMiwgbWFyZ2luQm90dG9tOiAyNCB9LAogIGhlYWRlckluZm86IHsgZmxleDogMSB9LAogIGdyZWV0aW5nOiB7IGZvbnRTaXplOiAxOCwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIHJvbGU6IHsgZm9udFNpemU6IDEzLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCiAgb25saW5lVG9nZ2xlOiB7IGFsaWduSXRlbXM6ICdjZW50ZXInLCBnYXA6IDQgfSwKICBvbmxpbmVMYWJlbDogeyBmb250U2l6ZTogMTEsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIGZvbnRXZWlnaHQ6ICc2MDAnIH0sCiAgb25saW5lTGFiZWxBY3RpdmU6IHsgY29sb3I6IENvbG9ycy5TVUNDRVNTIH0sCiAgc3RhdHNHcmlkOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBnYXA6IDEwLCBtYXJnaW5Cb3R0b206IDI4IH0sCiAgc3RhdENhcmQ6IHsgZmxleDogMSwgYWxpZ25JdGVtczogJ2NlbnRlcicsIHBhZGRpbmdWZXJ0aWNhbDogMTYsIGdhcDogNCB9LAogIHN0YXRFbW9qaTogeyBmb250U2l6ZTogMjAgfSwKICBzdGF0VmFsdWU6IHsgZm9udFNpemU6IDE4LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCiAgc3RhdExhYmVsOiB7IGZvbnRTaXplOiAxMSwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgdGV4dEFsaWduOiAnY2VudGVyJyB9LAogIHNlY3Rpb25IZWFkZXI6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGp1c3RpZnlDb250ZW50OiAnc3BhY2UtYmV0d2VlbicsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBtYXJnaW5Cb3R0b206IDE0IH0sCiAgc2VjdGlvblRpdGxlOiB7IGZvbnRTaXplOiAxNywgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIHNlZUFsbDogeyBmb250U2l6ZTogMTQsIGNvbG9yOiBDb2xvcnMuUFJJTUFSWSwgZm9udFdlaWdodDogJzYwMCcgfSwKICBvZmZsaW5lQ2FyZDogeyBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ1ZlcnRpY2FsOiAzMiB9LAogIG9mZmxpbmVFbW9qaTogeyBmb250U2l6ZTogNDAsIG1hcmdpbkJvdHRvbTogMTIgfSwKICBvZmZsaW5lVGl0bGU6IHsgZm9udFNpemU6IDE3LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDYgfSwKICBvZmZsaW5lVGV4dDogeyBmb250U2l6ZTogMTQsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIHRleHRBbGlnbjogJ2NlbnRlcicsIGxpbmVIZWlnaHQ6IDIwIH0sCn0pOwo=" | base64 -d > 'mobile/app/(transporteur)/dashboard.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZUVmZmVjdCwgdXNlU3RhdGUgfSBmcm9tICdyZWFjdCc7CmltcG9ydCB7IEZsYXRMaXN0LCBTdHlsZVNoZWV0LCBUZXh0LCBUb3VjaGFibGVPcGFjaXR5LCBWaWV3IH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgdXNlUm91dGVyIH0gZnJvbSAnZXhwby1yb3V0ZXInOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgdXNlTWlzc2lvbnMgfSBmcm9tICcuLi8uLi9ob29rcy91c2VNaXNzaW9ucyc7CmltcG9ydCB7IE1pc3Npb25DYXJkIH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy9taXNzaW9uL01pc3Npb25DYXJkJzsKCnR5cGUgVGFiID0gJ2F2YWlsYWJsZScgfCAnbXknOwoKZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gVHJhbnNwb3J0ZXVyTWlzc2lvbnNTY3JlZW4oKSB7CiAgY29uc3Qgcm91dGVyID0gdXNlUm91dGVyKCk7CiAgY29uc3QgeyBhdmFpbGFibGUsIGxpc3QsIGxvYWRBdmFpbGFibGUsIGxvYWRNaXNzaW9ucywgaXNMb2FkaW5nIH0gPSB1c2VNaXNzaW9ucygpOwogIGNvbnN0IFt0YWIsIHNldFRhYl0gPSB1c2VTdGF0ZTxUYWI+KCdhdmFpbGFibGUnKTsKCiAgdXNlRWZmZWN0KCgpID0+IHsgbG9hZEF2YWlsYWJsZSgpOyBsb2FkTWlzc2lvbnMoKTsgfSwgW10pOwoKICBjb25zdCBkYXRhID0gdGFiID09PSAnYXZhaWxhYmxlJyA/IGF2YWlsYWJsZSA6IGxpc3Q7CgogIHJldHVybiAoCiAgICA8VmlldyBzdHlsZT17c3R5bGVzLnNjcmVlbn0+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaGVhZGVyU2VjdGlvbn0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy50aXRsZX0+TWlzc2lvbnM8L1RleHQ+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy50YWJzfT4KICAgICAgICAgIHsoWydhdmFpbGFibGUnLCAnbXknXSBhcyBUYWJbXSkubWFwKCh0KSA9PiAoCiAgICAgICAgICAgIDxUb3VjaGFibGVPcGFjaXR5IGtleT17dH0gc3R5bGU9e1tzdHlsZXMudGFiLCB0YWIgPT09IHQgJiYgc3R5bGVzLnRhYkFjdGl2ZV19IG9uUHJlc3M9eygpID0+IHNldFRhYih0KX0+CiAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMudGFiVGV4dCwgdGFiID09PSB0ICYmIHN0eWxlcy50YWJUZXh0QWN0aXZlXX0+CiAgICAgICAgICAgICAgICB7dCA9PT0gJ2F2YWlsYWJsZScgPyAnRGlzcG9uaWJsZXMnIDogJ01lcyBtaXNzaW9ucyd9CiAgICAgICAgICAgICAgPC9UZXh0PgogICAgICAgICAgICA8L1RvdWNoYWJsZU9wYWNpdHk+CiAgICAgICAgICApKX0KICAgICAgICA8L1ZpZXc+CiAgICAgIDwvVmlldz4KCiAgICAgIDxGbGF0TGlzdAogICAgICAgIGRhdGE9e2RhdGF9CiAgICAgICAga2V5RXh0cmFjdG9yPXsoaXRlbSkgPT4gaXRlbS5pZH0KICAgICAgICByZW5kZXJJdGVtPXsoeyBpdGVtIH0pID0+ICgKICAgICAgICAgIDxNaXNzaW9uQ2FyZCBtaXNzaW9uPXtpdGVtfSBvblByZXNzPXsobSkgPT4gcm91dGVyLnB1c2goYC8odHJhbnNwb3J0ZXVyKS9taXNzaW9uLyR7bS5pZH1gKX0gLz4KICAgICAgICApfQogICAgICAgIGNvbnRlbnRDb250YWluZXJTdHlsZT17c3R5bGVzLmxpc3R9CiAgICAgICAgc2hvd3NWZXJ0aWNhbFNjcm9sbEluZGljYXRvcj17ZmFsc2V9CiAgICAgICAgb25SZWZyZXNoPXsoKSA9PiB7IGxvYWRBdmFpbGFibGUoKTsgbG9hZE1pc3Npb25zKCk7IH19CiAgICAgICAgcmVmcmVzaGluZz17aXNMb2FkaW5nfQogICAgICAgIExpc3RFbXB0eUNvbXBvbmVudD17CiAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmVtcHR5Q29udGFpbmVyfT4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5lbXB0eUVtb2ppfT7wn5OtPC9UZXh0PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmVtcHR5VGl0bGV9PkF1Y3VuZSBtaXNzaW9uPC9UZXh0PgogICAgICAgICAgPC9WaWV3PgogICAgICAgIH0KICAgICAgLz4KICAgIDwvVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgc2NyZWVuOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQgfSwKICBoZWFkZXJTZWN0aW9uOiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ1RvcDogNjAsIHBhZGRpbmdCb3R0b206IDE2IH0sCiAgdGl0bGU6IHsgZm9udFNpemU6IDI2LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDE2IH0sCiAgdGFiczogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VSRkFDRSwgYm9yZGVyUmFkaXVzOiAxMiwgcGFkZGluZzogNCwgZ2FwOiA0IH0sCiAgdGFiOiB7IGZsZXg6IDEsIHBhZGRpbmdWZXJ0aWNhbDogMTAsIGJvcmRlclJhZGl1czogMTAsIGFsaWduSXRlbXM6ICdjZW50ZXInIH0sCiAgdGFiQWN0aXZlOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKICB0YWJUZXh0OiB7IGZvbnRTaXplOiAxNCwgZm9udFdlaWdodDogJzYwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlkgfSwKICB0YWJUZXh0QWN0aXZlOiB7IGNvbG9yOiBDb2xvcnMuV0hJVEUgfSwKICBsaXN0OiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ1RvcDogOCwgcGFkZGluZ0JvdHRvbTogNDAgfSwKICBlbXB0eUNvbnRhaW5lcjogeyBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ1RvcDogNjAgfSwKICBlbXB0eUVtb2ppOiB7IGZvbnRTaXplOiA0OCwgbWFyZ2luQm90dG9tOiAxMiB9LAogIGVtcHR5VGl0bGU6IHsgZm9udFNpemU6IDE4LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSB9LAp9KTsK" | base64 -d > 'mobile/app/(transporteur)/missions.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZUVmZmVjdCwgdXNlU3RhdGUgfSBmcm9tICdyZWFjdCc7CmltcG9ydCB7IEFjdGl2aXR5SW5kaWNhdG9yLCBBbGVydCwgU2Nyb2xsVmlldywgU3R5bGVTaGVldCwgVGV4dCwgVG91Y2hhYmxlT3BhY2l0eSwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IHVzZUxvY2FsU2VhcmNoUGFyYW1zLCB1c2VSb3V0ZXIgfSBmcm9tICdleHBvLXJvdXRlcic7CmltcG9ydCAqIGFzIExvY2F0aW9uIGZyb20gJ2V4cG8tbG9jYXRpb24nOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgdXNlTWlzc2lvbnMgfSBmcm9tICcuLi8uLi8uLi9ob29rcy91c2VNaXNzaW9ucyc7CmltcG9ydCB7IHVzZVNvY2tldCB9IGZyb20gJy4uLy4uLy4uL2hvb2tzL3VzZVNvY2tldCc7CmltcG9ydCB7IE1pc3Npb25TdGF0dXNUcmFja2VyIH0gZnJvbSAnLi4vLi4vLi4vY29tcG9uZW50cy9taXNzaW9uL01pc3Npb25TdGF0dXMnOwppbXBvcnQgeyBUcmFja2luZ01hcCB9IGZyb20gJy4uLy4uLy4uL2NvbXBvbmVudHMvbWFwL1RyYWNraW5nTWFwJzsKaW1wb3J0IHsgQ2FyZCB9IGZyb20gJy4uLy4uLy4uL2NvbXBvbmVudHMvdWkvQ2FyZCc7CmltcG9ydCB7IEJ1dHRvbiB9IGZyb20gJy4uLy4uLy4uL2NvbXBvbmVudHMvdWkvQnV0dG9uJzsKCmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIFRyYW5zcG9ydGV1ck1pc3Npb25EZXRhaWxTY3JlZW4oKSB7CiAgY29uc3QgeyBpZCB9ID0gdXNlTG9jYWxTZWFyY2hQYXJhbXM8eyBpZDogc3RyaW5nIH0+KCk7CiAgY29uc3Qgcm91dGVyID0gdXNlUm91dGVyKCk7CiAgY29uc3QgeyBjdXJyZW50LCBsb2FkTWlzc2lvbiwgYWNjZXB0LCBzdGFydCwgY29tcGxldGUsIGlzTG9hZGluZyB9ID0gdXNlTWlzc2lvbnMoKTsKICBjb25zdCB7IGNvbm5lY3QsIGVtaXRHcHNVcGRhdGUsIGRpc2Nvbm5lY3QgfSA9IHVzZVNvY2tldCgpOwogIGNvbnN0IFtncHNJbnRlcnZhbCwgc2V0R3BzSW50ZXJ2YWxdID0gdXNlU3RhdGU8UmV0dXJuVHlwZTx0eXBlb2Ygc2V0SW50ZXJ2YWw+IHwgbnVsbD4obnVsbCk7CgogIHVzZUVmZmVjdCgoKSA9PiB7IGlmIChpZCkgbG9hZE1pc3Npb24oaWQpOyB9LCBbaWRdKTsKCiAgdXNlRWZmZWN0KCgpID0+IHsKICAgIGNvbm5lY3QoKTsKICAgIHJldHVybiAoKSA9PiB7IGRpc2Nvbm5lY3QoKTsgaWYgKGdwc0ludGVydmFsKSBjbGVhckludGVydmFsKGdwc0ludGVydmFsKTsgfTsKICB9LCBbXSk7CgogIGNvbnN0IHN0YXJ0R3BzVHJhY2tpbmcgPSBhc3luYyAoKSA9PiB7CiAgICBjb25zdCB7IHN0YXR1cyB9ID0gYXdhaXQgTG9jYXRpb24ucmVxdWVzdEZvcmVncm91bmRQZXJtaXNzaW9uc0FzeW5jKCk7CiAgICBpZiAoc3RhdHVzICE9PSAnZ3JhbnRlZCcpIHsgQWxlcnQuYWxlcnQoJ1Blcm1pc3Npb24gR1BTJywgJ0xhIGxvY2FsaXNhdGlvbiBlc3QgbsOpY2Vzc2FpcmUgcG91ciBsZSBzdWl2aS4nKTsgcmV0dXJuOyB9CiAgICBjb25zdCBpbnRlcnZhbCA9IHNldEludGVydmFsKGFzeW5jICgpID0+IHsKICAgICAgY29uc3QgbG9jID0gYXdhaXQgTG9jYXRpb24uZ2V0Q3VycmVudFBvc2l0aW9uQXN5bmMoeyBhY2N1cmFjeTogTG9jYXRpb24uQWNjdXJhY3kuSGlnaCB9KTsKICAgICAgZW1pdEdwc1VwZGF0ZShpZCEsIHsKICAgICAgICBsYXQ6IGxvYy5jb29yZHMubGF0aXR1ZGUsCiAgICAgICAgbG5nOiBsb2MuY29vcmRzLmxvbmdpdHVkZSwKICAgICAgICBoZWFkaW5nOiBsb2MuY29vcmRzLmhlYWRpbmcgPz8gdW5kZWZpbmVkLAogICAgICAgIHNwZWVkOiBsb2MuY29vcmRzLnNwZWVkID8/IHVuZGVmaW5lZCwKICAgICAgICB0aW1lc3RhbXA6IERhdGUubm93KCksCiAgICAgIH0pOwogICAgfSwgNTAwMCk7CiAgICBzZXRHcHNJbnRlcnZhbChpbnRlcnZhbCk7CiAgfTsKCiAgaWYgKGlzTG9hZGluZyB8fCAhY3VycmVudCkgewogICAgcmV0dXJuICg8VmlldyBzdHlsZT17c3R5bGVzLmNlbnRlcn0+PEFjdGl2aXR5SW5kaWNhdG9yIHNpemU9ImxhcmdlIiBjb2xvcj17Q29sb3JzLlBSSU1BUll9IC8+PC9WaWV3Pik7CiAgfQoKICBjb25zdCBtaXNzaW9uID0gY3VycmVudDsKICBjb25zdCBpc1BlbmRpbmcgPSBtaXNzaW9uLnN0YXR1cyA9PT0gJ1BFTkRJTkcnOwogIGNvbnN0IGlzQWNjZXB0ZWQgPSBtaXNzaW9uLnN0YXR1cyA9PT0gJ0FDQ0VQVEVEJzsKICBjb25zdCBpc0luUHJvZ3Jlc3MgPSBtaXNzaW9uLnN0YXR1cyA9PT0gJ0lOX1BST0dSRVNTJzsKCiAgY29uc3QgaGFuZGxlQWNjZXB0ID0gYXN5bmMgKCkgPT4gewogICAgQWxlcnQuYWxlcnQoJ0FjY2VwdGVyIGxhIG1pc3Npb24nLCAnQ29uZmlybWVyIGxhIHByaXNlIGVuIGNoYXJnZSA/JywgWwogICAgICB7IHRleHQ6ICdBbm51bGVyJywgc3R5bGU6ICdjYW5jZWwnIH0sCiAgICAgIHsgdGV4dDogJ0FjY2VwdGVyJywgb25QcmVzczogYXN5bmMgKCkgPT4geyBhd2FpdCBhY2NlcHQobWlzc2lvbi5pZCwgJ1ZFSElDTEVfSURfUExBQ0VIT0xERVInKTsgfSB9LAogICAgXSk7CiAgfTsKCiAgY29uc3QgaGFuZGxlU3RhcnQgPSBhc3luYyAoKSA9PiB7IGF3YWl0IHN0YXJ0KG1pc3Npb24uaWQpOyBhd2FpdCBzdGFydEdwc1RyYWNraW5nKCk7IH07CgogIGNvbnN0IGhhbmRsZUNvbXBsZXRlID0gYXN5bmMgKCkgPT4gewogICAgQWxlcnQuYWxlcnQoJ1Rlcm1pbmVyIGxhIG1pc3Npb24nLCAnQ29uZmlybWVyIGxhIGxpdnJhaXNvbiBlZmZlY3R1w6llID8nLCBbCiAgICAgIHsgdGV4dDogJ0FubnVsZXInLCBzdHlsZTogJ2NhbmNlbCcgfSwKICAgICAgeyB0ZXh0OiAnQ29uZmlybWVyJywgb25QcmVzczogYXN5bmMgKCkgPT4geyBpZiAoZ3BzSW50ZXJ2YWwpIGNsZWFySW50ZXJ2YWwoZ3BzSW50ZXJ2YWwpOyBhd2FpdCBjb21wbGV0ZShtaXNzaW9uLmlkKTsgfSB9LAogICAgXSk7CiAgfTsKCiAgcmV0dXJuICgKICAgIDxTY3JvbGxWaWV3IHN0eWxlPXtzdHlsZXMuc2NyZWVufSBjb250ZW50Q29udGFpbmVyU3R5bGU9e3N0eWxlcy5jb250YWluZXJ9IHNob3dzVmVydGljYWxTY3JvbGxJbmRpY2F0b3I9e2ZhbHNlfT4KICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5oZWFkZXJ9PgogICAgICAgIDxUb3VjaGFibGVPcGFjaXR5IG9uUHJlc3M9eygpID0+IHJvdXRlci5iYWNrKCl9IHN0eWxlPXtzdHlsZXMuYmFja0J0bn0+PFRleHQgc3R5bGU9e3N0eWxlcy5iYWNrVGV4dH0+4oaQPC9UZXh0PjwvVG91Y2hhYmxlT3BhY2l0eT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnRpdGxlfT5NaXNzaW9uICN7bWlzc2lvbi5pZC5zbGljZSgwLCA4KS50b1VwcGVyQ2FzZSgpfTwvVGV4dD4KICAgICAgICA8VmlldyBzdHlsZT17eyB3aWR0aDogNDAgfX0gLz4KICAgICAgPC9WaWV3PgoKICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5tYXBDb250YWluZXJ9PgogICAgICAgIDxUcmFja2luZ01hcCBwaWNrdXBMYXQ9e21pc3Npb24ucGlja3VwTGF0fSBwaWNrdXBMbmc9e21pc3Npb24ucGlja3VwTG5nfSBkZWxpdmVyeUxhdD17bWlzc2lvbi5kZWxpdmVyeUxhdH0gZGVsaXZlcnlMbmc9e21pc3Npb24uZGVsaXZlcnlMbmd9IC8+CiAgICAgIDwvVmlldz4KCiAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMuc2VjdGlvbn0+PE1pc3Npb25TdGF0dXNUcmFja2VyIHN0YXR1cz17bWlzc2lvbi5zdGF0dXN9IC8+PC9DYXJkPgoKICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5zZWN0aW9ufT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlY3Rpb25UaXRsZX0+SXRpbsOpcmFpcmU8L1RleHQ+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5kZXRhaWxSb3d9PgogICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5ncmVlbkRvdH0gLz4KICAgICAgICAgIDxWaWV3PjxUZXh0IHN0eWxlPXtzdHlsZXMuZGV0YWlsTGFiZWx9PkVubMOodmVtZW50PC9UZXh0PjxUZXh0IHN0eWxlPXtzdHlsZXMuZGV0YWlsVmFsdWV9PnttaXNzaW9uLnBpY2t1cEFkZHJlc3N9PC9UZXh0PjwvVmlldz4KICAgICAgICA8L1ZpZXc+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5yb3V0ZUxpbmV9IC8+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5kZXRhaWxSb3d9PgogICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5yZWREb3R9IC8+CiAgICAgICAgICA8Vmlldz48VGV4dCBzdHlsZT17c3R5bGVzLmRldGFpbExhYmVsfT5MaXZyYWlzb248L1RleHQ+PFRleHQgc3R5bGU9e3N0eWxlcy5kZXRhaWxWYWx1ZX0+e21pc3Npb24uZGVsaXZlcnlBZGRyZXNzfTwvVGV4dD48L1ZpZXc+CiAgICAgICAgPC9WaWV3PgogICAgICA8L0NhcmQ+CgogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLnNlY3Rpb259PgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMucHJpY2VSb3d9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5wcmljZUxhYmVsfT5Sw6ltdW7DqXJhdGlvbjwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMucHJpY2VWYWx1ZX0+eyhtaXNzaW9uLnByaWNlIC0gbWlzc2lvbi5jb21taXNzaW9uKS50b0ZpeGVkKDIpfSDigqw8L1RleHQ+CiAgICAgICAgPC9WaWV3PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuY29tbWlzc2lvbk5vdGV9PkNvbW1pc3Npb24gSk8nRFJJVkU6IHttaXNzaW9uLmNvbW1pc3Npb24udG9GaXhlZCgyKX0g4oKsICh7KChtaXNzaW9uLmNvbW1pc3Npb24gLyBtaXNzaW9uLnByaWNlKSAqIDEwMCkudG9GaXhlZCgwKX0lKTwvVGV4dD4KICAgICAgICB7bWlzc2lvbi5kaXN0YW5jZSAhPSBudWxsICYmICg8VGV4dCBzdHlsZT17c3R5bGVzLmRpc3RhbmNlTm90ZX0+RGlzdGFuY2U6IHttaXNzaW9uLmRpc3RhbmNlLnRvRml4ZWQoMSl9IGttPC9UZXh0Pil9CiAgICAgIDwvQ2FyZD4KCiAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMuc2VjdGlvbn0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zZWN0aW9uVGl0bGV9Pk9iamV0cyAoe21pc3Npb24uaXRlbXMubGVuZ3RofSk8L1RleHQ+CiAgICAgICAge21pc3Npb24uaXRlbXMubWFwKChpdGVtLCBpKSA9PiAoCiAgICAgICAgICA8VmlldyBrZXk9e2l0ZW0uaWR9IHN0eWxlPXtbc3R5bGVzLml0ZW1Sb3csIGkgPiAwICYmIHN0eWxlcy5pdGVtQm9yZGVyXX0+CiAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuaXRlbUVtb2ppfT7wn5OmPC9UZXh0PgogICAgICAgICAgICA8Vmlldz4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLml0ZW1EZXNjfT57aXRlbS5kZXNjcmlwdGlvbn08L1RleHQ+CiAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5pdGVtTWV0YX0+UXTDqToge2l0ZW0ucXVhbnRpdHl9e2l0ZW0uZXN0aW1hdGVkV2VpZ2h0ID8gYCDigKIgJHtpdGVtLmVzdGltYXRlZFdlaWdodH0ga2dgIDogJyd9PC9UZXh0PgogICAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgKSl9CiAgICAgIDwvQ2FyZD4KCiAgICAgIHtpc1BlbmRpbmcgJiYgPEJ1dHRvbiB0aXRsZT0i4pyFIEFjY2VwdGVyIGxhIG1pc3Npb24iIG9uUHJlc3M9e2hhbmRsZUFjY2VwdH0gbG9hZGluZz17aXNMb2FkaW5nfSBmdWxsV2lkdGggc2l6ZT0ibGciIHN0eWxlPXtzdHlsZXMuYWN0aW9uQnRufSAvPn0KICAgICAge2lzQWNjZXB0ZWQgJiYgPEJ1dHRvbiB0aXRsZT0i8J+agCBEw6ltYXJyZXIgbGEgbWlzc2lvbiIgb25QcmVzcz17aGFuZGxlU3RhcnR9IGxvYWRpbmc9e2lzTG9hZGluZ30gZnVsbFdpZHRoIHNpemU9ImxnIiBzdHlsZT17c3R5bGVzLmFjdGlvbkJ0bn0gLz59CiAgICAgIHtpc0luUHJvZ3Jlc3MgJiYgPEJ1dHRvbiB0aXRsZT0i8J+PgSBDb25maXJtZXIgbGEgbGl2cmFpc29uIiBvblByZXNzPXtoYW5kbGVDb21wbGV0ZX0gbG9hZGluZz17aXNMb2FkaW5nfSBmdWxsV2lkdGggc2l6ZT0ibGciIHN0eWxlPXtzdHlsZXMuYWN0aW9uQnRufSAvPn0KICAgIDwvU2Nyb2xsVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgc2NyZWVuOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQgfSwKICBjb250YWluZXI6IHsgcGFkZGluZ0hvcml6b250YWw6IDIwLCBwYWRkaW5nVG9wOiA1NiwgcGFkZGluZ0JvdHRvbTogNDAgfSwKICBjZW50ZXI6IHsgZmxleDogMSwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQkFDS0dST1VORCwgYWxpZ25JdGVtczogJ2NlbnRlcicsIGp1c3RpZnlDb250ZW50OiAnY2VudGVyJyB9LAogIGhlYWRlcjogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYWxpZ25JdGVtczogJ2NlbnRlcicsIGp1c3RpZnlDb250ZW50OiAnc3BhY2UtYmV0d2VlbicsIG1hcmdpbkJvdHRvbTogMjAgfSwKICBiYWNrQnRuOiB7IHdpZHRoOiA0MCwgaGVpZ2h0OiA0MCwgYm9yZGVyUmFkaXVzOiAyMCwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VSRkFDRSwgYWxpZ25JdGVtczogJ2NlbnRlcicsIGp1c3RpZnlDb250ZW50OiAnY2VudGVyJyB9LAogIGJhY2tUZXh0OiB7IGNvbG9yOiBDb2xvcnMuVEVYVCwgZm9udFNpemU6IDE4LCBmb250V2VpZ2h0OiAnNzAwJyB9LAogIHRpdGxlOiB7IGZvbnRTaXplOiAxNiwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIG1hcENvbnRhaW5lcjogeyBoZWlnaHQ6IDIwMCwgYm9yZGVyUmFkaXVzOiAxNiwgb3ZlcmZsb3c6ICdoaWRkZW4nLCBtYXJnaW5Cb3R0b206IDE2IH0sCiAgc2VjdGlvbjogeyBtYXJnaW5Cb3R0b206IDE0IH0sCiAgc2VjdGlvblRpdGxlOiB7IGZvbnRTaXplOiAxNSwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiAxMiB9LAogIGRldGFpbFJvdzogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYWxpZ25JdGVtczogJ2ZsZXgtc3RhcnQnLCBnYXA6IDEyIH0sCiAgZ3JlZW5Eb3Q6IHsgd2lkdGg6IDE0LCBoZWlnaHQ6IDE0LCBib3JkZXJSYWRpdXM6IDcsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVQ0NFU1MsIG1hcmdpblRvcDogNCB9LAogIHJlZERvdDogeyB3aWR0aDogMTQsIGhlaWdodDogMTQsIGJvcmRlclJhZGl1czogNywgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuUFJJTUFSWSwgbWFyZ2luVG9wOiA0IH0sCiAgZGV0YWlsTGFiZWw6IHsgZm9udFNpemU6IDEyLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBmb250V2VpZ2h0OiAnNjAwJywgbWFyZ2luQm90dG9tOiAyIH0sCiAgZGV0YWlsVmFsdWU6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFQgfSwKICByb3V0ZUxpbmU6IHsgd2lkdGg6IDIsIGhlaWdodDogMjAsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJPUkRFUiwgbWFyZ2luTGVmdDogNiwgbWFyZ2luVmVydGljYWw6IDQgfSwKICBwcmljZVJvdzogeyBmbGV4RGlyZWN0aW9uOiAncm93JywganVzdGlmeUNvbnRlbnQ6ICdzcGFjZS1iZXR3ZWVuJywgYWxpZ25JdGVtczogJ2NlbnRlcicsIG1hcmdpbkJvdHRvbTogNiB9LAogIHByaWNlTGFiZWw6IHsgZm9udFNpemU6IDE1LCBjb2xvcjogQ29sb3JzLlRFWFQsIGZvbnRXZWlnaHQ6ICc1MDAnIH0sCiAgcHJpY2VWYWx1ZTogeyBmb250U2l6ZTogMjQsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlNVQ0NFU1MgfSwKICBjb21taXNzaW9uTm90ZTogeyBmb250U2l6ZTogMTIsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlkgfSwKICBkaXN0YW5jZU5vdGU6IHsgZm9udFNpemU6IDEyLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBtYXJnaW5Ub3A6IDIgfSwKICBpdGVtUm93OiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgZ2FwOiAxMiwgcGFkZGluZ1ZlcnRpY2FsOiAxMCB9LAogIGl0ZW1Cb3JkZXI6IHsgYm9yZGVyVG9wV2lkdGg6IDEsIGJvcmRlclRvcENvbG9yOiBDb2xvcnMuQk9SREVSIH0sCiAgaXRlbUVtb2ppOiB7IGZvbnRTaXplOiAyMiB9LAogIGl0ZW1EZXNjOiB7IGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhULCBmb250V2VpZ2h0OiAnNTAwJyB9LAogIGl0ZW1NZXRhOiB7IGZvbnRTaXplOiAxMiwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luVG9wOiAyIH0sCiAgYWN0aW9uQnRuOiB7IG1hcmdpblRvcDogNCB9LAp9KTsK" | base64 -d > 'mobile/app/(transporteur)/mission/[id].tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgQWxlcnQsIFNjcm9sbFZpZXcsIFN0eWxlU2hlZXQsIFRleHQsIFRvdWNoYWJsZU9wYWNpdHksIFZpZXcgfSBmcm9tICdyZWFjdC1uYXRpdmUnOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgdXNlQXV0aCB9IGZyb20gJy4uLy4uL2hvb2tzL3VzZUF1dGgnOwppbXBvcnQgeyBBdmF0YXIgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0F2YXRhcic7CmltcG9ydCB7IENhcmQgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0NhcmQnOwoKZnVuY3Rpb24gTWVudUl0ZW0oeyBlbW9qaSwgbGFiZWwsIG9uUHJlc3MsIGRhbmdlciB9OiB7IGVtb2ppOiBzdHJpbmc7IGxhYmVsOiBzdHJpbmc7IG9uUHJlc3M6ICgpID0+IHZvaWQ7IGRhbmdlcj86IGJvb2xlYW4gfSkgewogIHJldHVybiAoCiAgICA8VG91Y2hhYmxlT3BhY2l0eSBzdHlsZT17c3R5bGVzLm1lbnVJdGVtfSBvblByZXNzPXtvblByZXNzfSBhY3RpdmVPcGFjaXR5PXswLjd9PgogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLm1lbnVFbW9qaX0+e2Vtb2ppfTwvVGV4dD4KICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMubWVudUxhYmVsLCBkYW5nZXIgJiYgc3R5bGVzLm1lbnVMYWJlbERhbmdlcl19PntsYWJlbH08L1RleHQ+CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMubWVudUFycm93fT7igLo8L1RleHQ+CiAgICA8L1RvdWNoYWJsZU9wYWNpdHk+CiAgKTsKfQoKZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gVHJhbnNwb3J0ZXVyUHJvZmlsU2NyZWVuKCkgewogIGNvbnN0IHsgdXNlciwgbG9nb3V0IH0gPSB1c2VBdXRoKCk7CgogIGNvbnN0IGhhbmRsZUxvZ291dCA9ICgpID0+IHsKICAgIEFsZXJ0LmFsZXJ0KCdEw6ljb25uZXhpb24nLCAnVm91bGV6LXZvdXMgdnJhaW1lbnQgdm91cyBkw6ljb25uZWN0ZXIgPycsIFsKICAgICAgeyB0ZXh0OiAnQW5udWxlcicsIHN0eWxlOiAnY2FuY2VsJyB9LAogICAgICB7IHRleHQ6ICdEw6ljb25uZXhpb24nLCBzdHlsZTogJ2Rlc3RydWN0aXZlJywgb25QcmVzczogKCkgPT4gbG9nb3V0KCkgfSwKICAgIF0pOwogIH07CgogIHJldHVybiAoCiAgICA8U2Nyb2xsVmlldyBzdHlsZT17c3R5bGVzLnNjcmVlbn0gY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMuY29udGFpbmVyfSBzaG93c1ZlcnRpY2FsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMucHJvZmlsZVNlY3Rpb259PgogICAgICAgIDxBdmF0YXIgbmFtZT17YCR7dXNlcj8uZmlyc3ROYW1lID8/ICcnfSAke3VzZXI/Lmxhc3ROYW1lID8/ICcnfWB9IHVyaT17dXNlcj8uYXZhdGFyfSBzaXplPSJ4bCIgc3R5bGU9e3N0eWxlcy5hdmF0YXJ9IC8+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5uYW1lfT57dXNlcj8uZmlyc3ROYW1lfSB7dXNlcj8ubGFzdE5hbWV9PC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZW1haWx9Pnt1c2VyPy5lbWFpbH08L1RleHQ+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5yb2xlQmFkZ2V9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5yb2xlQmFkZ2VUZXh0fT7wn5qaIFRyYW5zcG9ydGV1cjwvVGV4dD4KICAgICAgICA8L1ZpZXc+CiAgICAgIDwvVmlldz4KCiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuc3RhdHNSb3d9PgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuc3RhdEl0ZW19PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zdGF0VmFsdWV9PuKAlDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdExhYmVsfT5MaXZyYWlzb25zPC9UZXh0PgogICAgICAgIDwvVmlldz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0YXREaXZpZGVyfSAvPgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuc3RhdEl0ZW19PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zdGF0VmFsdWV9PuKAlDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdExhYmVsfT5Ob3RlPC9UZXh0PgogICAgICAgIDwvVmlldz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN0YXREaXZpZGVyfSAvPgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuc3RhdEl0ZW19PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zdGF0VmFsdWV9PuKAlDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3RhdExhYmVsfT5SZXZlbnVzPC9UZXh0PgogICAgICAgIDwvVmlldz4KICAgICAgPC9WaWV3PgoKICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zZWN0aW9uVGl0bGV9Pk1vbiBjb21wdGU8L1RleHQ+CiAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMubWVudUNhcmR9IHBhZGRpbmc9Im5vbmUiPgogICAgICAgIDxNZW51SXRlbSBlbW9qaT0i8J+RpCIgbGFiZWw9Ik1vZGlmaWVyIG1vbiBwcm9maWwiIG9uUHJlc3M9eygpID0+IHt9fSAvPgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMubWVudVNlcGFyYXRvcn0gLz4KICAgICAgICA8TWVudUl0ZW0gZW1vamk9IvCfmpoiIGxhYmVsPSJNZXMgdsOpaGljdWxlcyIgb25QcmVzcz17KCkgPT4ge319IC8+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5tZW51U2VwYXJhdG9yfSAvPgogICAgICAgIDxNZW51SXRlbSBlbW9qaT0i8J+ThCIgbGFiZWw9Ik1lcyBkb2N1bWVudHMiIG9uUHJlc3M9eygpID0+IHt9fSAvPgogICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMubWVudVNlcGFyYXRvcn0gLz4KICAgICAgICA8TWVudUl0ZW0gZW1vamk9IvCflJQiIGxhYmVsPSJOb3RpZmljYXRpb25zIiBvblByZXNzPXsoKSA9PiB7fX0gLz4KICAgICAgPC9DYXJkPgoKICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zZWN0aW9uVGl0bGV9PlBhaWVtZW50czwvVGV4dD4KICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5tZW51Q2FyZH0gcGFkZGluZz0ibm9uZSI+CiAgICAgICAgPE1lbnVJdGVtIGVtb2ppPSLwn4+mIiBsYWJlbD0iQ29tcHRlIGJhbmNhaXJlIiBvblByZXNzPXsoKSA9PiB7fX0gLz4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLm1lbnVTZXBhcmF0b3J9IC8+CiAgICAgICAgPE1lbnVJdGVtIGVtb2ppPSLwn5OKIiBsYWJlbD0iSGlzdG9yaXF1ZSBkZXMgcGFpZW1lbnRzIiBvblByZXNzPXsoKSA9PiB7fX0gLz4KICAgICAgPC9DYXJkPgoKICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zZWN0aW9uVGl0bGV9PkluZm9ybWF0aW9uczwvVGV4dD4KICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5tZW51Q2FyZH0gcGFkZGluZz0ibm9uZSI+CiAgICAgICAgPE1lbnVJdGVtIGVtb2ppPSLinZMiIGxhYmVsPSJBaWRlICYgU3VwcG9ydCIgb25QcmVzcz17KCkgPT4ge319IC8+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5tZW51U2VwYXJhdG9yfSAvPgogICAgICAgIDxNZW51SXRlbSBlbW9qaT0i8J+ThCIgbGFiZWw9IkNvbmRpdGlvbnMgdHJhbnNwb3J0ZXVyIiBvblByZXNzPXsoKSA9PiB7fX0gLz4KICAgICAgPC9DYXJkPgoKICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5tZW51Q2FyZH0gcGFkZGluZz0ibm9uZSI+CiAgICAgICAgPE1lbnVJdGVtIGVtb2ppPSLwn5qqIiBsYWJlbD0iU2UgZMOpY29ubmVjdGVyIiBvblByZXNzPXtoYW5kbGVMb2dvdXR9IGRhbmdlciAvPgogICAgICA8L0NhcmQ+CgogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnZlcnNpb259PkpPJ0RSSVZFIHYxLjAuMCDigKIgR3V5YW5lIPCfjL88L1RleHQ+CiAgICA8L1Njcm9sbFZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIHNjcmVlbjogeyBmbGV4OiAxLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CQUNLR1JPVU5EIH0sCiAgY29udGFpbmVyOiB7IHBhZGRpbmdCb3R0b206IDYwIH0sCiAgcHJvZmlsZVNlY3Rpb246IHsgYWxpZ25JdGVtczogJ2NlbnRlcicsIHBhZGRpbmdUb3A6IDYwLCBwYWRkaW5nQm90dG9tOiAyNCwgcGFkZGluZ0hvcml6b250YWw6IDIwIH0sCiAgYXZhdGFyOiB7IG1hcmdpbkJvdHRvbTogMTYgfSwKICBuYW1lOiB7IGZvbnRTaXplOiAyMiwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIGVtYWlsOiB7IGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luVG9wOiA0LCBtYXJnaW5Cb3R0b206IDEyIH0sCiAgcm9sZUJhZGdlOiB7IGJhY2tncm91bmRDb2xvcjogJ3JnYmEoMzQsMTk3LDk0LDAuMTIpJywgcGFkZGluZ0hvcml6b250YWw6IDE0LCBwYWRkaW5nVmVydGljYWw6IDUsIGJvcmRlclJhZGl1czogOTk5IH0sCiAgcm9sZUJhZGdlVGV4dDogeyBjb2xvcjogQ29sb3JzLlNVQ0NFU1MsIGZvbnRXZWlnaHQ6ICc3MDAnLCBmb250U2l6ZTogMTMgfSwKICBzdGF0c1JvdzogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VSRkFDRSwgbWFyZ2luSG9yaXpvbnRhbDogMjAsIGJvcmRlclJhZGl1czogMTYsIHBhZGRpbmc6IDIwLCBtYXJnaW5Cb3R0b206IDI4LCBib3JkZXJXaWR0aDogMSwgYm9yZGVyQ29sb3I6IENvbG9ycy5CT1JERVIgfSwKICBzdGF0SXRlbTogeyBmbGV4OiAxLCBhbGlnbkl0ZW1zOiAnY2VudGVyJyB9LAogIHN0YXRWYWx1ZTogeyBmb250U2l6ZTogMjAsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQsIG1hcmdpbkJvdHRvbTogNCB9LAogIHN0YXRMYWJlbDogeyBmb250U2l6ZTogMTIsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlkgfSwKICBzdGF0RGl2aWRlcjogeyB3aWR0aDogMSwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQk9SREVSIH0sCiAgc2VjdGlvblRpdGxlOiB7IGZvbnRTaXplOiAxNCwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIHRleHRUcmFuc2Zvcm06ICd1cHBlcmNhc2UnLCBsZXR0ZXJTcGFjaW5nOiAxLCBwYWRkaW5nSG9yaXpvbnRhbDogMjAsIG1hcmdpbkJvdHRvbTogMTAsIG1hcmdpblRvcDogOCB9LAogIG1lbnVDYXJkOiB7IG1hcmdpbkhvcml6b250YWw6IDIwLCBtYXJnaW5Cb3R0b206IDE2IH0sCiAgbWVudUl0ZW06IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBwYWRkaW5nVmVydGljYWw6IDE2LCBwYWRkaW5nSG9yaXpvbnRhbDogMTYsIGdhcDogMTQgfSwKICBtZW51RW1vamk6IHsgZm9udFNpemU6IDIwIH0sCiAgbWVudUxhYmVsOiB7IGZsZXg6IDEsIGZvbnRTaXplOiAxNSwgY29sb3I6IENvbG9ycy5URVhULCBmb250V2VpZ2h0OiAnNTAwJyB9LAogIG1lbnVMYWJlbERhbmdlcjogeyBjb2xvcjogQ29sb3JzLkVSUk9SIH0sCiAgbWVudUFycm93OiB7IGZvbnRTaXplOiAyMCwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSB9LAogIG1lbnVTZXBhcmF0b3I6IHsgaGVpZ2h0OiAxLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIsIG1hcmdpbkxlZnQ6IDU0IH0sCiAgdmVyc2lvbjogeyB0ZXh0QWxpZ246ICdjZW50ZXInLCBmb250U2l6ZTogMTIsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIG1hcmdpblRvcDogOCB9LAp9KTsK" | base64 -d > 'mobile/app/(transporteur)/profil.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZVN0YXRlIH0gZnJvbSAncmVhY3QnOwppbXBvcnQgeyBTY3JvbGxWaWV3LCBTdHlsZVNoZWV0LCBUZXh0LCBUb3VjaGFibGVPcGFjaXR5LCBWaWV3IH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgQ29sb3JzIH0gZnJvbSAnLi4vLi4vY29uc3RhbnRzL2NvbG9ycyc7CmltcG9ydCB7IENhcmQgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0NhcmQnOwoKdHlwZSBQZXJpb2QgPSAnd2VlaycgfCAnbW9udGgnIHwgJ3llYXInOwoKZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gUmV2ZW51c1NjcmVlbigpIHsKICBjb25zdCBbcGVyaW9kLCBzZXRQZXJpb2RdID0gdXNlU3RhdGU8UGVyaW9kPignbW9udGgnKTsKCiAgY29uc3QgcGVyaW9kTGFiZWxzOiBSZWNvcmQ8UGVyaW9kLCBzdHJpbmc+ID0gewogICAgd2VlazogJ0NldHRlIHNlbWFpbmUnLAogICAgbW9udGg6ICdDZSBtb2lzJywKICAgIHllYXI6ICdDZXR0ZSBhbm7DqWUnLAogIH07CgogIHJldHVybiAoCiAgICA8U2Nyb2xsVmlldyBzdHlsZT17c3R5bGVzLnNjcmVlbn0gY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMuY29udGFpbmVyfSBzaG93c1ZlcnRpY2FsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0+CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMudGl0bGV9Pk1lcyByZXZlbnVzPC9UZXh0PgoKICAgICAgey8qIFBlcmlvZCBTZWxlY3RvciAqL30KICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5wZXJpb2RTZWxlY3Rvcn0+CiAgICAgICAgeyhbJ3dlZWsnLCAnbW9udGgnLCAneWVhciddIGFzIFBlcmlvZFtdKS5tYXAoKHApID0+ICgKICAgICAgICAgIDxUb3VjaGFibGVPcGFjaXR5CiAgICAgICAgICAgIGtleT17cH0KICAgICAgICAgICAgc3R5bGU9e1tzdHlsZXMucGVyaW9kQnRuLCBwZXJpb2QgPT09IHAgJiYgc3R5bGVzLnBlcmlvZEJ0bkFjdGl2ZV19CiAgICAgICAgICAgIG9uUHJlc3M9eygpID0+IHNldFBlcmlvZChwKX0KICAgICAgICAgID4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMucGVyaW9kQnRuVGV4dCwgcGVyaW9kID09PSBwICYmIHN0eWxlcy5wZXJpb2RCdG5UZXh0QWN0aXZlXX0+CiAgICAgICAgICAgICAge3BlcmlvZExhYmVsc1twXX0KICAgICAgICAgICAgPC9UZXh0PgogICAgICAgICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICAgICAgICkpfQogICAgICA8L1ZpZXc+CgogICAgICB7LyogQmlnIFJldmVudWUgTnVtYmVyICovfQogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLmhlcm9DYXJkfSBlbGV2YXRlZD4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmhlcm9MYWJlbH0+e3BlcmlvZExhYmVsc1twZXJpb2RdfTwvVGV4dD4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmhlcm9BbW91bnR9PjAsMDAg4oKsPC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuaGVyb0RlbHRhfT5BdWN1bmUgZG9ubsOpZSBkaXNwb25pYmxlPC9UZXh0PgogICAgICA8L0NhcmQ+CgogICAgICB7LyogQnJlYWtkb3duICovfQogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmJyZWFrZG93bkdyaWR9PgogICAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMuYnJlYWtkb3duQ2FyZH0+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmJyZWFrZG93bkVtb2ppfT7wn5qAPC9UZXh0PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5icmVha2Rvd25WYWx1ZX0+MDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYnJlYWtkb3duTGFiZWx9Pk1pc3Npb25zPC9UZXh0PgogICAgICAgIDwvQ2FyZD4KICAgICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLmJyZWFrZG93bkNhcmR9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5icmVha2Rvd25FbW9qaX0+8J+SszwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYnJlYWtkb3duVmFsdWV9PjAsMDAg4oKsPC9UZXh0PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5icmVha2Rvd25MYWJlbH0+Q29tbWlzc2lvbjwvVGV4dD4KICAgICAgICA8L0NhcmQ+CiAgICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5icmVha2Rvd25DYXJkfT4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYnJlYWtkb3duRW1vaml9PuKtkDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYnJlYWtkb3duVmFsdWV9PuKAlDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYnJlYWtkb3duTGFiZWx9Pk5vdGUgbW95LjwvVGV4dD4KICAgICAgICA8L0NhcmQ+CiAgICAgIDwvVmlldz4KCiAgICAgIHsvKiBUcmFuc2FjdGlvbnMgKi99CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VjdGlvblRpdGxlfT5UcmFuc2FjdGlvbnM8L1RleHQ+CiAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMuZW1wdHlDYXJkfT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmVtcHR5RW1vaml9PvCfkrg8L1RleHQ+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5lbXB0eVRpdGxlfT5BdWN1bmUgdHJhbnNhY3Rpb248L1RleHQ+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5lbXB0eVRleHR9PlZvcyBwYWllbWVudHMgYXBwYXJhw650cm9udCBpY2kgYXByw6hzIGNoYXF1ZSBsaXZyYWlzb24gdGVybWluw6llLjwvVGV4dD4KICAgICAgPC9DYXJkPgoKICAgICAgey8qIFdpdGhkcmF3YWwgKi99CiAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMud2l0aGRyYXdDYXJkfT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLndpdGhkcmF3VGl0bGV9PlJldGlyZXIgbWVzIGZvbmRzPC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMud2l0aGRyYXdUZXh0fT4KICAgICAgICAgIExlcyBmb25kcyBzb250IGF1dG9tYXRpcXVlbWVudCB2aXLDqXMgc3VyIHZvdHJlIGNvbXB0ZSBiYW5jYWlyZSBjaGFxdWUgbHVuZGkuCiAgICAgICAgPC9UZXh0PgogICAgICA8L0NhcmQ+CiAgICA8L1Njcm9sbFZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIHNjcmVlbjogeyBmbGV4OiAxLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CQUNLR1JPVU5EIH0sCiAgY29udGFpbmVyOiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ1RvcDogNjAsIHBhZGRpbmdCb3R0b206IDQwIH0sCiAgdGl0bGU6IHsgZm9udFNpemU6IDI2LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDIwIH0sCiAgcGVyaW9kU2VsZWN0b3I6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsIGJvcmRlclJhZGl1czogMTIsIHBhZGRpbmc6IDQsIG1hcmdpbkJvdHRvbTogMjAgfSwKICBwZXJpb2RCdG46IHsgZmxleDogMSwgcGFkZGluZ1ZlcnRpY2FsOiA4LCBib3JkZXJSYWRpdXM6IDEwLCBhbGlnbkl0ZW1zOiAnY2VudGVyJyB9LAogIHBlcmlvZEJ0bkFjdGl2ZTogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgcGVyaW9kQnRuVGV4dDogeyBmb250U2l6ZTogMTMsIGZvbnRXZWlnaHQ6ICc2MDAnLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCiAgcGVyaW9kQnRuVGV4dEFjdGl2ZTogeyBjb2xvcjogQ29sb3JzLldISVRFIH0sCiAgaGVyb0NhcmQ6IHsgYWxpZ25JdGVtczogJ2NlbnRlcicsIHBhZGRpbmdWZXJ0aWNhbDogMzIsIG1hcmdpbkJvdHRvbTogMTYgfSwKICBoZXJvTGFiZWw6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBtYXJnaW5Cb3R0b206IDggfSwKICBoZXJvQW1vdW50OiB7IGZvbnRTaXplOiA0OCwgZm9udFdlaWdodDogJzkwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbGV0dGVyU3BhY2luZzogLTEgfSwKICBoZXJvRGVsdGE6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBtYXJnaW5Ub3A6IDggfSwKICBicmVha2Rvd25HcmlkOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBnYXA6IDEwLCBtYXJnaW5Cb3R0b206IDI4IH0sCiAgYnJlYWtkb3duQ2FyZDogeyBmbGV4OiAxLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ1ZlcnRpY2FsOiAxNiwgZ2FwOiA2IH0sCiAgYnJlYWtkb3duRW1vamk6IHsgZm9udFNpemU6IDIyIH0sCiAgYnJlYWtkb3duVmFsdWU6IHsgZm9udFNpemU6IDE2LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCiAgYnJlYWtkb3duTGFiZWw6IHsgZm9udFNpemU6IDExLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCB0ZXh0QWxpZ246ICdjZW50ZXInIH0sCiAgc2VjdGlvblRpdGxlOiB7IGZvbnRTaXplOiAxNywgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiAxNCB9LAogIGVtcHR5Q2FyZDogeyBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ1ZlcnRpY2FsOiAzMiwgbWFyZ2luQm90dG9tOiAxNiB9LAogIGVtcHR5RW1vamk6IHsgZm9udFNpemU6IDM2LCBtYXJnaW5Cb3R0b206IDEwIH0sCiAgZW1wdHlUaXRsZTogeyBmb250U2l6ZTogMTYsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQsIG1hcmdpbkJvdHRvbTogNiB9LAogIGVtcHR5VGV4dDogeyBmb250U2l6ZTogMTMsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIHRleHRBbGlnbjogJ2NlbnRlcicsIGxpbmVIZWlnaHQ6IDE4IH0sCiAgd2l0aGRyYXdDYXJkOiB7IGJhY2tncm91bmRDb2xvcjogJ3JnYmEoMzQsMTk3LDk0LDAuMDgpJywgYm9yZGVyQ29sb3I6ICdyZ2JhKDM0LDE5Nyw5NCwwLjMpJywgYm9yZGVyV2lkdGg6IDEuNSwgYm9yZGVyUmFkaXVzOiAxNiwgcGFkZGluZzogMTYgfSwKICB3aXRoZHJhd1RpdGxlOiB7IGZvbnRTaXplOiAxNSwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuU1VDQ0VTUywgbWFyZ2luQm90dG9tOiA2IH0sCiAgd2l0aGRyYXdUZXh0OiB7IGZvbnRTaXplOiAxMywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbGluZUhlaWdodDogMTggfSwKfSk7Cg==" | base64 -d > 'mobile/app/(transporteur)/revenus.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZVN0YXRlIH0gZnJvbSAncmVhY3QnOwppbXBvcnQgewogIEFsZXJ0LAogIEZsYXRMaXN0LAogIE1vZGFsLAogIFNjcm9sbFZpZXcsCiAgU3R5bGVTaGVldCwKICBUZXh0LAogIFRvdWNoYWJsZU9wYWNpdHksCiAgVmlldywKfSBmcm9tICdyZWFjdC1uYXRpdmUnOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgVmVoaWNsZSwgVmVoaWNsZVR5cGUgfSBmcm9tICcuLi8uLi90eXBlcyc7CmltcG9ydCB7IENhcmQgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0NhcmQnOwppbXBvcnQgeyBCdXR0b24gfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0J1dHRvbic7CmltcG9ydCB7IElucHV0IH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy91aS9JbnB1dCc7Cgpjb25zdCBWRUhJQ0xFX0lDT05TOiBSZWNvcmQ8VmVoaWNsZVR5cGUsIHN0cmluZz4gPSB7CiAgVVRJTElUQUlSRTogJ/CfmpAnLAogIEZPVVJHT046ICfwn5qaJywKICBDQU1JT046ICfwn4+X77iPJywKfTsKCmNvbnN0IFZFSElDTEVfTEFCRUxTOiBSZWNvcmQ8VmVoaWNsZVR5cGUsIHN0cmluZz4gPSB7CiAgVVRJTElUQUlSRTogJ1V0aWxpdGFpcmUnLAogIEZPVVJHT046ICdGb3VyZ29uJywKICBDQU1JT046ICdDYW1pb24nLAp9OwoKZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gVmVoaWN1bGVzU2NyZWVuKCkgewogIGNvbnN0IFt2ZWhpY2xlcywgc2V0VmVoaWNsZXNdID0gdXNlU3RhdGU8VmVoaWNsZVtdPihbXSk7CiAgY29uc3QgW3Nob3dNb2RhbCwgc2V0U2hvd01vZGFsXSA9IHVzZVN0YXRlKGZhbHNlKTsKICBjb25zdCBbZm9ybSwgc2V0Rm9ybV0gPSB1c2VTdGF0ZSh7CiAgICB0eXBlOiAnVVRJTElUQUlSRScgYXMgVmVoaWNsZVR5cGUsCiAgICBicmFuZDogJycsCiAgICBtb2RlbDogJycsCiAgICBsaWNlbnNlUGxhdGU6ICcnLAogICAgeWVhcjogJycsCiAgICBtYXhXZWlnaHQ6ICcnLAogICAgdm9sdW1lOiAnJywKICB9KTsKCiAgY29uc3QgaGFuZGxlQWRkID0gKCkgPT4gewogICAgaWYgKCFmb3JtLmJyYW5kIHx8ICFmb3JtLm1vZGVsIHx8ICFmb3JtLmxpY2Vuc2VQbGF0ZSkgewogICAgICBBbGVydC5hbGVydCgnQ2hhbXBzIHJlcXVpcycsICdSZW5zZWlnbmV6IGxhIG1hcnF1ZSwgbGUgbW9kw6hsZSBldCBsYSBwbGFxdWUuJyk7CiAgICAgIHJldHVybjsKICAgIH0KICAgIGNvbnN0IG5ld1ZlaGljbGU6IFZlaGljbGUgPSB7CiAgICAgIGlkOiBEYXRlLm5vdygpLnRvU3RyaW5nKCksCiAgICAgIHRyYW5zcG9ydGV1cklkOiAnJywKICAgICAgdHlwZTogZm9ybS50eXBlLAogICAgICBicmFuZDogZm9ybS5icmFuZCwKICAgICAgbW9kZWw6IGZvcm0ubW9kZWwsCiAgICAgIGxpY2Vuc2VQbGF0ZTogZm9ybS5saWNlbnNlUGxhdGUudG9VcHBlckNhc2UoKSwKICAgICAgeWVhcjogcGFyc2VJbnQoZm9ybS55ZWFyKSB8fCBuZXcgRGF0ZSgpLmdldEZ1bGxZZWFyKCksCiAgICAgIG1heFdlaWdodDogcGFyc2VGbG9hdChmb3JtLm1heFdlaWdodCkgfHwgMCwKICAgICAgdm9sdW1lOiBwYXJzZUZsb2F0KGZvcm0udm9sdW1lKSB8fCAwLAogICAgICBwaG90b3M6IFtdLAogICAgICBpc0FjdGl2ZTogdHJ1ZSwKICAgICAgY3JlYXRlZEF0OiBuZXcgRGF0ZSgpLnRvSVNPU3RyaW5nKCksCiAgICB9OwogICAgc2V0VmVoaWNsZXMoKHByZXYpID0+IFsuLi5wcmV2LCBuZXdWZWhpY2xlXSk7CiAgICBzZXRTaG93TW9kYWwoZmFsc2UpOwogICAgc2V0Rm9ybSh7IHR5cGU6ICdVVElMSVRBSVJFJywgYnJhbmQ6ICcnLCBtb2RlbDogJycsIGxpY2Vuc2VQbGF0ZTogJycsIHllYXI6ICcnLCBtYXhXZWlnaHQ6ICcnLCB2b2x1bWU6ICcnIH0pOwogIH07CgogIHJldHVybiAoCiAgICA8VmlldyBzdHlsZT17c3R5bGVzLnNjcmVlbn0+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaGVhZGVyU2VjdGlvbn0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy50aXRsZX0+TWVzIHbDqWhpY3VsZXM8L1RleHQ+CiAgICAgICAgPFRvdWNoYWJsZU9wYWNpdHkgc3R5bGU9e3N0eWxlcy5hZGRCdG59IG9uUHJlc3M9eygpID0+IHNldFNob3dNb2RhbCh0cnVlKX0+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmFkZEJ0blRleHR9PisgQWpvdXRlcjwvVGV4dD4KICAgICAgICA8L1RvdWNoYWJsZU9wYWNpdHk+CiAgICAgIDwvVmlldz4KCiAgICAgIHt2ZWhpY2xlcy5sZW5ndGggPT09IDAgPyAoCiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5lbXB0eUNvbnRhaW5lcn0+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmVtcHR5RW1vaml9PvCfmpc8L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmVtcHR5VGl0bGV9PkF1Y3VuIHbDqWhpY3VsZTwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZW1wdHlUZXh0fT5Bam91dGV6IHZvdHJlIHByZW1pZXIgdsOpaGljdWxlIHBvdXIgY29tbWVuY2VyIMOgIGFjY2VwdGVyIGRlcyBtaXNzaW9ucy48L1RleHQ+CiAgICAgICAgICA8QnV0dG9uIHRpdGxlPSIrIEFqb3V0ZXIgdW4gdsOpaGljdWxlIiBvblByZXNzPXsoKSA9PiBzZXRTaG93TW9kYWwodHJ1ZSl9IHN0eWxlPXtzdHlsZXMuZW1wdHlCdG59IC8+CiAgICAgICAgPC9WaWV3PgogICAgICApIDogKAogICAgICAgIDxGbGF0TGlzdAogICAgICAgICAgZGF0YT17dmVoaWNsZXN9CiAgICAgICAgICBrZXlFeHRyYWN0b3I9eyh2KSA9PiB2LmlkfQogICAgICAgICAgY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMubGlzdH0KICAgICAgICAgIHJlbmRlckl0ZW09eyh7IGl0ZW06IHYgfSkgPT4gKAogICAgICAgICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLnZlaGljbGVDYXJkfSBlbGV2YXRlZD4KICAgICAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnZlaGljbGVIZWFkZXJ9PgogICAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy52ZWhpY2xlSWNvbn0+e1ZFSElDTEVfSUNPTlNbdi50eXBlXX08L1RleHQ+CiAgICAgICAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmZsZXh9PgogICAgICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnZlaGljbGVOYW1lfT57di5icmFuZH0ge3YubW9kZWx9PC9UZXh0PgogICAgICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnZlaGljbGVUeXBlfT57VkVISUNMRV9MQUJFTFNbdi50eXBlXX0g4oCiIHt2LnllYXJ9PC9UZXh0PgogICAgICAgICAgICAgICAgPC9WaWV3PgogICAgICAgICAgICAgICAgPFZpZXcgc3R5bGU9e1tzdHlsZXMuc3RhdHVzRG90LCB2LmlzQWN0aXZlICYmIHN0eWxlcy5zdGF0dXNEb3RBY3RpdmVdfSAvPgogICAgICAgICAgICAgIDwvVmlldz4KICAgICAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnZlaGljbGVEZXRhaWxzfT4KICAgICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMucGxhdGVUYWd9Pnt2LmxpY2Vuc2VQbGF0ZX08L1RleHQ+CiAgICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmNhcGFjaXR5VGV4dH0+e3YubWF4V2VpZ2h0fSBrZyDigKIge3Yudm9sdW1lfSBtwrM8L1RleHQ+CiAgICAgICAgICAgICAgPC9WaWV3PgogICAgICAgICAgICA8L0NhcmQ+CiAgICAgICAgICApfQogICAgICAgICAgc2hvd3NWZXJ0aWNhbFNjcm9sbEluZGljYXRvcj17ZmFsc2V9CiAgICAgICAgLz4KICAgICAgKX0KCiAgICAgIHsvKiBBZGQgVmVoaWNsZSBNb2RhbCAqL30KICAgICAgPE1vZGFsIHZpc2libGU9e3Nob3dNb2RhbH0gYW5pbWF0aW9uVHlwZT0ic2xpZGUiIHByZXNlbnRhdGlvblN0eWxlPSJwYWdlU2hlZXQiPgogICAgICAgIDxTY3JvbGxWaWV3IHN0eWxlPXtzdHlsZXMubW9kYWx9IGNvbnRlbnRDb250YWluZXJTdHlsZT17c3R5bGVzLm1vZGFsQ29udGVudH0+CiAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLm1vZGFsSGVhZGVyfT4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5tb2RhbFRpdGxlfT5Ob3V2ZWF1IHbDqWhpY3VsZTwvVGV4dD4KICAgICAgICAgICAgPFRvdWNoYWJsZU9wYWNpdHkgb25QcmVzcz17KCkgPT4gc2V0U2hvd01vZGFsKGZhbHNlKX0+CiAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5tb2RhbENsb3NlfT7inJU8L1RleHQ+CiAgICAgICAgICAgIDwvVG91Y2hhYmxlT3BhY2l0eT4KICAgICAgICAgIDwvVmlldz4KCiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmZpZWxkTGFiZWx9PlR5cGUgZGUgdsOpaGljdWxlPC9UZXh0PgogICAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy50eXBlUm93fT4KICAgICAgICAgICAgeyhbJ1VUSUxJVEFJUkUnLCAnRk9VUkdPTicsICdDQU1JT04nXSBhcyBWZWhpY2xlVHlwZVtdKS5tYXAoKHQpID0+ICgKICAgICAgICAgICAgICA8VG91Y2hhYmxlT3BhY2l0eQogICAgICAgICAgICAgICAga2V5PXt0fQogICAgICAgICAgICAgICAgc3R5bGU9e1tzdHlsZXMudHlwZUJ0biwgZm9ybS50eXBlID09PSB0ICYmIHN0eWxlcy50eXBlQnRuQWN0aXZlXX0KICAgICAgICAgICAgICAgIG9uUHJlc3M9eygpID0+IHNldEZvcm0oKGYpID0+ICh7IC4uLmYsIHR5cGU6IHQgfSkpfQogICAgICAgICAgICAgID4KICAgICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMudHlwZUljb259PntWRUhJQ0xFX0lDT05TW3RdfTwvVGV4dD4KICAgICAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtbc3R5bGVzLnR5cGVMYWJlbCwgZm9ybS50eXBlID09PSB0ICYmIHN0eWxlcy50eXBlTGFiZWxBY3RpdmVdfT4KICAgICAgICAgICAgICAgICAge1ZFSElDTEVfTEFCRUxTW3RdfQogICAgICAgICAgICAgICAgPC9UZXh0PgogICAgICAgICAgICAgIDwvVG91Y2hhYmxlT3BhY2l0eT4KICAgICAgICAgICAgKSl9CiAgICAgICAgICA8L1ZpZXc+CgogICAgICAgICAgPElucHV0IGxhYmVsPSJNYXJxdWUiIHZhbHVlPXtmb3JtLmJyYW5kfSBvbkNoYW5nZVRleHQ9eyh2KSA9PiBzZXRGb3JtKChmKSA9PiAoeyAuLi5mLCBicmFuZDogdiB9KSl9IHBsYWNlaG9sZGVyPSJleDogUmVuYXVsdCIgLz4KICAgICAgICAgIDxJbnB1dCBsYWJlbD0iTW9kw6hsZSIgdmFsdWU9e2Zvcm0ubW9kZWx9IG9uQ2hhbmdlVGV4dD17KHYpID0+IHNldEZvcm0oKGYpID0+ICh7IC4uLmYsIG1vZGVsOiB2IH0pKX0gcGxhY2Vob2xkZXI9ImV4OiBNYXN0ZXIiIC8+CiAgICAgICAgICA8SW5wdXQgbGFiZWw9IkltbWF0cmljdWxhdGlvbiIgdmFsdWU9e2Zvcm0ubGljZW5zZVBsYXRlfSBvbkNoYW5nZVRleHQ9eyh2KSA9PiBzZXRGb3JtKChmKSA9PiAoeyAuLi5mLCBsaWNlbnNlUGxhdGU6IHYgfSkpfSBwbGFjZWhvbGRlcj0iZXg6IEFCLTEyMy1DRCIgYXV0b0NhcGl0YWxpemU9ImNoYXJhY3RlcnMiIC8+CiAgICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnJvd30+CiAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuZmxleH0+CiAgICAgICAgICAgICAgPElucHV0IGxhYmVsPSJBbm7DqWUiIHZhbHVlPXtmb3JtLnllYXJ9IG9uQ2hhbmdlVGV4dD17KHYpID0+IHNldEZvcm0oKGYpID0+ICh7IC4uLmYsIHllYXI6IHYgfSkpfSBwbGFjZWhvbGRlcj0iMjAyMyIga2V5Ym9hcmRUeXBlPSJudW1lcmljIiAvPgogICAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuZmxleH0+CiAgICAgICAgICAgICAgPElucHV0IGxhYmVsPSJQb2lkcyBtYXggKGtnKSIgdmFsdWU9e2Zvcm0ubWF4V2VpZ2h0fSBvbkNoYW5nZVRleHQ9eyh2KSA9PiBzZXRGb3JtKChmKSA9PiAoeyAuLi5mLCBtYXhXZWlnaHQ6IHYgfSkpfSBwbGFjZWhvbGRlcj0iZXg6IDEyMDAiIGtleWJvYXJkVHlwZT0iZGVjaW1hbC1wYWQiIC8+CiAgICAgICAgICAgIDwvVmlldz4KICAgICAgICAgIDwvVmlldz4KICAgICAgICAgIDxJbnB1dCBsYWJlbD0iVm9sdW1lIChtwrMpIiB2YWx1ZT17Zm9ybS52b2x1bWV9IG9uQ2hhbmdlVGV4dD17KHYpID0+IHNldEZvcm0oKGYpID0+ICh7IC4uLmYsIHZvbHVtZTogdiB9KSl9IHBsYWNlaG9sZGVyPSJleDogMTIiIGtleWJvYXJkVHlwZT0iZGVjaW1hbC1wYWQiIC8+CgogICAgICAgICAgPEJ1dHRvbiB0aXRsZT0iQWpvdXRlciBsZSB2w6loaWN1bGUiIG9uUHJlc3M9e2hhbmRsZUFkZH0gZnVsbFdpZHRoIHNpemU9ImxnIiAvPgogICAgICAgIDwvU2Nyb2xsVmlldz4KICAgICAgPC9Nb2RhbD4KICAgIDwvVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgc2NyZWVuOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQgfSwKICBmbGV4OiB7IGZsZXg6IDEgfSwKICBoZWFkZXJTZWN0aW9uOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBqdXN0aWZ5Q29udGVudDogJ3NwYWNlLWJldHdlZW4nLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ0hvcml6b250YWw6IDIwLCBwYWRkaW5nVG9wOiA2MCwgcGFkZGluZ0JvdHRvbTogMjAgfSwKICB0aXRsZTogeyBmb250U2l6ZTogMjYsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQgfSwKICBhZGRCdG46IHsgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuUFJJTUFSWSwgcGFkZGluZ0hvcml6b250YWw6IDE2LCBwYWRkaW5nVmVydGljYWw6IDgsIGJvcmRlclJhZGl1czogMTAgfSwKICBhZGRCdG5UZXh0OiB7IGNvbG9yOiBDb2xvcnMuV0hJVEUsIGZvbnRXZWlnaHQ6ICc3MDAnLCBmb250U2l6ZTogMTQgfSwKICBsaXN0OiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ0JvdHRvbTogNDAgfSwKICBlbXB0eUNvbnRhaW5lcjogeyBmbGV4OiAxLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywganVzdGlmeUNvbnRlbnQ6ICdjZW50ZXInLCBwYWRkaW5nOiA0MCB9LAogIGVtcHR5RW1vamk6IHsgZm9udFNpemU6IDU2LCBtYXJnaW5Cb3R0b206IDE2IH0sCiAgZW1wdHlUaXRsZTogeyBmb250U2l6ZTogMjAsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQsIG1hcmdpbkJvdHRvbTogOCB9LAogIGVtcHR5VGV4dDogeyBmb250U2l6ZTogMTQsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIHRleHRBbGlnbjogJ2NlbnRlcicsIGxpbmVIZWlnaHQ6IDIwLCBtYXJnaW5Cb3R0b206IDI0IH0sCiAgZW1wdHlCdG46IHt9LAogIHZlaGljbGVDYXJkOiB7IG1hcmdpbkJvdHRvbTogMTQgfSwKICB2ZWhpY2xlSGVhZGVyOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgZ2FwOiAxNCwgbWFyZ2luQm90dG9tOiAxMiB9LAogIHZlaGljbGVJY29uOiB7IGZvbnRTaXplOiAzMiB9LAogIHZlaGljbGVOYW1lOiB7IGZvbnRTaXplOiAxNiwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIHZlaGljbGVUeXBlOiB7IGZvbnRTaXplOiAxMywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luVG9wOiAyIH0sCiAgc3RhdHVzRG90OiB7IHdpZHRoOiAxMCwgaGVpZ2h0OiAxMCwgYm9yZGVyUmFkaXVzOiA1LCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIgfSwKICBzdGF0dXNEb3RBY3RpdmU6IHsgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VDQ0VTUyB9LAogIHZlaGljbGVEZXRhaWxzOiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBqdXN0aWZ5Q29udGVudDogJ3NwYWNlLWJldHdlZW4nLCBhbGlnbkl0ZW1zOiAnY2VudGVyJyB9LAogIHBsYXRlVGFnOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJPUkRFUiwgcGFkZGluZ0hvcml6b250YWw6IDEyLCBwYWRkaW5nVmVydGljYWw6IDQsIGJvcmRlclJhZGl1czogNiwgZm9udFNpemU6IDEzLCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCiAgY2FwYWNpdHlUZXh0OiB7IGZvbnRTaXplOiAxMywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSB9LAogIG1vZGFsOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQgfSwKICBtb2RhbENvbnRlbnQ6IHsgcGFkZGluZzogMjQgfSwKICBtb2RhbEhlYWRlcjogeyBmbGV4RGlyZWN0aW9uOiAncm93JywganVzdGlmeUNvbnRlbnQ6ICdzcGFjZS1iZXR3ZWVuJywgYWxpZ25JdGVtczogJ2NlbnRlcicsIG1hcmdpbkJvdHRvbTogMjQsIHBhZGRpbmdUb3A6IDIwIH0sCiAgbW9kYWxUaXRsZTogeyBmb250U2l6ZTogMjIsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQgfSwKICBtb2RhbENsb3NlOiB7IGZvbnRTaXplOiAyMCwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSB9LAogIGZpZWxkTGFiZWw6IHsgZm9udFNpemU6IDEzLCBmb250V2VpZ2h0OiAnNjAwJywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgdGV4dFRyYW5zZm9ybTogJ3VwcGVyY2FzZScsIGxldHRlclNwYWNpbmc6IDAuNSwgbWFyZ2luQm90dG9tOiAxMCB9LAogIHR5cGVSb3c6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGdhcDogMTAsIG1hcmdpbkJvdHRvbTogMjQgfSwKICB0eXBlQnRuOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsIGJvcmRlclJhZGl1czogMTIsIHBhZGRpbmc6IDEyLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgYm9yZGVyV2lkdGg6IDEuNSwgYm9yZGVyQ29sb3I6IENvbG9ycy5CT1JERVIsIGdhcDogNiB9LAogIHR5cGVCdG5BY3RpdmU6IHsgYm9yZGVyQ29sb3I6IENvbG9ycy5QUklNQVJZLCBiYWNrZ3JvdW5kQ29sb3I6ICdyZ2JhKDIyNyw2LDE5LDAuMDYpJyB9LAogIHR5cGVJY29uOiB7IGZvbnRTaXplOiAyNCB9LAogIHR5cGVMYWJlbDogeyBmb250U2l6ZTogMTIsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIGZvbnRXZWlnaHQ6ICc2MDAnIH0sCiAgdHlwZUxhYmVsQWN0aXZlOiB7IGNvbG9yOiBDb2xvcnMuUFJJTUFSWSB9LAogIHJvdzogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgZ2FwOiAxMiB9LAp9KTsK" | base64 -d > 'mobile/app/(transporteur)/vehicules.tsx'
echo "aW1wb3J0IFJlYWN0IGZyb20gJ3JlYWN0JzsKaW1wb3J0IHsgU2Nyb2xsVmlldywgU3R5bGVTaGVldCwgVGV4dCwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwppbXBvcnQgeyBDYXJkIH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy91aS9DYXJkJzsKCmludGVyZmFjZSBLcGlDYXJkUHJvcHMgewogIGVtb2ppOiBzdHJpbmc7CiAgbGFiZWw6IHN0cmluZzsKICB2YWx1ZTogc3RyaW5nOwogIGRlbHRhPzogc3RyaW5nOwogIGRlbHRhVXA/OiBib29sZWFuOwp9CgpmdW5jdGlvbiBLcGlDYXJkKHsgZW1vamksIGxhYmVsLCB2YWx1ZSwgZGVsdGEsIGRlbHRhVXAgfTogS3BpQ2FyZFByb3BzKSB7CiAgcmV0dXJuICgKICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMua3BpQ2FyZH0gZWxldmF0ZWQ+CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMua3BpRW1vaml9PntlbW9qaX08L1RleHQ+CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMua3BpVmFsdWV9Pnt2YWx1ZX08L1RleHQ+CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMua3BpTGFiZWx9PntsYWJlbH08L1RleHQ+CiAgICAgIHtkZWx0YSAmJiAoCiAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMua3BpRGVsdGEsIGRlbHRhVXAgPyBzdHlsZXMua3BpRGVsdGFVcCA6IHN0eWxlcy5rcGlEZWx0YURvd25dfT4KICAgICAgICAgIHtkZWx0YVVwID8gJ+KGkScgOiAn4oaTJ30ge2RlbHRhfQogICAgICAgIDwvVGV4dD4KICAgICAgKX0KICAgIDwvQ2FyZD4KICApOwp9CgpleHBvcnQgZGVmYXVsdCBmdW5jdGlvbiBBZG1pbkRhc2hib2FyZCgpIHsKICByZXR1cm4gKAogICAgPFNjcm9sbFZpZXcgc3R5bGU9e3N0eWxlcy5zY3JlZW59IGNvbnRlbnRDb250YWluZXJTdHlsZT17c3R5bGVzLmNvbnRhaW5lcn0gc2hvd3NWZXJ0aWNhbFNjcm9sbEluZGljYXRvcj17ZmFsc2V9PgogICAgICB7LyogSGVhZGVyICovfQogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmhlYWRlcn0+CiAgICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5sb2dvUm93fT4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMubG9nb1JlZH0+Sk88L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmxvZ29XaGl0ZX0+J0RSSVZFPC9UZXh0PgogICAgICAgIDwvVmlldz4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmFkbWluTGFiZWx9PkFkbWluaXN0cmF0aW9uPC9UZXh0PgogICAgICA8L1ZpZXc+CgogICAgICB7LyogS1BJcyAqL30KICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zZWN0aW9uVGl0bGV9PlZ1ZSBkJ2Vuc2VtYmxlPC9UZXh0PgogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmtwaUdyaWR9PgogICAgICAgIDxLcGlDYXJkIGVtb2ppPSLwn5GlIiBsYWJlbD0iVXRpbGlzYXRldXJzIiB2YWx1ZT0i4oCUIiAvPgogICAgICAgIDxLcGlDYXJkIGVtb2ppPSLwn5OmIiBsYWJlbD0iTWlzc2lvbnMiIHZhbHVlPSLigJQiIC8+CiAgICAgICAgPEtwaUNhcmQgZW1vamk9IvCfkrAiIGxhYmVsPSJSZXZlbnVzIiB2YWx1ZT0i4oCUIiAvPgogICAgICAgIDxLcGlDYXJkIGVtb2ppPSLwn5qaIiBsYWJlbD0iVHJhbnNwb3J0ZXVycyIgdmFsdWU9IuKAlCIgLz4KICAgICAgPC9WaWV3PgoKICAgICAgey8qIEFsZXJ0cyAqL30KICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zZWN0aW9uVGl0bGV9PkFsZXJ0ZXM8L1RleHQ+CiAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMuYWxlcnRDYXJkfT4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmFsZXJ0RW1vaml9PuKchTwvVGV4dD4KICAgICAgICA8Vmlldz4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYWxlcnRUaXRsZX0+U3lzdMOobWUgb3DDqXJhdGlvbm5lbDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuYWxlcnRUZXh0fT5Ub3VzIGxlcyBzZXJ2aWNlcyBmb25jdGlvbm5lbnQgbm9ybWFsZW1lbnQuPC9UZXh0PgogICAgICAgIDwvVmlldz4KICAgICAgPC9DYXJkPgoKICAgICAgey8qIFF1aWNrIEFjdGlvbnMgKi99CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VjdGlvblRpdGxlfT5BY3Rpb25zIHJhcGlkZXM8L1RleHQ+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuYWN0aW9uc0dyaWR9PgogICAgICAgIHtbCiAgICAgICAgICB7IGVtb2ppOiAn8J+TiicsIGxhYmVsOiAnRXhwb3J0ZXIgcmFwcG9ydCcgfSwKICAgICAgICAgIHsgZW1vamk6ICfwn5SUJywgbGFiZWw6ICdFbnZveWVyIG5vdGlmaWNhdGlvbicgfSwKICAgICAgICAgIHsgZW1vamk6ICfwn5KzJywgbGFiZWw6ICdHZXN0aW9uIGNvbW1pc3Npb25zJyB9LAogICAgICAgICAgeyBlbW9qaTogJ/Cfm6HvuI8nLCBsYWJlbDogJ01vZMOpcmF0aW9uJyB9LAogICAgICAgIF0ubWFwKChhY3Rpb24pID0+ICgKICAgICAgICAgIDxDYXJkIGtleT17YWN0aW9uLmxhYmVsfSBzdHlsZT17c3R5bGVzLmFjdGlvbkNhcmR9PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmFjdGlvbkVtb2ppfT57YWN0aW9uLmVtb2ppfTwvVGV4dD4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5hY3Rpb25MYWJlbH0+e2FjdGlvbi5sYWJlbH08L1RleHQ+CiAgICAgICAgICA8L0NhcmQ+CiAgICAgICAgKSl9CiAgICAgIDwvVmlldz4KICAgIDwvU2Nyb2xsVmlldz4KICApOwp9Cgpjb25zdCBzdHlsZXMgPSBTdHlsZVNoZWV0LmNyZWF0ZSh7CiAgc2NyZWVuOiB7IGZsZXg6IDEsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLkJBQ0tHUk9VTkQgfSwKICBjb250YWluZXI6IHsgcGFkZGluZ0hvcml6b250YWw6IDIwLCBwYWRkaW5nVG9wOiA2MCwgcGFkZGluZ0JvdHRvbTogNDAgfSwKICBoZWFkZXI6IHsgbWFyZ2luQm90dG9tOiAyOCB9LAogIGxvZ29Sb3c6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGFsaWduSXRlbXM6ICdiYXNlbGluZScsIG1hcmdpbkJvdHRvbTogNCB9LAogIGxvZ29SZWQ6IHsgZm9udFNpemU6IDI4LCBmb250V2VpZ2h0OiAnOTAwJywgY29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgbG9nb1doaXRlOiB7IGZvbnRTaXplOiAyOCwgZm9udFdlaWdodDogJzkwMCcsIGNvbG9yOiBDb2xvcnMuV0hJVEUgfSwKICBhZG1pbkxhYmVsOiB7IGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgZm9udFdlaWdodDogJzYwMCcsIHRleHRUcmFuc2Zvcm06ICd1cHBlcmNhc2UnLCBsZXR0ZXJTcGFjaW5nOiAxLjUgfSwKICBzZWN0aW9uVGl0bGU6IHsgZm9udFNpemU6IDE2LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDE0IH0sCiAga3BpR3JpZDogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgZmxleFdyYXA6ICd3cmFwJywgZ2FwOiAxMiwgbWFyZ2luQm90dG9tOiAyOCB9LAogIGtwaUNhcmQ6IHsgd2lkdGg6ICc0NyUnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ1ZlcnRpY2FsOiAyMCwgZ2FwOiA0IH0sCiAga3BpRW1vamk6IHsgZm9udFNpemU6IDI2LCBtYXJnaW5Cb3R0b206IDQgfSwKICBrcGlWYWx1ZTogeyBmb250U2l6ZTogMjQsIGZvbnRXZWlnaHQ6ICc4MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQgfSwKICBrcGlMYWJlbDogeyBmb250U2l6ZTogMTIsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIHRleHRBbGlnbjogJ2NlbnRlcicgfSwKICBrcGlEZWx0YTogeyBmb250U2l6ZTogMTIsIGZvbnRXZWlnaHQ6ICc2MDAnIH0sCiAga3BpRGVsdGFVcDogeyBjb2xvcjogQ29sb3JzLlNVQ0NFU1MgfSwKICBrcGlEZWx0YURvd246IHsgY29sb3I6IENvbG9ycy5FUlJPUiB9LAogIGFsZXJ0Q2FyZDogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgYWxpZ25JdGVtczogJ2NlbnRlcicsIGdhcDogMTQsIG1hcmdpbkJvdHRvbTogMjggfSwKICBhbGVydEVtb2ppOiB7IGZvbnRTaXplOiAyNCB9LAogIGFsZXJ0VGl0bGU6IHsgZm9udFNpemU6IDE1LCBmb250V2VpZ2h0OiAnNjAwJywgY29sb3I6IENvbG9ycy5TVUNDRVNTIH0sCiAgYWxlcnRUZXh0OiB7IGZvbnRTaXplOiAxMywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luVG9wOiAyIH0sCiAgYWN0aW9uc0dyaWQ6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGZsZXhXcmFwOiAnd3JhcCcsIGdhcDogMTIgfSwKICBhY3Rpb25DYXJkOiB7IHdpZHRoOiAnNDclJywgYWxpZ25JdGVtczogJ2NlbnRlcicsIHBhZGRpbmdWZXJ0aWNhbDogMTgsIGdhcDogOCB9LAogIGFjdGlvbkVtb2ppOiB7IGZvbnRTaXplOiAyNCB9LAogIGFjdGlvbkxhYmVsOiB7IGZvbnRTaXplOiAxMywgZm9udFdlaWdodDogJzYwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgdGV4dEFsaWduOiAnY2VudGVyJyB9LAp9KTsK" | base64 -d > 'mobile/app/(admin)/dashboard.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZVN0YXRlIH0gZnJvbSAncmVhY3QnOwppbXBvcnQgeyBTY3JvbGxWaWV3LCBTdHlsZVNoZWV0LCBUZXh0LCBUb3VjaGFibGVPcGFjaXR5LCBWaWV3IH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgQ29sb3JzIH0gZnJvbSAnLi4vLi4vY29uc3RhbnRzL2NvbG9ycyc7CmltcG9ydCB7IENhcmQgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0NhcmQnOwoKZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gQWRtaW5Db21taXNzaW9uc1NjcmVlbigpIHsKICBjb25zdCBbcmF0ZSwgc2V0UmF0ZV0gPSB1c2VTdGF0ZSgxNSk7IC8vIDE1JQoKICByZXR1cm4gKAogICAgPFNjcm9sbFZpZXcgc3R5bGU9e3N0eWxlcy5zY3JlZW59IGNvbnRlbnRDb250YWluZXJTdHlsZT17c3R5bGVzLmNvbnRhaW5lcn0gc2hvd3NWZXJ0aWNhbFNjcm9sbEluZGljYXRvcj17ZmFsc2V9PgogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnRpdGxlfT5Db21taXNzaW9uczwvVGV4dD4KCiAgICAgIHsvKiBDdXJyZW50IFJhdGUgKi99CiAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMucmF0ZUNhcmR9IGVsZXZhdGVkPgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMucmF0ZUxhYmVsfT5UYXV4IGRlIGNvbW1pc3Npb24gYWN0dWVsPC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMucmF0ZVZhbHVlfT57cmF0ZX0lPC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMucmF0ZU5vdGV9PkFwcGxpcXXDqSDDoCBjaGFxdWUgbWlzc2lvbiBjb21wbMOpdMOpZTwvVGV4dD4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnJhdGVCdXR0b25zfT4KICAgICAgICAgIDxUb3VjaGFibGVPcGFjaXR5IHN0eWxlPXtzdHlsZXMucmF0ZUJ0bn0gb25QcmVzcz17KCkgPT4gc2V0UmF0ZSgocikgPT4gTWF0aC5tYXgoNSwgciAtIDEpKX0+CiAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMucmF0ZUJ0blRleHR9PuKIkjwvVGV4dD4KICAgICAgICAgIDwvVG91Y2hhYmxlT3BhY2l0eT4KICAgICAgICAgIDxUb3VjaGFibGVPcGFjaXR5IHN0eWxlPXtbc3R5bGVzLnJhdGVCdG4sIHN0eWxlcy5yYXRlQnRuUHJpbWFyeV19IG9uUHJlc3M9eygpID0+IHNldFJhdGUoKHIpID0+IE1hdGgubWluKDMwLCByICsgMSkpfT4KICAgICAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMucmF0ZUJ0blRleHQsIHN0eWxlcy5yYXRlQnRuVGV4dFdoaXRlXX0+KzwvVGV4dD4KICAgICAgICAgIDwvVG91Y2hhYmxlT3BhY2l0eT4KICAgICAgICA8L1ZpZXc+CiAgICAgIDwvQ2FyZD4KCiAgICAgIHsvKiBTdW1tYXJ5ICovfQogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnN1bW1hcnlHcmlkfT4KICAgICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLnN1bW1hcnlDYXJkfT4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3VtbWFyeUVtb2ppfT7wn5KwPC9UZXh0PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zdW1tYXJ5VmFsdWV9PuKAlDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3VtbWFyeUxhYmVsfT5Ub3RhbCBjb2xsZWN0w6k8L1RleHQ+CiAgICAgICAgPC9DYXJkPgogICAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMuc3VtbWFyeUNhcmR9PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zdW1tYXJ5RW1vaml9PuKPszwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3VtbWFyeVZhbHVlfT7igJQ8L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnN1bW1hcnlMYWJlbH0+RW4gYXR0ZW50ZTwvVGV4dD4KICAgICAgICA8L0NhcmQ+CiAgICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5zdW1tYXJ5Q2FyZH0+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnN1bW1hcnlFbW9qaX0+4pyFPC9UZXh0PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zdW1tYXJ5VmFsdWV9PuKAlDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc3VtbWFyeUxhYmVsfT5WZXJzw6llczwvVGV4dD4KICAgICAgICA8L0NhcmQ+CiAgICAgIDwvVmlldz4KCiAgICAgIHsvKiBUcmFuc2FjdGlvbnMgKi99CiAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuc2VjdGlvblRpdGxlfT5UcmFuc2FjdGlvbnMgcsOpY2VudGVzPC9UZXh0PgogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLmVtcHR5Q2FyZH0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5lbXB0eUVtb2ppfT7wn5K4PC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZW1wdHlUaXRsZX0+QXVjdW5lIGNvbW1pc3Npb248L1RleHQ+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5lbXB0eVRleHR9PkxlcyBjb21taXNzaW9ucyBhcHBhcmHDrnRyb250IGljaSBhcHLDqHMgbGVzIHByZW1pw6hyZXMgbWlzc2lvbnMuPC9UZXh0PgogICAgICA8L0NhcmQ+CgogICAgICB7LyogRXhwb3J0ICovfQogICAgICA8VG91Y2hhYmxlT3BhY2l0eSBzdHlsZT17c3R5bGVzLmV4cG9ydEJ0bn0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5leHBvcnRUZXh0fT7wn5OKIEV4cG9ydGVyIGVuIENTVjwvVGV4dD4KICAgICAgPC9Ub3VjaGFibGVPcGFjaXR5PgogICAgPC9TY3JvbGxWaWV3PgogICk7Cn0KCmNvbnN0IHN0eWxlcyA9IFN0eWxlU2hlZXQuY3JlYXRlKHsKICBzY3JlZW46IHsgZmxleDogMSwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQkFDS0dST1VORCB9LAogIGNvbnRhaW5lcjogeyBwYWRkaW5nSG9yaXpvbnRhbDogMjAsIHBhZGRpbmdUb3A6IDYwLCBwYWRkaW5nQm90dG9tOiA0MCB9LAogIHRpdGxlOiB7IGZvbnRTaXplOiAyNiwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiAyMCB9LAogIHJhdGVDYXJkOiB7IGFsaWduSXRlbXM6ICdjZW50ZXInLCBwYWRkaW5nVmVydGljYWw6IDI4LCBtYXJnaW5Cb3R0b206IDIwIH0sCiAgcmF0ZUxhYmVsOiB7IGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgbWFyZ2luQm90dG9tOiA4IH0sCiAgcmF0ZVZhbHVlOiB7IGZvbnRTaXplOiA2NCwgZm9udFdlaWdodDogJzkwMCcsIGNvbG9yOiBDb2xvcnMuUFJJTUFSWSwgbGV0dGVyU3BhY2luZzogLTIsIGxpbmVIZWlnaHQ6IDcyIH0sCiAgcmF0ZU5vdGU6IHsgZm9udFNpemU6IDEzLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCBtYXJnaW5Cb3R0b206IDIwIH0sCiAgcmF0ZUJ1dHRvbnM6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGdhcDogMTYgfSwKICByYXRlQnRuOiB7IHdpZHRoOiA1MiwgaGVpZ2h0OiA1MiwgYm9yZGVyUmFkaXVzOiAyNiwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VSRkFDRSwgYm9yZGVyV2lkdGg6IDEuNSwgYm9yZGVyQ29sb3I6IENvbG9ycy5CT1JERVIsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicgfSwKICByYXRlQnRuUHJpbWFyeTogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5QUklNQVJZLCBib3JkZXJDb2xvcjogQ29sb3JzLlBSSU1BUlkgfSwKICByYXRlQnRuVGV4dDogeyBmb250U2l6ZTogMjQsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQgfSwKICByYXRlQnRuVGV4dFdoaXRlOiB7IGNvbG9yOiBDb2xvcnMuV0hJVEUgfSwKICBzdW1tYXJ5R3JpZDogeyBmbGV4RGlyZWN0aW9uOiAncm93JywgZ2FwOiAxMCwgbWFyZ2luQm90dG9tOiAyOCB9LAogIHN1bW1hcnlDYXJkOiB7IGZsZXg6IDEsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBwYWRkaW5nVmVydGljYWw6IDE2LCBnYXA6IDQgfSwKICBzdW1tYXJ5RW1vamk6IHsgZm9udFNpemU6IDIyIH0sCiAgc3VtbWFyeVZhbHVlOiB7IGZvbnRTaXplOiAxOCwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCB9LAogIHN1bW1hcnlMYWJlbDogeyBmb250U2l6ZTogMTEsIGNvbG9yOiBDb2xvcnMuVEVYVF9TRUNPTkRBUlksIHRleHRBbGlnbjogJ2NlbnRlcicgfSwKICBzZWN0aW9uVGl0bGU6IHsgZm9udFNpemU6IDE3LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDE0IH0sCiAgZW1wdHlDYXJkOiB7IGFsaWduSXRlbXM6ICdjZW50ZXInLCBwYWRkaW5nVmVydGljYWw6IDMyLCBtYXJnaW5Cb3R0b206IDIwIH0sCiAgZW1wdHlFbW9qaTogeyBmb250U2l6ZTogMzYsIG1hcmdpbkJvdHRvbTogMTAgfSwKICBlbXB0eVRpdGxlOiB7IGZvbnRTaXplOiAxNiwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiA2IH0sCiAgZW1wdHlUZXh0OiB7IGZvbnRTaXplOiAxMywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgdGV4dEFsaWduOiAnY2VudGVyJywgbGluZUhlaWdodDogMTggfSwKICBleHBvcnRCdG46IHsgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuU1VSRkFDRSwgYm9yZGVyUmFkaXVzOiAxMiwgcGFkZGluZ1ZlcnRpY2FsOiAxNiwgYWxpZ25JdGVtczogJ2NlbnRlcicsIGJvcmRlcldpZHRoOiAxLCBib3JkZXJDb2xvcjogQ29sb3JzLkJPUkRFUiB9LAogIGV4cG9ydFRleHQ6IHsgZm9udFNpemU6IDE1LCBmb250V2VpZ2h0OiAnNjAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCn0pOwo=" | base64 -d > 'mobile/app/(admin)/commissions.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZUVmZmVjdCwgdXNlU3RhdGUgfSBmcm9tICdyZWFjdCc7CmltcG9ydCB7IEZsYXRMaXN0LCBTdHlsZVNoZWV0LCBUZXh0LCBUb3VjaGFibGVPcGFjaXR5LCBWaWV3IH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgdXNlUm91dGVyIH0gZnJvbSAnZXhwby1yb3V0ZXInOwppbXBvcnQgeyBDb2xvcnMgfSBmcm9tICcuLi8uLi9jb25zdGFudHMvY29sb3JzJzsKaW1wb3J0IHsgdXNlTWlzc2lvbnMgfSBmcm9tICcuLi8uLi9ob29rcy91c2VNaXNzaW9ucyc7CmltcG9ydCB7IE1pc3Npb25DYXJkIH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy9taXNzaW9uL01pc3Npb25DYXJkJzsKaW1wb3J0IHsgTWlzc2lvblN0YXR1cyB9IGZyb20gJy4uLy4uL3R5cGVzJzsKCnR5cGUgU3RhdHVzRmlsdGVyID0gJ0FMTCcgfCBNaXNzaW9uU3RhdHVzOwoKY29uc3QgU1RBVFVTX0ZJTFRFUlM6IHsga2V5OiBTdGF0dXNGaWx0ZXI7IGxhYmVsOiBzdHJpbmcgfVtdID0gWwogIHsga2V5OiAnQUxMJywgbGFiZWw6ICdUb3V0ZXMnIH0sCiAgeyBrZXk6ICdQRU5ESU5HJywgbGFiZWw6ICdFbiBhdHRlbnRlJyB9LAogIHsga2V5OiAnQUNDRVBURUQnLCBsYWJlbDogJ0FjY2VwdMOpZXMnIH0sCiAgeyBrZXk6ICdJTl9QUk9HUkVTUycsIGxhYmVsOiAnRW4gY291cnMnIH0sCiAgeyBrZXk6ICdDT01QTEVURUQnLCBsYWJlbDogJ1Rlcm1pbsOpZXMnIH0sCiAgeyBrZXk6ICdDQU5DRUxMRUQnLCBsYWJlbDogJ0FubnVsw6llcycgfSwKXTsKCmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIEFkbWluTWlzc2lvbnNTY3JlZW4oKSB7CiAgY29uc3Qgcm91dGVyID0gdXNlUm91dGVyKCk7CiAgY29uc3QgeyBsaXN0LCBsb2FkTWlzc2lvbnMsIGlzTG9hZGluZyB9ID0gdXNlTWlzc2lvbnMoKTsKICBjb25zdCBbZmlsdGVyLCBzZXRGaWx0ZXJdID0gdXNlU3RhdGU8U3RhdHVzRmlsdGVyPignQUxMJyk7CgogIHVzZUVmZmVjdCgoKSA9PiB7CiAgICBsb2FkTWlzc2lvbnMoKTsKICB9LCBbXSk7CgogIGNvbnN0IGZpbHRlcmVkID0gZmlsdGVyID09PSAnQUxMJyA/IGxpc3QgOiBsaXN0LmZpbHRlcigobSkgPT4gbS5zdGF0dXMgPT09IGZpbHRlcik7CgogIHJldHVybiAoCiAgICA8VmlldyBzdHlsZT17c3R5bGVzLnNjcmVlbn0+CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuaGVhZGVyU2VjdGlvbn0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy50aXRsZX0+VG91dGVzIGxlcyBtaXNzaW9uczwvVGV4dD4KICAgICAgICA8RmxhdExpc3QKICAgICAgICAgIGhvcml6b250YWwKICAgICAgICAgIGRhdGE9e1NUQVRVU19GSUxURVJTfQogICAgICAgICAga2V5RXh0cmFjdG9yPXsoZikgPT4gZi5rZXl9CiAgICAgICAgICByZW5kZXJJdGVtPXsoeyBpdGVtIH0pID0+ICgKICAgICAgICAgICAgPFRvdWNoYWJsZU9wYWNpdHkKICAgICAgICAgICAgICBzdHlsZT17W3N0eWxlcy5maWx0ZXJDaGlwLCBmaWx0ZXIgPT09IGl0ZW0ua2V5ICYmIHN0eWxlcy5maWx0ZXJDaGlwQWN0aXZlXX0KICAgICAgICAgICAgICBvblByZXNzPXsoKSA9PiBzZXRGaWx0ZXIoaXRlbS5rZXkpfQogICAgICAgICAgICA+CiAgICAgICAgICAgICAgPFRleHQgc3R5bGU9e1tzdHlsZXMuZmlsdGVyVGV4dCwgZmlsdGVyID09PSBpdGVtLmtleSAmJiBzdHlsZXMuZmlsdGVyVGV4dEFjdGl2ZV19PgogICAgICAgICAgICAgICAge2l0ZW0ubGFiZWx9CiAgICAgICAgICAgICAgPC9UZXh0PgogICAgICAgICAgICA8L1RvdWNoYWJsZU9wYWNpdHk+CiAgICAgICAgICApfQogICAgICAgICAgY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMuZmlsdGVyUm93fQogICAgICAgICAgc2hvd3NIb3Jpem9udGFsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0KICAgICAgICAvPgogICAgICA8L1ZpZXc+CgogICAgICA8RmxhdExpc3QKICAgICAgICBkYXRhPXtmaWx0ZXJlZH0KICAgICAgICBrZXlFeHRyYWN0b3I9eyhtKSA9PiBtLmlkfQogICAgICAgIHJlbmRlckl0ZW09eyh7IGl0ZW0gfSkgPT4gKAogICAgICAgICAgPE1pc3Npb25DYXJkIG1pc3Npb249e2l0ZW19IG9uUHJlc3M9eygpID0+IHt9fSAvPgogICAgICAgICl9CiAgICAgICAgY29udGVudENvbnRhaW5lclN0eWxlPXtzdHlsZXMubGlzdH0KICAgICAgICBzaG93c1ZlcnRpY2FsU2Nyb2xsSW5kaWNhdG9yPXtmYWxzZX0KICAgICAgICBvblJlZnJlc2g9e2xvYWRNaXNzaW9uc30KICAgICAgICByZWZyZXNoaW5nPXtpc0xvYWRpbmd9CiAgICAgICAgTGlzdEVtcHR5Q29tcG9uZW50PXsKICAgICAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuZW1wdHlDb250YWluZXJ9PgogICAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmVtcHR5RW1vaml9PvCfk608L1RleHQ+CiAgICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZW1wdHlUaXRsZX0+QXVjdW5lIG1pc3Npb248L1RleHQ+CiAgICAgICAgICA8L1ZpZXc+CiAgICAgICAgfQogICAgICAvPgogICAgPC9WaWV3PgogICk7Cn0KCmNvbnN0IHN0eWxlcyA9IFN0eWxlU2hlZXQuY3JlYXRlKHsKICBzY3JlZW46IHsgZmxleDogMSwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQkFDS0dST1VORCB9LAogIGhlYWRlclNlY3Rpb246IHsgcGFkZGluZ0hvcml6b250YWw6IDIwLCBwYWRkaW5nVG9wOiA2MCwgcGFkZGluZ0JvdHRvbTogMTIgfSwKICB0aXRsZTogeyBmb250U2l6ZTogMjYsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQsIG1hcmdpbkJvdHRvbTogMTYgfSwKICBmaWx0ZXJSb3c6IHsgZ2FwOiA4LCBwYWRkaW5nQm90dG9tOiA0IH0sCiAgZmlsdGVyQ2hpcDogeyBwYWRkaW5nSG9yaXpvbnRhbDogMTQsIHBhZGRpbmdWZXJ0aWNhbDogOCwgYm9yZGVyUmFkaXVzOiA5OTksIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsIGJvcmRlcldpZHRoOiAxLCBib3JkZXJDb2xvcjogQ29sb3JzLkJPUkRFUiB9LAogIGZpbHRlckNoaXBBY3RpdmU6IHsgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuUFJJTUFSWSwgYm9yZGVyQ29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgZmlsdGVyVGV4dDogeyBmb250U2l6ZTogMTMsIGZvbnRXZWlnaHQ6ICc2MDAnLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCiAgZmlsdGVyVGV4dEFjdGl2ZTogeyBjb2xvcjogQ29sb3JzLldISVRFIH0sCiAgbGlzdDogeyBwYWRkaW5nSG9yaXpvbnRhbDogMjAsIHBhZGRpbmdUb3A6IDEyLCBwYWRkaW5nQm90dG9tOiA0MCB9LAogIGVtcHR5Q29udGFpbmVyOiB7IGFsaWduSXRlbXM6ICdjZW50ZXInLCBwYWRkaW5nVG9wOiA2MCB9LAogIGVtcHR5RW1vamk6IHsgZm9udFNpemU6IDQ4LCBtYXJnaW5Cb3R0b206IDEyIH0sCiAgZW1wdHlUaXRsZTogeyBmb250U2l6ZTogMTgsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCn0pOwo=" | base64 -d > 'mobile/app/(admin)/missions.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZVN0YXRlIH0gZnJvbSAncmVhY3QnOwppbXBvcnQgeyBTY3JvbGxWaWV3LCBTdHlsZVNoZWV0LCBUZXh0LCBUb3VjaGFibGVPcGFjaXR5LCBWaWV3IH0gZnJvbSAncmVhY3QtbmF0aXZlJzsKaW1wb3J0IHsgQ29sb3JzIH0gZnJvbSAnLi4vLi4vY29uc3RhbnRzL2NvbG9ycyc7CmltcG9ydCB7IENhcmQgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0NhcmQnOwoKdHlwZSBQZXJpb2QgPSAnd2VlaycgfCAnbW9udGgnIHwgJ3llYXInOwoKZnVuY3Rpb24gU3RhdEJhcih7IGxhYmVsLCB2YWx1ZSwgbWF4LCBjb2xvciB9OiB7IGxhYmVsOiBzdHJpbmc7IHZhbHVlOiBudW1iZXI7IG1heDogbnVtYmVyOyBjb2xvcjogc3RyaW5nIH0pIHsKICBjb25zdCBwY3QgPSBtYXggPiAwID8gKHZhbHVlIC8gbWF4KSAqIDEwMCA6IDA7CiAgcmV0dXJuICgKICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuYmFyUm93fT4KICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5iYXJMYWJlbH0+e2xhYmVsfTwvVGV4dD4KICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5iYXJUcmFja30+CiAgICAgICAgPFZpZXcgc3R5bGU9e1tzdHlsZXMuYmFyRmlsbCwgeyB3aWR0aDogYCR7cGN0fSVgIGFzIGFueSwgYmFja2dyb3VuZENvbG9yOiBjb2xvciB9XX0gLz4KICAgICAgPC9WaWV3PgogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmJhclZhbHVlfT57dmFsdWV9PC9UZXh0PgogICAgPC9WaWV3PgogICk7Cn0KCmV4cG9ydCBkZWZhdWx0IGZ1bmN0aW9uIEFkbWluU3RhdGlzdGlxdWVzU2NyZWVuKCkgewogIGNvbnN0IFtwZXJpb2QsIHNldFBlcmlvZF0gPSB1c2VTdGF0ZTxQZXJpb2Q+KCdtb250aCcpOwoKICByZXR1cm4gKAogICAgPFNjcm9sbFZpZXcgc3R5bGU9e3N0eWxlcy5zY3JlZW59IGNvbnRlbnRDb250YWluZXJTdHlsZT17c3R5bGVzLmNvbnRhaW5lcn0gc2hvd3NWZXJ0aWNhbFNjcm9sbEluZGljYXRvcj17ZmFsc2V9PgogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnRpdGxlfT5TdGF0aXN0aXF1ZXM8L1RleHQ+CgogICAgICB7LyogUGVyaW9kICovfQogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnBlcmlvZFNlbGVjdG9yfT4KICAgICAgICB7KFsnd2VlaycsICdtb250aCcsICd5ZWFyJ10gYXMgUGVyaW9kW10pLm1hcCgocCkgPT4gKAogICAgICAgICAgPFRvdWNoYWJsZU9wYWNpdHkKICAgICAgICAgICAga2V5PXtwfQogICAgICAgICAgICBzdHlsZT17W3N0eWxlcy5wZXJpb2RCdG4sIHBlcmlvZCA9PT0gcCAmJiBzdHlsZXMucGVyaW9kQnRuQWN0aXZlXX0KICAgICAgICAgICAgb25QcmVzcz17KCkgPT4gc2V0UGVyaW9kKHApfQogICAgICAgICAgPgogICAgICAgICAgICA8VGV4dCBzdHlsZT17W3N0eWxlcy5wZXJpb2RUZXh0LCBwZXJpb2QgPT09IHAgJiYgc3R5bGVzLnBlcmlvZFRleHRBY3RpdmVdfT4KICAgICAgICAgICAgICB7cCA9PT0gJ3dlZWsnID8gJ1NlbWFpbmUnIDogcCA9PT0gJ21vbnRoJyA/ICdNb2lzJyA6ICdBbm7DqWUnfQogICAgICAgICAgICA8L1RleHQ+CiAgICAgICAgICA8L1RvdWNoYWJsZU9wYWNpdHk+CiAgICAgICAgKSl9CiAgICAgIDwvVmlldz4KCiAgICAgIHsvKiBNYWluIEtQSXMgKi99CiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMua3BpUm93fT4KICAgICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLmtwaUNhcmR9IGVsZXZhdGVkPgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5rcGlFbW9qaX0+8J+TpjwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMua3BpVmFsdWV9PuKAlDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMua3BpTGFiZWx9Pk1pc3Npb25zPC9UZXh0PgogICAgICAgIDwvQ2FyZD4KICAgICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLmtwaUNhcmR9IGVsZXZhdGVkPgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5rcGlFbW9qaX0+8J+SsDwvVGV4dD4KICAgICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMua3BpVmFsdWV9PuKAlCDigqw8L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmtwaUxhYmVsfT5DQSB0b3RhbDwvVGV4dD4KICAgICAgICA8L0NhcmQ+CiAgICAgIDwvVmlldz4KICAgICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5rcGlSb3d9PgogICAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMua3BpQ2FyZH0gZWxldmF0ZWQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmtwaUVtb2ppfT7wn5GlPC9UZXh0PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5rcGlWYWx1ZX0+4oCUPC9UZXh0PgogICAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5rcGlMYWJlbH0+Tm91dmVhdXggdXNlcnM8L1RleHQ+CiAgICAgICAgPC9DYXJkPgogICAgICAgIDxDYXJkIHN0eWxlPXtzdHlsZXMua3BpQ2FyZH0gZWxldmF0ZWQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmtwaUVtb2ppfT7irZA8L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmtwaVZhbHVlfT7igJQ8L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmtwaUxhYmVsfT5Ob3RlIG1veWVubmU8L1RleHQ+CiAgICAgICAgPC9DYXJkPgogICAgICA8L1ZpZXc+CgogICAgICB7LyogTWlzc2lvbiBTdGF0dXMgRGlzdHJpYnV0aW9uICovfQogICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlY3Rpb25UaXRsZX0+UsOpcGFydGl0aW9uIGRlcyBtaXNzaW9uczwvVGV4dD4KICAgICAgPENhcmQgc3R5bGU9e3N0eWxlcy5jaGFydENhcmR9PgogICAgICAgIDxTdGF0QmFyIGxhYmVsPSJUZXJtaW7DqWVzIiB2YWx1ZT17MH0gbWF4PXsxMDB9IGNvbG9yPXtDb2xvcnMuU1VDQ0VTU30gLz4KICAgICAgICA8U3RhdEJhciBsYWJlbD0iRW4gY291cnMiIHZhbHVlPXswfSBtYXg9ezEwMH0gY29sb3I9e0NvbG9ycy5QUklNQVJZfSAvPgogICAgICAgIDxTdGF0QmFyIGxhYmVsPSJFbiBhdHRlbnRlIiB2YWx1ZT17MH0gbWF4PXsxMDB9IGNvbG9yPXtDb2xvcnMuV0FSTklOR30gLz4KICAgICAgICA8U3RhdEJhciBsYWJlbD0iQW5udWzDqWVzIiB2YWx1ZT17MH0gbWF4PXsxMDB9IGNvbG9yPXtDb2xvcnMuRVJST1J9IC8+CiAgICAgIDwvQ2FyZD4KCiAgICAgIHsvKiBUb3AgVHJhbnNwb3J0ZXVycyAqL30KICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5zZWN0aW9uVGl0bGV9PlRvcCB0cmFuc3BvcnRldXJzPC9UZXh0PgogICAgICA8Q2FyZCBzdHlsZT17c3R5bGVzLmVtcHR5Q2FyZH0+CiAgICAgICAgPFRleHQgc3R5bGU9e3N0eWxlcy5lbXB0eVRleHR9PkF1Y3VuZSBkb25uw6llIGRpc3BvbmlibGUgcG91ciBsZSBtb21lbnQuPC9UZXh0PgogICAgICA8L0NhcmQ+CiAgICA8L1Njcm9sbFZpZXc+CiAgKTsKfQoKY29uc3Qgc3R5bGVzID0gU3R5bGVTaGVldC5jcmVhdGUoewogIHNjcmVlbjogeyBmbGV4OiAxLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CQUNLR1JPVU5EIH0sCiAgY29udGFpbmVyOiB7IHBhZGRpbmdIb3Jpem9udGFsOiAyMCwgcGFkZGluZ1RvcDogNjAsIHBhZGRpbmdCb3R0b206IDQwIH0sCiAgdGl0bGU6IHsgZm9udFNpemU6IDI2LCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhULCBtYXJnaW5Cb3R0b206IDIwIH0sCiAgcGVyaW9kU2VsZWN0b3I6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlNVUkZBQ0UsIGJvcmRlclJhZGl1czogMTIsIHBhZGRpbmc6IDQsIG1hcmdpbkJvdHRvbTogMjAgfSwKICBwZXJpb2RCdG46IHsgZmxleDogMSwgcGFkZGluZ1ZlcnRpY2FsOiA4LCBib3JkZXJSYWRpdXM6IDEwLCBhbGlnbkl0ZW1zOiAnY2VudGVyJyB9LAogIHBlcmlvZEJ0bkFjdGl2ZTogeyBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5QUklNQVJZIH0sCiAgcGVyaW9kVGV4dDogeyBmb250U2l6ZTogMTMsIGZvbnRXZWlnaHQ6ICc2MDAnLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCiAgcGVyaW9kVGV4dEFjdGl2ZTogeyBjb2xvcjogQ29sb3JzLldISVRFIH0sCiAga3BpUm93OiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBnYXA6IDEyLCBtYXJnaW5Cb3R0b206IDEyIH0sCiAga3BpQ2FyZDogeyBmbGV4OiAxLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgcGFkZGluZ1ZlcnRpY2FsOiAyMCwgZ2FwOiA0IH0sCiAga3BpRW1vamk6IHsgZm9udFNpemU6IDI0IH0sCiAga3BpVmFsdWU6IHsgZm9udFNpemU6IDIyLCBmb250V2VpZ2h0OiAnNzAwJywgY29sb3I6IENvbG9ycy5URVhUIH0sCiAga3BpTGFiZWw6IHsgZm9udFNpemU6IDEyLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZLCB0ZXh0QWxpZ246ICdjZW50ZXInIH0sCiAgc2VjdGlvblRpdGxlOiB7IGZvbnRTaXplOiAxNiwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiAxNCwgbWFyZ2luVG9wOiAxNiB9LAogIGNoYXJ0Q2FyZDogeyBnYXA6IDE0IH0sCiAgYmFyUm93OiB7IGZsZXhEaXJlY3Rpb246ICdyb3cnLCBhbGlnbkl0ZW1zOiAnY2VudGVyJywgZ2FwOiAxMCB9LAogIGJhckxhYmVsOiB7IHdpZHRoOiA4MCwgZm9udFNpemU6IDEzLCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCiAgYmFyVHJhY2s6IHsgZmxleDogMSwgaGVpZ2h0OiA4LCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5CT1JERVIsIGJvcmRlclJhZGl1czogNCwgb3ZlcmZsb3c6ICdoaWRkZW4nIH0sCiAgYmFyRmlsbDogeyBoZWlnaHQ6ICcxMDAlJywgYm9yZGVyUmFkaXVzOiA0LCBtaW5XaWR0aDogNCB9LAogIGJhclZhbHVlOiB7IHdpZHRoOiAyOCwgZm9udFNpemU6IDEzLCBmb250V2VpZ2h0OiAnNjAwJywgY29sb3I6IENvbG9ycy5URVhULCB0ZXh0QWxpZ246ICdyaWdodCcgfSwKICBlbXB0eUNhcmQ6IHsgYWxpZ25JdGVtczogJ2NlbnRlcicsIHBhZGRpbmdWZXJ0aWNhbDogMjQgfSwKICBlbXB0eVRleHQ6IHsgZm9udFNpemU6IDE0LCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCn0pOwo=" | base64 -d > 'mobile/app/(admin)/statistiques.tsx'
echo "aW1wb3J0IFJlYWN0LCB7IHVzZVN0YXRlIH0gZnJvbSAncmVhY3QnOwppbXBvcnQgeyBGbGF0TGlzdCwgU3R5bGVTaGVldCwgVGV4dCwgVG91Y2hhYmxlT3BhY2l0eSwgVmlldyB9IGZyb20gJ3JlYWN0LW5hdGl2ZSc7CmltcG9ydCB7IENvbG9ycyB9IGZyb20gJy4uLy4uL2NvbnN0YW50cy9jb2xvcnMnOwppbXBvcnQgeyBBdmF0YXIgfSBmcm9tICcuLi8uLi9jb21wb25lbnRzL3VpL0F2YXRhcic7CmltcG9ydCB7IEJhZGdlIH0gZnJvbSAnLi4vLi4vY29tcG9uZW50cy91aS9CYWRnZSc7CmltcG9ydCB7IFVzZXJSb2xlIH0gZnJvbSAnLi4vLi4vdHlwZXMnOwoKdHlwZSBGaWx0ZXIgPSAnQUxMJyB8IFVzZXJSb2xlOwoKY29uc3QgRklMVEVSUzogeyBrZXk6IEZpbHRlcjsgbGFiZWw6IHN0cmluZyB9W10gPSBbCiAgeyBrZXk6ICdBTEwnLCBsYWJlbDogJ1RvdXMnIH0sCiAgeyBrZXk6ICdDTElFTlQnLCBsYWJlbDogJ0NsaWVudHMnIH0sCiAgeyBrZXk6ICdUUkFOU1BPUlRFVVInLCBsYWJlbDogJ1RyYW5zcG9ydGV1cnMnIH0sCiAgeyBrZXk6ICdBRE1JTicsIGxhYmVsOiAnQWRtaW5zJyB9LApdOwoKZXhwb3J0IGRlZmF1bHQgZnVuY3Rpb24gQWRtaW5VdGlsaXNhdGV1cnNTY3JlZW4oKSB7CiAgY29uc3QgW2ZpbHRlciwgc2V0RmlsdGVyXSA9IHVzZVN0YXRlPEZpbHRlcj4oJ0FMTCcpOwoKICByZXR1cm4gKAogICAgPFZpZXcgc3R5bGU9e3N0eWxlcy5zY3JlZW59PgogICAgICA8VmlldyBzdHlsZT17c3R5bGVzLmhlYWRlclNlY3Rpb259PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMudGl0bGV9PlV0aWxpc2F0ZXVyczwvVGV4dD4KICAgICAgICA8VmlldyBzdHlsZT17c3R5bGVzLnNlYXJjaEJhcn0+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlYXJjaEljb259PvCflI08L1RleHQ+CiAgICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLnNlYXJjaFBsYWNlaG9sZGVyfT5SZWNoZXJjaGVyIHVuIHV0aWxpc2F0ZXVyLi4uPC9UZXh0PgogICAgICAgIDwvVmlldz4KICAgICAgICA8RmxhdExpc3QKICAgICAgICAgIGhvcml6b250YWwKICAgICAgICAgIGRhdGE9e0ZJTFRFUlN9CiAgICAgICAgICBrZXlFeHRyYWN0b3I9eyhmKSA9PiBmLmtleX0KICAgICAgICAgIHJlbmRlckl0ZW09eyh7IGl0ZW0gfSkgPT4gKAogICAgICAgICAgICA8VG91Y2hhYmxlT3BhY2l0eQogICAgICAgICAgICAgIHN0eWxlPXtbc3R5bGVzLmZpbHRlckNoaXAsIGZpbHRlciA9PT0gaXRlbS5rZXkgJiYgc3R5bGVzLmZpbHRlckNoaXBBY3RpdmVdfQogICAgICAgICAgICAgIG9uUHJlc3M9eygpID0+IHNldEZpbHRlcihpdGVtLmtleSl9CiAgICAgICAgICAgID4KICAgICAgICAgICAgICA8VGV4dCBzdHlsZT17W3N0eWxlcy5maWx0ZXJUZXh0LCBmaWx0ZXIgPT09IGl0ZW0ua2V5ICYmIHN0eWxlcy5maWx0ZXJUZXh0QWN0aXZlXX0+CiAgICAgICAgICAgICAgICB7aXRlbS5sYWJlbH0KICAgICAgICAgICAgICA8L1RleHQ+CiAgICAgICAgICAgIDwvVG91Y2hhYmxlT3BhY2l0eT4KICAgICAgICAgICl9CiAgICAgICAgICBjb250ZW50Q29udGFpbmVyU3R5bGU9e3N0eWxlcy5maWx0ZXJSb3d9CiAgICAgICAgICBzaG93c0hvcml6b250YWxTY3JvbGxJbmRpY2F0b3I9e2ZhbHNlfQogICAgICAgIC8+CiAgICAgIDwvVmlldz4KCiAgICAgIDxWaWV3IHN0eWxlPXtzdHlsZXMuZW1wdHlDb250YWluZXJ9PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZW1wdHlFbW9qaX0+8J+RpTwvVGV4dD4KICAgICAgICA8VGV4dCBzdHlsZT17c3R5bGVzLmVtcHR5VGl0bGV9PkF1Y3VuIHV0aWxpc2F0ZXVyPC9UZXh0PgogICAgICAgIDxUZXh0IHN0eWxlPXtzdHlsZXMuZW1wdHlUZXh0fT5MZXMgdXRpbGlzYXRldXJzIGluc2NyaXRzIGFwcGFyYcOudHJvbnQgaWNpLjwvVGV4dD4KICAgICAgPC9WaWV3PgogICAgPC9WaWV3PgogICk7Cn0KCmNvbnN0IHN0eWxlcyA9IFN0eWxlU2hlZXQuY3JlYXRlKHsKICBzY3JlZW46IHsgZmxleDogMSwgYmFja2dyb3VuZENvbG9yOiBDb2xvcnMuQkFDS0dST1VORCB9LAogIGhlYWRlclNlY3Rpb246IHsgcGFkZGluZ0hvcml6b250YWw6IDIwLCBwYWRkaW5nVG9wOiA2MCwgcGFkZGluZ0JvdHRvbTogMTIgfSwKICB0aXRsZTogeyBmb250U2l6ZTogMjYsIGZvbnRXZWlnaHQ6ICc3MDAnLCBjb2xvcjogQ29sb3JzLlRFWFQsIG1hcmdpbkJvdHRvbTogMTYgfSwKICBzZWFyY2hCYXI6IHsgZmxleERpcmVjdGlvbjogJ3JvdycsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5TVVJGQUNFLCBib3JkZXJSYWRpdXM6IDEyLCBwYWRkaW5nSG9yaXpvbnRhbDogMTQsIHBhZGRpbmdWZXJ0aWNhbDogMTIsIGJvcmRlcldpZHRoOiAxLCBib3JkZXJDb2xvcjogQ29sb3JzLkJPUkRFUiwgZ2FwOiAxMCwgbWFyZ2luQm90dG9tOiAxNCB9LAogIHNlYXJjaEljb246IHsgZm9udFNpemU6IDE2IH0sCiAgc2VhcmNoUGxhY2Vob2xkZXI6IHsgZm9udFNpemU6IDE1LCBjb2xvcjogQ29sb3JzLlRFWFRfU0VDT05EQVJZIH0sCiAgZmlsdGVyUm93OiB7IGdhcDogOCwgcGFkZGluZ0JvdHRvbTogNCB9LAogIGZpbHRlckNoaXA6IHsgcGFkZGluZ0hvcml6b250YWw6IDE2LCBwYWRkaW5nVmVydGljYWw6IDgsIGJvcmRlclJhZGl1czogOTk5LCBiYWNrZ3JvdW5kQ29sb3I6IENvbG9ycy5TVVJGQUNFLCBib3JkZXJXaWR0aDogMSwgYm9yZGVyQ29sb3I6IENvbG9ycy5CT1JERVIgfSwKICBmaWx0ZXJDaGlwQWN0aXZlOiB7IGJhY2tncm91bmRDb2xvcjogQ29sb3JzLlBSSU1BUlksIGJvcmRlckNvbG9yOiBDb2xvcnMuUFJJTUFSWSB9LAogIGZpbHRlclRleHQ6IHsgZm9udFNpemU6IDEzLCBmb250V2VpZ2h0OiAnNjAwJywgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSB9LAogIGZpbHRlclRleHRBY3RpdmU6IHsgY29sb3I6IENvbG9ycy5XSElURSB9LAogIGVtcHR5Q29udGFpbmVyOiB7IGZsZXg6IDEsIGFsaWduSXRlbXM6ICdjZW50ZXInLCBqdXN0aWZ5Q29udGVudDogJ2NlbnRlcicsIHBhZGRpbmc6IDQwIH0sCiAgZW1wdHlFbW9qaTogeyBmb250U2l6ZTogNTYsIG1hcmdpbkJvdHRvbTogMTYgfSwKICBlbXB0eVRpdGxlOiB7IGZvbnRTaXplOiAyMCwgZm9udFdlaWdodDogJzcwMCcsIGNvbG9yOiBDb2xvcnMuVEVYVCwgbWFyZ2luQm90dG9tOiA4IH0sCiAgZW1wdHlUZXh0OiB7IGZvbnRTaXplOiAxNCwgY29sb3I6IENvbG9ycy5URVhUX1NFQ09OREFSWSwgdGV4dEFsaWduOiAnY2VudGVyJyB9LAp9KTsK" | base64 -d > 'mobile/app/(admin)/utilisateurs.tsx'

# ─── Git setup ───────────────────────────────────────────────────────────────
git init
git add -A
git commit -m "feat: complete JO'DRIVE MVP V1"
git branch -M main
git remote add origin https://github.com/johanel46-create/JO-DRIVE.git
git push -u origin main

echo ""
echo "✅ JO'DRIVE project setup complete!"
