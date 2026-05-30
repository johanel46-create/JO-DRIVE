import React, { useEffect, useState } from 'react';
import { ScrollView, StyleSheet, Switch, Text, TouchableOpacity, View } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '../../constants/colors';
import { useAuth } from '../../hooks/useAuth';
import { useMissions } from '../../hooks/useMissions';
import { MissionCard } from '../../components/mission/MissionCard';
import { Card } from '../../components/ui/Card';
import { Avatar } from '../../components/ui/Avatar';

export default function TransporteurDashboard() {
  const router = useRouter();
  const { user } = useAuth();
  const { available, loadAvailable, isLoading } = useMissions();
  const [isOnline, setIsOnline] = useState(false);

  useEffect(() => { if (isOnline) loadAvailable(); }, [isOnline]);

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
      <View style={styles.header}>
        <Avatar name={`${user?.firstName ?? ''} ${user?.lastName ?? ''}`} uri={user?.avatar} size="md" />
        <View style={styles.headerInfo}>
          <Text style={styles.greeting}>Bonjour, {user?.firstName}</Text>
          <Text style={styles.role}>Transporteur</Text>
        </View>
        <View style={styles.onlineToggle}>
          <Text style={[styles.onlineLabel, isOnline && styles.onlineLabelActive]}>
            {isOnline ? 'En ligne' : 'Hors ligne'}
          </Text>
          <Switch value={isOnline} onValueChange={setIsOnline} trackColor={{ false: Colors.BORDER, true: Colors.SUCCESS }} thumbColor={Colors.WHITE} />
        </View>
      </View>

      <View style={styles.statsGrid}>
        <Card style={styles.statCard}><Text style={styles.statEmoji}>🚀</Text><Text style={styles.statValue}>—</Text><Text style={styles.statLabel}>Aujourd'hui</Text></Card>
        <Card style={styles.statCard}><Text style={styles.statEmoji}>💰</Text><Text style={styles.statValue}>— €</Text><Text style={styles.statLabel}>Revenus</Text></Card>
        <Card style={styles.statCard}><Text style={styles.statEmoji}>⭐</Text><Text style={styles.statValue}>—</Text><Text style={styles.statLabel}>Note moy.</Text></Card>
      </View>

      <View style={styles.sectionHeader}>
        <Text style={styles.sectionTitle}>
          {isOnline ? `${available.length} mission${available.length > 1 ? 's' : ''} disponible${available.length > 1 ? 's' : ''}` : 'Missions disponibles'}
        </Text>
        {available.length > 0 && (
          <TouchableOpacity onPress={() => router.push('/(transporteur)/missions')}>
            <Text style={styles.seeAll}>Voir tout</Text>
          </TouchableOpacity>
        )}
      </View>

      {!isOnline ? (
        <Card style={styles.offlineCard}>
          <Text style={styles.offlineEmoji}>💤</Text>
          <Text style={styles.offlineTitle}>Vous êtes hors ligne</Text>
          <Text style={styles.offlineText}>Activez votre disponibilité pour recevoir des missions.</Text>
        </Card>
      ) : available.length === 0 ? (
        <Card style={styles.offlineCard}>
          <Text style={styles.offlineEmoji}>🔍</Text>
          <Text style={styles.offlineTitle}>Aucune mission disponible</Text>
          <Text style={styles.offlineText}>Restez connecté, une mission peut arriver à tout moment.</Text>
        </Card>
      ) : (
        available.slice(0, 3).map((m) => (
          <MissionCard key={m.id} mission={m} onPress={(mission) => router.push(`/(transporteur)/mission/${mission.id}`)} />
        ))
      )}
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 40 },
  header: { flexDirection: 'row', alignItems: 'center', gap: 12, marginBottom: 24 },
  headerInfo: { flex: 1 },
  greeting: { fontSize: 18, fontWeight: '700', color: Colors.TEXT },
  role: { fontSize: 13, color: Colors.TEXT_SECONDARY },
  onlineToggle: { alignItems: 'center', gap: 4 },
  onlineLabel: { fontSize: 11, color: Colors.TEXT_SECONDARY, fontWeight: '600' },
  onlineLabelActive: { color: Colors.SUCCESS },
  statsGrid: { flexDirection: 'row', gap: 10, marginBottom: 28 },
  statCard: { flex: 1, alignItems: 'center', paddingVertical: 16, gap: 4 },
  statEmoji: { fontSize: 20 },
  statValue: { fontSize: 18, fontWeight: '700', color: Colors.TEXT },
  statLabel: { fontSize: 11, color: Colors.TEXT_SECONDARY, textAlign: 'center' },
  sectionHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 },
  sectionTitle: { fontSize: 17, fontWeight: '700', color: Colors.TEXT },
  seeAll: { fontSize: 14, color: Colors.PRIMARY, fontWeight: '600' },
  offlineCard: { alignItems: 'center', paddingVertical: 32 },
  offlineEmoji: { fontSize: 40, marginBottom: 12 },
  offlineTitle: { fontSize: 17, fontWeight: '700', color: Colors.TEXT, marginBottom: 6 },
  offlineText: { fontSize: 14, color: Colors.TEXT_SECONDARY, textAlign: 'center', lineHeight: 20 },
});
