import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/config/sharedpref.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/user_profile/updateuserprofile_cubit.dart';
import 'package:slipbuddy/controller/user_profile/userprofile_cubit.dart';
import 'package:slipbuddy/models/UserProfileModel.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController mobileController = TextEditingController();
  late TextEditingController dobController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name = "Prem Pareek";
  String mobile = "+91 87410 44628";
  String gender = "Male";
  String age = "26";
  String email = "prem@gmail.com";
  String city = "Jaipur";
  String imageUrl = "";
  final List<String> genderList = ['Male', 'Female', 'Other'];
  File? category_fill;
  DateTime? selectedDate;
  late UserProfileCubit userProfileCubit;
  late UpdateUserProfileCubit updateUserProfileCubit;
  void initCubit()async {
    userProfileCubit = context.read<UserProfileCubit>();
    updateUserProfileCubit = context.read<UpdateUserProfileCubit>();
    userProfileCubit.fetchUserProfileData();
  }
  bool isDataSet = false;
  @override
  void initState() {
    // TODO: implement initState
    initCubit();
    super.initState();
  }
  Future<void> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      await Permission.camera.request();
    } else {
      await Permission.photos.request();
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dobController.text = "${picked.day}/${picked.month}/${picked.year}"; // Update age field
      });
  }

  _FromCamera(BuildContext context,ImageSource source) async {
    // Ask permission
    await _requestPermission(source);
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        category_fill = pickedFile != null ? File(pickedFile.path) : null;
      });
    }
  }
  _FromGallery(BuildContext context,ImageSource source) async {
    // Ask permission
    await _requestPermission(source);
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        category_fill = pickedFile != null ? File(pickedFile.path) : null;
      });
    }
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppTheme.whiteColor,
        shape: const RoundedRectangleBorder( // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (BuildContext bc) {
          return  SingleChildScrollView(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Center(
                child: Padding(padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Add Media",
                            style: GoogleFonts.lato(
                                color: AppTheme.blackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: (){
                            _FromCamera(context,ImageSource.camera);
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              SvgPicture.asset(
                                'assets/icons/camera.svg',
                                height: 20,width: 20,
                                color: AppTheme.blackColor,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("Take Photos",
                                    style: GoogleFonts.lato(
                                        color: AppTheme.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                        width: MediaQuery.of(context).size.width,
                        color: AppTheme.blackColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: () async{
                            _FromGallery(context,ImageSource.gallery);
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:  [
                              SvgPicture.asset(
                                'assets/icons/choose_from_gallery.svg',
                                height: 20,width: 20,
                                color: AppTheme.blackColor,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text("Choose From Gallery",
                                    style: GoogleFonts.lato(
                                        color: AppTheme.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ) ,)
                ,
              ),
            )
            ,
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Profile',
        backgroundColor: AppTheme.statusBar,
        actions: [
          // Icon(Icons.search),
        ],
      ),
      body: MultiBlocListener(
          listeners: [
            BlocListener<UserProfileCubit,UserProfileState>(listener: (context,state){
              if (state is UserProfileLoading) {
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
              } else if (state is UserProfileLoaded) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar(
                    ' update successfully', Icons.done, Colors.green);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);

              } else if (state is UserProfileFailed) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar('Failed to update complain status.',
                    Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is UserProfileTimeout) {
                // Navigator.of(context).pop();
                final _snackBar =
                snackBar('Time out exception', Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is UserProfileInternetError) {
                // Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Internet connection failed.', Icons.wifi, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is UserProfileLogout) {
                final _snackBar =
                snackBar('Token has been expired', Icons.done, Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            }),
            BlocListener<UpdateUserProfileCubit,UpdateUserProfileState>(listener: (context,state){
              if (state is UpdateUserProfileLoading) {
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
              } else if (state is UpdateUserProfile) {
                Navigator.of(context).pop();
                userProfileCubit.fetchUserProfileData();


              } else if (state is UpdateUserProfileFailed) {
                 Navigator.of(context).pop();
                final _snackBar = snackBar('Failed to update complain status.',
                    Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is UpdateUserProfileTimeout) {
                 Navigator.of(context).pop();
                final _snackBar =
                snackBar('Time out exception', Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is UpdateUserProfileInternetError) {
                 Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Internet connection failed.', Icons.wifi, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is UpdateUserProfileLogout) {
                final _snackBar =
                snackBar('Token has been expired', Icons.done, Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            })
          ],
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: BlocBuilder<UserProfileCubit,UserProfileState>(builder: (context,state){
              if (state is MultipleDataLoaded) {
                final user = state.userList.first;
                // ✅ Only set once
                if (!isDataSet) {
                  nameController.text = user.name ?? '';
                  mobileController.text = user.mobile ?? '';
                  dobController.text = user.dob ?? '';
                  emailController.text = user.email ?? '';
                  cityController.text = user.city ?? '';
                  gender = user.gender ?? '';
                  imageUrl = user.image ?? '';

                  SharedPref.setUserFirstName(user.name ?? '');
                  SharedPref.setUserEmail(user.email ?? '');
                  SharedPref.setToken(user.userId.toString());
                  SharedPref.setProfileImage(user.image ?? '');
                  SharedPref.setUserPhone(user.mobile ?? '');

                  isDataSet = true;
                }
                return Column(
                  children: [
                    // Profile Image
                    Stack(
                      children: [
                        category_fill != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(45), // Rounded corners
                          child: Image.file(
                            category_fill!,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover, // Ensures the image fits well
                          ),
                        )
                            : CircleAvatar(
                          radius: 45, // Ensure the size matches
                          backgroundImage: NetworkImage(
                            imageUrl, // Placeholder image URL
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.amber,
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(nameController,"Name", (val) => name = val),
                          _buildTextField(mobileController,"Mobile",(val) => mobile = val),
                          SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: gender,
                            decoration: InputDecoration(
                              labelText: 'Gender',
                              border: OutlineInputBorder(),
                            ),
                            items: genderList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                gender = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: TextEditingController(text: dobController.text),
                                decoration: InputDecoration(
                                  labelText: 'Date of Birth',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                            ),
                          ),
                          _buildTextField(emailController,"Email", (val) => email = val),
                          _buildTextField(cityController,"City", (val) => city = val),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          String userToken = prefs.getString('user_id') ?? '';
                          String userID = prefs.getString('user_token') ?? '';
                          Map body = {
                            "MsrNo": userToken,
                            "UserId": userID,
                            "Name":nameController.text.trim(),
                            "Mobile":mobileController.text.trim(),
                            "Email":emailController.text.trim(),
                            "FullAddress":"abc street",
                            "CityName":cityController.text.trim(),
                            "Gender":gender};
                          updateUserProfileCubit.fetchUpdateUserProfileData(body);
                        }

                      },
                      child: Text("Save"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: AppTheme.statusBar,
                      ),
                    )
                  ],
                );
              } else {
                return const Center(child: Text('No Announcement Found'));
              }
            })
            ,
          )),
    );
  }

  Widget _buildTextField(TextEditingController controller,String label, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: (val) => onChanged(val!),
      ),
    );
  }
}
