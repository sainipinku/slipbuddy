import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Widgets/patient_list..dart';
import '../../bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Recent Activities'),
                  // Replace with your Recent Activities widget
                  SizedBox(height: 20),
                  Text('Patients Needing Attention'),
                  PatientList(patients: state.patientsNeedingAttention),
                ],
              ),
            );
          } else {
            return Center(child: Text('Error loading home'));
          }
        },
      ),
    );
  }
}
