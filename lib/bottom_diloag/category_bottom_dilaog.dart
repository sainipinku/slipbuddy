import 'package:flutter/material.dart';
import 'package:slipbuddy/bottom_diloag/category_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';

CategoryBottomDilog(BuildContext buildContext){

  showModalBottomSheet<void>(
    context: buildContext,
    isScrollControlled: true,
    backgroundColor: AppTheme.whiteColor,
    shape: const RoundedRectangleBorder( // <-- SEE HERE
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      return  StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            setState((){});
            return SingleChildScrollView(
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const CategoryWidget(),
              )
              ,
            );
          }
      );
    },

  );

}