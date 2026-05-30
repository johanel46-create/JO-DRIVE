import { Colors } from './colors';

export const Theme = {
  colors: Colors,

  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  },

  borderRadius: {
    sm: 6,
    md: 12,
    lg: 16,
    xl: 24,
    full: 9999,
  },

  typography: {
    h1: {
      fontSize: 32,
      fontWeight: '700' as const,
      color: Colors.TEXT,
      letterSpacing: -0.5,
    },
    h2: {
      fontSize: 24,
      fontWeight: '700' as const,
      color: Colors.TEXT,
    },
    h3: {
      fontSize: 20,
      fontWeight: '600' as const,
      color: Colors.TEXT,
    },
    body: {
      fontSize: 16,
      fontWeight: '400' as const,
      color: Colors.TEXT,
    },
    caption: {
      fontSize: 13,
      fontWeight: '400' as const,
      color: Colors.TEXT_SECONDARY,
    },
    label: {
      fontSize: 14,
      fontWeight: '500' as const,
      color: Colors.TEXT,
    },
  },

  shadows: {
    sm: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 1 },
      shadowOpacity: 0.3,
      shadowRadius: 4,
      elevation: 2,
    },
    md: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 4 },
      shadowOpacity: 0.4,
      shadowRadius: 8,
      elevation: 4,
    },
    lg: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 8 },
      shadowOpacity: 0.5,
      shadowRadius: 16,
      elevation: 8,
    },
  },
} as const;
