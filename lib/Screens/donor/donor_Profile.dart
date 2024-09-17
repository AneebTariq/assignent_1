import 'package:assignmen_1/Screens/donor/donor_incomplete_requests.dart';
import 'package:assignmen_1/Screens/selecttype.dart';
import 'package:assignmen_1/shared_pref/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notification.dart';
import 'donor_history.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String myString = '';
  bool value = false;
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
    myString = prefs.getString('donoremail') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String mydonor = myString;

    final Query<Map<String, dynamic>> usersCollection = FirebaseFirestore
        .instance
        .collection('Donor')
        .where('Donoremail', isEqualTo: mydonor);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              accountName: const Text('  '),
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
                    image: AssetImage('assets/images/donor.png'),
                  ),
                ),
              ),
              accountEmail: Text(mydonor),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                ' Home ',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Get.offAll(() => const Selected());
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text(
                ' Incomplete Requests ',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Get.to(() => const Donorincomphistory());
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text(
                'View Requests ',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Get.to(() => const Donornotification());
              },
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text(
                ' History ',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Get.to(() => const Donorhistory());
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                ' L o g o u t ',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () async {
                FirebaseAuth.instance.signOut();
                await SharedPrefClient().clearUser();
                Get.to(() => const Selected());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 100,
                right: 100,
                child: Container(
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
                      image: AssetImage('assets/images/donor.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: usersCollection.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: <Widget>[
                          //                    Donor Name
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              elevation: 5,
                              borderOnForeground: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  iconColor: Colors.red,
                                  title: const Text(
                                    'Name ',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 40.0,
                                      top: 10,
                                    ),
                                    child: Text(
                                      snapshot.data!.docs[index]['Name'],
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //                   Donor Email
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              elevation: 5,
                              borderOnForeground: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.mail,
                                  ),
                                  iconColor: Colors.red,
                                  title: const Text(
                                    'Email',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 40,
                                    ),
                                    child: Text(
                                      snapshot.data!.docs[index]['Donoremail'],
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //               Donor Number
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              elevation: 5,
                              borderOnForeground: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                  leading: const Icon(Icons.phone_android),
                                  iconColor: Colors.red,
                                  title: const Text(
                                    'Number',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 40,
                                    ),
                                    child: Text(
                                      snapshot.data!.docs[index]['Number'],
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //              Donor Blood Group
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              elevation: 5,
                              borderOnForeground: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                  leading: const Icon(Icons.bloodtype),
                                  iconColor: Colors.red,
                                  title: const Text(
                                    'Blood Group',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 40,
                                    ),
                                    child: Text(
                                      snapshot.data!.docs[index]['Blood Group'],
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //              Donor City
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              elevation: 5,
                              borderOnForeground: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                  leading: const Icon(Icons.location_city),
                                  iconColor: Colors.red,
                                  title: const Text(
                                    'City',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 40),
                                    child: Text(
                                      snapshot.data!.docs[index]['City'],
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //                Donor Area
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Card(
                              elevation: 5,
                              borderOnForeground: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: ListTile(
                                  leading: const Icon(Icons.area_chart),
                                  iconColor: Colors.red,
                                  title: const Text(
                                    'Area',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 40),
                                    child: Text(
                                      snapshot.data!.docs[index]['Area'],
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
