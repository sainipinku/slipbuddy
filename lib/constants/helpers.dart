import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Helpers {

  static String dateformat(String date){
    // Convert string to DateTime object
    DateTime dateTime = DateFormat("MM/dd/yyyy hh:mm:ss a").parse(date);

    // Format the date as 'Wed, 2 Oct'
    String formattedDate = DateFormat("EEE, d MMM").format(dateTime);
    return formattedDate;
  }

  static String dateformat1(String date){
    // Convert string to DateTime object
    DateTime dateTime = DateFormat("MM/dd/yyyy hh:mm:ss a").parse(date);

    // Format the date as 'Wed, 2 Oct'
    String formattedDate = DateFormat("yyyy-MM-dd").format(dateTime);
    return formattedDate;
  }

  static String formatTime(String dateTimeString) {
    // Create a DateFormat for the input format
    DateFormat inputFormat = DateFormat("hh:mm:ss");

    // Parse the input date string
    DateTime dateTime = inputFormat.parse(dateTimeString);

    // Format the time in 'hh:mm a' format
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }
}