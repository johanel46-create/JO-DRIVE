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
