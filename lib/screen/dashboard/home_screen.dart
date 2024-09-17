import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/home/docter_state.dart';
import 'package:slipbuddy/controller/home/doctor_cubit.dart';
import 'package:slipbuddy/screen/dashboard/appoitmentpage.dart';
import 'package:slipbuddy/screen/dashboard/profile%20page.dart';
import 'package:slipbuddy/screen/dashboard/searchpage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    SearchPage(),
    AppointmentsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppTheme.primaryColor, // Set your desired status bar color here
      statusBarBrightness: Brightness.light, // For iOS: set the status bar text color to light
      statusBarIconBrightness: Brightness.light, // For Android: set the status bar icons to light
    ));
    return Scaffold(
      key: _key,
      appBar: customAppBar(context, _key),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Handle the navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle the navigation
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppTheme.primaryColor,  // Set your desired background color here
        onTap: _onItemTapped,
      ),
    );
  }

  PreferredSizeWidget customAppBar(BuildContext context, GlobalKey<ScaffoldState> key) {
    return AppBar(
      title: Text("Find Doctor"),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            // Handle the notification icon press
          },
        ),
      ],
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          key.currentState?.openDrawer();
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<String> bannerImages = [
    'https://via.placeholder.com/800x300.png?text=Banner+1',
    'https://via.placeholder.com/800x300.png?text=Banner+2',
    'https://via.placeholder.com/800x300.png?text=Banner+3',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorCubit, DoctorState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 180.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                  items: bannerImages.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Specialities",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle view all doctors action
                      },
                      child: Text("View All"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor, // Set the same color as app bar
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.specialities
                      .map((speciality) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppTheme.primaryColor,
                          child: Text(speciality[0]),
                        ),
                        SizedBox(height: 5),
                        Text(speciality),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Find Doctors",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle view all doctors action
                      },
                      child: Text("View All"),
                    ),
                  ],
                ),
              ),
              ...state.doctors.map((doctor) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(doctor.imageUrl),
                          ),
                          title: Text(doctor.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(doctor.education),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(doctor.speciality),
                                  SizedBox(height: 5),
                                  Text(doctor.experience),
                                  SizedBox(height: 5),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.star, color: Colors.yellow),
                                  SizedBox(width: 5),
                                  Text(doctor.rating.toString()),
                                  Text(" (${doctor.reviews})"),
                                  SizedBox(height: 5),
                                  Text(doctor.location),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(doctor.feeRange),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            minimumSize: Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                          onPressed: () {},
                          child: Text('Book Appointment'),
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}