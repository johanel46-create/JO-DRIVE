import React, { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import * as Location from 'expo-location';
import { Colors } from '../../../constants/colors';
import { useMissions } from '../../../hooks/useMissions';
import { useSocket } from '../../../hooks/useSocket';
import { MissionStatusTracker } from '../../../components/mission/MissionStatus';
import { TrackingMap } from '../../../components/map/TrackingMap';
import { Card } from '../../../components/ui/Card';
import { Button } from '../../../components/ui/Button';

export default function TransporteurMissionDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const { current, loadMission, accept, start, complete, isLoading } = useMissions();
  const { connect, emitGpsUpdate, disconnect } = useSocket();
  const [gpsInterval, setGpsInterval] = useState<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => { if (id) loadMission(id); }, [id]);

  useEffect(() => {
    connect();
    return () => { disconnect(); if (gpsInterval) clearInterval(gpsInterval); };
  }, []);

  const startGpsTracking = async () => {
    const { status } = await Location.requestForegroundPermissionsAsync();
    if (status !== 'granted') { Alert.alert('Permission GPS', 'La localisation est nécessaire pour le suivi.'); return; }
    const interval = setInterval(async () => {
      const loc = await Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.High });
      emitGpsUpdate(id!, {
        lat: loc.coords.latitude,
        lng: loc.coords.longitude,
        heading: loc.coords.heading ?? undefined,
        speed: loc.coords.speed ?? undefined,
        timestamp: Date.now(),
      });
    }, 5000);
    setGpsInterval(interval);
  };

  if (isLoading || !current) {
    return (<View style={styles.center}><ActivityIndicator size="large" color={Colors.PRIMARY} /></View>);
  }

  const mission = current;
  const isPending = mission.status === 'PENDING';
  const isAccepted = mission.status === 'ACCEPTED';
  const isInProgress = mission.status === 'IN_PROGRESS';

  const handleAccept = async () => {
    Alert.alert('Accepter la mission', 'Confirmer la prise en charge ?', [
      { text: 'Annuler', style: 'cancel' },
      { text: 'Accepter', onPress: async () => { await accept(mission.id, 'VEHICLE_ID_PLACEHOLDER'); } },
    ]);
  };

  const handleStart = async () => { await start(mission.id); await startGpsTracking(); };

  const handleComplete = async () => {
    Alert.alert('Terminer la mission', 'Confirmer la livraison effectuée ?', [
      { text: 'Annuler', style: 'cancel' },
      { text: 'Confirmer', onPress: async () => { if (gpsInterval) clearInterval(gpsInterval); await complete(mission.id); } },
    ]);
  };

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}><Text style={styles.backText}>←</Text></TouchableOpacity>
        <Text style={styles.title}>Mission #{mission.id.slice(0, 8).toUpperCase()}</Text>
        <View style={{ width: 40 }} />
      </View>

      <View style={styles.mapContainer}>
        <TrackingMap pickupLat={mission.pickupLat} pickupLng={mission.pickupLng} deliveryLat={mission.deliveryLat} deliveryLng={mission.deliveryLng} />
      </View>

      <Card style={styles.section}><MissionStatusTracker status={mission.status} /></Card>

      <Card style={styles.section}>
        <Text style={styles.sectionTitle}>Itinéraire</Text>
        <View style={styles.detailRow}>
          <View style={styles.greenDot} />
          <View><Text style={styles.detailLabel}>Enlèvement</Text><Text style={styles.detailValue}>{mission.pickupAddress}</Text></View>
        </View>
        <View style={styles.routeLine} />
        <View style={styles.detailRow}>
          <View style={styles.redDot} />
          <View><Text style={styles.detailLabel}>Livraison</Text><Text style={styles.detailValue}>{mission.deliveryAddress}</Text></View>
        </View>
      </Card>

      <Card style={styles.section}>
        <View style={styles.priceRow}>
          <Text style={styles.priceLabel}>Rémunération</Text>
          <Text style={styles.priceValue}>{(mission.price - mission.commission).toFixed(2)} €</Text>
        </View>
        <Text style={styles.commissionNote}>Commission JO'DRIVE: {mission.commission.toFixed(2)} € ({((mission.commission / mission.price) * 100).toFixed(0)}%)</Text>
        {mission.distance != null && (<Text style={styles.distanceNote}>Distance: {mission.distance.toFixed(1)} km</Text>)}
      </Card>

      <Card style={styles.section}>
        <Text style={styles.sectionTitle}>Objets ({mission.items.length})</Text>
        {mission.items.map((item, i) => (
          <View key={item.id} style={[styles.itemRow, i > 0 && styles.itemBorder]}>
            <Text style={styles.itemEmoji}>📦</Text>
            <View>
              <Text style={styles.itemDesc}>{item.description}</Text>
              <Text style={styles.itemMeta}>Qté: {item.quantity}{item.estimatedWeight ? ` • ${item.estimatedWeight} kg` : ''}</Text>
            </View>
          </View>
        ))}
      </Card>

      {isPending && <Button title="✅ Accepter la mission" onPress={handleAccept} loading={isLoading} fullWidth size="lg" style={styles.actionBtn} />}
      {isAccepted && <Button title="🚀 Démarrer la mission" onPress={handleStart} loading={isLoading} fullWidth size="lg" style={styles.actionBtn} />}
      {isInProgress && <Button title="🏁 Confirmer la livraison" onPress={handleComplete} loading={isLoading} fullWidth size="lg" style={styles.actionBtn} />}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { paddingHorizontal: 20, paddingTop: 56, paddingBottom: 40 },
  center: { flex: 1, backgroundColor: Colors.BACKGROUND, alignItems: 'center', justifyContent: 'center' },
  header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 20 },
  backBtn: { width: 40, height: 40, borderRadius: 20, backgroundColor: Colors.SURFACE, alignItems: 'center', justifyContent: 'center' },
  backText: { color: Colors.TEXT, fontSize: 18, fontWeight: '700' },
  title: { fontSize: 16, fontWeight: '700', color: Colors.TEXT },
  mapContainer: { height: 200, borderRadius: 16, overflow: 'hidden', marginBottom: 16 },
  section: { marginBottom: 14 },
  sectionTitle: { fontSize: 15, fontWeight: '700', color: Colors.TEXT, marginBottom: 12 },
  detailRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 12 },
  greenDot: { width: 14, height: 14, borderRadius: 7, backgroundColor: Colors.SUCCESS, marginTop: 4 },
  redDot: { width: 14, height: 14, borderRadius: 7, backgroundColor: Colors.PRIMARY, marginTop: 4 },
  detailLabel: { fontSize: 12, color: Colors.TEXT_SECONDARY, fontWeight: '600', marginBottom: 2 },
  detailValue: { fontSize: 14, color: Colors.TEXT },
  routeLine: { width: 2, height: 20, backgroundColor: Colors.BORDER, marginLeft: 6, marginVertical: 4 },
  priceRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 6 },
  priceLabel: { fontSize: 15, color: Colors.TEXT, fontWeight: '500' },
  priceValue: { fontSize: 24, fontWeight: '700', color: Colors.SUCCESS },
  commissionNote: { fontSize: 12, color: Colors.TEXT_SECONDARY },
  distanceNote: { fontSize: 12, color: Colors.TEXT_SECONDARY, marginTop: 2 },
  itemRow: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 10 },
  itemBorder: { borderTopWidth: 1, borderTopColor: Colors.BORDER },
  itemEmoji: { fontSize: 22 },
  itemDesc: { fontSize: 14, color: Colors.TEXT, fontWeight: '500' },
  itemMeta: { fontSize: 12, color: Colors.TEXT_SECONDARY, marginTop: 2 },
  actionBtn: { marginTop: 4 },
});
