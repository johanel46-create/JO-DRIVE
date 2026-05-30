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
