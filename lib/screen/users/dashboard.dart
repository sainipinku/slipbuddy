

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
import 'package:slipbuddy/screen/notification/notification.dart';
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
  String currentLocation = 'Ajmer'; // Default city
  late DepartmentCubit departmentCubit;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  List<BannerModel>? bannerImagesList;
  Future<String?> getSavedAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_address');
  }
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
  void loadAddress() async {
    currentLocation = (await getSavedAddress())!;
    setState(() {});
  }
  @override
  void initState() {
    getData();
    // Add listener to TextField controller
    loadAddress();
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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
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
          preferredSize: Size.fromHeight(230),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.statusappBar,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent so Container shows
              elevation: 0,
              toolbarHeight: 230, // Increase height for customization
              automaticallyImplyLeading: false, // Removes default back arrow
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location Icon on the Left Side
                      GestureDetector(
                        onTap: () {
                          _key.currentState!.openDrawer();
                          print("Menu button clicked");
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 22, // Adjusted to fit inside the container
                              backgroundImage: (imageUrl.isNotEmpty)
                                  ? NetworkImage(imageUrl)
                                  : AssetImage('assets/images/defult_img.png') as ImageProvider,
                              backgroundColor: Colors.transparent,
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
                                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w400), // Responsive font size
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down_rounded,size: 25,color: Colors.white,),

                          ],
                        ),
                      ),
                      // Profile button or any widget on the right side
                      IconButton(
                        icon: Icon(Icons.notifications,size: 30,), // Location icon
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: NotificationPage(),
                                ctx: context),
                          );
                          // Action when location icon is clicked
                          print("Location icon clicked");
                        },
                      ),

                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Glad you're here",
                    style: GoogleFonts.poppins(fontSize: 18, color: AppTheme.whiteColor,fontWeight: FontWeight.w400,), // Responsive font size
                  ),
                  Text(
                    "Let's help you find the perfect \ndoctor.",
                    style: GoogleFonts.poppins(fontSize: 20, color: AppTheme.whiteColor,fontWeight: FontWeight.w700,), // Responsive font size
                  ),
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
                                borderRadius: BorderRadius.circular(10),
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
                                    style: GoogleFonts.poppins(
                                      fontSize: 12.0,
                                      color: AppTheme.searchGreyText,fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  Expanded(
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText(
                                          'hospital and clinics',
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: 12.0,
                                              color: AppTheme.searchGreyText,fontWeight: FontWeight.w400
                                          ),
                                          speed: Duration(milliseconds: 100),
                                        ),
                                        TypewriterAnimatedText(
                                          'doctors',
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: 12.0,
                                              color: AppTheme.searchGreyText,fontWeight: FontWeight.w400
                                          ),
                                          speed: Duration(milliseconds: 100),
                                        ),
                                        TypewriterAnimatedText(
                                          'City',
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: 12.0,
                                              color: AppTheme.searchGreyText,fontWeight: FontWeight.w400
                                          ),
                                          speed: Duration(milliseconds: 100),
                                        ),
                                        TypewriterAnimatedText(
                                          'Specialities',
                                          textStyle: GoogleFonts.poppins(
                                              fontSize: 12.0,
                                              color: AppTheme.searchGreyText,fontWeight: FontWeight.w400
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
        drawer: GlobalDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ------------------ BANNER ------------------
                BlocBuilder<DepartmentCubit, DepartmentState>(
                  builder: (context, state) {
                    if (state is MultipleDataLoaded) {
                      bannerImagesList = state.bannerImagesList;

                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: isTablet ? 360 : 160,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: bannerImagesList!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: AppTheme.statusappBar,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: bannerImagesList![index].path!,
                                      fit: BoxFit.fill,
                                      placeholder: (_, __) =>
                                      const Center(child: CircularProgressIndicator()),
                                      errorWidget: (_, __, ___) =>
                                      const Icon(Icons.error),
                                    ),
                                  ),
                                );
                              },
                              onPageChanged: (index) {
                                setState(() => _currentPage = index);
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: bannerImagesList!.length,
                              effect: WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 6,
                                dotColor: Colors.grey.shade400,
                                activeDotColor: AppTheme.statusappBar,
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

                const SizedBox(height: 16),

                /// ------------------ TITLE ------------------
                Text(
                  "Connect with Top Doctors In Minutes.",
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 18 : 14.5,
                    color: AppTheme.greyText,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                /// ------------------ CATEGORY GRID ------------------
                BlocBuilder<DepartmentCubit, DepartmentState>(
                  builder: (context, state) {
                    if (state is MultipleDataLoaded) {
                      final list = state.departmentList;
                      final itemCount = list.length > 8 ? 8 : list.length;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 4 : 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: itemCount,
                        itemBuilder: (context, index) {

                          /// ---- MORE BUTTON ----
                          if (index == 7 && list.length > 8) {
                            return GestureDetector(
                              onTap: () => CategoryBottomDilog(context),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: AppTheme.statusappBar,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${list.length}+\nMore',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          }

                          final category = list[index];

                          /// ---- NORMAL ITEM ----
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DoctorListing(
                                    catId: category.iD.toString(),
                                    drId: "0",
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(category.icon!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    category.deptName!,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: isTablet ? 12 : 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.greyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No Department Found'));
                    }
                  },
                ),
                

                /// ------------------ COMPLETED TITLE ------------------
                Text(
                  "Consultation Successfully Completed",
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 18 : 14.5,
                    color: AppTheme.greyText,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

                /// ------------------ COMPLETED DOCTORS ------------------
                BlocBuilder<DepartmentCubit, DepartmentState>(
                  builder: (context, state) {
                    if (state is MultipleDataLoaded) {
                      final completedDoctorList = state.completedDoctorList;

                      return SizedBox(
                        height: isTablet ? 170 : 100,
                        child: completedDoctorList.isNotEmpty
                            ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: completedDoctorList.length,
                          itemBuilder: (context, index) {
                            final doctor = completedDoctorList[index];
                            return Container(
                              width: isTablet ? 130 : 100,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: isTablet ? 45 : 35,
                                    backgroundImage:
                                    NetworkImage(doctor.drPic!),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    doctor.drName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTablet ? 13 : 11,
                                      color: AppTheme.greyText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                            : const Center(child: Text('No Record Found')),
                      );
                    } else {
                      return const Center(child: Text('No Record Found'));
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
                      "assets/images/defult_img.png"),
                  imageErrorBuilder:
                      (context,
                      error,
                      stackTrace) {
                    return Image
                        .asset(
                      "assets/images/defult_img.png",
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
        color: AppTheme.statusappBar,
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
