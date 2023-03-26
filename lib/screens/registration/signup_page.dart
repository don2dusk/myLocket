import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_locket/screens/screens.dart';
import 'package:my_locket/globals.dart' as globals;
import '../../utils/colors.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormFieldState> fnameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> lnameKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                        nameField(fnameKey, 'First Name'),
                        const SizedBox(height: 20),
                        nameField(lnameKey, 'Last Name'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: size.width,
                      child: TextButton(
                          onPressed: () {
                            if (fnameKey.currentState!.value
                                    .toString()
                                    .isEmpty ||
                                lnameKey.currentState!.value
                                    .toString()
                                    .isEmpty) {
                              Get.snackbar(
                                  'Error...', 'These fields cannot be blank.');
                            } else {
                              globals.name =
                                  '${fnameKey.currentState!.value} ${lnameKey.currentState!.value}';
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
                ]))));
  }

  TextFormField nameField(GlobalKey<FormFieldState> key, String placeholder) {
    return TextFormField(
      key: key,
      cursorColor: primaryColor,
      style: GoogleFonts.rubik(
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      autofocus: true,
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
