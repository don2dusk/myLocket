import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_locket/screens/registration/enter_number.dart';

import '../../utils/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Iconsax.heart_circle5,
                color: primaryColor,
                size: 40,
              ),
              Text(
                "MyLocket",
                style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 40),
            child: Text(
              "Live pics from your friends, on your home screen. Made with Flutter",
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const EnterNumber())),
            style: TextButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
              child: Text(
                "Set up MyLocket →",
                style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                  color: black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                )),
              ),
            ),
          )
        ],
      ),
    )));
  }
}
