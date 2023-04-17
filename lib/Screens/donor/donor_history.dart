// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Donorhistory extends StatefulWidget {
  const Donorhistory({super.key});

  @override
  State<StatefulWidget> createState() {
    return Donorhistorystate();
  }
}

class Donorhistorystate extends State {
  //final user = FirebaseAuth.instance.currentUser;
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
    myString = prefs.getString('donoremail') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // String? myaccepter = user?.email;
    String myaccepter = myString;

    final Query<Map<String, dynamic>> usersCollection = FirebaseFirestore
        .instance
        .collection('AccepterRequest')
        .where('Donorid', isEqualTo: myaccepter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request History'),
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                            textColor: Colors.black,
                            trailing:
                                Text(snapshot.data!.docs[index]['Status']),
                            title: Text('Name: ' +
                                snapshot.data!.docs[index]['AccepName']),
                            subtitle: Text('Address: ' +
                                snapshot.data!.docs[index]['Address']),
                          ),
                          Text('DonorEmail: ' +
                              snapshot.data!.docs[index]['Donorid']),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
