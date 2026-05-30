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
