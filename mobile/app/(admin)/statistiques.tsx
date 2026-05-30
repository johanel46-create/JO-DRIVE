import React, { useState } from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { Card } from '../../components/ui/Card';

type Period = 'week' | 'month' | 'year';

function StatBar({ label, value, max, color }: { label: string; value: number; max: number; color: string }) {
  const pct = max > 0 ? (value / max) * 100 : 0;
  return (
    <View style={styles.barRow}>
      <Text style={styles.barLabel}>{label}</Text>
      <View style={styles.barTrack}>
        <View style={[styles.barFill, { width: `${pct}%` as any, backgroundColor: color }]} />
      </View>
      <Text style={styles.barValue}>{value}</Text>
    </View>
  );
}

export default function AdminStatistiquesScreen() {
  const [period, setPeriod] = useState<Period>('month');

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
      <Text style={styles.title}>Statistiques</Text>

      {/* Period */}
      <View style={styles.periodSelector}>
        {(['week', 'month', 'year'] as Period[]).map((p) => (
          <TouchableOpacity
            key={p}
            style={[styles.periodBtn, period === p && styles.periodBtnActive]}
            onPress={() => setPeriod(p)}
          >
            <Text style={[styles.periodText, period === p && styles.periodTextActive]}>
              {p === 'week' ? 'Semaine' : p === 'month' ? 'Mois' : 'Année'}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      {/* Main KPIs */}
      <View style={styles.kpiRow}>
        <Card style={styles.kpiCard} elevated>
          <Text style={styles.kpiEmoji}>📦</Text>
          <Text style={styles.kpiValue}>—</Text>
          <Text style={styles.kpiLabel}>Missions</Text>
        </Card>
        <Card style={styles.kpiCard} elevated>
          <Text style={styles.kpiEmoji}>💰</Text>
          <Text style={styles.kpiValue}>— €</Text>
          <Text style={styles.kpiLabel}>CA total</Text>
        </Card>
      </View>
      <View style={styles.kpiRow}>
        <Card style={styles.kpiCard} elevated>
          <Text style={styles.kpiEmoji}>👥</Text>
          <Text style={styles.kpiValue}>—</Text>
          <Text style={styles.kpiLabel}>Nouveaux users</Text>
        </Card>
        <Card style={styles.kpiCard} elevated>
          <Text style={styles.kpiEmoji}>⭐</Text>
          <Text style={styles.kpiValue}>—</Text>
          <Text style={styles.kpiLabel}>Note moyenne</Text>
        </Card>
      </View>

      {/* Mission Status Distribution */}
      <Text style={styles.sectionTitle}>Répartition des missions</Text>
      <Card style={styles.chartCard}>
        <StatBar label="Terminées" value={0} max={100} color={Colors.SUCCESS} />
        <StatBar label="En cours" value={0} max={100} color={Colors.PRIMARY} />
        <StatBar label="En attente" value={0} max={100} color={Colors.WARNING} />
        <StatBar label="Annulées" value={0} max={100} color={Colors.ERROR} />
      </Card>

      {/* Top Transporteurs */}
      <Text style={styles.sectionTitle}>Top transporteurs</Text>
      <Card style={styles.emptyCard}>
        <Text style={styles.emptyText}>Aucune donnée disponible pour le moment.</Text>
      </Card>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 40 },
  title: { fontSize: 26, fontWeight: '700', color: Colors.TEXT, marginBottom: 20 },
  periodSelector: { flexDirection: 'row', backgroundColor: Colors.SURFACE, borderRadius: 12, padding: 4, marginBottom: 20 },
  periodBtn: { flex: 1, paddingVertical: 8, borderRadius: 10, alignItems: 'center' },
  periodBtnActive: { backgroundColor: Colors.PRIMARY },
  periodText: { fontSize: 13, fontWeight: '600', color: Colors.TEXT_SECONDARY },
  periodTextActive: { color: Colors.WHITE },
  kpiRow: { flexDirection: 'row', gap: 12, marginBottom: 12 },
  kpiCard: { flex: 1, alignItems: 'center', paddingVertical: 20, gap: 4 },
  kpiEmoji: { fontSize: 24 },
  kpiValue: { fontSize: 22, fontWeight: '700', color: Colors.TEXT },
  kpiLabel: { fontSize: 12, color: Colors.TEXT_SECONDARY, textAlign: 'center' },
  sectionTitle: { fontSize: 16, fontWeight: '700', color: Colors.TEXT, marginBottom: 14, marginTop: 16 },
  chartCard: { gap: 14 },
  barRow: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  barLabel: { width: 80, fontSize: 13, color: Colors.TEXT_SECONDARY },
  barTrack: { flex: 1, height: 8, backgroundColor: Colors.BORDER, borderRadius: 4, overflow: 'hidden' },
  barFill: { height: '100%', borderRadius: 4, minWidth: 4 },
  barValue: { width: 28, fontSize: 13, fontWeight: '600', color: Colors.TEXT, textAlign: 'right' },
  emptyCard: { alignItems: 'center', paddingVertical: 24 },
  emptyText: { fontSize: 14, color: Colors.TEXT_SECONDARY },
});
