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
