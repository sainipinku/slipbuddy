import 'package:flutter/material.dart';
import 'package:slipbuddy/Widgets/CommonAppBar.dart';
import 'package:slipbuddy/constants/app_theme.dart';


class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Notification',
        backgroundColor: AppTheme.statusBar,
        actions: [
          // Icon(Icons.search),
        ],
      ),
      body: Center(
        child: Text('No Record Found',style: TextStyle(color: Colors.black,fontSize: 16),),
      ),
    );
  }
}
