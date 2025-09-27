import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slipbuddy/constants/app_theme.dart';

class LocationSearchPage extends StatefulWidget {
  @override
  _LocationSearchPageState createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  TextEditingController searchController = TextEditingController();

  List<String> recentSearches = ['Chomu'];
  List<String> topLocalities = [
    'Vaishali Nagar',
    'Mansarovar',
    'Malviya Nagar',
    'Vidhyadhar Nagar',
    'Jhotwara',
    'Gopalpura',
    'Sodala',
  ];

  Future<String> getCityName() async {
    try {
      // Step 1: Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Step 2: Reverse geocoding
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      print('full address--------${placemarks}');
      // Step 3: Get city from placemark
      Placemark place = placemarks[0];
      return place.subLocality ?? "City not found";
    } catch (e) {
      print("Error: $e");
      return "Error getting city";
    }
  }


  Future<void> getLocation() async {
    // Check location permission status
    var status = await Permission.location.status;

    if (status.isDenied) {
      // Ask for permission
      status = await Permission.location.request();

      if (status.isDenied) {
        print('Location permission denied.');
        return;
      }
    }

    if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens app settings manually
      return;
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    print('Lat: ${position.latitude}, Lon: ${position.longitude}');
  }

  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: AppTheme.statusappBar,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Enter your city or locality'),
          centerTitle: false,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 16),
          _buildSearchField(),
          _buildOptionTile('Use current location', Icons.my_location),
         // _buildOptionTile('Search in entire Jaipur', Icons.search),
          SizedBox(height: 12),
          _buildSectionTitle('Recent Search', showClear: true),
          _buildLocationTile(recentSearches[0], 'Jaipur'),
          SizedBox(height: 12),
          _buildSectionTitle('Top Localities in Jaipur'),
          ...topLocalities.map((locality) => _buildSimpleTile(locality)).toList(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {}); // To show/hide clear icon based on input
        },
        decoration: InputDecoration(
          hintText: 'Search your location here',
          border: InputBorder.none,
          icon: Icon(Icons.search),
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              searchController.clear();
              setState(() {}); // To hide the icon

              /// Optionally clear your search result list
              // yourList.clear();
              // Or trigger a BLoC event or function to update list
            },
          )
              : null,
        ),
      ),
    );
  }


  Widget _buildOptionTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(color: Colors.blue)),
      onTap: () async {
        String city = await getCityName();
        print("You are in: $city");
        Navigator.pop(context,city);
      },
    );
  }

  Widget _buildSectionTitle(String title, {bool showClear = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        if (showClear)
          TextButton(
            child: Text('CLEAR'),
            onPressed: () {
              setState(() {
                recentSearches.clear();
              });
            },
          ),
      ],
    );
  }

  Widget _buildLocationTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text('LOCALITY', style: TextStyle(color: Colors.grey)),
      onTap: () {},
    );
  }

  Widget _buildSimpleTile(String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        // Handle tap
      },
    );
  }
}
