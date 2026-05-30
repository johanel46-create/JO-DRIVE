import React from 'react';
import { Image, StyleSheet, Text, View, ViewStyle } from 'react-native';
import { Colors } from '../../constants/colors';

type AvatarSize = 'sm' | 'md' | 'lg' | 'xl';

interface AvatarProps {
  uri?: string;
  name?: string;
  size?: AvatarSize;
  style?: ViewStyle;
}

const sizes: Record<AvatarSize, number> = {
  sm: 32,
  md: 44,
  lg: 56,
  xl: 80,
};

function getInitials(name?: string): string {
  if (!name) return '?';
  const parts = name.trim().split(' ');
  if (parts.length === 1) return parts[0][0].toUpperCase();
  return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
}

export function Avatar({ uri, name, size = 'md', style }: AvatarProps) {
  const dim = sizes[size];

  if (uri) {
    return (
      <Image
        source={{ uri }}
        style={[styles.avatar, { width: dim, height: dim, borderRadius: dim / 2 }, style]}
      />
    );
  }

  return (
    <View
      style={[
        styles.placeholder,
        { width: dim, height: dim, borderRadius: dim / 2 },
        style,
      ]}
    >
      <Text style={[styles.initials, { fontSize: dim * 0.38 }]}>
        {getInitials(name)}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  avatar: { backgroundColor: Colors.BORDER },
  placeholder: {
    backgroundColor: Colors.PRIMARY,
    alignItems: 'center',
    justifyContent: 'center',
  },
  initials: { color: Colors.WHITE, fontWeight: '700' },
});
