export const Colors = {
  PRIMARY: '#E30613',
  BACKGROUND: '#0A0A0A',
  SURFACE: '#1A1A1A',
  TEXT: '#FFFFFF',
  TEXT_SECONDARY: '#999999',
  BORDER: '#2A2A2A',
  SUCCESS: '#22C55E',
  WARNING: '#F59E0B',
  ERROR: '#EF4444',
  TRANSPARENT: 'transparent',
  WHITE: '#FFFFFF',
  BLACK: '#000000',
  OVERLAY: 'rgba(0,0,0,0.6)',
} as const;

export type ColorKey = keyof typeof Colors;
