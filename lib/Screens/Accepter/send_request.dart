// ignore_for_file: non_constant_identifier_names

import 'package:assignmen_1/Screens/Accepter/searchscreen.dart';
import 'package:assignmen_1/model/accepter_request_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/request_repository.dart';
import 'accepterhome.dart';

class Requesttodonor extends StatefulWidget {
  const Requesttodonor({super.key});

  @override
  State<StatefulWidget> createState() {
    return Requesttodonorstate();
  }
}

class Requesttodonorstate extends State {
  TextEditingController AccepName = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController AccepterEmail = TextEditingController();

  final args = Get.arguments as MyPageArguments;
  String myString = '';
// SharedPreferences prefs = await SharedPreferences.getInstance();
  final formKey = GlobalKey<FormState>(); //key for form
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

  final user = FirebaseAuth.instance.currentUser;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    String? myaccepemail = user?.email;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('To: ${args.donorid}'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Text('Email: ${args.donorid}'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: AccepterEmail,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: FocusNode(),
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'From:  Enter Your Email',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                      return "Enter Email";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: AccepName,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: FocusNode(),
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'From:  Enter Your Name',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      return "Enter Correct Name";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: Address,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: FocusNode(),
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    hintText: 'Enter Hospital Address or Name',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.person,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      return "Enter Correct Address";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      fixedSize: const Size(350, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final acceptrequest = UserRequest(
                          AccepName: AccepName.text,
                          Address: Address.text,
                          Donorid: args.donorid,
                          Accepterid: myaccepemail.toString(),
                          Status: "send",
                        );
                        await Requestrepository().CreateDonor(acceptrequest);
                        Get.offAll(() => const AccepterHome());
                      }
                    },
                    child: const Text(
                      ' R e q u e s t ',
                      style: TextStyle(fontSize: 25),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
