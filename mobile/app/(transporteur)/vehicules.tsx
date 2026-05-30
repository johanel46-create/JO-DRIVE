import React, { useState } from 'react';
import {
  Alert,
  FlatList,
  Modal,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { Colors } from '../../constants/colors';
import { Vehicle, VehicleType } from '../../types';
import { Card } from '../../components/ui/Card';
import { Button } from '../../components/ui/Button';
import { Input } from '../../components/ui/Input';

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

export default function VehiculesScreen() {
  const [vehicles, setVehicles] = useState<Vehicle[]>([]);
  const [showModal, setShowModal] = useState(false);
  const [form, setForm] = useState({
    type: 'UTILITAIRE' as VehicleType,
    brand: '',
    model: '',
    licensePlate: '',
    year: '',
    maxWeight: '',
    volume: '',
  });

  const handleAdd = () => {
    if (!form.brand || !form.model || !form.licensePlate) {
      Alert.alert('Champs requis', 'Renseignez la marque, le modèle et la plaque.');
      return;
    }
    const newVehicle: Vehicle = {
      id: Date.now().toString(),
      transporteurId: '',
      type: form.type,
      brand: form.brand,
      model: form.model,
      licensePlate: form.licensePlate.toUpperCase(),
      year: parseInt(form.year) || new Date().getFullYear(),
      maxWeight: parseFloat(form.maxWeight) || 0,
      volume: parseFloat(form.volume) || 0,
      photos: [],
      isActive: true,
      createdAt: new Date().toISOString(),
    };
    setVehicles((prev) => [...prev, newVehicle]);
    setShowModal(false);
    setForm({ type: 'UTILITAIRE', brand: '', model: '', licensePlate: '', year: '', maxWeight: '', volume: '' });
  };

  return (
    <View style={styles.screen}>
      <View style={styles.headerSection}>
        <Text style={styles.title}>Mes véhicules</Text>
        <TouchableOpacity style={styles.addBtn} onPress={() => setShowModal(true)}>
          <Text style={styles.addBtnText}>+ Ajouter</Text>
        </TouchableOpacity>
      </View>

      {vehicles.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyEmoji}>🚗</Text>
          <Text style={styles.emptyTitle}>Aucun véhicule</Text>
          <Text style={styles.emptyText}>Ajoutez votre premier véhicule pour commencer à accepter des missions.</Text>
          <Button title="+ Ajouter un véhicule" onPress={() => setShowModal(true)} style={styles.emptyBtn} />
        </View>
      ) : (
        <FlatList
          data={vehicles}
          keyExtractor={(v) => v.id}
          contentContainerStyle={styles.list}
          renderItem={({ item: v }) => (
            <Card style={styles.vehicleCard} elevated>
              <View style={styles.vehicleHeader}>
                <Text style={styles.vehicleIcon}>{VEHICLE_ICONS[v.type]}</Text>
                <View style={styles.flex}>
                  <Text style={styles.vehicleName}>{v.brand} {v.model}</Text>
                  <Text style={styles.vehicleType}>{VEHICLE_LABELS[v.type]} • {v.year}</Text>
                </View>
                <View style={[styles.statusDot, v.isActive && styles.statusDotActive]} />
              </View>
              <View style={styles.vehicleDetails}>
                <Text style={styles.plateTag}>{v.licensePlate}</Text>
                <Text style={styles.capacityText}>{v.maxWeight} kg • {v.volume} m³</Text>
              </View>
            </Card>
          )}
          showsVerticalScrollIndicator={false}
        />
      )}

      {/* Add Vehicle Modal */}
      <Modal visible={showModal} animationType="slide" presentationStyle="pageSheet">
        <ScrollView style={styles.modal} contentContainerStyle={styles.modalContent}>
          <View style={styles.modalHeader}>
            <Text style={styles.modalTitle}>Nouveau véhicule</Text>
            <TouchableOpacity onPress={() => setShowModal(false)}>
              <Text style={styles.modalClose}>✕</Text>
            </TouchableOpacity>
          </View>

          <Text style={styles.fieldLabel}>Type de véhicule</Text>
          <View style={styles.typeRow}>
            {(['UTILITAIRE', 'FOURGON', 'CAMION'] as VehicleType[]).map((t) => (
              <TouchableOpacity
                key={t}
                style={[styles.typeBtn, form.type === t && styles.typeBtnActive]}
                onPress={() => setForm((f) => ({ ...f, type: t }))}
              >
                <Text style={styles.typeIcon}>{VEHICLE_ICONS[t]}</Text>
                <Text style={[styles.typeLabel, form.type === t && styles.typeLabelActive]}>
                  {VEHICLE_LABELS[t]}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          <Input label="Marque" value={form.brand} onChangeText={(v) => setForm((f) => ({ ...f, brand: v }))} placeholder="ex: Renault" />
          <Input label="Modèle" value={form.model} onChangeText={(v) => setForm((f) => ({ ...f, model: v }))} placeholder="ex: Master" />
          <Input label="Immatriculation" value={form.licensePlate} onChangeText={(v) => setForm((f) => ({ ...f, licensePlate: v }))} placeholder="ex: AB-123-CD" autoCapitalize="characters" />
          <View style={styles.row}>
            <View style={styles.flex}>
              <Input label="Année" value={form.year} onChangeText={(v) => setForm((f) => ({ ...f, year: v }))} placeholder="2023" keyboardType="numeric" />
            </View>
            <View style={styles.flex}>
              <Input label="Poids max (kg)" value={form.maxWeight} onChangeText={(v) => setForm((f) => ({ ...f, maxWeight: v }))} placeholder="ex: 1200" keyboardType="decimal-pad" />
            </View>
          </View>
          <Input label="Volume (m³)" value={form.volume} onChangeText={(v) => setForm((f) => ({ ...f, volume: v }))} placeholder="ex: 12" keyboardType="decimal-pad" />

          <Button title="Ajouter le véhicule" onPress={handleAdd} fullWidth size="lg" />
        </ScrollView>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  flex: { flex: 1 },
  headerSection: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', paddingHorizontal: 20, paddingTop: 60, paddingBottom: 20 },
  title: { fontSize: 26, fontWeight: '700', color: Colors.TEXT },
  addBtn: { backgroundColor: Colors.PRIMARY, paddingHorizontal: 16, paddingVertical: 8, borderRadius: 10 },
  addBtnText: { color: Colors.WHITE, fontWeight: '700', fontSize: 14 },
  list: { paddingHorizontal: 20, paddingBottom: 40 },
  emptyContainer: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 40 },
  emptyEmoji: { fontSize: 56, marginBottom: 16 },
  emptyTitle: { fontSize: 20, fontWeight: '700', color: Colors.TEXT, marginBottom: 8 },
  emptyText: { fontSize: 14, color: Colors.TEXT_SECONDARY, textAlign: 'center', lineHeight: 20, marginBottom: 24 },
  emptyBtn: {},
  vehicleCard: { marginBottom: 14 },
  vehicleHeader: { flexDirection: 'row', alignItems: 'center', gap: 14, marginBottom: 12 },
  vehicleIcon: { fontSize: 32 },
  vehicleName: { fontSize: 16, fontWeight: '700', color: Colors.TEXT },
  vehicleType: { fontSize: 13, color: Colors.TEXT_SECONDARY, marginTop: 2 },
  statusDot: { width: 10, height: 10, borderRadius: 5, backgroundColor: Colors.BORDER },
  statusDotActive: { backgroundColor: Colors.SUCCESS },
  vehicleDetails: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  plateTag: { backgroundColor: Colors.BORDER, paddingHorizontal: 12, paddingVertical: 4, borderRadius: 6, fontSize: 13, fontWeight: '700', color: Colors.TEXT },
  capacityText: { fontSize: 13, color: Colors.TEXT_SECONDARY },
  modal: { flex: 1, backgroundColor: Colors.BACKGROUND },
  modalContent: { padding: 24 },
  modalHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 24, paddingTop: 20 },
  modalTitle: { fontSize: 22, fontWeight: '700', color: Colors.TEXT },
  modalClose: { fontSize: 20, color: Colors.TEXT_SECONDARY },
  fieldLabel: { fontSize: 13, fontWeight: '600', color: Colors.TEXT_SECONDARY, textTransform: 'uppercase', letterSpacing: 0.5, marginBottom: 10 },
  typeRow: { flexDirection: 'row', gap: 10, marginBottom: 24 },
  typeBtn: { flex: 1, backgroundColor: Colors.SURFACE, borderRadius: 12, padding: 12, alignItems: 'center', borderWidth: 1.5, borderColor: Colors.BORDER, gap: 6 },
  typeBtnActive: { borderColor: Colors.PRIMARY, backgroundColor: 'rgba(227,6,19,0.06)' },
  typeIcon: { fontSize: 24 },
  typeLabel: { fontSize: 12, color: Colors.TEXT_SECONDARY, fontWeight: '600' },
  typeLabelActive: { color: Colors.PRIMARY },
  row: { flexDirection: 'row', gap: 12 },
});
