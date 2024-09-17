import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slipbuddy/constants/app_theme.dart';


Widget button ({required Color color,required String text,required VoidCallback button,double? borderRadius}){
    return GestureDetector(
      onTap: (){

      },
      child: SizedBox(
        height: 45.h,
        width: 150.w,
        child: ElevatedButton(
          onPressed: () {
            button();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.bgColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 25.0)),
          ),
          child: Text('GET STARTED',style: GoogleFonts.roboto(
            textStyle:  TextStyle(
              color: AppTheme.whiteColor,
              fontSize: 12,
              fontWeight: FontWeight.w500, // regular
            ),
          ),),
        ),
      ),
    );
}
AppBar customAppBar(BuildContext context,GlobalKey<ScaffoldState> _key) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            _key.currentState!.openDrawer();
          }, // Image tapped
          child: SvgPicture.asset(
            'assets/icons/menu.svg',
            height: 20,
            width: 20,
            allowDrawingOutsideViewBox: true,
            color: AppTheme.whiteColor,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                /*  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                );*/
              }, // Image tapped
              child: Container(
                height: 27,
                width: 25,
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SvgPicture.asset(
                        'assets/icons/notification.svg',
                        height: 20,
                        width: 20,
                        allowDrawingOutsideViewBox: true,
                        color: AppTheme.whiteColor,
                      ),
                    )
                    ,
                    Positioned(
                      right: 0,
                      top: 0,
                      child:  Container(
                        padding: const EdgeInsets.all(1),
                        decoration:  BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child:  Center(
                          child: Text(
                            "0",
                            style:   TextStyle(
                              fontSize: 10,
                              color: AppTheme.whiteColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        )
      ],
    ),
    backgroundColor: AppTheme.primaryColor,
  );
}