import React from 'react';
import { StyleSheet, View, ViewProps, ViewStyle } from 'react-native';
import { Colors } from '../../constants/colors';

interface CardProps extends ViewProps {
  children: React.ReactNode;
  style?: ViewStyle;
  padding?: 'none' | 'sm' | 'md' | 'lg';
  elevated?: boolean;
}

export function Card({
  children,
  style,
  padding = 'md',
  elevated = false,
  ...rest
}: CardProps) {
  return (
    <View
      style={[
        styles.card,
        styles[`padding_${padding}`],
        elevated && styles.elevated,
        style,
      ]}
      {...rest}
    >
      {children}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: Colors.SURFACE,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: Colors.BORDER,
  },
  padding_none: { padding: 0 },
  padding_sm: { padding: 12 },
  padding_md: { padding: 16 },
  padding_lg: { padding: 24 },
  elevated: {
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 8,
    elevation: 4,
  },
});
