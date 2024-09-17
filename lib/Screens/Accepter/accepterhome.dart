// ignore_for_file: file_names
import 'package:assignmen_1/Screens/Accepter/accepter_history.dart';
import 'package:assignmen_1/Screens/Accepter/accepter_notification.dart';
import 'package:assignmen_1/Screens/Accepter/map_screen.dart';
import 'package:assignmen_1/Screens/selecttype.dart';
import 'package:assignmen_1/repository/location_controller.dart';
import 'package:assignmen_1/shared_pref/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../singleton.dart';

class AccepterHome extends StatefulWidget {
  const AccepterHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return Accepterhomestate();
  }
}

class Accepterhomestate extends State {
  String myString = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<SharedPreferences> getSharedPreferencesInstance() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await getSharedPreferencesInstance();
    myString = prefs.getString('accepteremail') ?? '';
    setState(() {});
  }

  // final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String myaccepter = myString;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              currentAccountPicture: Container(
                width: 170.0,
                height: 170.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.red,
                    width: 6.0,
                  ),
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/accepter.png'),
                  ),
                ),
              ),
              accountName: const Text(''),
              accountEmail: Text(myaccepter),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                ' H o m e ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Get.offAll(() => const Selected());
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text(
                ' S t a t u s ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Get.to(() => const Accepternotification());
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text(
                ' H i s t o r y ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Get.to(() => const Accepterhistory());
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text(
                ' V i e w  M a p ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                if (Singleton.instance.currentLat != 0.0) {
                  Get.to(() => const MyMap());
                } else {
                  LocationController().getCurrentLocation(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                ' L o g o u t ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await SharedPrefClient().clearAcceptar();
                Get.to(() => const Selected());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                'Welcome To Our App ',
                style: TextStyle(
                    wordSpacing: 4,
                    fontSize: 35,
                    color: Colors.red,
                    fontStyle: FontStyle.italic),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Image.asset('assets/images/first.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: const Size(350, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                // Get.to(() => const SearchScreen());

                if (Singleton.instance.currentLat != 0.0) {
                  Get.to(() => const MyMap());
                } else {
                  LocationController().getCurrentLocation(context);
                }
              },
              child: const Text(
                ' Search Donor',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
