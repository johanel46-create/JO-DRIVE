import React from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { Vehicle, VehicleType } from '../../types';

interface VehicleSelectorProps {
  vehicles: Vehicle[];
  selected?: string;
  onSelect: (vehicleId: string) => void;
}

const VEHICLE_ICONS: Record<VehicleType, string> = {
  UTILITAIRE: '🚐',
  FOURGON: '🚚',
  CAMION: '🏗️',
};

const VEHICLE_LABELS: Record<VehicleType, string> = {
  UTILITAIRE: 'Utilitaire',
  FOURGON: 'Fourgon',
  CAMION: 'Camion',
};

export function VehicleSelector({ vehicles, selected, onSelect }: VehicleSelectorProps) {
  return (
    <View>
      <Text style={styles.sectionTitle}>Choisir un véhicule</Text>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.scroll}>
        {vehicles.map((v) => {
          const isSelected = selected === v.id;
          return (
            <TouchableOpacity
              key={v.id}
              style={[styles.card, isSelected && styles.cardSelected]}
              onPress={() => onSelect(v.id)}
              activeOpacity={0.8}
            >
              <Text style={styles.icon}>{VEHICLE_ICONS[v.type]}</Text>
              <Text style={[styles.type, isSelected && styles.typeSelected]}>{VEHICLE_LABELS[v.type]}</Text>
              <Text style={styles.detail}>{v.brand} {v.model}</Text>
              <Text style={styles.plate}>{v.licensePlate}</Text>
              <Text style={styles.capacity}>{v.maxWeight} kg • {v.volume} m³</Text>
            </TouchableOpacity>
          );
        })}
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  sectionTitle: { fontSize: 16, fontWeight: '600', color: Colors.TEXT, marginBottom: 12 },
  scroll: { gap: 12, paddingBottom: 4 },
  card: { width: 140, backgroundColor: Colors.SURFACE, borderRadius: 14, padding: 14, borderWidth: 1.5, borderColor: Colors.BORDER },
  cardSelected: { borderColor: Colors.PRIMARY, backgroundColor: 'rgba(227,6,19,0.05)' },
  icon: { fontSize: 28, marginBottom: 8 },
  type: { fontSize: 14, fontWeight: '700', color: Colors.TEXT, marginBottom: 2 },
  typeSelected: { color: Colors.PRIMARY },
  detail: { fontSize: 12, color: Colors.TEXT_SECONDARY, marginBottom: 4 },
  plate: { fontSize: 12, color: Colors.TEXT_SECONDARY, fontWeight: '600', marginBottom: 8 },
  capacity: { fontSize: 11, color: Colors.TEXT_SECONDARY },
});
