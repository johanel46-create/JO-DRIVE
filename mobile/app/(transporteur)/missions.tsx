import React, { useEffect, useState } from 'react';
import { FlatList, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '../../constants/colors';
import { useMissions } from '../../hooks/useMissions';
import { MissionCard } from '../../components/mission/MissionCard';

type Tab = 'available' | 'my';

export default function TransporteurMissionsScreen() {
  const router = useRouter();
  const { available, list, loadAvailable, loadMissions, isLoading } = useMissions();
  const [tab, setTab] = useState<Tab>('available');

  useEffect(() => { loadAvailable(); loadMissions(); }, []);

  const data = tab === 'available' ? available : list;

  return (
    <View style={styles.screen}>
      <View style={styles.headerSection}>
        <Text style={styles.title}>Missions</Text>
        <View style={styles.tabs}>
          {(['available', 'my'] as Tab[]).map((t) => (
            <TouchableOpacity key={t} style={[styles.tab, tab === t && styles.tabActive]} onPress={() => setTab(t)}>
              <Text style={[styles.tabText, tab === t && styles.tabTextActive]}>
                {t === 'available' ? 'Disponibles' : 'Mes missions'}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      <FlatList
        data={data}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <MissionCard mission={item} onPress={(m) => router.push(`/(transporteur)/mission/${m.id}`)} />
        )}
        contentContainerStyle={styles.list}
        showsVerticalScrollIndicator={false}
        onRefresh={() => { loadAvailable(); loadMissions(); }}
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
  headerSection: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 16 },
  title: { fontSize: 26, fontWeight: '700', color: Colors.TEXT, marginBottom: 16 },
  tabs: { flexDirection: 'row', backgroundColor: Colors.SURFACE, borderRadius: 12, padding: 4, gap: 4 },
  tab: { flex: 1, paddingVertical: 10, borderRadius: 10, alignItems: 'center' },
  tabActive: { backgroundColor: Colors.PRIMARY },
  tabText: { fontSize: 14, fontWeight: '600', color: Colors.TEXT_SECONDARY },
  tabTextActive: { color: Colors.WHITE },
  list: { paddingHorizontal: 20, paddingTop: 8, paddingBottom: 40 },
  emptyContainer: { alignItems: 'center', paddingTop: 60 },
  emptyEmoji: { fontSize: 48, marginBottom: 12 },
  emptyTitle: { fontSize: 18, fontWeight: '700', color: Colors.TEXT_SECONDARY },
});
