import React from 'react';
import {
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '../../constants/colors';
import { useAuth } from '../../hooks/useAuth';
import { Avatar } from '../../components/ui/Avatar';
import { Card } from '../../components/ui/Card';

interface ServiceCardProps {
  emoji: string;
  title: string;
  description: string;
  active: boolean;
  onPress: () => void;
}

function ServiceCard({ emoji, title, description, active, onPress }: ServiceCardProps) {
  return (
    <TouchableOpacity
      onPress={active ? onPress : undefined}
      activeOpacity={active ? 0.8 : 1}
    >
      <Card style={[styles.serviceCard, !active && styles.serviceCardInactive]} elevated={active}>
        {!active && (
          <View style={styles.comingSoonBadge}>
            <Text style={styles.comingSoonText}>Bientôt</Text>
          </View>
        )}
        <Text style={styles.serviceEmoji}>{emoji}</Text>
        <Text style={[styles.serviceTitle, !active && styles.serviceTextDim]}>
          {title}
        </Text>
        <Text style={[styles.serviceDesc, !active && styles.serviceTextDim]}>
          {description}
        </Text>
        {active && (
          <View style={styles.serviceArrow}>
            <Text style={styles.serviceArrowText}>Commander →</Text>
          </View>
        )}
      </Card>
    </TouchableOpacity>
  );
}

export default function ClientHomeScreen() {
  const router = useRouter();
  const { user } = useAuth();

  return (
    <ScrollView
      style={styles.screen}
      contentContainerStyle={styles.container}
      showsVerticalScrollIndicator={false}
    >
      <View style={styles.header}>
        <View>
          <Text style={styles.greeting}>
            Bonjour, {user?.firstName ?? 'Client'} 👋
          </Text>
          <Text style={styles.headerSub}>Que voulez-vous faire aujourd'hui ?</Text>
        </View>
        <Avatar
          name={`${user?.firstName ?? ''} ${user?.lastName ?? ''}`}
          uri={user?.avatar}
          size="md"
        />
      </View>

      <View style={styles.heroBanner}>
        <Text style={styles.heroTitle}>JO'DRIVE</Text>
        <Text style={styles.heroTagline}>Mobilité • Livraison • Course</Text>
        <Text style={styles.heroSub}>Transport de confiance en Guyane</Text>
      </View>

      <Text style={styles.sectionTitle}>Nos services</Text>

      <View style={styles.servicesGrid}>
        <ServiceCard
          emoji="📦"
          title="Livraison"
          description="Transport de meubles, électroménager, matériaux"
          active
          onPress={() => router.push('/(client)/nouvelle-mission')}
        />
        <ServiceCard
          emoji="🚖"
          title="Transport"
          description="Déplacements personnels et professionnels"
          active={false}
          onPress={() => {}}
        />
        <ServiceCard
          emoji="🏃"
          title="Course rapide"
          description="Livraison express de colis urgents"
          active={false}
          onPress={() => {}}
        />
      </View>

      <Text style={styles.sectionTitle}>Mes missions</Text>
      <View style={styles.statsRow}>
        <Card style={styles.statCard}>
          <Text style={styles.statValue}>—</Text>
          <Text style={styles.statLabel}>En cours</Text>
        </Card>
        <Card style={styles.statCard}>
          <Text style={styles.statValue}>—</Text>
          <Text style={styles.statLabel}>Terminées</Text>
        </Card>
        <Card style={styles.statCard}>
          <Text style={styles.statValue}>—</Text>
          <Text style={styles.statLabel}>Annulées</Text>
        </Card>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { paddingHorizontal: 20, paddingTop: 60, paddingBottom: 40 },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  greeting: { fontSize: 22, fontWeight: '700', color: Colors.TEXT },
  headerSub: { fontSize: 14, color: Colors.TEXT_SECONDARY, marginTop: 2 },
  heroBanner: {
    backgroundColor: Colors.PRIMARY,
    borderRadius: 20,
    padding: 24,
    marginBottom: 32,
  },
  heroTitle: {
    fontSize: 36,
    fontWeight: '900',
    color: Colors.WHITE,
    letterSpacing: -1,
  },
  heroTagline: {
    fontSize: 13,
    color: 'rgba(255,255,255,0.8)',
    letterSpacing: 1.5,
    marginBottom: 8,
  },
  heroSub: { fontSize: 15, color: 'rgba(255,255,255,0.9)' },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: Colors.TEXT,
    marginBottom: 16,
  },
  servicesGrid: { gap: 12, marginBottom: 32 },
  serviceCard: { position: 'relative', overflow: 'hidden' },
  serviceCardInactive: { opacity: 0.6 },
  comingSoonBadge: {
    position: 'absolute',
    top: 12,
    right: 12,
    backgroundColor: Colors.BORDER,
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 999,
  },
  comingSoonText: { fontSize: 11, color: Colors.TEXT_SECONDARY, fontWeight: '600' },
  serviceEmoji: { fontSize: 36, marginBottom: 10 },
  serviceTitle: { fontSize: 18, fontWeight: '700', color: Colors.TEXT, marginBottom: 6 },
  serviceDesc: { fontSize: 14, color: Colors.TEXT_SECONDARY, lineHeight: 20 },
  serviceTextDim: { opacity: 0.7 },
  serviceArrow: { marginTop: 16 },
  serviceArrowText: { color: Colors.PRIMARY, fontWeight: '700', fontSize: 14 },
  statsRow: { flexDirection: 'row', gap: 12 },
  statCard: { flex: 1, alignItems: 'center', paddingVertical: 18 },
  statValue: { fontSize: 22, fontWeight: '700', color: Colors.TEXT, marginBottom: 4 },
  statLabel: { fontSize: 12, color: Colors.TEXT_SECONDARY },
});
