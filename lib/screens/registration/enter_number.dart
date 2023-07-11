import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_locket/screens/screens.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/colors.dart';

class EnterNumber extends StatefulWidget {
  const EnterNumber({super.key});

  @override
  State<EnterNumber> createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  GetStorage userStorage = GetStorage();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: secondaryColor,
                        ),
                        child: const Center(
                            child: Icon(Icons.arrow_back_ios_rounded)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("What's your number?",
                              style: GoogleFonts.rubik(
                                textStyle: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const SizedBox(height: 20),
                          PhoneFormField(
                            autofocus: true,
                            defaultCountry: IsoCode.NG,
                            validator: PhoneValidator.validMobile(),
                            onSaved: (p) => userStorage.write(
                                'phoneNumber', "+${p!.countryCode}${p.nsn}"),
                            keyboardType: TextInputType.phone,
                            autovalidateMode: AutovalidateMode.always,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            countryCodeStyle: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            countrySelectorNavigator:
                                const CountrySelectorNavigator
                                    .draggableBottomSheet(),
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: secondaryColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Text(
                    "By tapping Continue, you are agreeing to our Terms of Service and Privacy Policy",
                    style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600, color: termsText)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: size.width,
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            confirmNumber(size);
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
                ],
              ),
            ),
          ),
        ));
  }

  void confirmNumber(Size size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: size.width,
              height: 250,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                child: Column(
                  children: [
                    Text(
                      "Confirmation...",
                      style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                    const SizedBox(height: 20),
                    confirmationtextSpan(),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "No",
                                    style: GoogleFonts.rubik(
                                        textStyle: TextStyle(
                                      fontSize: 15,
                                      color: termsText,
                                    )),
                                  ),
                                )),
                            const SizedBox(width: 15),
                            GestureDetector(
                                onTap: () async {
                                  Navigator.pop(context);
                                  await auth.verifyPhoneNumber(
                                    timeout: const Duration(seconds: 30),
                                    phoneNumber:
                                        userStorage.read('phoneNumber'),
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) {},
                                    verificationFailed:
                                        (FirebaseAuthException e) {},
                                    codeSent: (String verificationId,
                                        int? resendToken) {
                                      userStorage.write(
                                          'verificationId', verificationId);
                                      Get.to(() => const PhoneVerification());
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {},
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Yes",
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                            fontSize: 15,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ))
                          ]),
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  RichText confirmationtextSpan() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: "We will be verifying this phone number."
                "\n\nAre you sure ",
            style: GoogleFonts.rubik(
                textStyle: const TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            )),
          ),
          TextSpan(
            text: "'${userStorage.read('phoneNumber')}'",
            style: GoogleFonts.rubik(
                textStyle: const TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            )),
          ),
          TextSpan(
            text: " is your correct mobile number?",
            style: GoogleFonts.rubik(
                textStyle: const TextStyle(
              color: white,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            )),
          ),
        ]));
  }
}
