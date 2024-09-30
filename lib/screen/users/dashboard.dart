

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:slipbuddy/Widgets/loading_logo_wiget.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/bottom_diloag/category_bottom_dilaog.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/department/department_cubit.dart';
import 'package:slipbuddy/drawer/GlobalDrawer.dart';
import 'package:slipbuddy/screen/users/doctor_listing.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedCity = 'Murlipura'; // Default city
  final List<String> cities = ['Murlipura', 'Jaipur', 'Delhi', 'Mumbai'];
  late DepartmentCubit departmentCubit;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  final List<String> bannerImages = [
    'assets/images/banner_1.jpg',
    'assets/images/banner_2.jpg',
    'assets/images/banner_1.jpg',
    'assets/images/banner_2.jpg',
    'assets/images/banner_1.jpg',
  //  'https://via.placeholder.com/350x150.png?text=Banner+2',
   // 'https://via.placeholder.com/350x150.png?text=Banner+3',
  ];

  void _autoScrollPages() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  initCubit() {
    departmentCubit = context.read<DepartmentCubit>();
    departmentCubit.fetchDepartment();
    print("----------------------------------------------------");
  }

  @override
  void initState() {
    _autoScrollPages();
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
        key: _key,
        appBar: AppBar(
          backgroundColor: AppTheme.statusBar,
          elevation: 0,
          toolbarHeight: 150, // Increase height for customization
          automaticallyImplyLeading: false, // Removes default back arrow
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location Icon on the Left Side
                    IconButton(
                      icon: Icon(Icons.menu), // The menu icon or other custom icon
                      onPressed: () {
                        _key.currentState!.openDrawer();
                        // Action when menu icon is clicked
                        print("Menu button clicked");
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
                    // Profile button or any widget on the right side
                    IconButton(
                      icon: Icon(Icons.notification_important), // Location icon
                      onPressed: () {
                        // Action when location icon is clicked
                        print("Location icon clicked");
                      },
                    ),

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
        drawer: GlobalDrawer(),
        body:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: bannerImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            bannerImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                // SmoothPageIndicator for Dots
                SmoothPageIndicator(
                  controller: _pageController, // PageController
                  count: bannerImages.length,  // Number of pages
                  effect: WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    spacing: 8,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue, // Customize active dot color
                  ),
                ),
                SizedBox(height: 20),
                ActionCard(
                  title: 'Scheduled your clinic visit? ',
                  desc: 'Book your appointment today and get expert medical care at your convenience. Whether it a routine check-up or a specialized consultation, our experienced doctors are here to help. Don wait—secure your spot now for hassle-free healthcare!',
                  image: 'assets/images/demo_1.jpg', // Use your asset path here
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03), // Responsive spacing
                Text(
                  "Find a Doctor for your Health Problem",
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03, color: Colors.black), // Responsive font size
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Responsive spacing
          Container(
            height: MediaQuery.of(context).size.height * 0.25, // Responsive height for the GridView
            child: BlocBuilder<DepartmentCubit, DepartmentState>(
              builder: (context, state) {
                if (state is DepartmentLoaded) {
                  int itemCount = state.DepartmentList.length > 8 ? 8 : state.DepartmentList.length;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of columns
                      mainAxisSpacing: 8.0, // Spacing between rows
                      crossAxisSpacing: 8.0, // Spacing between columns
                      childAspectRatio: 0.8, // Adjust this ratio for image-text size balance
                    ),
                    itemCount: state.DepartmentList.length > 8 ? 8 : itemCount,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < 7 && index < state.DepartmentList.length) {
                        final category = state.DepartmentList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorListing(
                                  id: category.iD.toString(),
                                ),
                              ),
                            );
                          },
                          child: LayoutBuilder( // Use LayoutBuilder to calculate item size
                            builder: (context, constraints) {
                              double imageSize = constraints.maxHeight * 0.6; // Image takes up 60% of item height
                              double textHeight = constraints.maxHeight * 0.2; // Text takes up 20%

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: imageSize, // Responsive image height
                                    width: imageSize, // Responsive image width
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(category.icon!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5), // Space between image and text
                                  Text(
                                    category.deptName!,
                                    style: TextStyle(
                                      fontSize: constraints.maxHeight * 0.12, // Responsive font size
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else if (index == 7 && state.DepartmentList.length > 8) {
                        return GestureDetector(
                          onTap: () {
                            CategoryBottomDilog(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.08, // Responsive height
                                width: MediaQuery.of(context).size.width * 0.18,  // Responsive width
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue[50],
                                ),
                                child: Center(
                                  child: Text(
                                    '${state.DepartmentList.length}+',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.03, // Responsive font size
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              const Text('More'),
                            ],
                          ),
                        );
                      } else {
                        return Container(); // Return an empty container as a fallback
                      }
                    },
                  );
                } else {
                  return const Center(child: Text('No Announcement Found'));
                }
              },
            ),
          ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03), // Responsive spacing
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.person, size: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Find a Doctor for your Health Problem",
                        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.black), // Responsive font size
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Responsive spacing
                Container(
                  height: MediaQuery.of(context).size.height * 0.08, // Responsive height
                  width: MediaQuery.of(context).size.width, // Full width
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/demo_2.png'),
                          radius: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Dr. Garima Gupta",
                                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02, color: Colors.black),
                              ),
                              Text(
                                "Dentist",
                                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018, color: Colors.black54),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        ,
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
  final String desc;
  final String image;

  ActionCard({required this.title,required this.desc, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Adjust the radius for roundness
              child: Image.asset(
                image, // Replace with your image path
                width: 120, // Set a width to maintain the aspect ratio
                height: 130, // Set a height
                fit: BoxFit.cover, // This ensures the image covers the container properly
              ),
            ),
          ) ,// Use the appropriate asset image here
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title,maxLines: 2,overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,style: TextStyle(fontSize: 18,color: Colors.white),),
                Text(desc,maxLines: 4,overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,style: TextStyle(fontSize: 14,color: Colors.white),),
                Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.arrow_right, size: 30),
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
