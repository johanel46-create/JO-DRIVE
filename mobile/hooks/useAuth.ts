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
