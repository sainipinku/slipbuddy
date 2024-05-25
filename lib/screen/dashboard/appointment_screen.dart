import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Repositories/appointment_repository.dart';
import '../../Widgets/appointment_list.dart';
import '../../bloc/appointment_bloc.dart';

class AppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Canceled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider(
              create: (context) => AppointmentBloc(repository: AppointmentRepository())
                ..add(LoadAppointments(status: 'upcoming')),
              child: AppointmentListScreen(status: 'upcoming'),
            ),
            BlocProvider(
              create: (context) => AppointmentBloc(repository: AppointmentRepository())
                ..add(LoadAppointments(status: 'completed')),
              child: AppointmentListScreen(status: 'completed'),
            ),
            BlocProvider(
              create: (context) => AppointmentBloc(repository: AppointmentRepository())
                ..add(LoadAppointments(status: 'canceled')),
              child: AppointmentListScreen(status: 'canceled'),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentListScreen extends StatelessWidget {
  final String status;

  AppointmentListScreen({required this.status});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is AppointmentLoaded) {
          return AppointmentList(appointments: state.appointments);
        } else {
          return Center(child: Text('Error loading appointments'));
        }
      },
    );
  }
}
