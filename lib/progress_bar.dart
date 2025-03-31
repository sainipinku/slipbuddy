
import 'package:flutter/material.dart';
import 'package:slipbuddy/constants/app_theme.dart';




class Progressbar extends StatelessWidget {
  const Progressbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return  Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor)),
        ),
      )
      ,
    );
  }
}
