import React, { useEffect, useState } from 'react';
import { FlatList, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '../../constants/colors';
import { useMissions } from '../../hooks/useMissions';
import { MissionCard } from '../../components/mission/MissionCard';
import { MissionStatus } from '../../types';

type StatusFilter = 'ALL' | MissionStatus;

const STATUS_FILTERS: { key: StatusFilter; label: string }[] = [
  { key: 'ALL', label: 'Toutes' },
  { key: 'PENDING', label: 'En attente' },
  { key: 'ACCEPTED', label: 'Acceptées' },
  { key: 'IN_PROGRESS', label: 'En cours' },
  { key: 'COMPLETED', label: 'Terminées' },
  { key: 'CANCELLED', label: 'Annulées' },
];

export default function AdminMissionsScreen() {
  const router = useRouter();
  const { list, loadMissions, isLoading } = useMissions();
  const [filter, setFilter] = useState<StatusFilter>('ALL');

  useEffect(() => {
    loadMissions();
  }, []);

  const filtered = filter === 'ALL' ? list : list.filter((m) => m.status === filter);

  return (
    <View style={styles.screen}>
      <View style={styles.headerSection}>
        <Text style={styles.title}>Toutes les missions</Text>
        <FlatList
          horizontal
          data={STATUS_FILTERS}
          keyExtractor={(f) => f.key}
          renderItem={({ item }) => (
            <TouchableOpacity
              style={[styles.filterChip, filter === item.key && styles.filterChipActive]}
              onPress={() => setFilter(item.key)}
            >
              <Text style={[styles.filterText, filter === item.key && styles.filterTextActive]}>
                {item.label}
              </Text>
            </TouchableOpacity>
          )}
          contentContainerStyle={styles.filterRow}
          showsHorizontalScrollIndicator={false}
        />
      </View>

      <FlatList
        data={filtered}
        keyExtractor={(m) => m.id}
        renderItem={({ item }) => (
          <MissionCard mission={item} onPress={() => {}} />
        )}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        onRefresh={loadMissions}
        refreshing={isLoading}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Text style={styles.emptyEmoji}>📭</Text>
            <Text style={styles.emptyTitle}>Aucune mission</Text>
          </View>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  headerSection: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 12 },
  title: { fontSize: 26, fontWeight: '700', color: Colors.TEXT, marginBottom: 16 },
  filterRow: { gap: 8, paddingBottom: 4 },
  filterChip: { paddingHorizontal: 14, paddingVertical: 8, borderRadius: 999, backgroundColor: Colors.SURFACE, borderWidth: 1, borderColor: Colors.BORDER },
  filterChipActive: { backgroundColor: Colors.PRIMARY, borderColor: Colors.PRIMARY },
  filterText: { fontSize: 13, fontWeight: '600', color: Colors.TEXT_SECONDARY },
  filterTextActive: { color: Colors.WHITE },
  list: { paddingHorizontal: 20, paddingTop: 12, paddingBottom: 40 },
  emptyContainer: { alignItems: 'center', paddingTop: 60 },
  emptyEmoji: { fontSize: 48, marginBottom: 12 },
  emptyTitle: { fontSize: 18, fontWeight: '700', color: Colors.TEXT_SECONDARY },
});
