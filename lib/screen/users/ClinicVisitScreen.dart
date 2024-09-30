import 'package:flutter/material.dart';
import 'package:slipbuddy/constants/app_theme.dart';

class ClinicVisitScreen extends StatefulWidget {
  @override
  _ClinicVisitScreenState createState() => _ClinicVisitScreenState();
}

class _ClinicVisitScreenState extends State<ClinicVisitScreen> {
  int selectedIndex = 1; // Default selected date index
  final List<String> availableDates = [
    'Wed, 2 Oct',
    'Thu, 3 Oct',
    'Fri, 4 Oct',
  ];

  final List<String> morningSlots = ['10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM'];
  final List<String> afternoonSlots = ['12:00 PM', '12:30 PM'];
  final List<String> eveningSlots = ['04:00 PM', '04:30 PM', '05:00 PM', '05:30 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/doctor_profile.png'), // Replace with actual image path
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dr. Aarti Midha', style: TextStyle(fontSize: 16)),
                Text('Mindlisten Integrative Psychiatry Clinic', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        backgroundColor: AppTheme.statusBar,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clinic Visit Slots', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 55, // Adjust height based on your need
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableDates.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      width: 120, // Adjust width based on your need
                      margin: EdgeInsets.only(right: 10), // Add some spacing between items
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedIndex == index ? Colors.blue[100] : Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(availableDates[index], style: TextStyle(fontSize: 14)),
                          SizedBox(height: 2),
                          Text('10 slots available', style: TextStyle(fontSize: 12, color: Colors.green)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text('Thu, 3 Oct', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TimeSlotSection(
              label: 'Morning',
              slots: morningSlots,
              icon: Icons.wb_sunny,
            ),
            TimeSlotSection(
              label: 'Afternoon',
              slots: afternoonSlots,
              icon: Icons.wb_cloudy,
            ),
            TimeSlotSection(
              label: 'Evening',
              slots: eveningSlots,
              icon: Icons.nights_stay,
            ),
            Spacer(),
            // Bottom ad and button
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Image.network(
                      'https://via.placeholder.com/100x50', // Replace with actual image
                      width: 100,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Clinic slots full?\nConsult an expert doctor online within 2 mins.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add action to consult now
                  },
                  child: Text('CONSULT NOW'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimeSlotSection extends StatelessWidget {
  final String label;
  final List<String> slots;
  final IconData icon;

  const TimeSlotSection({
    Key? key,
    required this.label,
    required this.slots,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 10),
            Text('$label ${slots.length} slots', style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(slots.length, (index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(slots[index], style: TextStyle(color: Colors.blueAccent)),
            );
          }),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
