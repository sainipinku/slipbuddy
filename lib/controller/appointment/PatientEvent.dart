abstract class PatientEvent {}

class UpdatePatientName extends PatientEvent {
  final String name;

  UpdatePatientName(this.name);
}
