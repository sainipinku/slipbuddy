import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slipbuddy/Widgets/snack_bar_widget.dart';
import 'package:slipbuddy/constants/app_theme.dart';
import 'package:slipbuddy/controller/location/location_cubit.dart';
import 'package:slipbuddy/controller/search_location/search_location_cubit.dart';
import 'package:slipbuddy/models/GetRecentSearchModel/GetLocationModel.dart';
import 'package:slipbuddy/models/GetRecentSearchModel/GetRecentSearchModel.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
class LocationSearchPage extends StatefulWidget {
  @override
  _LocationSearchPageState createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  TextEditingController searchController = TextEditingController();
  var uuid = const Uuid();
  List<String> recentSearches = ['Chomu'];

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
  SharedPreferences? prefs;
  Future<Map<String, dynamic>> getAddressData(double lat ,double long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_id') ?? '';
    try {
      // Step 1: Get current position

      // Step 2: Reverse geocoding
      List<Placemark> placemarks =
      await placemarkFromCoordinates(lat,long);

      Placemark place = placemarks[0];

      // Step 3: Create API body
      Map<String, dynamic> body = {
        "MsrNo": userToken, // static or dynamic
        "AddressType": "Home",
        "AddressLine1": "${place.street ?? ""}, ${place.subLocality ?? ""}",
        "City": place.locality ?? "",
        "State": place.administrativeArea ?? "",
        "Country": place.country ?? "",
        "Pincode": place.postalCode ?? "",
        "Latitude": lat,
        "Longitude": long,
        "IsDefault": 1,
      };
      prefs.setString('saved_address', place.locality ?? "");
      print("Address Data for API: $body");
      return body;
    } catch (e) {
      print("Error: $e");
      return {};
    }
  }
  void sendAddressToApi(BuildContext context,double lat ,double long) async {
    final body = await getAddressData(lat,long);
    if (body.isNotEmpty) {
      context.read<LocationCubit>().addLocation(body);
    }
  }
  void sendRecentAddressToApi(BuildContext context,String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_id') ?? '';
    body = {"MsrNo" : userToken,"SearchText" : type,
      "Latitude" : 19.0760,
      "Longitude" : 72.8777};
    context.read<SearchLocationCubit>().addRecentLocation(body);
  }
  Future<void> getLocation() async {
    // Check location permission status
    prefs = await SharedPreferences.getInstance();
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
  late LocationCubit locationCubit;
  late SearchLocationCubit searchLocationCubit;
  Map<String, dynamic> body = {};
  void initCubit()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('user_id') ?? '';
    body = {"msrno" : userToken};
    locationCubit = context.read<LocationCubit>();
    searchLocationCubit = context.read<SearchLocationCubit>();
    locationCubit.fetchLocation(body);
    searchLocationCubit.fetchSearchLocation(body);
  }
  String _seesionToken = '1234';
  String kGoogleApiKey = 'AIzaSyAR3c7miZSd_2SArHFTVXVGzMuEOU4vE9k';
  List<dynamic> _list = [];
  @override
  void initState() {
    // TODO: implement initState
    initCubit();
    getLocation();
    searchController.addListener(() {
      onChange();
    });
    super.initState();
  }

  void onChange() {
    if (_seesionToken == null) {
      setState(() {
        _seesionToken = uuid.v4();
      });
    }
    getSuggestion(searchController.text);

  }

  void getSuggestion(String input) async {
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kGoogleApiKey&sessiontoken=$_seesionToken';
    var response = await http.get(Uri.parse(request));
    print(jsonDecode(response.body.toString()));
    if (response.statusCode == 200) {
      setState(() {
        _list = jsonDecode(response.body.toString())['predictions'];
        print(_list);
      });
      //Provider.of<PlayerProvider>(context, listen: false).postRecentSearchList(context, input);
    } else {
      throw Exception("fiald");
    }
  }
  Future<void> getLatLngFromPlaceId(String placeId,String searchAddress) async {

    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kGoogleApiKey");

    final response = await http.get(url);
    final data = json.decode(response.body);

    if (data["status"] == "OK") {
      final location = data["result"]["geometry"]["location"];
      double lat = location["lat"];
      double lng = location["lng"];

      print("Latitude: $lat");
      print("Longitude: $lng");
      if(lng != 0 && lat != 0){
        sendAddressToApi(context,lat,lng);
      }

    } else {
      print("Error fetching place details: ${data["status"]}");
    }
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
      body: MultiBlocListener(
          listeners: [
            BlocListener<LocationCubit,LocationState>(listener: (context,state){
              if (state is LocationLoading) {
              /*     showDialog(
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
              } else if (state is LocationLoaded) {
                 //Navigator.of(context).pop();

              } else if (state is AddSuccess) {
                Navigator.pop(context,prefs!.getString('saved_address'));
                final _snackBar = snackBar('Add Address Sccusfully',
                    Icons.warning, Colors.green);
                locationCubit.fetchLocation(body);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }

              else if (state is LocationFailed) {
               //  Navigator.of(context).pop();
                final _snackBar = snackBar('Failed to update complain status.',
                    Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is LocationTimeout) {
               //  Navigator.of(context).pop();
                final _snackBar =
                snackBar('Time out exception', Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is LocationInternetError) {
               //  Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Internet connection failed.', Icons.wifi, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is LocationLogout) {
                final _snackBar =
                snackBar('Token has been expired', Icons.done, Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            }),
            BlocListener<SearchLocationCubit,SearchLocationState>(listener: (context,state){
              if (state is LocationLoading) {
                /*     showDialog(
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
              }   else if (state is SearchSearchLocationLoaded) {
                // Navigator.of(context).pop();
              }
              else if (state is AddRecentSearchLocationSuccess) {
                //  Navigator.of(context).pop();
                final _snackBar = snackBar('Add Address Sccusfully',
                    Icons.warning, Colors.green);
                searchController.clear();
                searchLocationCubit.fetchSearchLocation(body);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
              else if (state is LocationFailed) {
                //  Navigator.of(context).pop();
                final _snackBar = snackBar('Failed to update complain status.',
                    Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is LocationTimeout) {
                //  Navigator.of(context).pop();
                final _snackBar =
                snackBar('Time out exception', Icons.warning, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is LocationInternetError) {
                //  Navigator.of(context).pop();
                final _snackBar = snackBar(
                    'Internet connection failed.', Icons.wifi, Colors.red);

                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              } else if (state is LocationLogout) {
                final _snackBar =
                snackBar('Token has been expired', Icons.done, Colors.red);
                ScaffoldMessenger.of(context).showSnackBar(_snackBar);
              }
            }),
          ],
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              SizedBox(height: 16),
              _buildSearchField(),
              _list.isEmpty ? Column(
                 children: [
                   _buildOptionTile('Use current location', Icons.my_location),
                   // _buildOptionTile('Search in entire Jaipur', Icons.search),
                   SizedBox(height: 12),
                   _buildSectionTitle('Recent Search', showClear: true),
                   BlocBuilder<SearchLocationCubit, SearchLocationState>(
                     builder: (context, state) {
                       if (state is SearchSearchLocationLoaded) {
                         final List<GetRecentSearchModel> getRecentSearchLocation = state.recentSearchList;

                         if (getRecentSearchLocation.isEmpty) {
                           return const Center(child: Text('No Record Found'));
                         }

                         return Column(
                           children: getRecentSearchLocation.map((location) {
                             return _buildSimpleTile(
                               location.searchText ?? "Unknown City",
                             );
                           }).toList(),
                         );
                       } else if (state is LocationLoading) {
                         return const Center(child: CircularProgressIndicator());
                       } else if (state is LocationFailed) {
                         return const Center(child: Text("Failed to load locations"));
                       } else {
                         return const Center(child: Text('Loading...'));
                       }
                     },
                   ),
                   SizedBox(height: 12),
                   _buildSectionTitle('Add Address List'),
                   BlocBuilder<LocationCubit, LocationState>(
                     builder: (context, state) {
                       if (state is LocationLoaded) {
                         final List<GetLocationModel> locations = state.locationList;

                         if (locations.isEmpty) {
                           return const Center(child: Text('No Record Found'));
                         }

                         return Column(
                           children: locations.map((location) {
                             return _buildLocationTile(
                               location.city ?? "Unknown City",
                               location.addressLine1 ?? "No Address",
                             );
                           }).toList(),
                         );
                       } else if (state is LocationLoading) {
                         return const Center(child: CircularProgressIndicator());
                       } else if (state is LocationFailed) {
                         return const Center(child: Text("Failed to load locations"));
                       } else {
                         return const Center(child: Text('Loading...'));
                       }
                     },
                   )
                 ],
               )  : ListView.separated(
                shrinkWrap: true,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      onTap: () async {
                        print('address-----------${_list[index]}');
                        var placeId = _list[index]['place_id']; // from your prediction JSON
                        var description = _list[index]['description']; // from your prediction JSON
                        getLatLngFromPlaceId(placeId,description);
                      },
                      title: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _list[index]['description'],
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                        ),
                      ]));
                },
                separatorBuilder: (context, index) {
                  return Container(
                      height: 1, color: Colors.green);
                },
              )


            ],
          ))
      ,
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
          setState(() {}); // To show/hide clear icon
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            sendRecentAddressToApi(context, value.trim());
          } else {
            final _snackBar = snackBar(
              'Please enter a location',
              Icons.warning,
              Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(_snackBar);
          }
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
              setState(() {});
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
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        sendAddressToApi(context,position.latitude, position.longitude);
        Navigator.pop(context,city);
        searchController.clear();
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
      title: Text(title),       // city
      subtitle: Text(subtitle), // addressLine1
      trailing: Text('LOCALITY', style: TextStyle(color: Colors.grey)),
      onTap: () {
        // यहाँ आप return कर सकते हो selected city
        Navigator.pop(context, title);
      },
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
