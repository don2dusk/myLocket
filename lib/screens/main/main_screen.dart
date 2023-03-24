import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
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
    // _controller = CameraController(
    //     globals.cameras[currentCameraIndex], ResolutionPreset.medium,
    //     imageFormatGroup: ImageFormatGroup.jpeg, enableAudio: false);
    // _initializeControllerFuture = _controller.initialize();
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

    return Scaffold(
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
                          onPressed: () {},
                          icon: const Icon(Iconsax.user, color: Colors.white),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                      ),
                      currentPageIndex == 0
                          ? TextButton.icon(
                              onPressed: () {},
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
                            )
                          : TextButton(
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
                            ),
                      CircleAvatar(
                        backgroundColor: secondaryColor,
                        radius: 25,
                        child: IconButton(
                          onPressed: () {},
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
                        animationController.reset();
                        animationController.forward();
                      });
                    },
                    children: [
                      Column(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(75),
                              ),
                            ),
                          ),
                          // FutureBuilder<void>(
                          //   future: _initializeControllerFuture,
                          //   builder: (context, snapshot) {
                          //     if (snapshot.connectionState ==
                          //         ConnectionState.done) {
                          //       return GestureDetector(
                          //         onDoubleTap: onSwitchCamera,
                          //         child: SizedBox(
                          //             width: size.width,
                          //             height: size.width,
                          //             child: ClipRRect(
                          //               borderRadius: BorderRadius.circular(75),
                          //               child: OverflowBox(
                          //                   alignment: Alignment.center,
                          //                   child: FittedBox(
                          //                       fit: BoxFit.fitWidth,
                          //                       child: SizedBox(
                          //                           width: size.width,
                          //                           child: CameraPreview(
                          //                               _controller)))),
                          //             )),
                          //       );
                          //     } else {
                          //       return AspectRatio(
                          //         aspectRatio: 1,
                          //         child: Container(
                          //           width: size.width,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(50),
                          //           ),
                          //         ),
                          //       );
                          //     }
                          //   },
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40)
                                .copyWith(top: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                onTap: () => _pageViewController.animateToPage(
                                    1,
                                    duration: const Duration(milliseconds: 500),
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
                                                          const EdgeInsets.only(
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
                                                                  fontSize: 16,
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
                                            padding: const EdgeInsets.all(8.0),
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
        ));
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
