import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_locket/model/firestore.dart';
import 'package:my_locket/screens/screens.dart';
import '../../utils/colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  GetStorage userStorage = GetStorage();
  Users userInstance = const Users();
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String fullName = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("What's your name?",
                          style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      const SizedBox(height: 30),
                      nameField('First Name', (value) => fullName += value),
                      const SizedBox(height: 20),
                      nameField('Last Name', (value) => fullName += " $value"),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: size.width,
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            userInstance.updateInfo(Users(name: fullName));
                            userStorage.write('name', fullName);
                            userStorage.write('profileUrl', "");
                            Get.offAll(() => const MainScreen());
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text("Continue →",
                              style: GoogleFonts.rubik(
                                  textStyle: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ))),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  TextFormField nameField(String placeholder, onSaved) {
    return TextFormField(
      cursorColor: primaryColor,
      onSaved: onSaved,
      style: GoogleFonts.rubik(
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      autofocus: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Field cannot be empty";
        }
        return null;
      },
      decoration: InputDecoration(
        hintStyle: GoogleFonts.rubik(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        hintText: placeholder,
        filled: true,
        fillColor: secondaryColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
      ),
    );
  }
}
