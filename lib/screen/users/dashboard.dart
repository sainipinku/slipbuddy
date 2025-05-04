

import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/Widgets/loading_logo_wiget.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/bottom_diloag/category_bottom_dilaog.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/department/department_cubit.dart';
import 'package:slipbuddy/drawer/GlobalDrawer.dart';
import 'package:slipbuddy/models/BannerModel.dart';
import 'package:slipbuddy/models/CompletedDoctorListModel.dart';
import 'package:slipbuddy/screen/location/GalobleSearchPage.dart';
import 'package:slipbuddy/screen/location/LocationSearchPage.dart';
import 'package:slipbuddy/screen/users/doctor_listing.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final TextEditingController search = TextEditingController();
  bool isSearchEmpty = true;
  String currentLocation = 'Japiur'; // Default city
  late DepartmentCubit departmentCubit;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  List<BannerModel>? bannerImagesList;

  void _autoScrollPages() async {
    _timer = await Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < bannerImagesList!.length - 1) {
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
    search.dispose(); // Dispose of the controller when done
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  initCubit() async{
    departmentCubit = context.read<DepartmentCubit>();
    departmentCubit.fetchDepartment();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_id') ?? '';
    print("----------------------------------------------------$userToken");
  }
  void _openCitySelector() async {
    final selectedCity = await Navigator.push(
      context,
      PageTransition(
          type: PageTransitionType.rightToLeft,
          child: LocationSearchPage(),
          ctx: context),
    );

    if (selectedCity != null) {
      print('Selected City: $selectedCity');
      setState(() {
        currentLocation = selectedCity;
      });
    }
  }
  String imageUrl = '';

  // Function to get data from SharedPreferences
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imageUrl = prefs.getString('user_profile') ?? ''; // Default to an empty string if null
    });
  }
  @override
  void initState() {
    getData();
    // Add listener to TextField controller
    search.addListener(() {
      setState(() {
        isSearchEmpty = search.text.isEmpty; // Check if the TextField is empty
      });
    });

    initCubit();
    _autoScrollPages();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DepartmentCubit, DepartmentState>(
          listener: (context, state) {
            if (state is DepartmentLoading) {
           /*   showDialog(
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
                  });*/
            } else if (state is DepartmentLoaded) {
             // Navigator.of(context).pop();


            }else if (state is BannerImageLoaded) {
              // Navigator.of(context).pop();


            }else if (state is CompletedDoctorListLoaded) {
              // Navigator.of(context).pop();


            }
            else if (state is DepartmentFailed) {
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.statusBar,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent so Container shows
              elevation: 0,
              toolbarHeight: 150, // Increase height for customization
              automaticallyImplyLeading: false, // Removes default back arrow
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location Icon on the Left Side
                        GestureDetector(
                          onTap: (){
                            _key.currentState!.openDrawer();
                            // Action when menu icon is clicked
                            print("Menu button clicked");
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue
                            ),
                            child: Center(
                              child: CircleAvatar(
                                radius: 45, // Ensure the size matches
                                backgroundImage: NetworkImage(
                                  imageUrl, // Placeholder image URL
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Dropdown for city selection
                        GestureDetector(
                          onTap: (){
                            _openCitySelector();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on,size: 25,color: Colors.white,),
                              SizedBox(
                                child: Text(
                                  currentLocation,maxLines: 1,overflow: TextOverflow.fade,textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w700), // Responsive font size
                                ),
                              ),
                              SizedBox()

                            ],
                          ),
                        ),
                        // Profile button or any widget on the right side
                        IconButton(
                          icon: Icon(Icons.notifications,size: 30,), // Location icon
                          onPressed: () {
                            // Action when location icon is clicked
                            print("Location icon clicked");
                          },
                        ),

                      ],
                    ),
                    SizedBox(height: 10),
                    // Search field below the city dropdown
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: Galoblesearchpage(),
                              ctx: context),
                        );
                      },
                      child: Stack(
                        children: [
                          // Search TextField
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: TextField(
                              maxLines: 2,
                              minLines: 1,
                              controller: search,
                              enabled: false,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: '',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 0),
                              ),
                            ),
                          ),

                          // Animated text below TextField
                          if (isSearchEmpty)
                            Positioned(
                              top: 25,
                              left: 48,
                              child: Container(
                                width: 300,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Search for ', // Static text
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Expanded(
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            'hospital and clinics',
                                            textStyle: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                            speed: Duration(milliseconds: 100),
                                          ),
                                          TypewriterAnimatedText(
                                            'doctors',
                                            textStyle: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                            speed: Duration(milliseconds: 100),
                                          ),
                                          TypewriterAnimatedText(
                                            'City',
                                            textStyle: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                            speed: Duration(milliseconds: 100),
                                          ),
                                          TypewriterAnimatedText(
                                            'Specialities',
                                            textStyle: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey,
                                            ),
                                            speed: Duration(milliseconds: 100),
                                          ),
                                        ],
                                        totalRepeatCount: 20000,
                                        pause: Duration(milliseconds: 100),
                                        displayFullTextOnTap: true,
                                        stopPauseOnTap: true,
                                        isRepeatingAnimation: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: GlobalDrawer(),
        body:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<DepartmentCubit, DepartmentState>(
                  builder: (context, state) {
                    if (state is MultipleDataLoaded) {
                      bannerImagesList = state.bannerImagesList;

                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.18,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: bannerImagesList!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    color: AppTheme.statusBar,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: bannerImagesList![index].path!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                          Positioned(
                            bottom: 5,
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: bannerImagesList!.length,
                              effect: WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 6,
                                dotColor: Colors.grey,
                                activeDotColor: AppTheme.statusBar,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No Announcement Found'));
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Divider(
                    color: Colors.black26,
                    thickness: 2,
                  ),
                ),
                ActionCard(
                  title: 'Schedule Your In-Clinic Visit',
                  desc: 'Experience personalized care with ease. Schedule your in-clinic visit now and get expert medical attention when you need it most.',
                  image: 'assets/images/doctor.jpg', // Use your asset path here
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Divider(
                    color: Colors.black26,
                    thickness: 2,
                  ),
                ), // Responsive spacing
                Text(
                  "Connect with Top Doctors In Minutes.",
                  style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w700), // Responsive font size
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Responsive spacing
                Container(
            height: MediaQuery.of(context).size.height * 0.25, // Responsive height for the GridView
            child: BlocBuilder<DepartmentCubit, DepartmentState>(
              builder: (context, state) {
                if (state is MultipleDataLoaded) {
                  int itemCount = state.departmentList.length > 8 ? 8 : state.departmentList.length;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of columns
                      mainAxisSpacing: 8.0, // Spacing between rows
                      crossAxisSpacing: 8.0, // Spacing between columns
                      childAspectRatio: 0.8, // Adjust this ratio for image-text size balance
                    ),
                    itemCount: state.departmentList.length > 8 ? 8 : itemCount,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < 7 && index < state.departmentList.length) {
                        final category = state.departmentList[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorListing(
                                  catId: category.iD.toString(),drId: "0",
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
                      } else if (index == 7 && state.departmentList.length > 8) {
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
                                  color: AppTheme.statusBar,
                                ),
                                child: Center(
                                  child: Text(
                                    '${state.departmentList.length}+',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.height * 0.03, // Responsive font size
                                      color: Colors.white,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Divider(
                    color: Colors.black26,
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Consultation Successfully Completed",
                    style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.w700), // Responsive font size
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Responsive spacing
                BlocBuilder<DepartmentCubit, DepartmentState>(
                  builder: (context, state) {
                    if (state is MultipleDataLoaded) {
                      List<CompletedDoctorListModel> completedDoctorList = state.completedDoctorList;

                      return Container(
                        height: 150, // Set the height for horizontal scroll
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: completedDoctorList.isNotEmpty ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: completedDoctorList.length,
                          itemBuilder: (context, index) {

                            return Container(
                              width: 100,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(completedDoctorList[index].drPic!),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    completedDoctorList[index].drName!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    completedDoctorList[index].department!,
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ) : Center(child: Text('No Record Found')),
                      );
                    } else {
                      return const Center(child: Text('No Announcement Found'));
                    }
                  },
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
        color: AppTheme.statusBar,
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
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title,maxLines: 2,overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w700),),
                SizedBox(height: 5,),
                Text(desc,maxLines: 5,overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify,style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w500),),
              ],
            ),
          )

        ],
      ),
    );
  }
}
