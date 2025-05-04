import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/global_search/global_search_cubit.dart';
import 'package:slipbuddy/screen/location/LocationSearchPage.dart';
import 'package:slipbuddy/screen/users/ClinicVisitScreen.dart';
import 'package:slipbuddy/screen/users/doctor_listing.dart';

class Galoblesearchpage extends StatefulWidget {
  @override
  _GaloblesearchpageState createState() => _GaloblesearchpageState();
}

class _GaloblesearchpageState extends State<Galoblesearchpage> {
  TextEditingController searchController = TextEditingController();
  String currentLocation = 'Japiur'; // Default city

  @override
  void initState() {
    super.initState();
    initCubit();
  }
  late GlobalSearchCubit globalSearchCubit;
  initCubit() {
    globalSearchCubit = context.read<GlobalSearchCubit>();
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
  void filterList(String query) {
    var body = {"searchtext" : query};
    globalSearchCubit.fetchGlobalSearch(body);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.statusBar,
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Make AppBar transparent so Container shows
            elevation: 0,
            toolbarHeight: 50, // Increase height for customization
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
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
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
                            Icon(Icons.location_on, size: 25, color: Colors.white),
                            SizedBox(width: 4), // Space between icon and text
                            Text(
                              currentLocation,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 4), // Space between icon and text
                            Icon(Icons.keyboard_arrow_down_outlined, size: 25, color: Colors.white),
                          ],
                        )
                        ,
                      ),
                      // Profile button or any widget on the right side
                      IconButton(
                        icon: Icon(Icons.arrow_back,color: AppTheme.statusBar,),
                        onPressed: () => {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GlobalSearchCubit, GlobalSearchState>(
            listener: (context, state) {
              if (state is GlobalSearchLoading) {
               /* showDialog(
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
              } else if (state is GlobalSearchLoaded) {
                // Navigator.of(context).pop();
                /*final _snackBar = snackBar(
                    'Status update successfully', Icons.done, Colors.green);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);*/

              } else if (state is GlobalSearchFailed) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar('Failed to update complain status.',
                    Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is GlobalSearchTimeout) {
                // Navigator.of(context).pop();
                final _snackBar =
                snackBar('Time out exception', Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is GlobalSearchInternetError) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Internet connection failed.', Icons.wifi, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is GlobalSearchLogout) {
                final _snackBar =
                snackBar('Token has been expired', Icons.done, Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  onChanged: filterList,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        searchController.clear();
                        filterList('');
                      },
                    )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Search Results
              BlocBuilder<GlobalSearchCubit, GlobalSearchState>(
                  builder: (context, state) {
                    if (state is GlobalSearchLoaded) {
                      // Set the max item count to 6 or less, plus 1 if there are more than 6 items for the 'More' button
                      int itemCount = state.DoctorList.length;

                      return Expanded(
                        child: ListView.separated(
                          itemCount: itemCount,
                          separatorBuilder: (context, index) =>
                              Divider(color: Colors.grey[300]),
                          itemBuilder: (context, index) {
                            final doctor = state.DoctorList[index];
                            return ListTile(
                              leading: Container(
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
                                      doctor.profilePic!, // Placeholder image URL
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(doctor.fullName!,style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              )),
                              subtitle: Text(doctor.hospitalName!),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorListing(
                                      drId: doctor.id!.toString(),catId: "0",
                                    ),
                                  ),
                                );

                                // Do something on tap
                              },
                            );
                          },
                        ),
                      );
                    } else {
                    return const Center(child: Text('No Announcement Found'));
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
