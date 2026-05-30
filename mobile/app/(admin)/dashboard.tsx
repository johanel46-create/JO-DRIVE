import React from 'react';
import { ScrollView, StyleSheet, Text, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { Card } from '../../components/ui/Card';

interface KpiCardProps {
  emoji: string;
  label: string;
  value: string;
  delta?: string;
  deltaUp?: boolean;
}

function KpiCard({ emoji, label, value, delta, deltaUp }: KpiCardProps) {
  return (
    <Card style={styles.kpiCard} elevated>
      <Text style={styles.kpiEmoji}>{emoji}</Text>
      <Text style={styles.kpiValue}>{value}</Text>
      <Text style={styles.kpiLabel}>{label}</Text>
      {delta && (
        <Text style={[styles.kpiDelta, deltaUp ? styles.kpiDeltaUp : styles.kpiDeltaDown]}>
          {deltaUp ? '↑' : '↓'} {delta}
        </Text>
      )}
    </Card>
  );
}

export default function AdminDashboard() {
  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.logoRow}>
          <Text style={styles.logoRed}>JO</Text>
          <Text style={styles.logoWhite}>'DRIVE</Text>
        </View>
        <Text style={styles.adminLabel}>Administration</Text>
      </View>

      {/* KPIs */}
      <Text style={styles.sectionTitle}>Vue d'ensemble</Text>
      <View style={styles.kpiGrid}>
        <KpiCard emoji="👥" label="Utilisateurs" value="—" />
        <KpiCard emoji="📦" label="Missions" value="—" />
        <KpiCard emoji="💰" label="Revenus" value="—" />
        <KpiCard emoji="🚚" label="Transporteurs" value="—" />
      </View>

      {/* Alerts */}
      <Text style={styles.sectionTitle}>Alertes</Text>
      <Card style={styles.alertCard}>
        <Text style={styles.alertEmoji}>✅</Text>
        <View>
          <Text style={styles.alertTitle}>Système opérationnel</Text>
          <Text style={styles.alertText}>Tous les services fonctionnent normalement.</Text>
        </View>
      </Card>

      {/* Quick Actions */}
      <Text style={styles.sectionTitle}>Actions rapides</Text>
      <View style={styles.actionsGrid}>
        {[
          { emoji: '📊', label: 'Exporter rapport' },
          { emoji: '🔔', label: 'Envoyer notification' },
          { emoji: '💳', label: 'Gestion commissions' },
          { emoji: '🛡️', label: 'Modération' },
        ].map((action) => (
          <Card key={action.label} style={styles.actionCard}>
            <Text style={styles.actionEmoji}>{action.emoji}</Text>
            <Text style={styles.actionLabel}>{action.label}</Text>
          </Card>
        ))}
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 40 },
  header: { marginBottom: 28 },
  logoRow: { flexDirection: 'row', alignItems: 'baseline', marginBottom: 4 },
  logoRed: { fontSize: 28, fontWeight: '900', color: Colors.PRIMARY },
  logoWhite: { fontSize: 28, fontWeight: '900', color: Colors.WHITE },
  adminLabel: { fontSize: 14, color: Colors.TEXT_SECONDARY, fontWeight: '600', textTransform: 'uppercase', letterSpacing: 1.5 },
  sectionTitle: { fontSize: 16, fontWeight: '700', color: Colors.TEXT, marginBottom: 14 },
  kpiGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 12, marginBottom: 28 },
  kpiCard: { width: '47%', alignItems: 'center', paddingVertical: 20, gap: 4 },
  kpiEmoji: { fontSize: 26, marginBottom: 4 },
  kpiValue: { fontSize: 24, fontWeight: '800', color: Colors.TEXT },
  kpiLabel: { fontSize: 12, color: Colors.TEXT_SECONDARY, textAlign: 'center' },
  kpiDelta: { fontSize: 12, fontWeight: '600' },
  kpiDeltaUp: { color: Colors.SUCCESS },
  kpiDeltaDown: { color: Colors.ERROR },
  alertCard: { flexDirection: 'row', alignItems: 'center', gap: 14, marginBottom: 28 },
  alertEmoji: { fontSize: 24 },
  alertTitle: { fontSize: 15, fontWeight: '600', color: Colors.SUCCESS },
  alertText: { fontSize: 13, color: Colors.TEXT_SECONDARY, marginTop: 2 },
  actionsGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 12 },
  actionCard: { width: '47%', alignItems: 'center', paddingVertical: 18, gap: 8 },
  actionEmoji: { fontSize: 24 },
  actionLabel: { fontSize: 13, fontWeight: '600', color: Colors.TEXT, textAlign: 'center' },
});
