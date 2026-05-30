import React, { useState } from 'react';
import { FlatList, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { Avatar } from '../../components/ui/Avatar';
import { Badge } from '../../components/ui/Badge';
import { UserRole } from '../../types';

type Filter = 'ALL' | UserRole;

const FILTERS: { key: Filter; label: string }[] = [
  { key: 'ALL', label: 'Tous' },
  { key: 'CLIENT', label: 'Clients' },
  { key: 'TRANSPORTEUR', label: 'Transporteurs' },
  { key: 'ADMIN', label: 'Admins' },
];

export default function AdminUtilisateursScreen() {
  const [filter, setFilter] = useState<Filter>('ALL');

  return (
    <View style={styles.screen}>
      <View style={styles.headerSection}>
        <Text style={styles.title}>Utilisateurs</Text>
        <View style={styles.searchBar}>
          <Text style={styles.searchIcon}>🔍</Text>
          <Text style={styles.searchPlaceholder}>Rechercher un utilisateur...</Text>
        </View>
        <FlatList
          horizontal
          data={FILTERS}
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

      <View style={styles.emptyContainer}>
        <Text style={styles.emptyEmoji}>👥</Text>
        <Text style={styles.emptyTitle}>Aucun utilisateur</Text>
        <Text style={styles.emptyText}>Les utilisateurs inscrits apparaîtront ici.</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  headerSection: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 12 },
  title: { fontSize: 26, fontWeight: '700', color: Colors.TEXT, marginBottom: 16 },
  searchBar: { flexDirection: 'row', alignItems: 'center', backgroundColor: Colors.SURFACE, borderRadius: 12, paddingHorizontal: 14, paddingVertical: 12, borderWidth: 1, borderColor: Colors.BORDER, gap: 10, marginBottom: 14 },
  searchIcon: { fontSize: 16 },
  searchPlaceholder: { fontSize: 15, color: Colors.TEXT_SECONDARY },
  filterRow: { gap: 8, paddingBottom: 4 },
  filterChip: { paddingHorizontal: 16, paddingVertical: 8, borderRadius: 999, backgroundColor: Colors.SURFACE, borderWidth: 1, borderColor: Colors.BORDER },
  filterChipActive: { backgroundColor: Colors.PRIMARY, borderColor: Colors.PRIMARY },
  filterText: { fontSize: 13, fontWeight: '600', color: Colors.TEXT_SECONDARY },
  filterTextActive: { color: Colors.WHITE },
  emptyContainer: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 40 },
  emptyEmoji: { fontSize: 56, marginBottom: 16 },
  emptyTitle: { fontSize: 20, fontWeight: '700', color: Colors.TEXT, marginBottom: 8 },
  emptyText: { fontSize: 14, color: Colors.TEXT_SECONDARY, textAlign: 'center' },
});
