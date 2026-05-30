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
