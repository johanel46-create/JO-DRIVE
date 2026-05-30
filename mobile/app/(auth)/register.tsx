import React, { useEffect, useState } from 'react';
import {
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useRouter } from 'expo-router';
import { useAuth } from '../../hooks/useAuth';
import { Button } from '../../components/ui/Button';
import { Input } from '../../components/ui/Input';
import { Colors } from '../../constants/colors';
import { UserRole } from '../../types';

export default function RegisterScreen() {
  const router = useRouter();
  const { register, isLoading, error, clearError, isAuthenticated, user } = useAuth();

  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState<UserRole>('CLIENT');

  useEffect(() => {
    if (isAuthenticated && user) {
      if (user.role === 'CLIENT') router.replace('/(client)/');
      else if (user.role === 'TRANSPORTEUR') router.replace('/(transporteur)/dashboard');
    }
  }, [isAuthenticated, user]);

  useEffect(() => {
    if (error) {
      Alert.alert("Erreur d'inscription", error, [{ text: 'OK', onPress: clearError }]);
    }
  }, [error]);

  const handleRegister = async () => {
    if (!firstName || !lastName || !email || !phone || !password) {
      Alert.alert('Champs requis', 'Veuillez remplir tous les champs.');
      return;
    }
    if (password.length < 8) {
      Alert.alert('Mot de passe', 'Le mot de passe doit contenir au moins 8 caractères.');
      return;
    }
    await register({
      firstName,
      lastName,
      email: email.trim().toLowerCase(),
      phone,
      password,
      role,
    });
  };

  return (
    <KeyboardAvoidingView
      style={styles.flex}
      behavior={Platform.OS === 'ios' ? 'padding' : undefined}
    >
      <ScrollView
        contentContainerStyle={styles.container}
        keyboardShouldPersistTaps="handled"
      >
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backText}>← Retour</Text>
        </TouchableOpacity>

        <Text style={styles.title}>Créer un compte</Text>
        <Text style={styles.subtitle}>Rejoignez JO'DRIVE dès maintenant</Text>

        <View style={styles.roleSection}>
          <Text style={styles.roleLabel}>Je suis :</Text>
          <View style={styles.roleRow}>
            {(['CLIENT', 'TRANSPORTEUR'] as UserRole[]).map((r) => (
              <TouchableOpacity
                key={r}
                style={[styles.roleBtn, role === r && styles.roleBtnActive]}
                onPress={() => setRole(r)}
                activeOpacity={0.8}
              >
                <Text style={styles.roleIcon}>
                  {r === 'CLIENT' ? '👤' : '🚚'}
                </Text>
                <Text
                  style={[styles.roleBtnText, role === r && styles.roleBtnTextActive]}
                >
                  {r === 'CLIENT' ? 'Client' : 'Transporteur'}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>

        <View style={styles.row}>
          <View style={styles.flex}>
            <Input
              label="Prénom"
              value={firstName}
              onChangeText={setFirstName}
              placeholder="Jean"
              autoCapitalize="words"
            />
          </View>
          <View style={styles.flex}>
            <Input
              label="Nom"
              value={lastName}
              onChangeText={setLastName}
              placeholder="Dupont"
              autoCapitalize="words"
            />
          </View>
        </View>

        <Input
          label="E-mail"
          value={email}
          onChangeText={setEmail}
          placeholder="jean@exemple.com"
          keyboardType="email-address"
          autoCapitalize="none"
        />

        <Input
          label="Téléphone"
          value={phone}
          onChangeText={setPhone}
          placeholder="+594 ..."
          keyboardType="phone-pad"
        />

        <Input
          label="Mot de passe"
          value={password}
          onChangeText={setPassword}
          placeholder="Minimum 8 caractères"
          secureTextEntry
          hint="Au moins 8 caractères, avec chiffres et lettres."
        />

        <Button
          title="Créer mon compte"
          onPress={handleRegister}
          loading={isLoading}
          fullWidth
          size="lg"
          style={styles.registerBtn}
        />

        <View style={styles.footer}>
          <Text style={styles.footerText}>Déjà inscrit ? </Text>
          <TouchableOpacity onPress={() => router.back()}>
            <Text style={styles.footerLink}>Se connecter</Text>
          </TouchableOpacity>
        </View>

        <Text style={styles.legal}>
          En vous inscrivant, vous acceptez nos Conditions Générales d'Utilisation
          et notre Politique de Confidentialité.
        </Text>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  flex: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: { flexGrow: 1, paddingHorizontal: 24, paddingTop: 56, paddingBottom: 40 },
  backBtn: { marginBottom: 24 },
  backText: { color: Colors.TEXT_SECONDARY, fontSize: 15 },
  title: { fontSize: 28, fontWeight: '700', color: Colors.TEXT, marginBottom: 6 },
  subtitle: { fontSize: 15, color: Colors.TEXT_SECONDARY, marginBottom: 28 },
  roleSection: { marginBottom: 24 },
  roleLabel: { fontSize: 14, color: Colors.TEXT_SECONDARY, fontWeight: '600', marginBottom: 10, textTransform: 'uppercase', letterSpacing: 0.5 },
  roleRow: { flexDirection: 'row', gap: 12 },
  roleBtn: {
    flex: 1,
    backgroundColor: Colors.SURFACE,
    borderRadius: 14,
    padding: 16,
    alignItems: 'center',
    borderWidth: 1.5,
    borderColor: Colors.BORDER,
    gap: 6,
  },
  roleBtnActive: { borderColor: Colors.PRIMARY, backgroundColor: 'rgba(227,6,19,0.06)' },
  roleIcon: { fontSize: 24 },
  roleBtnText: { color: Colors.TEXT_SECONDARY, fontWeight: '600', fontSize: 14 },
  roleBtnTextActive: { color: Colors.PRIMARY },
  row: { flexDirection: 'row', gap: 12 },
  registerBtn: { marginTop: 8 },
  footer: { flexDirection: 'row', justifyContent: 'center', marginTop: 24 },
  footerText: { color: Colors.TEXT_SECONDARY, fontSize: 14 },
  footerLink: { color: Colors.PRIMARY, fontSize: 14, fontWeight: '600' },
  legal: { fontSize: 11, color: Colors.TEXT_SECONDARY, textAlign: 'center', marginTop: 20, lineHeight: 17 },
});
