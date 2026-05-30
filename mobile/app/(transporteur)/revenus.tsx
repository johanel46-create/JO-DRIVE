import React, { useState } from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { Card } from '../../components/ui/Card';

type Period = 'week' | 'month' | 'year';

export default function RevenusScreen() {
  const [period, setPeriod] = useState<Period>('month');

  const periodLabels: Record<Period, string> = {
    week: 'Cette semaine',
    month: 'Ce mois',
    year: 'Cette année',
  };

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
      <Text style={styles.title}>Mes revenus</Text>

      {/* Period Selector */}
      <View style={styles.periodSelector}>
        {(['week', 'month', 'year'] as Period[]).map((p) => (
          <TouchableOpacity
            key={p}
            style={[styles.periodBtn, period === p && styles.periodBtnActive]}
            onPress={() => setPeriod(p)}
          >
            <Text style={[styles.periodBtnText, period === p && styles.periodBtnTextActive]}>
              {periodLabels[p]}
            </Text>
          </TouchableOpacity>
        ))}
      </View>

      {/* Big Revenue Number */}
      <Card style={styles.heroCard} elevated>
        <Text style={styles.heroLabel}>{periodLabels[period]}</Text>
        <Text style={styles.heroAmount}>0,00 €</Text>
        <Text style={styles.heroDelta}>Aucune donnée disponible</Text>
      </Card>

      {/* Breakdown */}
      <View style={styles.breakdownGrid}>
        <Card style={styles.breakdownCard}>
          <Text style={styles.breakdownEmoji}>🚀</Text>
          <Text style={styles.breakdownValue}>0</Text>
          <Text style={styles.breakdownLabel}>Missions</Text>
        </Card>
        <Card style={styles.breakdownCard}>
          <Text style={styles.breakdownEmoji}>💳</Text>
          <Text style={styles.breakdownValue}>0,00 €</Text>
          <Text style={styles.breakdownLabel}>Commission</Text>
        </Card>
        <Card style={styles.breakdownCard}>
          <Text style={styles.breakdownEmoji}>⭐</Text>
          <Text style={styles.breakdownValue}>—</Text>
          <Text style={styles.breakdownLabel}>Note moy.</Text>
        </Card>
      </View>

      {/* Transactions */}
      <Text style={styles.sectionTitle}>Transactions</Text>
      <Card style={styles.emptyCard}>
        <Text style={styles.emptyEmoji}>💸</Text>
        <Text style={styles.emptyTitle}>Aucune transaction</Text>
        <Text style={styles.emptyText}>Vos paiements apparaîtront ici après chaque livraison terminée.</Text>
      </Card>

      {/* Withdrawal */}
      <Card style={styles.withdrawCard}>
        <Text style={styles.withdrawTitle}>Retirer mes fonds</Text>
        <Text style={styles.withdrawText}>
          Les fonds sont automatiquement virés sur votre compte bancaire chaque lundi.
        </Text>
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
  periodBtnText: { fontSize: 13, fontWeight: '600', color: Colors.TEXT_SECONDARY },
  periodBtnTextActive: { color: Colors.WHITE },
  heroCard: { alignItems: 'center', paddingVertical: 32, marginBottom: 16 },
  heroLabel: { fontSize: 14, color: Colors.TEXT_SECONDARY, marginBottom: 8 },
  heroAmount: { fontSize: 48, fontWeight: '900', color: Colors.TEXT, letterSpacing: -1 },
  heroDelta: { fontSize: 14, color: Colors.TEXT_SECONDARY, marginTop: 8 },
  breakdownGrid: { flexDirection: 'row', gap: 10, marginBottom: 28 },
  breakdownCard: { flex: 1, alignItems: 'center', paddingVertical: 16, gap: 6 },
  breakdownEmoji: { fontSize: 22 },
  breakdownValue: { fontSize: 16, fontWeight: '700', color: Colors.TEXT },
  breakdownLabel: { fontSize: 11, color: Colors.TEXT_SECONDARY, textAlign: 'center' },
  sectionTitle: { fontSize: 17, fontWeight: '700', color: Colors.TEXT, marginBottom: 14 },
  emptyCard: { alignItems: 'center', paddingVertical: 32, marginBottom: 16 },
  emptyEmoji: { fontSize: 36, marginBottom: 10 },
  emptyTitle: { fontSize: 16, fontWeight: '700', color: Colors.TEXT, marginBottom: 6 },
  emptyText: { fontSize: 13, color: Colors.TEXT_SECONDARY, textAlign: 'center', lineHeight: 18 },
  withdrawCard: { backgroundColor: 'rgba(34,197,94,0.08)', borderColor: 'rgba(34,197,94,0.3)', borderWidth: 1.5, borderRadius: 16, padding: 16 },
  withdrawTitle: { fontSize: 15, fontWeight: '700', color: Colors.SUCCESS, marginBottom: 6 },
  withdrawText: { fontSize: 13, color: Colors.TEXT_SECONDARY, lineHeight: 18 },
});
