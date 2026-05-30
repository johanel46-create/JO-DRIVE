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

export default function LoginScreen() {
  const router = useRouter();
  const { login, isLoading, error, clearError, isAuthenticated, user } = useAuth();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  useEffect(() => {
    if (isAuthenticated && user) {
      if (user.role === 'CLIENT') router.replace('/(client)/');
      else if (user.role === 'TRANSPORTEUR') router.replace('/(transporteur)/dashboard');
      else router.replace('/(admin)/dashboard');
    }
  }, [isAuthenticated, user]);

  useEffect(() => {
    if (error) {
      Alert.alert('Erreur de connexion', error, [{ text: 'OK', onPress: clearError }]);
    }
  }, [error]);

  const handleLogin = async () => {
    if (!email.trim() || !password.trim()) {
      Alert.alert('Champs requis', 'Veuillez remplir tous les champs.');
      return;
    }
    await login({ email: email.trim().toLowerCase(), password });
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
        <View style={styles.logoSection}>
          <View style={styles.logoContainer}>
            <Text style={styles.logoText}>JO</Text>
            <View style={styles.logoDivider} />
            <Text style={styles.logoTextWhite}>DRIVE</Text>
          </View>
          <Text style={styles.tagline}>Mobilité • Livraison • Course</Text>
        </View>

        <View style={styles.formSection}>
          <Text style={styles.title}>Connexion</Text>
          <Text style={styles.subtitle}>Bienvenue sur JO'DRIVE Guyane</Text>

          <Input
            label="Adresse e-mail"
            value={email}
            onChangeText={setEmail}
            placeholder="nom@exemple.com"
            keyboardType="email-address"
            autoCapitalize="none"
            autoComplete="email"
          />

          <Input
            label="Mot de passe"
            value={password}
            onChangeText={setPassword}
            placeholder="••••••••"
            secureTextEntry={!showPassword}
            rightIcon={
              <Text style={styles.showPassword}>
                {showPassword ? 'Masquer' : 'Voir'}
              </Text>
            }
            onRightIconPress={() => setShowPassword((v) => !v)}
          />

          <TouchableOpacity style={styles.forgotRow}>
            <Text style={styles.forgot}>Mot de passe oublié ?</Text>
          </TouchableOpacity>

          <Button
            title="Se connecter"
            onPress={handleLogin}
            loading={isLoading}
            fullWidth
            size="lg"
            style={styles.loginBtn}
          />
        </View>

        <View style={styles.footer}>
          <Text style={styles.footerText}>Pas encore de compte ? </Text>
          <TouchableOpacity onPress={() => router.push('/(auth)/register')}>
            <Text style={styles.footerLink}>S'inscrire</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  flex: { flex: 1, backgroundColor: Colors.BACKGROUND },
  container: {
    flexGrow: 1,
    paddingHorizontal: 24,
    paddingTop: 80,
    paddingBottom: 40,
  },
  logoSection: {
    alignItems: 'center',
    marginBottom: 56,
  },
  logoContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 0,
    marginBottom: 10,
  },
  logoText: {
    fontSize: 40,
    fontWeight: '900',
    color: Colors.PRIMARY,
    letterSpacing: -1,
  },
  logoDivider: {
    width: 3,
    height: 40,
    backgroundColor: Colors.WHITE,
    marginHorizontal: 6,
  },
  logoTextWhite: {
    fontSize: 40,
    fontWeight: '900',
    color: Colors.WHITE,
    letterSpacing: -1,
  },
  tagline: {
    fontSize: 13,
    color: Colors.TEXT_SECONDARY,
    letterSpacing: 1.5,
  },
  formSection: {
    flex: 1,
  },
  title: {
    fontSize: 28,
    fontWeight: '700',
    color: Colors.TEXT,
    marginBottom: 6,
  },
  subtitle: {
    fontSize: 15,
    color: Colors.TEXT_SECONDARY,
    marginBottom: 32,
  },
  forgotRow: {
    alignSelf: 'flex-end',
    marginTop: -8,
    marginBottom: 24,
  },
  forgot: {
    color: Colors.PRIMARY,
    fontSize: 14,
    fontWeight: '500',
  },
  loginBtn: {
    marginTop: 8,
  },
  showPassword: {
    color: Colors.PRIMARY,
    fontSize: 13,
    fontWeight: '600',
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: 32,
  },
  footerText: {
    color: Colors.TEXT_SECONDARY,
    fontSize: 14,
  },
  footerLink: {
    color: Colors.PRIMARY,
    fontSize: 14,
    fontWeight: '600',
  },
});
