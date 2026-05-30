import React, { useState } from 'react';
import { ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { Card } from '../../components/ui/Card';

export default function AdminCommissionsScreen() {
  const [rate, setRate] = useState(15); // 15%

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
      <Text style={styles.title}>Commissions</Text>

      {/* Current Rate */}
      <Card style={styles.rateCard} elevated>
        <Text style={styles.rateLabel}>Taux de commission actuel</Text>
        <Text style={styles.rateValue}>{rate}%</Text>
        <Text style={styles.rateNote}>Appliqué à chaque mission complétée</Text>
        <View style={styles.rateButtons}>
          <TouchableOpacity style={styles.rateBtn} onPress={() => setRate((r) => Math.max(5, r - 1))}>
            <Text style={styles.rateBtnText}>−</Text>
          </TouchableOpacity>
          <TouchableOpacity style={[styles.rateBtn, styles.rateBtnPrimary]} onPress={() => setRate((r) => Math.min(30, r + 1))}>
            <Text style={[styles.rateBtnText, styles.rateBtnTextWhite]}>+</Text>
          </TouchableOpacity>
        </View>
      </Card>

      {/* Summary */}
      <View style={styles.summaryGrid}>
        <Card style={styles.summaryCard}>
          <Text style={styles.summaryEmoji}>💰</Text>
          <Text style={styles.summaryValue}>—</Text>
          <Text style={styles.summaryLabel}>Total collecté</Text>
        </Card>
        <Card style={styles.summaryCard}>
          <Text style={styles.summaryEmoji}>⏳</Text>
          <Text style={styles.summaryValue}>—</Text>
          <Text style={styles.summaryLabel}>En attente</Text>
        </Card>
        <Card style={styles.summaryCard}>
          <Text style={styles.summaryEmoji}>✅</Text>
          <Text style={styles.summaryValue}>—</Text>
          <Text style={styles.summaryLabel}>Versées</Text>
        </Card>
      </View>

      {/* Transactions */}
      <Text style={styles.sectionTitle}>Transactions récentes</Text>
      <Card style={styles.emptyCard}>
        <Text style={styles.emptyEmoji}>💸</Text>
        <Text style={styles.emptyTitle}>Aucune commission</Text>
        <Text style={styles.emptyText}>Les commissions apparaîtront ici après les premières missions.</Text>
      </Card>

      {/* Export */}
      <TouchableOpacity style={styles.exportBtn}>
        <Text style={styles.exportText}>📊 Exporter en CSV</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 40 },
  title: { fontSize: 26, fontWeight: '700', color: Colors.TEXT, marginBottom: 20 },
  rateCard: { alignItems: 'center', paddingVertical: 28, marginBottom: 20 },
  rateLabel: { fontSize: 14, color: Colors.TEXT_SECONDARY, marginBottom: 8 },
  rateValue: { fontSize: 64, fontWeight: '900', color: Colors.PRIMARY, letterSpacing: -2, lineHeight: 72 },
  rateNote: { fontSize: 13, color: Colors.TEXT_SECONDARY, marginBottom: 20 },
  rateButtons: { flexDirection: 'row', gap: 16 },
  rateBtn: { width: 52, height: 52, borderRadius: 26, backgroundColor: Colors.SURFACE, borderWidth: 1.5, borderColor: Colors.BORDER, alignItems: 'center', justifyContent: 'center' },
  rateBtnPrimary: { backgroundColor: Colors.PRIMARY, borderColor: Colors.PRIMARY },
  rateBtnText: { fontSize: 24, fontWeight: '700', color: Colors.TEXT },
  rateBtnTextWhite: { color: Colors.WHITE },
  summaryGrid: { flexDirection: 'row', gap: 10, marginBottom: 28 },
  summaryCard: { flex: 1, alignItems: 'center', paddingVertical: 16, gap: 4 },
  summaryEmoji: { fontSize: 22 },
  summaryValue: { fontSize: 18, fontWeight: '700', color: Colors.TEXT },
  summaryLabel: { fontSize: 11, color: Colors.TEXT_SECONDARY, textAlign: 'center' },
  sectionTitle: { fontSize: 17, fontWeight: '700', color: Colors.TEXT, marginBottom: 14 },
  emptyCard: { alignItems: 'center', paddingVertical: 32, marginBottom: 20 },
  emptyEmoji: { fontSize: 36, marginBottom: 10 },
  emptyTitle: { fontSize: 16, fontWeight: '700', color: Colors.TEXT, marginBottom: 6 },
  emptyText: { fontSize: 13, color: Colors.TEXT_SECONDARY, textAlign: 'center', lineHeight: 18 },
  exportBtn: { backgroundColor: Colors.SURFACE, borderRadius: 12, paddingVertical: 16, alignItems: 'center', borderWidth: 1, borderColor: Colors.BORDER },
  exportText: { fontSize: 15, fontWeight: '600', color: Colors.TEXT },
});
