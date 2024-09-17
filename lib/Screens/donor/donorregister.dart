// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, duplicate_ignore, avoid_print, unused_local_variable
import 'package:assignmen_1/Screens/donor/donor_Profile.dart';
import 'package:assignmen_1/Screens/donor/registration_controller.dart';
import 'package:assignmen_1/shared_pref/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../model/donor_user_model.dart';
import '../../model/methodefile.dart';
import '../../repository/donorrepository.dart';
import 'donorlogin.dart';

class DonorRegister extends StatefulWidget {
  const DonorRegister({super.key});

  @override
  State<StatefulWidget> createState() {
    return DonorRegisterstate();
  }
}

class DonorRegisterstate extends State {
  bool isRegistering = false;
// SharedPreferences prefs = await SharedPreferences.getInstance();

  GeolocatorPlatform? geolocator;
  String? blood;
  // ignore: non_constant_identifier_names
  String? Area;
  // ignore: non_constant_identifier_names
  String? City;
  List<String> bloodgroup = [
    'A+',
    'B+',
    'AB+',
    'O+',
    'A-',
    'B-',
    'AB-',
    'O-',
  ];
  List<String> area = [
    'Gulberg',
    'Ravi',
    'Qartba Chownk',
    'College Road',
    'Shalamar',
    'wagha',
    'Aziz Bhatti',
    'Data Gunj Buksh',
    'Samanabad',
    'Iqbal Town',
    'Nishtar',
    'Green Town',
    'Johar Town',
    'Sabzazar',
    'Awan Town',
    'Model Town',
    'Muslim Town',
    'Gulshan-e-Ravi',
    'Anakali',
    'Mughalpura',
    'Baghbanpura',
  ];
  List<String> city = [
    'Lahore',
    'Karachi',
    'Islamabad',
  ];
  String? dropdownbloodValue = 'B+';
  String? dropdownareaValue = 'Qartba Chownk';
  String? dropdowncityValue = 'Lahore';

  Position? position;
  // ignore: prefer_typing_uninitialized_variables
  var passwordobsc;
  @override
  void initState() {
    super.initState();
    passwordobsc = true;
    geolocator = GeolocatorPlatform.instance;
    getPosition();
  }

  getPosition() async {
    LocationPermission locationP = await geolocator!.requestPermission();
    print("hello $locationP");
    if (locationP != LocationPermission.denied &&
        locationP != LocationPermission.deniedForever)
      position = await GeolocatorPlatform.instance.getCurrentPosition();
  }

  HomeController homecontroller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    String name = '', number = '';

    // ignore: no_leading_underscores_for_local_identifiers
    //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Register',
          style: TextStyle(fontSize: 30),
        )),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: !isRegistering
            ? SingleChildScrollView(
                child: Form(
                  key: homecontroller.loginFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 30,
                      ),
                      // Enter Blood Group
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DropdownButtonFormField<String>(
                          hint: const Text('Chose Blood Group'),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_circle,
                              color: Colors.red),
                          decoration: InputDecoration(
                            labelText: 'Blood Group',
                            prefixIcon: const Icon(
                              Icons.bloodtype,
                              color: Colors.red,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: blood != null
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: blood != null
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                          // value: dropdownbloodValue,
                          items: bloodgroup
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownbloodValue = newValue;
                              blood = dropdownbloodValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //chose Area
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: DropdownButtonFormField<String>(
                          hint: const Text('Chose Area'),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_circle,
                              color: Colors.red),
                          decoration: InputDecoration(
                            labelText: 'Area',
                            prefixIcon: const Icon(
                              Icons.area_chart_outlined,
                              color: Colors.red,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: blood != null
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: blood != null
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                          // value: dropdownareaValue,
                          items: area
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownareaValue = newValue;
                              Area = dropdownareaValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //chose city
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: DropdownButtonFormField<String>(
                          hint: const Text('Chose City'),
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down_circle,
                              color: Colors.red),
                          decoration: InputDecoration(
                            labelText: 'City',
                            prefixIcon: const Icon(
                              Icons.location_city,
                              color: Colors.red,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: blood != null
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                  color: blood != null
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),
                          // value: dropdowncityValue,
                          items: city
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdowncityValue = newValue;
                              City = dropdowncityValue;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Name of user
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: homecontroller.namecontroller,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: 'name',
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
                              return "Enter Name";
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      // Enter number
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: homecontroller.numbercontroller,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: 'number',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.numbers,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[+]*[0-9]+$').hasMatch(value)) {
                              return "Enter Phone Number";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // Email
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          // ignore: avoid_types_as_parameter_names
                          validator: (Value) =>
                              Value!.isEmpty ? 'Enter Email' : null,
                          controller: homecontroller.emailController,
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
                            hintText: 'Your Email',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.person,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // password
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          validator: (Value) =>
                              Value!.isEmpty ? 'Enter password' : null,
                          controller: homecontroller.passwordController,
                          keyboardType: TextInputType.name,
                          obscureText: passwordobsc,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            hintText: 'Password',
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordobsc = !passwordobsc;
                                  });
                                },
                                icon: passwordobsc
                                    ? const Icon(Icons.visibility)
                                    : const Icon(Icons.visibility_off),
                              ),
                            ),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.lock,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            fixedSize: const Size(350, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () async {
                            homecontroller.checkLogin();
                            isRegistering = true;
                            setState(() {});
                            if (homecontroller.loginFormKey.currentState!
                                    .validate() &&
                                blood != null &&
                                city != null &&
                                area != null) {
                              // ignore: non_constant_identifier_names
                              final User = UserDonor(
                                Name: homecontroller.namecontroller.text,
                                Bloodgroup: blood.toString(),
                                City: City.toString(),
                                Area: Area.toString(),
                                Donoremail: homecontroller.emailController.text,
                                Number: homecontroller.numbercontroller.text,
                                latitude: position?.latitude ?? 31.4735933,
                                longitude: position?.longitude ?? 74.3645786,
                              );

                              try {
                                UserCredential credential = await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                  email: homecontroller.emailController.text,
                                  password:
                                      homecontroller.passwordController.text,
                                );
                                if (credential.user?.uid != null) {
                                  print("@donor entered");
                                  await Donorrepository().CreateDonor(User);
                                  await SharedPrefClient().setUser(
                                      DonorUserModel(credential.user!.uid,
                                          credential.user!.email!));
                                  Get.offAll(() => const ProfileScreen());
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                  Get.snackbar(
                                      'Weak', ' Please Enter Strong Password ',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                } else if (e.code == 'email-already-in-use') {
                                  print(
                                      'The account already exists for that email.');
                                  Get.snackbar('Wrong',
                                      ' Enter Correct Email or Password ',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                                isRegistering = false;
                                setState(() {});
                              } catch (e) {
                                Get.snackbar("Some thing went wrong", "$e");
                                isRegistering = false;
                                setState(() {});
                              }
                            } else {
                              Get.snackbar("Missing Fields",
                                  "Try to fill all the missing fields");
                              isRegistering = false;
                              setState(() {});
                            }
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(fontSize: 25),
                          )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Allready have account?'),
                          TextButton(
                            onPressed: () {
                              Get.off(() => const DonorLogin());
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
