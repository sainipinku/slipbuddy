class PatientState {
  final String patientName;

  PatientState({required this.patientName});

  PatientState copyWith({String? patientName}) {
    return PatientState(
      patientName: patientName ?? this.patientName,
    );
  }
}
