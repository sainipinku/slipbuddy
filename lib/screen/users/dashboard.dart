import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slipbuddy/Widgets/loading_logo_wiget.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/department/department_cubit.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedCity = 'Murlipura'; // Default city
  final List<String> cities = ['Murlipura', 'Jaipur', 'Delhi', 'Mumbai'];
  late DepartmentCubit departmentCubit;

  initCubit() {
    departmentCubit = context.read<DepartmentCubit>();
    departmentCubit.fetchDepartment();
    print("----------------------------------------------------");
  }

  @override
  void initState() {
    initCubit();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DepartmentCubit, DepartmentState>(
          listener: (context, state) {
            if (state is DepartmentLoading) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_ctx) {
                    return Dialog(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppTheme.primaryColor,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            const Text('Loading...')
                          ],
                        ),
                      ),
                    );
                  });
            } else if (state is DepartmentLoaded) {
             // Navigator.of(context).pop();
              final _snackBar = snackBar(
                  'Status update successfully', Icons.done, Colors.green);
              ScaffoldMessenger.of(context).showSnackBar(_snackBar);

            } else if (state is DepartmentFailed) {
             // Navigator.of(context).pop();
              final _snackBar = snackBar('Failed to update complain status.',
                  Icons.warning, Colors.red);

              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            } else if (state is DepartmentTimeout) {
             // Navigator.of(context).pop();
              final _snackBar =
              snackBar('Time out exception', Icons.warning, Colors.red);

              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            } else if (state is DepartmentInternetError) {
             // Navigator.of(context).pop();
              final _snackBar = snackBar(
                  'Internet connection failed.', Icons.wifi, Colors.red);

              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            } else if (state is DepartmentLogout) {
              final _snackBar =
              snackBar('Token has been expired', Icons.done, Colors.red);
              ScaffoldMessenger.of(context).showSnackBar(_snackBar);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.statusBar,
          elevation: 0,
          toolbarHeight: 150, // Increase height for customization
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Profile Image
                    IconButton(
                      icon: Icon(Icons.menu), // The menu icon
                      onPressed: () {
                        // Action when menu icon is clicked
                        print("Menu button clicked");
                        // Add functionality to open a drawer or menu
                      },
                    ),
                    // Dropdown for city selection
                    DropdownButton<String>(
                      dropdownColor: Colors.blue[100],
                      value: selectedCity,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: SizedBox(),
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      items: cities.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue!;
                        });
                      },
                    ),
                    // Profile button on right side
                    SizedBox(),
                  ],
                ),
                SizedBox(height: 10),
                // Search field below the city dropdown
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search for clinic...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ActionCard(
                      title: 'Instant Video Consultation',
                      image: 'assets/images/demo_1.jpg', // Use your asset path here
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ActionCard(
                      title: 'Book In-Clinic Appointment',
                      image: 'assets/images/demo_2.png', // Use your asset path here
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Find a Doctor for your Health Problem",style: TextStyle(fontSize: 25,color: Colors.black),),
              SizedBox(height: 20),
              Expanded(
        child: BlocBuilder<DepartmentCubit, DepartmentState>(
          builder: (context, state) {
            if (state is DepartmentLoaded) {
              // Set the max item count to 6 or less, plus 1 if there are more than 6 items for the 'More' button
              int itemCount = state.DepartmentList.length > 6 ? 6 : state.DepartmentList.length;

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                ),
                itemCount: state.DepartmentList.length > 6 ? 6 : itemCount, // Show 6 items plus the "More" button if more than 6 items
                itemBuilder: (context, index) {
                  if (index < 5 && index < state.DepartmentList.length) {
                    // Regular item cards (for the first 6 items)
                    final category = state.DepartmentList[index];
                    return CategoryCard(
                      icon: category.icon!,
                      label: category.deptName!,
                    );
                  } else if (index == 5 && state.DepartmentList.length > 6) {
                    // Show the static "More" button at the 6th index if there are more than 6 items
                    return GestureDetector(
                      onTap: () {
                        // Action when clicking on the static image
                        print('More items clicked');
                        // Navigate to another screen or perform an action
                      },
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue[50],
                            ),
                            child: Center(
                              child: Text('${state.DepartmentList.length}+',style: TextStyle(fontSize: 30,color: Colors.blueAccent),),
                            ),
                          ),
                          const Text('More'),
                        ],
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container for safety
                  }
                },
              );
            } else {
              return const SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: Text('No Announcement Found')),
                  ],
                ),
              );
            }
          },
        ),
      ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.person, size: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Find a Doctor for your Health Problem",style: TextStyle(fontSize: 15,color: Colors.black),),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black, // Set your border color
                    width: 0.1, // Set the width of the border// Set the style, e.g., solid, dashed (optional)
                  ),
                  borderRadius: BorderRadius.circular(10), // Optional: adds rounded corners
                ),
                child:   Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/demo_2.png'), // Add your profile image asset here
                        radius: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Dr. Garima Gupta",style: TextStyle(fontSize: 14,color: Colors.black),),
                            Text("Dentist",style: TextStyle(fontSize: 12,color: Colors.black54),),

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
class CategoryCard extends StatelessWidget {
  final String icon;
  final String label;

  CategoryCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height:60,
          width:60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[50],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child:
                FadeInImage(
                  image: NetworkImage(icon),
                  fit: BoxFit.cover,

                  placeholder:
                  const AssetImage(
                      "assets/images/google.png"),
                  imageErrorBuilder:
                      (context,
                      error,
                      stackTrace) {
                    return Image
                        .asset(
                      "assets/images/google.png",
                    );
                  },
                )),
          ),
        ),
        SizedBox(height: 10),
        Text(label),
      ],
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final String image;

  ActionCard({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[50],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Adjust the radius for roundness
              child: Image.asset(
                image, // Replace with your image path
                width: 100, // Set a width to maintain the aspect ratio
                height: 100, // Set a height
                fit: BoxFit.cover, // This ensures the image covers the container properly
              ),
            ),
          ) ,// Use the appropriate asset image here
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                  child: Text(title, textAlign: TextAlign.center)),
              CircleAvatar(
                radius: 10,
                child: Icon(Icons.arrow_right, size: 10),
              )
            ],
          )

        ],
      ),
    );
  }
}
