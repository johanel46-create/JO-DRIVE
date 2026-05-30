import React, { useEffect, useRef } from 'react';
import { StyleSheet, View, Text } from 'react-native';
import MapView, { Marker, Polyline, PROVIDER_GOOGLE } from 'react-native-maps';
import { Colors } from '../../constants/colors';
import { GPSLocation } from '../../types';

interface TrackingMapProps {
  pickupLat: number;
  pickupLng: number;
  deliveryLat: number;
  deliveryLng: number;
  driverLocation?: GPSLocation;
  routeCoords?: { latitude: number; longitude: number }[];
}

export function TrackingMap({
  pickupLat,
  pickupLng,
  deliveryLat,
  deliveryLng,
  driverLocation,
  routeCoords,
}: TrackingMapProps) {
  const mapRef = useRef<MapView>(null);

  useEffect(() => {
    if (driverLocation && mapRef.current) {
      mapRef.current.animateToRegion(
        {
          latitude: driverLocation.lat,
          longitude: driverLocation.lng,
          latitudeDelta: 0.02,
          longitudeDelta: 0.02,
        },
        600,
      );
    }
  }, [driverLocation]);

  const initialRegion = {
    latitude: (pickupLat + deliveryLat) / 2,
    longitude: (pickupLng + deliveryLng) / 2,
    latitudeDelta: Math.abs(pickupLat - deliveryLat) * 2 + 0.02,
    longitudeDelta: Math.abs(pickupLng - deliveryLng) * 2 + 0.02,
  };

  return (
    <View style={styles.container}>
      <MapView
        ref={mapRef}
        style={StyleSheet.absoluteFillObject}
        provider={PROVIDER_GOOGLE}
        initialRegion={initialRegion}
        customMapStyle={DARK_MAP_STYLE}
      >
        <Marker coordinate={{ latitude: pickupLat, longitude: pickupLng }} title="Enlèvement">
          <View style={[styles.markerContainer, styles.markerPickup]}>
            <Text style={styles.markerText}>A</Text>
          </View>
        </Marker>

        <Marker coordinate={{ latitude: deliveryLat, longitude: deliveryLng }} title="Livraison">
          <View style={[styles.markerContainer, styles.markerDelivery]}>
            <Text style={styles.markerText}>B</Text>
          </View>
        </Marker>

        {driverLocation && (
          <Marker coordinate={{ latitude: driverLocation.lat, longitude: driverLocation.lng }} title="Transporteur">
            <View style={styles.driverMarker}>
              <Text style={styles.driverEmoji}>🚚</Text>
            </View>
          </Marker>
        )}

        {routeCoords && routeCoords.length > 1 && (
          <Polyline coordinates={routeCoords} strokeColor={Colors.PRIMARY} strokeWidth={3} lineDashPattern={[8, 4]} />
        )}
      </MapView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, borderRadius: 16, overflow: 'hidden', backgroundColor: Colors.SURFACE },
  markerContainer: { width: 32, height: 32, borderRadius: 16, alignItems: 'center', justifyContent: 'center', borderWidth: 2, borderColor: Colors.WHITE },
  markerPickup: { backgroundColor: Colors.SUCCESS },
  markerDelivery: { backgroundColor: Colors.PRIMARY },
  markerText: { color: Colors.WHITE, fontWeight: '700', fontSize: 14 },
  driverMarker: { backgroundColor: Colors.SURFACE, borderRadius: 20, padding: 4, borderWidth: 2, borderColor: Colors.PRIMARY },
  driverEmoji: { fontSize: 20 },
});

const DARK_MAP_STYLE = [
  { elementType: 'geometry', stylers: [{ color: '#1a1a1a' }] },
  { elementType: 'labels.text.stroke', stylers: [{ color: '#0a0a0a' }] },
  { elementType: 'labels.text.fill', stylers: [{ color: '#757575' }] },
  { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#2a2a2a' }] },
  { featureType: 'road', elementType: 'geometry.stroke', stylers: [{ color: '#212121' }] },
  { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#0d1117' }] },
  { featureType: 'poi', elementType: 'labels', stylers: [{ visibility: 'off' }] },
];
