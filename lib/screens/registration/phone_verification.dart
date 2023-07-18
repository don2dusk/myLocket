import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_locket/screens/screens.dart';

import 'package:my_locket/model/firestore.dart';

import '../../utils/colors.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({super.key});
  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification>
    with SingleTickerProviderStateMixin {
  int _secondsRemaining = 30;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Users userInstance = Users();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String code = "";
  GetStorage userStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    _startTimer();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    _controller.reset();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        _stopTimer();
        _controller.forward();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  void _resetTimer() {
    _secondsRemaining = 30;
  }

  void _stopTimer() {
    _timer.cancel();
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
                        Text("Verify your number",
                            style: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        const SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                          cursorColor: primaryColor,
                          style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          maxLength: 6,
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Invalid verification code";
                            }
                            return null;
                          },
                          onSaved: (value) => code = value!,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.rubik(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            hintText: '6-Digit Code',
                            filled: true,
                            fillColor: secondaryColor,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: whattoDisplay(),
                        ),
                      ],
                    )),
                    SizedBox(
                      width: size.width,
                      child: TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              try {
                                Users user = Users(
                                    name: "",
                                    profileUrl: "",
                                    phoneNumber:
                                        userStorage.read('phoneNumber'));

                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId:
                                            userStorage.read('verificationId'),
                                        smsCode: code);

                                await auth.signInWithCredential(credential);
                                QuerySnapshot querySnapshot = await firestore
                                    .collection('users')
                                    .where('phoneNumber',
                                        isEqualTo:
                                            userStorage.read('phoneNumber'))
                                    .get();

                                if (querySnapshot.docs.isNotEmpty) {
                                  userStorage.remove('verificationId');

                                  userStorage.write(
                                      'uid', auth.currentUser!.uid);
                                  final ref = firestore
                                      .collection("users")
                                      .doc(userStorage.read('uid'))
                                      .withConverter(
                                        fromFirestore: Users.fromFirestore,
                                        toFirestore: (Users user, _) =>
                                            user.toFirestore(),
                                      );
                                  final docSnap = await ref.get();
                                  final aUser = docSnap.data();
                                  userStorage.write('name', aUser!.name);
                                  userStorage.write(
                                      'profileUrl', aUser.profileUrl);

                                  Get.offAll(() => const MainScreen());
                                } else {
                                  firestore
                                      .collection('users')
                                      .withConverter(
                                          fromFirestore: Users.fromFirestore,
                                          toFirestore: (Users user, options) =>
                                              user.toFirestore())
                                      .doc(auth.currentUser!.uid)
                                      .set(user);
                                  userStorage.write(
                                      'uid', auth.currentUser!.uid);
                                  userStorage.remove('verificationId');
                                  Get.offAll(() => const SignupPage());
                                }
                              } catch (e) {
                                Get.snackbar("Error", e.toString());
                              }
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
                  ]),
            ))));
  }

  Widget whattoDisplay() {
    return _secondsRemaining == 0
        ? FadeTransition(
            opacity: _animation,
            child: SizedBox(
              width: 160,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: secondaryColor,
                ),
                onPressed: () async {
                  await auth.verifyPhoneNumber(
                    timeout: const Duration(seconds: 30),
                    phoneNumber: userStorage.read('phoneNumber'),
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      userStorage.write('verificationId', verificationId);
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                  _resetTimer();
                  _startTimer();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.replay_rounded,
                        color: white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Resend Code",
                        style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                                color: white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Text(
            "Verification sent to your number.\nResend code in $_secondsRemaining seconds.",
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
                textStyle:
                    TextStyle(fontWeight: FontWeight.w600, color: termsText)));
  }
}
