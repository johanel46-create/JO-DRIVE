import React, { useState } from 'react';
import {
  Alert, KeyboardAvoidingView, Platform, ScrollView,
  StyleSheet, Text, TouchableOpacity, View,
} from 'react-native';
import { useRouter } from 'expo-router';
import { Colors } from '../../constants/colors';
import { useMissions } from '../../hooks/useMissions';
import { Button } from '../../components/ui/Button';
import { Input } from '../../components/ui/Input';
import { Card } from '../../components/ui/Card';

interface ItemForm {
  description: string;
  quantity: string;
  estimatedWeight: string;
}

export default function NouvelleMissionScreen() {
  const router = useRouter();
  const { newMission, isLoading } = useMissions();

  const [step, setStep] = useState(1);
  const [pickupAddress, setPickupAddress] = useState('');
  const [deliveryAddress, setDeliveryAddress] = useState('');
  const [notes, setNotes] = useState('');
  const [items, setItems] = useState<ItemForm[]>([{ description: '', quantity: '1', estimatedWeight: '' }]);

  const addItem = () => setItems((prev) => [...prev, { description: '', quantity: '1', estimatedWeight: '' }]);
  const removeItem = (index: number) => { if (items.length === 1) return; setItems((prev) => prev.filter((_, i) => i !== index)); };
  const updateItem = (index: number, field: keyof ItemForm, value: string) => {
    setItems((prev) => prev.map((item, i) => (i === index ? { ...item, [field]: value } : item)));
  };

  const handleSubmit = async () => {
    if (!pickupAddress || !deliveryAddress) { Alert.alert('Adresses requises', 'Veuillez renseigner les deux adresses.'); return; }
    if (items.some((i) => !i.description)) { Alert.alert('Objets incomplets', 'Décrivez chaque objet à transporter.'); return; }
    const result = await newMission({
      pickupAddress, pickupLat: 4.922, pickupLng: -52.313,
      deliveryAddress, deliveryLat: 4.93, deliveryLng: -52.33,
      notes: notes || undefined,
      items: items.map((i) => ({
        description: i.description,
        quantity: parseInt(i.quantity, 10) || 1,
        estimatedWeight: i.estimatedWeight ? parseFloat(i.estimatedWeight) : undefined,
      })),
    });
    if (result.meta.requestStatus === 'fulfilled') {
      router.push(`/(client)/mission/${(result.payload as any).id}`);
    }
  };

  return (
    <KeyboardAvoidingView style={styles.flex} behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
      <ScrollView style={styles.flex} contentContainerStyle={styles.container} keyboardShouldPersistTaps="handled" showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <TouchableOpacity onPress={() => router.back()}><Text style={styles.back}>←</Text></TouchableOpacity>
          <Text style={styles.title}>Nouvelle livraison</Text>
          <View style={{ width: 24 }} />
        </View>

        <View style={styles.steps}>
          {[1, 2].map((s) => (
            <React.Fragment key={s}>
              <View style={[styles.stepDot, step >= s && styles.stepDotActive]}>
                <Text style={[styles.stepNum, step >= s && styles.stepNumActive]}>{s}</Text>
              </View>
              {s < 2 && <View style={[styles.stepLine, step > s && styles.stepLineDone]} />}
            </React.Fragment>
          ))}
        </View>
        <View style={styles.stepLabels}>
          <Text style={[styles.stepLabel, step === 1 && styles.stepLabelActive]}>Adresses</Text>
          <Text style={[styles.stepLabel, step === 2 && styles.stepLabelActive]}>Objets</Text>
        </View>

        {step === 1 ? (
          <View>
            <Card style={styles.addressCard}>
              <View style={styles.addressRow}>
                <View style={styles.greenDot} />
                <View style={styles.flex}>
                  <Text style={styles.addressLabel}>Point d'enlèvement</Text>
                  <Input value={pickupAddress} onChangeText={setPickupAddress} placeholder="Adresse de départ" />
                </View>
              </View>
              <View style={styles.verticalDivider} />
              <View style={styles.addressRow}>
                <View style={styles.redDot} />
                <View style={styles.flex}>
                  <Text style={styles.addressLabel}>Point de livraison</Text>
                  <Input value={deliveryAddress} onChangeText={setDeliveryAddress} placeholder="Adresse de destination" />
                </View>
              </View>
            </Card>

            <Input label="Notes pour le transporteur (optionnel)" value={notes} onChangeText={setNotes} placeholder="Instructions particulières, étage, code, etc." multiline numberOfLines={3} />

            <Button title="Suivant → Définir les objets" onPress={() => {
              if (!pickupAddress || !deliveryAddress) { Alert.alert('Requis', 'Renseignez les deux adresses.'); return; }
              setStep(2);
            }} fullWidth size="lg" />
          </View>
        ) : (
          <View>
            <Text style={styles.sectionTitle}>Objets à transporter</Text>
            <Text style={styles.sectionSub}>Décrivez les objets pour aider le transporteur à préparer le bon véhicule.</Text>

            {items.map((item, index) => (
              <Card key={index} style={styles.itemCard}>
                <View style={styles.itemHeader}>
                  <Text style={styles.itemNum}>Objet {index + 1}</Text>
                  {items.length > 1 && (
                    <TouchableOpacity onPress={() => removeItem(index)}>
                      <Text style={styles.removeText}>Supprimer</Text>
                    </TouchableOpacity>
                  )}
                </View>
                <Input label="Description" value={item.description} onChangeText={(v) => updateItem(index, 'description', v)} placeholder="ex: Canapé 3 places, Réfrigérateur..." />
                <View style={styles.itemRow}>
                  <View style={styles.flex}>
                    <Input label="Quantité" value={item.quantity} onChangeText={(v) => updateItem(index, 'quantity', v)} keyboardType="numeric" placeholder="1" />
                  </View>
                  <View style={styles.flex}>
                    <Input label="Poids estimé (kg)" value={item.estimatedWeight} onChangeText={(v) => updateItem(index, 'estimatedWeight', v)} keyboardType="decimal-pad" placeholder="ex: 80" />
                  </View>
                </View>
              </Card>
            ))}

            <TouchableOpacity onPress={addItem} style={styles.addItemBtn}>
              <Text style={styles.addItemText}>+ Ajouter un objet</Text>
            </TouchableOpacity>

            <View style={styles.actionRow}>
              <Button title="Retour" variant="outline" onPress={() => setStep(1)} style={styles.flex as any} />
              <Button title="Publier la mission" onPress={handleSubmit} loading={isLoading} style={styles.flex as any} />
            </View>
          </View>
        )}
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  flex: { flex: 1 },
  container: { backgroundColor: Colors.BACKGROUND, paddingHorizontal: 20, paddingTop: 56, paddingBottom: 40 },
  header: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 28 },
  back: { fontSize: 22, color: Colors.TEXT, fontWeight: '700' },
  title: { fontSize: 18, fontWeight: '700', color: Colors.TEXT },
  steps: { flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginBottom: 8 },
  stepDot: { width: 32, height: 32, borderRadius: 16, backgroundColor: Colors.BORDER, alignItems: 'center', justifyContent: 'center' },
  stepDotActive: { backgroundColor: Colors.PRIMARY },
  stepNum: { color: Colors.TEXT_SECONDARY, fontWeight: '700', fontSize: 14 },
  stepNumActive: { color: Colors.WHITE },
  stepLine: { width: 80, height: 2, backgroundColor: Colors.BORDER, marginHorizontal: 8 },
  stepLineDone: { backgroundColor: Colors.PRIMARY },
  stepLabels: { flexDirection: 'row', justifyContent: 'space-around', marginBottom: 28 },
  stepLabel: { fontSize: 13, color: Colors.TEXT_SECONDARY, fontWeight: '500' },
  stepLabelActive: { color: Colors.PRIMARY, fontWeight: '700' },
  addressCard: { marginBottom: 20 },
  addressRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 12 },
  greenDot: { width: 14, height: 14, borderRadius: 7, backgroundColor: Colors.SUCCESS, marginTop: 28 },
  redDot: { width: 14, height: 14, borderRadius: 7, backgroundColor: Colors.PRIMARY, marginTop: 28 },
  addressLabel: { fontSize: 13, fontWeight: '600', color: Colors.TEXT_SECONDARY, textTransform: 'uppercase', letterSpacing: 0.5, marginBottom: 4 },
  verticalDivider: { width: 2, height: 16, backgroundColor: Colors.BORDER, marginLeft: 6, marginVertical: -4 },
  sectionTitle: { fontSize: 18, fontWeight: '700', color: Colors.TEXT, marginBottom: 6 },
  sectionSub: { fontSize: 14, color: Colors.TEXT_SECONDARY, marginBottom: 20, lineHeight: 20 },
  itemCard: { marginBottom: 16 },
  itemHeader: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 },
  itemNum: { fontSize: 15, fontWeight: '700', color: Colors.TEXT },
  removeText: { fontSize: 13, color: Colors.ERROR, fontWeight: '600' },
  itemRow: { flexDirection: 'row', gap: 12 },
  addItemBtn: { borderWidth: 1.5, borderColor: Colors.PRIMARY, borderRadius: 12, paddingVertical: 14, alignItems: 'center', marginBottom: 24, borderStyle: 'dashed' },
  addItemText: { color: Colors.PRIMARY, fontWeight: '600', fontSize: 15 },
  actionRow: { flexDirection: 'row', gap: 12 },
});
