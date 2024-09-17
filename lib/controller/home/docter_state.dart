import 'package:flutter/material.dart';

class DoctorState {
  final List<String> specialities;
  final List<Doctor> doctors;

  DoctorState({required this.specialities, required this.doctors});
}

class Doctor {
  final String name;
  final String education;
  final String speciality;
  final String experience;
  final double rating;
  final int reviews;
  final String location;
  final String feeRange;
  final String imageUrl;

  Doctor({
    required this.name,
    required this.education,
    required this.speciality,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.location,
    required this.feeRange,
    required this.imageUrl,
  });
}
