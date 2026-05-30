import React from 'react';
import { Alert, ScrollView, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { useAuth } from '../../hooks/useAuth';
import { Avatar } from '../../components/ui/Avatar';
import { Card } from '../../components/ui/Card';

function MenuItem({ emoji, label, onPress, danger }: { emoji: string; label: string; onPress: () => void; danger?: boolean }) {
  return (
    <TouchableOpacity style={styles.menuItem} onPress={onPress} activeOpacity={0.7}>
      <Text style={styles.menuEmoji}>{emoji}</Text>
      <Text style={[styles.menuLabel, danger && styles.menuLabelDanger]}>{label}</Text>
      <Text style={styles.menuArrow}>›</Text>
    </TouchableOpacity>
  );
}

export default function ClientProfilScreen() {
  const { user, logout } = useAuth();

  const handleLogout = () => {
    Alert.alert('Déconnexion', 'Voulez-vous vraiment vous déconnecter ?', [
      { text: 'Annuler', style: 'cancel' },
      { text: 'Déconnexion', style: 'destructive', onPress: () => logout() },
    ]);
  };

  return (
    <ScrollView style={styles.screen} contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
      <View style={styles.profileSection}>
        <Avatar name={`${user?.firstName ?? ''} ${user?.lastName ?? ''}`} uri={user?.avatar} size="xl" style={styles.avatar} />
        <Text style={styles.name}>{user?.firstName} {user?.lastName}</Text>
        <Text style={styles.email}>{user?.email}</Text>
        <View style={styles.roleBadge}>
          <Text style={styles.roleBadgeText}>Client</Text>
        </View>
      </View>

      <View style={styles.statsRow}>
        <View style={styles.statItem}><Text style={styles.statValue}>—</Text><Text style={styles.statLabel}>Missions</Text></View>
        <View style={styles.statDivider} />
        <View style={styles.statItem}><Text style={styles.statValue}>—</Text><Text style={styles.statLabel}>Note</Text></View>
        <View style={styles.statDivider} />
        <View style={styles.statItem}><Text style={styles.statValue}>—</Text><Text style={styles.statLabel}>Dépenses</Text></View>
      </View>

      <Text style={styles.sectionTitle}>Mon compte</Text>
      <Card style={styles.menuCard} padding="none">
        <MenuItem emoji="👤" label="Modifier mon profil" onPress={() => {}} />
        <View style={styles.menuSeparator} />
        <MenuItem emoji="🔔" label="Notifications" onPress={() => {}} />
        <View style={styles.menuSeparator} />
        <MenuItem emoji="💳" label="Moyens de paiement" onPress={() => {}} />
        <View style={styles.menuSeparator} />
        <MenuItem emoji="🛡️" label="Sécurité" onPress={() => {}} />
      </Card>

      <Text style={styles.sectionTitle}>Informations</Text>
      <Card style={styles.menuCard} padding="none">
        <MenuItem emoji="❓" label="Aide & Support" onPress={() => {}} />
        <View style={styles.menuSeparator} />
        <MenuItem emoji="📄" label="Conditions d'utilisation" onPress={() => {}} />
        <View style={styles.menuSeparator} />
        <MenuItem emoji="🔒" label="Politique de confidentialité" onPress={() => {}} />
      </Card>

      <Card style={styles.menuCard} padding="none">
        <MenuItem emoji="🚪" label="Se déconnecter" onPress={handleLogout} danger />
      </Card>

      <Text style={styles.version}>JO'DRIVE v1.0.0 • Guyane 🌿</Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  screen: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { paddingBottom: 60 },
  profileSection: { alignItems: 'center', paddingTop: 60, paddingBottom: 24, paddingHorizontal: 20 },
  avatar: { marginBottom: 16 },
  name: { fontSize: 22, fontWeight: '700', color: Colors.TEXT },
  email: { fontSize: 14, color: Colors.TEXT_SECONDARY, marginTop: 4, marginBottom: 12 },
  roleBadge: { backgroundColor: 'rgba(227,6,19,0.12)', paddingHorizontal: 14, paddingVertical: 5, borderRadius: 999 },
  roleBadgeText: { color: Colors.PRIMARY, fontWeight: '700', fontSize: 13 },
  statsRow: { flexDirection: 'row', backgroundColor: Colors.SURFACE, marginHorizontal: 20, borderRadius: 16, padding: 20, marginBottom: 28, borderWidth: 1, borderColor: Colors.BORDER },
  statItem: { flex: 1, alignItems: 'center' },
  statValue: { fontSize: 20, fontWeight: '700', color: Colors.TEXT, marginBottom: 4 },
  statLabel: { fontSize: 12, color: Colors.TEXT_SECONDARY },
  statDivider: { width: 1, backgroundColor: Colors.BORDER },
  sectionTitle: { fontSize: 14, fontWeight: '700', color: Colors.TEXT_SECONDARY, textTransform: 'uppercase', letterSpacing: 1, paddingHorizontal: 20, marginBottom: 10, marginTop: 8 },
  menuCard: { marginHorizontal: 20, marginBottom: 16 },
  menuItem: { flexDirection: 'row', alignItems: 'center', paddingVertical: 16, paddingHorizontal: 16, gap: 14 },
  menuEmoji: { fontSize: 20 },
  menuLabel: { flex: 1, fontSize: 15, color: Colors.TEXT, fontWeight: '500' },
  menuLabelDanger: { color: Colors.ERROR },
  menuArrow: { fontSize: 20, color: Colors.TEXT_SECONDARY },
  menuSeparator: { height: 1, backgroundColor: Colors.BORDER, marginLeft: 54 },
  version: { textAlign: 'center', fontSize: 12, color: Colors.TEXT_SECONDARY, marginTop: 8 },
});
