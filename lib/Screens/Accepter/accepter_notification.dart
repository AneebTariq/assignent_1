// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Accepternotification extends StatefulWidget {
  const Accepternotification({super.key});

  @override
  State<StatefulWidget> createState() {
    return Accepternotificationstate();
  }
}

class Accepternotificationstate extends State {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String? myaccepter = user?.email;
    String getstatus = 'pendding';
    final Query<Map<String, dynamic>> usersCollection = FirebaseFirestore
        .instance
        .collection('AccepterRequest')
        .where('Accepterid', isEqualTo: myaccepter)
        .where('Status', isEqualTo: getstatus);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Status'),
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
                                onPressed: () {
                                  String donorid =
                                      snapshot.data!.docs[index]['Donorid'];
                                  String accepid =
                                      snapshot.data!.docs[index]['Accepterid'];
                                  String completedstatus = 'Completed';
                                  FirebaseFirestore.instance
                                      .collection('AccepterRequest')
                                      .where('Accepterid',
                                          isEqualTo: myaccepter)
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs
                                        // ignore: avoid_function_literals_in_foreach_calls
                                        .forEach((documentSnapshot) {
                                      documentSnapshot.reference
                                          .update({'Status': completedstatus});
                                    });
                                  });
                                  Get.snackbar(
                                      'Completed', ' Blood Donation Competed ',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                },
                                child: const Text(' c o m p l e t e d '),
                              ),
                              // incomplete donation
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                onPressed: () {
                                  // String donorid =
                                  //     snapshot.data!.docs[index]['Donorid'];
                                  // String accepid =
                                  //     snapshot.data!.docs[index]['Accepterid'];
                                  String incompletedstatus = 'InCompleted';
                                  FirebaseFirestore.instance
                                      .collection('AccepterRequest')
                                      .where('Accepterid',
                                          isEqualTo: myaccepter)
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs
                                        // ignore: avoid_function_literals_in_foreach_calls
                                        .forEach((documentSnapshot) {
                                      documentSnapshot.reference.update(
                                          {'Status': incompletedstatus});
                                    });
                                  });
                                  Get.snackbar('InCompleted',
                                      ' Blood Donation InCompeted ',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                },
                                child: const Text(' I n C o m p l e t e d '),
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
