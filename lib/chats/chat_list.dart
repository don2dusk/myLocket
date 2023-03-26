import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_locket/screens/screens.dart';

import '../utils/colors.dart';

class CustomChat extends StatelessWidget {
  const CustomChat({super.key, required this.name, required this.pfp});

  final String name;
  final AssetImage pfp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
          () => ChatPreview(
                userName: name,
                pfp: pfp,
              ),
          popGesture: false,
          transition: Transition.rightToLeftWithFade),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: secondaryColor,
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundImage: pfp,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      name,
                      style: GoogleFonts.rubik(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "No replies yet!",
                      style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: termsText,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: termsText,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  final double _swipeVelocityThreshold = 100.0;
  double _dragDistance = 0.0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            _dragDistance += details.primaryDelta!;
          } else {
            _dragDistance = 0.0;
          }
        },
        onHorizontalDragEnd: (details) {
          if (_dragDistance >= size.width / 4 &&
              details.primaryVelocity!.abs() > _swipeVelocityThreshold &&
              details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
          // Reset drag distance
          _dragDistance = 0.0;
        },
        child: Scaffold(
          appBar: AppBar(
              toolbarHeight: 70,
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new)),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Messages",
                            style: GoogleFonts.rubik(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                )
              ]),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: SizedBox(
              width: size.width,
              child: ListView(
                scrollDirection: Axis.vertical,
                controller: ScrollController(
                    initialScrollOffset: 0, keepScrollOffset: false),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: const [
                  CustomChat(
                      name: "Daniella",
                      pfp: AssetImage("assets/imgs/daniella.jpeg")),
                  CustomChat(
                      name: "Vienna", pfp: AssetImage("assets/imgs/teni.jpeg")),
                  CustomChat(
                      name: "Karen", pfp: AssetImage("assets/imgs/karen.jpeg")),
                ],
              ),
            )),
          ),
        ));
  }
}
