import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';

class ChatPreview extends StatefulWidget {
  const ChatPreview({super.key, required this.userName, required this.pfp});

  final String userName;
  final AssetImage pfp;

  @override
  State<ChatPreview> createState() => _ChatPreviewState();
}

class _ChatPreviewState extends State<ChatPreview> {
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
            Get.back();
          }
          // Reset drag distance
          _dragDistance = 0.0;
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
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
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: secondaryColor,
                              backgroundImage: widget.pfp,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.userName,
                              style: GoogleFonts.rubik(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white70),
                            ),
                          ]),
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
                height: size.height - 70,
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 58,
                          backgroundColor: secondaryColor,
                          child: Container(
                            height: 108,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: secondaryColor,
                          backgroundImage: widget.pfp,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Start the convo!",
                        style: GoogleFonts.rubik(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70),
                      ),
                    ),
                    Text(
                      "Reply to one of ${widget.userName}'s Lockets to start chatting",
                      style: GoogleFonts.rubik(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: termsText),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
