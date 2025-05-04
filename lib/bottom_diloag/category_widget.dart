import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slipbuddy/Widgets/CrossIconWidget.dart';
import 'package:slipbuddy/controller/department/department_cubit.dart';
import 'package:slipbuddy/screen/users/doctor_listing.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  void initState() {
    super.initState();
    // Optionally trigger any actions here, like loading data
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      builder: (context, state) {
        if (state is MultipleDataLoaded) {
          int itemCount = state.departmentList.length; // Show 6 items plus "More" button if applicable

          return Container(
            height: MediaQuery.of(context).size.height * 0.90,
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CrossIconWidget(
                  onClose: () {
                    Navigator.pop(context);
                    // Handle close action here
                    print('Close icon clicked');
                    // You can also navigate back or perform any action
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Find a Doctor for your Health Problem',style: TextStyle(fontSize: 25,color: Colors.black),),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      final category = state.departmentList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorListing(
                                catId: category.iD.toString(),drId: "0",
                              ),
                            ),
                          );
                          print('${category.deptName} clicked');
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                width: double.infinity, // Makes sure the tap area is full width
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue[50],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: FadeInImage(
                                            image: NetworkImage('${category.icon}'),
                                            fit: BoxFit.cover,
                                            placeholder: const AssetImage("assets/images/google.png"),
                                            imageErrorBuilder: (context, error, stackTrace) {
                                              return Image.asset("assets/images/google.png");
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded( // Make text take remaining space
                                      child: Text(
                                        '${category.deptName}',
                                        style: TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Divider(color: Colors.black38),
                            )
                          ],
                        ),
                      );

                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('No Announcement Found'),
          );
        }
      },
    );
  }
}
