import { Tabs } from 'expo-router';
import { Text } from 'react-native';
import { Colors } from '../../constants/colors';

function TabIcon({ emoji, focused }: { emoji: string; focused: boolean }) {
  return <Text style={{ fontSize: 22, opacity: focused ? 1 : 0.5 }}>{emoji}</Text>;
}

export default function AdminLayout() {
  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarStyle: {
          backgroundColor: Colors.SURFACE,
          borderTopColor: Colors.BORDER,
          borderTopWidth: 1,
          paddingBottom: 20,
          paddingTop: 10,
          height: 70,
        },
        tabBarActiveTintColor: Colors.PRIMARY,
        tabBarInactiveTintColor: Colors.TEXT_SECONDARY,
        tabBarLabelStyle: { fontSize: 10, fontWeight: '600' },
      }}
    >
      <Tabs.Screen name="dashboard" options={{ title: 'Dashboard', tabBarIcon: ({ focused }) => <TabIcon emoji="📊" focused={focused} /> }} />
      <Tabs.Screen name="utilisateurs" options={{ title: 'Utilisateurs', tabBarIcon: ({ focused }) => <TabIcon emoji="👥" focused={focused} /> }} />
      <Tabs.Screen name="missions" options={{ title: 'Missions', tabBarIcon: ({ focused }) => <TabIcon emoji="📦" focused={focused} /> }} />
      <Tabs.Screen name="commissions" options={{ title: 'Commissions', tabBarIcon: ({ focused }) => <TabIcon emoji="💳" focused={focused} /> }} />
      <Tabs.Screen name="statistiques" options={{ title: 'Stats', tabBarIcon: ({ focused }) => <TabIcon emoji="📈" focused={focused} /> }} />
    </Tabs>
  );
}
