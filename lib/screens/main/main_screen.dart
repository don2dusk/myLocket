import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_locket/screens/screens.dart';
import 'package:my_locket/utils/colors.dart';
import 'package:my_locket/globals.dart' as globals;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  PageController _pageViewController = PageController();
  PageController _secondPageController = PageController();
  bool isFlashToggled = false;
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  int currentCameraIndex = 0;
  int currentPageIndex = 0;
  String currentUser = "";
  final double _swipeVelocityThreshold = 100.0;
  double _dragDistance = 0.0;

  late AnimationController animationController;
  late Animation<double> animation;

  final _imageItems = <_ImageItems>[
    const _ImageItems(
      imageUrl: "assets/imgs/tega.jpeg",
      mobileNo: "+2348132071223",
      userName: "Oghenetega Eko-Brotobor",
      desc: "Visionary",
    ),
    const _ImageItems(
      imageUrl: "assets/imgs/karen.jpeg",
      mobileNo: "+2348033495986",
      userName: "Karen Ambrose",
    ),
    const _ImageItems(
      imageUrl: "assets/imgs/daniella.jpeg",
      mobileNo: "+2348174657238",
      userName: "Daniella Eko-Brotobor",
      desc: "🤭❤️",
    ),
    const _ImageItems(
      imageUrl: "assets/imgs/teni.jpeg",
      mobileNo: "+2349055849089",
      userName: "Vienna Kalaro",
      desc: "Lagos has shown me shege 😔",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(keepPage: false);
    _secondPageController = PageController(keepPage: false);
    _controller = CameraController(
        globals.cameras[currentCameraIndex], ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg, enableAudio: false);
    _initializeControllerFuture = _controller.initialize();
    currentUser = _imageItems[0].userName.split(" ")[0];

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animationController.reset();
    animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  void onSwitchCamera() {
    if (currentCameraIndex == globals.cameras.length - 1) {
      currentCameraIndex = 0;
      setState(() {
        isFlashToggled = false;
      });
    } else {
      currentCameraIndex = globals.cameras.length - 1;
      setState(() {
        isFlashToggled = false;
      });
    }
    _controller = CameraController(
        globals.cameras[currentCameraIndex], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  void onToggleFlash() {
    if (_controller.value.isInitialized) {
      if (_controller.value.flashMode == FlashMode.torch) {
        _controller.setFlashMode(FlashMode.off);
        setState(() {
          isFlashToggled = false;
        });
      } else {
        _controller.setFlashMode(FlashMode.torch);
        setState(() {
          isFlashToggled = true;
        });
      }
    }
  }

  void onTapDown(TapDownDetails details) {
    if (_controller.value.isInitialized) {
      final double width = MediaQuery.of(context).size.width;
      final double height = MediaQuery.of(context).size.height;
      final double x = details.globalPosition.dx / width;
      final double y = details.globalPosition.dy / height;
      _controller.setExposurePoint(Offset(x, y));
      _controller.setFocusPoint(Offset(x, y));
      _controller.setExposureMode(ExposureMode.auto);
      _controller.setFocusMode(FocusMode.auto);
    }
  }

  void takePicture() async {
    if (!_controller.value.isInitialized) {
      return;
    }
    await _controller.takePicture();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! < 0 || details.primaryDelta! > 0) {
          _dragDistance += details.primaryDelta!.abs();
        } else {
          _dragDistance = 0.0;
        }
      },
      onHorizontalDragEnd: (details) {
        if (_dragDistance >= size.width / 4 &&
            details.primaryVelocity!.abs() > _swipeVelocityThreshold &&
            details.primaryVelocity! < 0) {
          Get.to(
            () => const ChatsList(),
            transition: Transition.rightToLeftWithFade,
            popGesture: false,
          );
        } else if (_dragDistance >= size.width / 4 &&
            details.primaryVelocity!.abs() > _swipeVelocityThreshold &&
            details.primaryVelocity! > 0) {
          Get.to(
            () => const Profile(),
            transition: Transition.leftToRightWithFade,
            popGesture: false,
          );
        }
        // Reset drag distance
        _dragDistance = 0.0;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: secondaryColor,
                          radius: 25,
                          child: IconButton(
                            onPressed: () {
                              Get.to(
                                () => const Profile(),
                                transition: Transition.leftToRightWithFade,
                                popGesture: false,
                              );
                            },
                            icon: const Icon(Iconsax.user, color: Colors.white),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                        ),
                        currentPageIndex != 0
                            ? TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 34),
                                    foregroundColor: Colors.white,
                                    backgroundColor: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: Text(
                                    "Everyone",
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ),
                                ),
                              )
                            : TextButton.icon(
                                onPressed: () {
                                  addFriendsModal();
                                },
                                icon: FadeTransition(
                                    opacity: animation,
                                    child: const Icon(Iconsax.people)),
                                label: FadeTransition(
                                  opacity: animation,
                                  child: Text(
                                    "Add a Friend",
                                    style: GoogleFonts.rubik(
                                        textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    )),
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 10),
                                    foregroundColor: Colors.white,
                                    backgroundColor: secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                              ),
                        CircleAvatar(
                          backgroundColor: secondaryColor,
                          radius: 25,
                          child: IconButton(
                            onPressed: () {
                              Get.to(
                                () => const ChatsList(),
                                transition: Transition.rightToLeftWithFade,
                                popGesture: false,
                              );
                            },
                            icon: const Icon(Iconsax.message_2,
                                color: Colors.white),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: PageView(
                      controller: _pageViewController,
                      scrollDirection: Axis.vertical,
                      onPageChanged: (int value) {
                        setState(() {
                          currentPageIndex = value;
                          animationController.reset();
                          animationController.forward();
                        });
                      },
                      children: [
                        Column(
                          children: [
                            // AspectRatio(
                            //   aspectRatio: 1,
                            //   child: Container(
                            //     width: size.width,
                            //     decoration: BoxDecoration(
                            //       color: black,
                            //       borderRadius: BorderRadius.circular(75),
                            //     ),
                            //   ),
                            // ),
                            FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return GestureDetector(
                                    onDoubleTap: onSwitchCamera,
                                    child: SizedBox(
                                        width: size.width,
                                        height: size.width,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(75),
                                          child: OverflowBox(
                                              alignment: Alignment.center,
                                              child: FittedBox(
                                                  fit: BoxFit.fitWidth,
                                                  child: SizedBox(
                                                      width: size.width,
                                                      child: CameraPreview(
                                                          _controller)))),
                                        )),
                                  );
                                } else {
                                  return AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40)
                                      .copyWith(top: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  isFlashToggled
                                      ? IconButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onPressed: onToggleFlash,
                                          icon: const Icon(Iconsax.flash_15,
                                              size: 40, color: primaryColor),
                                        )
                                      : IconButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onPressed: onToggleFlash,
                                          icon: const Icon(Iconsax.flash_1,
                                              size: 40),
                                        ),
                                  TextButton(
                                    onPressed: takePicture,
                                    style: TextButton.styleFrom(
                                        backgroundColor: white,
                                        shape: const CircleBorder(
                                            side: BorderSide(
                                          width: 5,
                                          color: primaryColor,
                                          strokeAlign: 3,
                                        ))),
                                    child: const Padding(
                                      padding: EdgeInsets.all(40),
                                      child: Text(""),
                                    ),
                                  ),
                                  IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: onSwitchCamera,
                                    icon: const Icon(
                                        Icons.flip_camera_android_outlined,
                                        size: 40),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: GestureDetector(
                                  onTap: () =>
                                      _pageViewController.animateToPage(1,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.easeInOut),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "History",
                                        style: GoogleFonts.rubik(
                                            textStyle: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      const Icon(Iconsax.arrow_down_1, size: 30)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                                child: PageView(
                              onPageChanged: (int value) {
                                setState(() {
                                  currentUser =
                                      _imageItems[value].userName.split(" ")[0];
                                });
                              },
                              controller: _secondPageController,
                              scrollDirection: Axis.vertical,
                              children: [
                                for (var image in _imageItems)
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: size.width,
                                        height: size.width,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(75),
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                SizedBox(
                                                  width: size.width,
                                                  height: size.width,
                                                  child: OverflowBox(
                                                    alignment: Alignment.center,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitWidth,
                                                      child: SizedBox(
                                                        width: size.width,
                                                        child: Image(
                                                          image: AssetImage(
                                                              image.imageUrl),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                image.desc != ""
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 20),
                                                        child: DecoratedBox(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              color:
                                                                  secondaryColor,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                image.desc,
                                                                style: GoogleFonts.rubik(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            )),
                                                      )
                                                    : Container(),
                                              ],
                                            )),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CircleAvatar(
                                            radius: 20,
                                            backgroundColor: white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              image.userName.split(" ")[0],
                                              style: GoogleFonts.rubik(
                                                textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                              ],
                            )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 30)
                                          .copyWith(top: 30),
                                  child: Container(
                                    width: size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: secondaryColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 15),
                                      child: Row(children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: replyDialog,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Send a reply...",
                                                style: GoogleFonts.rubik(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: termsText),
                                              ),
                                            ),
                                          ),
                                        ),
                                        reactionsWidget("💛"),
                                        const SizedBox(width: 10),
                                        reactionsWidget("🔥"),
                                        const SizedBox(width: 10),
                                        reactionsWidget("😍"),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {},
                                          child: const Icon(
                                            Icons.add_reaction_outlined,
                                            size: 30,
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 40)
                                          .copyWith(top: 25, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Iconsax.menu,
                                            size: 40,
                                          )),
                                      TextButton(
                                        onPressed: () =>
                                            _pageViewController.animateTo(0,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeInOut),
                                        style: TextButton.styleFrom(
                                            backgroundColor: white,
                                            shape: const CircleBorder(
                                                side: BorderSide(
                                              width: 5,
                                              color: primaryColor,
                                              strokeAlign: 3,
                                            ))),
                                        child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(""),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.ios_share_rounded,
                                            size: 40,
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget reactionsWidget(String reaction) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        reaction,
        style: GoogleFonts.rubik(fontSize: 30),
      ),
    );
  }

  void replyDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            alignment: Alignment.bottomCenter,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextField(
                cursorHeight: 20,
                cursorColor: white,
                style: GoogleFonts.rubik(
                    fontSize: 16, fontWeight: FontWeight.w400),
                autofocus: true,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Reply to $currentUser...",
                  hintStyle: GoogleFonts.rubik(
                      fontSize: 16, fontWeight: FontWeight.w400),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      print('Sent Message');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Iconsax.send_1,
                        color: termsText,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void addFriendsModal() {
    showModalBottomSheet(
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        context: context,
        builder: (BuildContext context) {
          return const ModalBottomSheet();
        });
  }
}

class _ImageItems {
  const _ImageItems(
      {required this.imageUrl,
      required this.userName,
      this.desc = "",
      required this.mobileNo});

  final String imageUrl;
  final String userName;
  final String desc;
  final String mobileNo;
}

class ModalBottomSheet extends StatefulWidget {
  const ModalBottomSheet({super.key});

  @override
  State<ModalBottomSheet> createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet>
    with SingleTickerProviderStateMixin {
  late Timer timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int namesIndex = 0;
  List<String> names = [
    "family",
    "friends",
    "best friend",
    "siblings",
    "so",
  ];

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (namesIndex < 4) {
        setState(() {
          namesIndex++;
          _animationController.reset();
          _animationController.forward();
          // _animationController.reverse();
        });
      } else {
        setState(() {
          namesIndex = 0;
          _animationController.reset();
          _animationController.forward();
          // _animationController.reverse();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      startTimer();
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 750),
        vsync: this,
      );
      _animation =
          Tween<double>(begin: 0, end: 1).animate(_animationController);
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                width: 50,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "5 out of 20 friends",
                style: GoogleFonts.rubik(
                    fontSize: 26, fontWeight: FontWeight.w700, color: white),
              ),
            ),
            SizedBox(
                height: 25,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Add your  ",
                          style: GoogleFonts.rubik(
                              fontSize: 18,
                              color: termsText,
                              fontWeight: FontWeight.w600)),
                      FadeTransition(
                        opacity: _animation,
                        child: Text("${names[namesIndex]}  ",
                            style: GoogleFonts.rubik(
                                fontSize: 18,
                                color: primaryColor,
                                fontWeight: FontWeight.w600)),
                      ),
                      namesIndex == 0
                          ? FadeTransition(
                              opacity: _animation,
                              child: Text("👨‍👩‍👧‍👦",
                                  style: GoogleFonts.rubik(fontSize: 18)),
                            )
                          : (namesIndex == 3
                              ? FadeTransition(
                                  opacity: _animation,
                                  child: Text("👧🏾👦🏻",
                                      style: GoogleFonts.rubik(fontSize: 18)),
                                )
                              : (namesIndex == 4
                                  ? FadeTransition(
                                      opacity: _animation,
                                      child: Text("❤️",
                                          style:
                                              GoogleFonts.rubik(fontSize: 18)),
                                    )
                                  : Container()))
                    ])),
          ],
        ),
      ),
    );
  }
}
