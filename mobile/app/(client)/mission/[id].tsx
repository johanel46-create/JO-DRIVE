import React, { useEffect, useState } from 'react';
import { ActivityIndicator, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useLocalSearchParams, useRouter } from 'expo-router';
import { Colors } from '../../../constants/colors';
import { useMissions } from '../../../hooks/useMissions';
import { useSocket } from '../../../hooks/useSocket';
import { GPSLocation } from '../../../types';
import { MissionStatusTracker } from '../../../components/mission/MissionStatus';
import { Card } from '../../../components/ui/Card';
import { Button } from '../../../components/ui/Button';
import { TrackingMap } from '../../../components/map/TrackingMap';

export default function ClientMissionDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const { current, loadMission, isLoading } = useMissions();
  const { connect, subscribeToMission, onGpsUpdate, disconnect } = useSocket();
  const [driverLocation, setDriverLocation] = useState<GPSLocation | undefined>();

  useEffect(() => { if (id) loadMission(id); }, [id]);

  useEffect(() => {
    if (!id) return;
    connect().then(() => {
      subscribeToMission(id);
      onGpsUpdate(id, (loc) => setDriverLocation(loc));
    });
    return () => disconnect();
  }, [id]);

  if (isLoading || !current) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color={Colors.PRIMARY} />
      </View>
    );
  }

  const mission = current;

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backText}>←</Text>
        </TouchableOpacity>
        <Text style={styles.title}>Suivi de mission</Text>
        <View style={{ width: 40 }} />
      </View>

      <View style={styles.mapContainer}>
        <TrackingMap
          pickupLat={mission.pickupLat}
          pickupLng={mission.pickupLng}
          deliveryLat={mission.deliveryLat}
          deliveryLng={mission.deliveryLng}
          driverLocation={driverLocation}
        />
      </View>

      <Card style={styles.section}>
        <Text style={styles.sectionTitle}>Avancement</Text>
        <MissionStatusTracker status={mission.status} />
      </Card>

      <Card style={styles.section}>
        <Text style={styles.sectionTitle}>Détails de la mission</Text>
        <View style={styles.detailRow}>
          <View style={styles.greenDot} />
          <View>
            <Text style={styles.detailLabel}>Enlèvement</Text>
            <Text style={styles.detailValue}>{mission.pickupAddress}</Text>
          </View>
        </View>
        <View style={styles.routeLine} />
        <View style={styles.detailRow}>
          <View style={styles.redDot} />
          <View>
            <Text style={styles.detailLabel}>Livraison</Text>
            <Text style={styles.detailValue}>{mission.deliveryAddress}</Text>
          </View>
        </View>
        <View style={styles.divider} />
        <View style={styles.metaGrid}>
          <View style={styles.metaItem}>
            <Text style={styles.metaLabel}>Prix</Text>
            <Text style={styles.metaValue}>{mission.price.toFixed(2)} €</Text>
          </View>
          {mission.distance && (
            <View style={styles.metaItem}>
              <Text style={styles.metaLabel}>Distance</Text>
              <Text style={styles.metaValue}>{mission.distance.toFixed(1)} km</Text>
            </View>
          )}
          <View style={styles.metaItem}>
            <Text style={styles.metaLabel}>Objets</Text>
            <Text style={styles.metaValue}>{mission.items.length}</Text>
          </View>
        </View>
      </Card>

      <Card style={styles.section}>
        <Text style={styles.sectionTitle}>Objets transportés</Text>
        {mission.items.map((item, i) => (
          <View key={item.id} style={[styles.itemRow, i > 0 && styles.itemBorder]}>
            <Text style={styles.itemEmoji}>📦</Text>
            <View style={{ flex: 1 }}>
              <Text style={styles.itemDesc}>{item.description}</Text>
              <Text style={styles.itemMeta}>Qté: {item.quantity}{item.estimatedWeight ? ` • ${item.estimatedWeight} kg` : ''}</Text>
            </View>
          </View>
        ))}
      </Card>

      {mission.transporteur && (
        <Card style={styles.section}>
          <Text style={styles.sectionTitle}>Votre transporteur</Text>
          <View style={styles.transporteurRow}>
            <View style={styles.transporteurAvatar}>
              <Text style={styles.transporteurInitial}>{mission.transporteur.firstName[0]}</Text>
            </View>
            <View>
              <Text style={styles.transporteurName}>{mission.transporteur.firstName} {mission.transporteur.lastName}</Text>
              <Text style={styles.transporteurPhone}>{mission.transporteur.phone}</Text>
            </View>
          </View>
        </Card>
      )}

      {mission.status === 'COMPLETED' && !mission.rating && (
        <Button title="⭐ Évaluer la mission" variant="outline" fullWidth onPress={() => {}} style={styles.rateBtn} />
      )}
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
  title: { fontSize: 17, fontWeight: '700', color: Colors.TEXT },
  mapContainer: { height: 220, borderRadius: 16, overflow: 'hidden', marginBottom: 16 },
  section: { marginBottom: 16 },
  sectionTitle: { fontSize: 15, fontWeight: '700', color: Colors.TEXT, marginBottom: 14 },
  detailRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 12 },
  greenDot: { width: 14, height: 14, borderRadius: 7, backgroundColor: Colors.SUCCESS, marginTop: 4 },
  redDot: { width: 14, height: 14, borderRadius: 7, backgroundColor: Colors.PRIMARY, marginTop: 4 },
  detailLabel: { fontSize: 12, color: Colors.TEXT_SECONDARY, fontWeight: '600', marginBottom: 2 },
  detailValue: { fontSize: 14, color: Colors.TEXT, lineHeight: 20 },
  routeLine: { width: 2, height: 20, backgroundColor: Colors.BORDER, marginLeft: 6, marginVertical: 4 },
  divider: { height: 1, backgroundColor: Colors.BORDER, marginVertical: 16 },
  metaGrid: { flexDirection: 'row', gap: 16 },
  metaItem: {},
  metaLabel: { fontSize: 12, color: Colors.TEXT_SECONDARY },
  metaValue: { fontSize: 16, fontWeight: '700', color: Colors.TEXT },
  itemRow: { flexDirection: 'row', alignItems: 'center', gap: 12, paddingVertical: 10 },
  itemBorder: { borderTopWidth: 1, borderTopColor: Colors.BORDER },
  itemEmoji: { fontSize: 22 },
  itemDesc: { fontSize: 14, color: Colors.TEXT, fontWeight: '500' },
  itemMeta: { fontSize: 12, color: Colors.TEXT_SECONDARY, marginTop: 2 },
  transporteurRow: { flexDirection: 'row', alignItems: 'center', gap: 14 },
  transporteurAvatar: { width: 48, height: 48, borderRadius: 24, backgroundColor: Colors.PRIMARY, alignItems: 'center', justifyContent: 'center' },
  transporteurInitial: { color: Colors.WHITE, fontSize: 20, fontWeight: '700' },
  transporteurName: { fontSize: 16, fontWeight: '600', color: Colors.TEXT },
  transporteurPhone: { fontSize: 13, color: Colors.TEXT_SECONDARY, marginTop: 2 },
  rateBtn: { marginTop: 4 },
});
