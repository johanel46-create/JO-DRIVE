import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { Colors } from '../../constants/colors';
import { MissionStatus as MissionStatusType } from '../../types';

interface Step {
  key: MissionStatusType;
  label: string;
}

const STEPS: Step[] = [
  { key: 'PENDING', label: 'En attente' },
  { key: 'ACCEPTED', label: 'Acceptée' },
  { key: 'IN_PROGRESS', label: 'En cours' },
  { key: 'COMPLETED', label: 'Terminée' },
];

const ORDER: MissionStatusType[] = ['PENDING', 'ACCEPTED', 'IN_PROGRESS', 'COMPLETED'];

interface Props { status: MissionStatusType; }

export function MissionStatusTracker({ status }: Props) {
  if (status === 'CANCELLED') {
    return (
      <View style={styles.cancelled}>
        <Text style={styles.cancelledText}>Mission annulée</Text>
      </View>
    );
  }

  const currentIdx = ORDER.indexOf(status);

  return (
    <View style={styles.container}>
      {STEPS.map((step, idx) => {
        const done = idx < currentIdx;
        const active = idx === currentIdx;
        return (
          <React.Fragment key={step.key}>
            <View style={styles.step}>
              <View style={[styles.circle, done && styles.circleDone, active && styles.circleActive]}>
                {done ? (
                  <Text style={styles.checkmark}>✓</Text>
                ) : (
                  <Text style={[styles.stepNumber, active && styles.stepNumberActive]}>{idx + 1}</Text>
                )}
              </View>
              <Text style={[styles.stepLabel, active && styles.stepLabelActive, done && styles.stepLabelDone]}>
                {step.label}
              </Text>
            </View>
            {idx < STEPS.length - 1 && (
              <View style={[styles.line, done && styles.lineDone]} />
            )}
          </React.Fragment>
        );
      })}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flexDirection: 'row', alignItems: 'flex-start', justifyContent: 'center', paddingVertical: 16 },
  step: { alignItems: 'center', width: 72 },
  circle: { width: 32, height: 32, borderRadius: 16, backgroundColor: Colors.BORDER, alignItems: 'center', justifyContent: 'center', marginBottom: 6 },
  circleDone: { backgroundColor: Colors.SUCCESS },
  circleActive: { backgroundColor: Colors.PRIMARY },
  checkmark: { color: Colors.WHITE, fontSize: 14, fontWeight: '700' },
  stepNumber: { color: Colors.TEXT_SECONDARY, fontSize: 13, fontWeight: '600' },
  stepNumberActive: { color: Colors.WHITE },
  stepLabel: { fontSize: 11, color: Colors.TEXT_SECONDARY, textAlign: 'center' },
  stepLabelActive: { color: Colors.PRIMARY, fontWeight: '600' },
  stepLabelDone: { color: Colors.SUCCESS },
  line: { flex: 1, height: 2, backgroundColor: Colors.BORDER, marginTop: 15 },
  lineDone: { backgroundColor: Colors.SUCCESS },
  cancelled: { backgroundColor: 'rgba(239,68,68,0.1)', borderRadius: 12, paddingVertical: 14, alignItems: 'center' },
  cancelledText: { color: Colors.ERROR, fontWeight: '600', fontSize: 15 },
});
