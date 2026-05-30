import React, { useEffect } from 'react';
import { ActivityIndicator, FlatList, StyleSheet, Text, View } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '../../constants/colors';
import { useMissions } from '../../hooks/useMissions';
import { MissionCard } from '../../components/mission/MissionCard';
import { Mission } from '../../types';

export default function HistoriqueScreen() {
  const router = useRouter();
  const { list, isLoading, loadMissions } = useMissions();

  useEffect(() => { loadMissions(); }, []);

  if (isLoading && list.length === 0) {
    return (
      <View style={styles.center}>
        <ActivityIndicator size="large" color={Colors.PRIMARY} />
      </View>
    );
  }

  return (
    <View style={styles.screen}>
      <View style={styles.headerSection}>
        <Text style={styles.title}>Mes missions</Text>
        <Text style={styles.subtitle}>{list.length} mission{list.length > 1 ? 's' : ''}</Text>
      </View>

      {list.length === 0 ? (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyEmoji}>📭</Text>
          <Text style={styles.emptyTitle}>Aucune mission</Text>
          <Text style={styles.emptyText}>Vos missions apparaîtront ici une fois que vous en aurez créé.</Text>
        </View>
      ) : (
        <FlatList
          data={list}
          keyExtractor={(item) => item.id}
          renderItem={({ item }: { item: Mission }) => (
            <MissionCard
              mission={item}
              onPress={(m) => router.push(`/(client)/mission/${m.id}`)}
            />
          )}
          contentContainerStyle={styles.list}
          showsVerticalScrollIndicator={false}
          onRefresh={() => loadMissions()}
          refreshing={isLoading}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  center: { flex: 1, backgroundColor: Colors.BACKGROUND, alignItems: 'center', justifyContent: 'center' },
  headerSection: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 20 },
  title: { fontSize: 26, fontWeight: '700', color: Colors.TEXT },
  subtitle: { fontSize: 14, color: Colors.TEXT_SECONDARY, marginTop: 4 },
  list: { paddingHorizontal: 20, paddingBottom: 40 },
  emptyContainer: { flex: 1, alignItems: 'center', justifyContent: 'center', paddingHorizontal: 40 },
  emptyEmoji: { fontSize: 56, marginBottom: 16 },
  emptyTitle: { fontSize: 20, fontWeight: '700', color: Colors.TEXT, marginBottom: 8 },
  emptyText: { fontSize: 14, color: Colors.TEXT_SECONDARY, textAlign: 'center', lineHeight: 20 },
});
