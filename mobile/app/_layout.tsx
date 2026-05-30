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
