// ignore_for_file: avoid_print
import 'package:assignmen_1/Screens/donor/donor_Profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/donor_user_model.dart';
import '../../shared_pref/shared_pref.dart';
import 'donorregister.dart';

class DonorLogin extends StatefulWidget {
  const DonorLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return DonorLoginstate();
  }
}

class DonorLoginstate extends State {
  // ignore: prefer_typing_uninitialized_variables
  var passwordobs;

  @override
  void initState() {
    super.initState();
    passwordobs = true;
  }

  @override
  Widget build(BuildContext context) {
    String donoremail = '', donorpassword = '';

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Login',
          style: TextStyle(fontSize: 30),
        )),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.asset(
                'assets/images/donate.png',
                height: 300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                onChanged: (value) {
                  donoremail = value;
                },
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
                validator: (value) => value!.isEmpty ? 'Enter Email' : null,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                onChanged: (value) {
                  donorpassword = value;
                },
                keyboardType: TextInputType.name,
                obscureText: passwordobs,
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
                          passwordobs = !passwordobs;
                        });
                      },
                      icon: passwordobs
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
                validator: (value) => value!.isEmpty ? 'Enter Password' : null,
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
                  try {
                    // ignore: unused_local_variable
                    print("Entered into login area:");
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: donoremail,
                      password: donorpassword,
                    );
                    if (credential.user?.uid != null) {
                      print("entered into credential check of login:");
                      await SharedPrefClient().setUser(DonorUserModel(
                          credential.user!.uid, credential.user!.email!));
                      Get.offAll(() => const ProfileScreen());
                    } else {
                      print("entered into else print:");
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      Get.snackbar('Wrong',
                          ' Please Enter Correct Email.This User is Not Found ',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      Get.snackbar('Weak', ' Please Enter Correct Password ',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 25),
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Do not have account?'),
                TextButton(
                  onPressed: () {
                    Get.off(() => const DonorRegister());
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
