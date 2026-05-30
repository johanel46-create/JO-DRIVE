import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { Mission } from '../../types';
import { Card } from '../ui/Card';
import { MissionStatusBadge } from '../ui/Badge';

interface MissionCardProps {
  mission: Mission;
  onPress: (mission: Mission) => void;
}

function formatDate(dateStr: string): string {
  const d = new Date(dateStr);
  return d.toLocaleDateString('fr-FR', {
    day: '2-digit',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit',
  });
}

export function MissionCard({ mission, onPress }: MissionCardProps) {
  return (
    <TouchableOpacity onPress={() => onPress(mission)} activeOpacity={0.8}>
      <Card style={styles.card} elevated>
        <View style={styles.header}>
          <View style={styles.idRow}>
            <Text style={styles.idText}>#{mission.id.slice(0, 8).toUpperCase()}</Text>
            <MissionStatusBadge status={mission.status} />
          </View>
          <Text style={styles.price}>{mission.price.toFixed(2)} €</Text>
        </View>

        <View style={styles.route}>
          <View style={styles.routeRow}>
            <View style={styles.dot} />
            <Text style={styles.address} numberOfLines={1}>{mission.pickupAddress}</Text>
          </View>
          <View style={styles.routeLine} />
          <View style={styles.routeRow}>
            <View style={[styles.dot, styles.dotDestination]} />
            <Text style={styles.address} numberOfLines={1}>{mission.deliveryAddress}</Text>
          </View>
        </View>

        <View style={styles.footer}>
          <Text style={styles.meta}>{mission.items.length} objet{mission.items.length > 1 ? 's' : ''}</Text>
          {mission.distance != null && (
            <Text style={styles.meta}>{mission.distance.toFixed(1)} km</Text>
          )}
          <Text style={styles.meta}>{formatDate(mission.createdAt)}</Text>
        </View>
      </Card>
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: { marginBottom: 12 },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: 14 },
  idRow: { flexDirection: 'row', alignItems: 'center', gap: 8 },
  idText: { fontSize: 12, color: Colors.TEXT_SECONDARY, fontWeight: '600' },
  price: { fontSize: 18, fontWeight: '700', color: Colors.PRIMARY },
  route: { marginBottom: 14 },
  routeRow: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  routeLine: { width: 2, height: 18, backgroundColor: Colors.BORDER, marginLeft: 7, marginVertical: 2 },
  dot: { width: 14, height: 14, borderRadius: 7, backgroundColor: Colors.SUCCESS, borderWidth: 2, borderColor: Colors.SURFACE },
  dotDestination: { backgroundColor: Colors.PRIMARY },
  address: { flex: 1, fontSize: 14, color: Colors.TEXT, fontWeight: '500' },
  footer: { flexDirection: 'row', justifyContent: 'space-between', borderTopWidth: 1, borderTopColor: Colors.BORDER, paddingTop: 12 },
  meta: { fontSize: 12, color: Colors.TEXT_SECONDARY },
});
