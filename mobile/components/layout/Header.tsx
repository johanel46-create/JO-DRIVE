import React from 'react';
import { Platform, StatusBar, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '../../constants/colors';

interface HeaderProps {
  title: string;
  subtitle?: string;
  showBack?: boolean;
  rightAction?: { label: string; onPress: () => void };
}

export function Header({ title, subtitle, showBack = false, rightAction }: HeaderProps) {
  const router = useRouter();

  return (
    <View style={styles.container}>
      <View style={styles.left}>
        {showBack && (
          <TouchableOpacity onPress={() => router.back()} style={styles.backBtn} activeOpacity={0.7}>
            <Text style={styles.backIcon}>←</Text>
          </TouchableOpacity>
        )}
        <View>
          <Text style={styles.title}>{title}</Text>
          {subtitle && <Text style={styles.subtitle}>{subtitle}</Text>}
        </View>
      </View>
      {rightAction && (
        <TouchableOpacity onPress={rightAction.onPress} activeOpacity={0.7}>
          <Text style={styles.rightLabel}>{rightAction.label}</Text>
        </TouchableOpacity>
      )}
    </View>
  );
}

const STATUS_BAR_HEIGHT = Platform.OS === 'android' ? StatusBar.currentHeight ?? 0 : 0;

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: STATUS_BAR_HEIGHT + 12,
    paddingBottom: 12,
    paddingHorizontal: 20,
    backgroundColor: Colors.BACKGROUND,
    borderBottomWidth: 1,
    borderBottomColor: Colors.BORDER,
  },
  left: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  backBtn: { width: 36, height: 36, borderRadius: 18, backgroundColor: Colors.SURFACE, alignItems: 'center', justifyContent: 'center' },
  backIcon: { color: Colors.TEXT, fontSize: 18, fontWeight: '700' },
  title: { fontSize: 20, fontWeight: '700', color: Colors.TEXT },
  subtitle: { fontSize: 13, color: Colors.TEXT_SECONDARY, marginTop: 1 },
  rightLabel: { fontSize: 15, color: Colors.PRIMARY, fontWeight: '600' },
});
