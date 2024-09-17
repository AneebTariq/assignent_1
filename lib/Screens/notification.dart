// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Donornotification extends StatefulWidget {
  const Donornotification({super.key});

  @override
  State<StatefulWidget> createState() {
    return Donornotificationstate();
  }
}

class Donornotificationstate extends State {
  String myString = '';

// SharedPreferences prefs = await SharedPreferences.getInstance();
  bool button1Enabled = true;
  bool button2Enabled = true;
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
    String mystatus = 'send';
    final Query<Map<String, dynamic>> usersCollection = FirebaseFirestore
        .instance
        .collection('AccepterRequest')
        .where('Donorid', isEqualTo: mydonor)
        .where('Status', isEqualTo: mystatus);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests'),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        ListTile(
                          textColor: Colors.black,
                          title: Text('Name: ' +
                              snapshot.data!.docs[index]['AccepName']),
                          subtitle: Text('Address: ' +
                              snapshot.data!.docs[index]['Address']),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                onPressed: button1Enabled
                                    ? () {
                                        setState(() {
                                          button1Enabled = true;
                                          button2Enabled = false;
                                        });
                                        // Do something when button 1 is clicked
                                        // String donorid = snapshot
                                        //     .data!.docs[index]['Donorid'];
                                        // String accepid = snapshot
                                        //     .data!.docs[index]['Accepterid'];
                                        String penddingstatus = 'pendding';
                                        FirebaseFirestore.instance
                                            .collection('AccepterRequest')

                                            // .where('Accepterid',
                                            //     isEqualTo: accepid)
                                            .where('Donorid',
                                                isEqualTo: mydonor)
                                            .get()
                                            .then((querySnapshot) {
                                          querySnapshot.docs
                                              // ignore: avoid_function_literals_in_foreach_calls
                                              .forEach((documentSnapshot) {
                                            documentSnapshot.reference.update(
                                                {'Status': penddingstatus});
                                          });
                                        });
                                        Get.snackbar(
                                            'Approved', 'You have aproved it',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      }
                                    : null,
                                child: const Text(' A p p r o v e '),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                onPressed: button2Enabled
                                    ? () {
                                        setState(() {
                                          button1Enabled = false;
                                          button2Enabled = true;
                                        });
                                        // Do something when button 2 is clicked
                                        // String donorid = snapshot
                                        //     .data!.docs[index]['Donorid'];
                                        // String accepid = snapshot
                                        //     .data!.docs[index]['Accepterid'];
                                        String rejectstatus = 'rejected';
                                        FirebaseFirestore.instance
                                            .collection('AccepterRequest')
                                            // .doc(accepid + "_" + donorid)
                                            // .update({'Status': rejectstatus});
                                            // .where('Accepterid',
                                            //     isEqualTo: accepid)
                                            .where('Donorid',
                                                isEqualTo: mydonor)
                                            .get()
                                            .then((querySnapshot) {
                                          querySnapshot.docs
                                              // ignore: avoid_function_literals_in_foreach_calls
                                              .forEach((documentSnapshot) {
                                            documentSnapshot.reference.update(
                                                {'Status': rejectstatus});
                                          });

                                          Get.snackbar(
                                            'Rejected',
                                            'You have Rejected it',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                          );
                                        });
                                      }
                                    : null,
                                child: const Text(' R e j e c t '),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
