import React from 'react';
import { StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { BottomTabBarProps } from '@react-navigation/bottom-tabs';
import { Colors } from '../../constants/colors';

export function TabBar({ state, descriptors, navigation }: BottomTabBarProps) {
  return (
    <View style={styles.container}>
      {state.routes.map((route, index) => {
        const { options } = descriptors[route.key];
        const label =
          options.tabBarLabel !== undefined
            ? options.tabBarLabel
            : options.title !== undefined
            ? options.title
            : route.name;

        const isFocused = state.index === index;

        const onPress = () => {
          const event = navigation.emit({
            type: 'tabPress',
            target: route.key,
            canPreventDefault: true,
          });
          if (!isFocused && !event.defaultPrevented) {
            navigation.navigate(route.name);
          }
        };

        return (
          <TouchableOpacity key={route.key} onPress={onPress} style={styles.tab} activeOpacity={0.8}>
            {options.tabBarIcon?.({
              focused: isFocused,
              color: isFocused ? Colors.PRIMARY : Colors.TEXT_SECONDARY,
              size: 24,
            })}
            <Text style={[styles.label, isFocused ? styles.labelActive : styles.labelInactive]}>
              {typeof label === 'string' ? label : route.name}
            </Text>
            {isFocused && <View style={styles.indicator} />}
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    backgroundColor: Colors.SURFACE,
    borderTopWidth: 1,
    borderTopColor: Colors.BORDER,
    paddingBottom: 20,
    paddingTop: 10,
  },
  tab: { flex: 1, alignItems: 'center', justifyContent: 'center', position: 'relative', gap: 4 },
  label: { fontSize: 11, fontWeight: '600' },
  labelActive: { color: Colors.PRIMARY },
  labelInactive: { color: Colors.TEXT_SECONDARY },
  indicator: { position: 'absolute', top: -10, width: 4, height: 4, borderRadius: 2, backgroundColor: Colors.PRIMARY },
});
