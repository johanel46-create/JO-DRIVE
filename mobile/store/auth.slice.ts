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
