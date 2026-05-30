import React from 'react';
import {
  ActivityIndicator,
  StyleSheet,
  Text,
  TouchableOpacity,
  TouchableOpacityProps,
  ViewStyle,
} from 'react-native';
import { Colors } from '../../constants/colors';

type Variant = 'primary' | 'secondary' | 'outline' | 'ghost' | 'danger';
type Size = 'sm' | 'md' | 'lg';

interface ButtonProps extends TouchableOpacityProps {
  title: string;
  variant?: Variant;
  size?: Size;
  loading?: boolean;
  fullWidth?: boolean;
  style?: ViewStyle;
}

export function Button({
  title,
  variant = 'primary',
  size = 'md',
  loading = false,
  fullWidth = false,
  style,
  disabled,
  ...rest
}: ButtonProps) {
  const isDisabled = disabled || loading;

  return (
    <TouchableOpacity
      style={[
        styles.base,
        styles[variant],
        styles[size],
        fullWidth && styles.fullWidth,
        isDisabled && styles.disabled,
        style,
      ]}
      disabled={isDisabled}
      activeOpacity={0.8}
      {...rest}
    >
      {loading ? (
        <ActivityIndicator
          size="small"
          color={variant === 'outline' || variant === 'ghost' ? Colors.PRIMARY : Colors.WHITE}
        />
      ) : (
        <Text style={[styles.text, styles[`text_${variant}`], styles[`text_${size}`]]}>
          {title}
        </Text>
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  base: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 12,
  },
  primary: { backgroundColor: Colors.PRIMARY },
  secondary: { backgroundColor: Colors.SURFACE },
  outline: { backgroundColor: Colors.TRANSPARENT, borderWidth: 1.5, borderColor: Colors.PRIMARY },
  ghost: { backgroundColor: Colors.TRANSPARENT },
  danger: { backgroundColor: Colors.ERROR },
  sm: { paddingHorizontal: 12, paddingVertical: 8 },
  md: { paddingHorizontal: 20, paddingVertical: 14 },
  lg: { paddingHorizontal: 28, paddingVertical: 18 },
  disabled: { opacity: 0.5 },
  fullWidth: { width: '100%' },
  text: { fontWeight: '600', letterSpacing: 0.3 },
  text_primary: { color: Colors.WHITE },
  text_secondary: { color: Colors.TEXT },
  text_outline: { color: Colors.PRIMARY },
  text_ghost: { color: Colors.PRIMARY },
  text_danger: { color: Colors.WHITE },
  text_sm: { fontSize: 13 },
  text_md: { fontSize: 15 },
  text_lg: { fontSize: 17 },
});
