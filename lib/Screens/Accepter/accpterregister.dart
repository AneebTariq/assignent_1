// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, duplicate_ignore, avoid_print, unused_local_variable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/user_model.dart';
import '../../repository/login_controller.dart';
import '../../shared_pref/accepter_sharedpref.dart';
import 'accepterhome.dart';
import 'accepterlogin.dart';

class AccepterRegister extends StatefulWidget {
  const AccepterRegister({super.key});

  @override
  State<StatefulWidget> createState() {
    return Accepterregisterstate();
  }
}

class Accepterregisterstate extends State {
  // ignore: prefer_typing_uninitialized_variables
  var passwordobs;

  @override
  void initState() {
    super.initState();
    passwordobs = true;
  }

  HomeControlleracc homecontroller = Get.put(HomeControlleracc());
  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    String accepteremail = '', accepterpassword = '';
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Sign Up',
          style: TextStyle(fontSize: 30),
        )),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: homecontroller.accregisterFormKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(
                  'assets/images/accept.png',
                  height: 300,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  // ignore: avoid_types_as_parameter_names
                  validator: (Value) => Value!.isEmpty ? 'Enter Email' : null,
                  // onChanged: (value) {
                  //   accepteremail = value;
                  // },
                  controller: homecontroller.accemailController,
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  validator: (Value) =>
                      Value!.isEmpty ? 'Enter password' : null,
                  // onChanged: (value) {
                  //   accepterpassword = value;
                  // },
                  controller: homecontroller.accpasswordController,
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
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.lock,
                        color: Colors.red,
                      ),
                    ),
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
                    homecontroller.checkregister();
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: homecontroller.accemailController.text,
                        password: homecontroller.accpasswordController.text,
                      );
                      await SharedPrefaccClient().setUseraccepter(
                          AccepterUserModel(
                              credential.user!.uid, credential.user!.email!));
                      Get.offAll(() => const AccepterHome());
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        Get.snackbar('Weak Password', ' Enter Strong Password ',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM);
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                        Get.snackbar('Wrong Email', ' Enter another Email ',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Text(
                    ' R e g i s t e r ',
                    style: TextStyle(fontSize: 25),
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Allready have account?'),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const AccepterLogin());
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
      ),
    );
  }
}
