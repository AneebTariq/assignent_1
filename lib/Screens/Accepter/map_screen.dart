import 'package:assignmen_1/Screens/Accepter/searchscreen.dart';
import 'package:assignmen_1/Screens/Accepter/send_request.dart';
import 'package:assignmen_1/repository/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/methodefile.dart';
import '../../repository/donorrepository.dart';
import '../../singleton.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key}) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  LatLng? targetLatLng;
  BitmapDescriptor markerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  List<int> distances = [];

  // Step 1.
  int dropdownValue = 5;

  List<int> distanceRanges = [
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    55,
    60,
    65,
    70,
    75,
    80,
    85,
    90,
    95,
    100,
  ];

  List<String> bloodGroupList = [
    'A+',
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
    'O-',
  ];

  String dropdownBloodValue = 'A+';
// Step 2.

  final Set<Marker> _markers = {};
  LocationController controller = LocationController();
  List<UserDonor>? donorList;

  final Singleton _singlton = Singleton();

  @override
  void initState() {
    // TODO: implement initState
    targetLatLng = LatLng(_singlton.currentLat!, _singlton.currentLng!);
    super.initState();
  }

  getDonorsList() async {
    print("called getDonotList");
    _markers.clear();
    var customMarker = Marker(
        markerId: const MarkerId("currentLocation"),
        position: LatLng(
            Singleton.instance.currentLat!, Singleton.instance.currentLng!),
        draggable: false,
        onDragEnd: (value) {
          // value is the new position
        },
        icon: markerIcon);
    _markers.add(customMarker);
    Donorrepository().alluser().then((donorList) async {
      for (int i = 0; i < donorList.length; i++) {
        if (donorList[i].latitude != null && donorList[i].longitude != null) {
          var distance = Geolocator.distanceBetween(
              _singlton.currentLat!,
              _singlton.currentLng!,
              donorList[i].latitude!,
              donorList[i].longitude!);
          distance = distance / 1000;
          print("blood groups are: ${donorList[i].Bloodgroup}");
          print("donor list length is: ${donorList.length}");
          if (distance <= dropdownValue &&
              donorList[i].Bloodgroup == dropdownBloodValue) {
            print("calculated distance:$distance");
            print("dropdown $dropdownValue");

            _markers.add(
                // added markers
                Marker(
              markerId: MarkerId(i.toString()),
              position: LatLng(donorList[i].latitude!, donorList[i].longitude!),
              infoWindow: InfoWindow(
                  title: donorList[i].Bloodgroup,
                  snippet: donorList[i].address,
                  onTap: () {
                    print("marker tapped");
                    String donorId = donorList[i].Donoremail;
                    print("donar id is : ${donorList[i].Donoremail}");
                    Get.to(const Requesttodonor(),
                        arguments: MyPageArguments(donorid: donorId));
                  }),
              icon: BitmapDescriptor.defaultMarker,
            ));
            setState(() {});
          }
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      getDonorsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            GoogleMap(
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: targetLatLng!,
                zoom: 11.0,
              ),
              markers: _markers,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  Container(
                    color: Colors.white10,
                    child: DropdownButton<String>(
                      // Step 3.
                      value: dropdownBloodValue,
                      // Step 4.
                      items: bloodGroupList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                      // Step 5.
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownBloodValue = newValue!;
                          getDonorsList();
                        });
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white10,
                    child: DropdownButton<int>(
                      // Step 3.
                      value: dropdownValue,
                      // Step 4.
                      items: distanceRanges
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "$value km",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }).toList(),
                      // Step 5.
                      onChanged: (int? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          getDonorsList();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
