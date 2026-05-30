import React from 'react';
import { StyleSheet, Text, View, ViewStyle } from 'react-native';
import { Colors } from '../../constants/colors';
import { MissionStatus } from '../../types';

type BadgeVariant = 'default' | 'success' | 'warning' | 'error' | 'info';

interface BadgeProps {
  label: string;
  variant?: BadgeVariant;
  style?: ViewStyle;
}

export function Badge({ label, variant = 'default', style }: BadgeProps) {
  return (
    <View style={[styles.badge, styles[variant], style]}>
      <Text style={[styles.text, styles[`text_${variant}`]]}>{label}</Text>
    </View>
  );
}

export function MissionStatusBadge({ status }: { status: MissionStatus }) {
  const map: Record<MissionStatus, { label: string; variant: BadgeVariant }> = {
    PENDING: { label: 'En attente', variant: 'warning' },
    ACCEPTED: { label: 'Acceptée', variant: 'info' },
    IN_PROGRESS: { label: 'En cours', variant: 'info' },
    COMPLETED: { label: 'Terminée', variant: 'success' },
    CANCELLED: { label: 'Annulée', variant: 'error' },
  };
  const { label, variant } = map[status];
  return <Badge label={label} variant={variant} />;
}

const styles = StyleSheet.create({
  badge: {
    paddingHorizontal: 10,
    paddingVertical: 4,
    borderRadius: 999,
    alignSelf: 'flex-start',
  },
  text: { fontSize: 12, fontWeight: '600' },
  default: { backgroundColor: Colors.BORDER },
  success: { backgroundColor: 'rgba(34,197,94,0.15)' },
  warning: { backgroundColor: 'rgba(245,158,11,0.15)' },
  error: { backgroundColor: 'rgba(239,68,68,0.15)' },
  info: { backgroundColor: 'rgba(227,6,19,0.15)' },
  text_default: { color: Colors.TEXT_SECONDARY },
  text_success: { color: Colors.SUCCESS },
  text_warning: { color: Colors.WARNING },
  text_error: { color: Colors.ERROR },
  text_info: { color: Colors.PRIMARY },
});
