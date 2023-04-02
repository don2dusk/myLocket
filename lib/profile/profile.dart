import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_locket/screens/screens.dart';
import 'package:my_locket/utils/colors.dart';
import 'package:my_locket/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class CustomTileItems extends StatelessWidget {
  const CustomTileItems(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.onTap});

  final leadingIcon;
  final String title;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade700,
                child: leadingIcon),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                title,
                style: GoogleFonts.rubik(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.white70,
                    ))),
          ]),
        ),
      ),
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  double _scrolloffset = 0.0;
  final double _swipeVelocityThreshold = 100.0;
  double _dragDistance = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  getData() {
    return Future(
      () async => await users
          .doc(_auth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        var data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          globals.name = data['name'];
          globals.mobileNumber = data['phoneNumber'];
        });
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrolloffset = _scrollController.offset;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! < 0) {
            _dragDistance += details.primaryDelta!.abs();
          } else {
            _dragDistance = 0.0;
          }
        },
        onHorizontalDragEnd: (details) {
          if (_dragDistance >= size.width / 4 &&
              details.primaryVelocity!.abs() > _swipeVelocityThreshold &&
              details.primaryVelocity! < 0) {
            Navigator.pop(context);
          }
          // Reset drag distance
          _dragDistance = 0.0;
        },
        child: Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            backgroundColor: backgroundColor!
                .withOpacity((_scrolloffset / 250).clamp(0, 1).toDouble()),
            elevation: 0,
            actions: [
              _scrolloffset > 250
                  ? Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 30),
                            CircleAvatar(
                                radius: 20,
                                backgroundColor: secondaryColor,
                                child: Center(
                                  child: Text(
                                    "${globals.name.split(" ")[0][0]}${globals.name.split(" ")[1][0]}",
                                    style: GoogleFonts.rubik(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: termsText),
                                  ),
                                )),
                            const SizedBox(width: 10),
                            Text(
                              globals.name.split(" ")[0],
                              style: GoogleFonts.rubik(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_forward_ios, size: 26)),
              )
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50)
                  .copyWith(top: 70),
              child: Column(children: [
                Center(
                  child: Stack(alignment: Alignment.center, children: [
                    CircleAvatar(
                        radius: 90,
                        backgroundColor: primaryColor,
                        child: Container(
                          height: 170,
                          decoration: BoxDecoration(
                              color: backgroundColor, shape: BoxShape.circle),
                        )),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: secondaryColor,
                      child: Stack(children: [
                        Center(
                          child: Text(
                            globals.name.isNotEmpty
                                ? "${globals.name.split(" ")[0][0]}${globals.name.split(" ")[1][0]}"
                                : "",
                            style: GoogleFonts.rubik(
                                fontSize: 72,
                                fontWeight: FontWeight.w700,
                                color: termsText),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: BoxDecoration(
                                color: backgroundColor, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.add_circle_rounded,
                              color: primaryColor,
                              size: 40,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      globals.name,
                      style: GoogleFonts.rubik(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: white),
                    )),
                TextButton(
                    onPressed: () {
                      modalSheet("name");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: secondaryColor,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Edit Info",
                      style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: white),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10)
                      .copyWith(top: 35),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.heart_circle,
                        color: termsText,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Widgets",
                        style: GoogleFonts.rubik(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: termsText),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: secondaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: backgroundColor,
                              border: Border.all(
                                  width: 4,
                                  color:
                                      const Color.fromARGB(166, 86, 86, 86))),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Stack(alignment: Alignment.center, children: [
                                  CircleAvatar(
                                      radius: 31,
                                      backgroundColor: primaryColor,
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            shape: BoxShape.circle),
                                      )),
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: termsText,
                                    child: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white60,
                                      size: 30,
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 10),
                                Text(
                                  "New Widget",
                                  style: GoogleFonts.rubik(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white60),
                                ),
                                Text(
                                  "Pick a friend",
                                  style: GoogleFonts.rubik(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: termsText),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey.shade700,
                              border: Border.all(width: 4, color: termsText!)),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                      left: 40,
                                      child: profilesPictureStack(
                                          15,
                                          Colors.grey.shade700,
                                          const AssetImage(
                                              "assets/imgs/karen.jpeg"))),
                                  Positioned(
                                      right: 40,
                                      child: profilesPictureStack(
                                          15,
                                          Colors.grey.shade700,
                                          const AssetImage(
                                              "assets/imgs/teni.jpeg"))),
                                  profilesPictureStack(
                                      20,
                                      Colors.grey.shade700,
                                      const AssetImage(
                                          "assets/imgs/daniella.jpeg")),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Everyone",
                                style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white70),
                              ),
                              Text(
                                "3 Friends",
                                style: GoogleFonts.rubik(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey[500]),
                              ),
                            ]),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                menuListItems(
                  Icon(
                    Iconsax.user4,
                    color: termsText,
                    size: 18,
                  ),
                  "General",
                  [
                    CustomTileItems(
                        leadingIcon: const Icon(
                          Icons.phone_rounded,
                          size: 25,
                          color: Colors.white60,
                        ),
                        title: "Change phone number",
                        onTap: () {
                          modalSheet("phone");
                        }),
                    CustomTileItems(
                        leadingIcon: const Icon(
                          Icons.help_rounded,
                          size: 25,
                          color: Colors.white60,
                        ),
                        title: "Get Help",
                        onTap: () async {
                          Uri url = Uri(
                              scheme: "https",
                              host: "github.com",
                              path: "/don2dusk/myLocket");
                          if (!await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          )) {
                            throw Exception('Could not launch $url');
                          }
                        }),
                    CustomTileItems(
                        leadingIcon: const Icon(
                          Iconsax.add_square5,
                          size: 25,
                          color: Colors.white60,
                        ),
                        title: "How to add the widget",
                        onTap: () {}),
                    CustomTileItems(
                        leadingIcon: const Icon(
                          Iconsax.send_2,
                          size: 25,
                          color: Colors.white60,
                        ),
                        title: "Share feedback",
                        onTap: () {})
                  ],
                  size,
                ),
                menuListItems(
                    Icon(
                      Iconsax.heart5,
                      color: termsText,
                      size: 18,
                    ),
                    "About",
                    [
                      CustomTileItems(
                          leadingIcon: const ImageIcon(
                            AssetImage("assets/imgs/github-logo.png"),
                            size: 25,
                            color: Colors.white60,
                          ),
                          title: "Github",
                          onTap: () async {
                            Uri url = Uri(
                                scheme: "https",
                                host: "github.com",
                                path: "/don2dusk");
                            if (!await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw Exception('Could not launch $url');
                            }
                          }),
                      CustomTileItems(
                          leadingIcon: const ImageIcon(
                            AssetImage("assets/imgs/twitter.png"),
                            size: 25,
                            color: Colors.white60,
                          ),
                          title: "Twitter",
                          onTap: () async {
                            Uri url = Uri(
                                scheme: "https",
                                host: "twitter.com",
                                path: "/don2dusk");
                            if (!await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw Exception('Could not launch $url');
                            }
                          }),
                      CustomTileItems(
                          leadingIcon: const ImageIcon(
                            AssetImage("assets/imgs/linkedin.png"),
                            size: 25,
                            color: Colors.white60,
                          ),
                          title: "LinkedIn",
                          onTap: () async {
                            Uri url = Uri(
                                scheme: "https",
                                host: "linkedin.com",
                                path: "/in/otega17");
                            if (!await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw Exception('Could not launch $url');
                            }
                          }),
                      CustomTileItems(
                          leadingIcon: const ImageIcon(
                            AssetImage("assets/imgs/click.png"),
                            size: 25,
                            color: Colors.white60,
                          ),
                          title: "Portfolio",
                          onTap: () async {
                            Uri url = Uri(
                              scheme: "https",
                              host: "don2dusk.github.io",
                            );
                            if (!await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw Exception('Could not launch $url');
                            }
                          })
                    ],
                    size),
                menuListItems(
                    Icon(
                      Iconsax.danger5,
                      color: termsText,
                      size: 18,
                    ),
                    "Danger Zone",
                    [
                      CustomTileItems(
                          leadingIcon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 25,
                            color: Colors.white60,
                          ),
                          title: "Delete account",
                          onTap: () {
                            users.doc(_auth.currentUser!.uid).delete();
                            _auth.currentUser!.delete();
                            Get.offAll(() => const WelcomeScreen());
                          }),
                      CustomTileItems(
                          leadingIcon: const Icon(
                            Icons.waving_hand_rounded,
                            size: 25,
                            color: Colors.white60,
                          ),
                          title: "Sign out",
                          onTap: () {
                            _auth.signOut();
                            Get.offAll(() => const WelcomeScreen());
                          }),
                    ],
                    size),
              ]),
            ),
          ),
        ));
  }

  Widget editField(
      String placeholder, onSaved, String initialValue, bool isEditable) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: TextFormField(
        readOnly: !isEditable,
        autofocus: true,
        cursorColor: primaryColor,
        style: GoogleFonts.rubik(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: !isEditable ? Colors.grey[500] : Colors.white),
        initialValue: initialValue,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: GoogleFonts.rubik(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          filled: true,
          fillColor: !isEditable ? Colors.grey[700] : secondaryColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
        ),
        onSaved: onSaved,
        validator: (value) {
          if (value!.isEmpty) {
            return "Field cannot be empty";
          }
          return null;
        },
      ),
    );
  }

  void modalSheet(String type) {
    Future<void> addName(String name) async {
      final User? user = _auth.currentUser;
      if (user != null) {
        final userRef = users.doc(_auth.currentUser!.uid);
        await userRef.update({
          'name': name,
        });
      }
    }

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String newName = "";
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        context: _scaffoldKey.currentContext!,
        builder: (modalContext) {
          return type == "phone"
              ? SizedBox(
                  height: size.height * 0.95,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 50,
                          height: 7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondaryColor),
                        ),
                      ),
                      Expanded(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Text(
                                "Change phone number",
                                style: GoogleFonts.rubik(
                                  fontSize: 26,
                                  color: white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            editField(
                                "", (value) {}, globals.mobileNumber, false),
                            const SizedBox(height: 50),
                            Container(
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.grey[500],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                child: Center(
                                  child: Text("Save",
                                      style: GoogleFonts.rubik(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: termsText)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                    ]),
                  ),
                )
              : SizedBox(
                  height: size.height * 0.95,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 50,
                          height: 7,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondaryColor),
                        ),
                      ),
                      Expanded(
                          child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Text(
                                "Change phone number",
                                style: GoogleFonts.rubik(
                                  fontSize: 26,
                                  color: white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            editField("First name", (value) => newName += value,
                                globals.name.split(" ")[0], true),
                            const SizedBox(height: 20),
                            editField(
                                "Last name",
                                (value) => newName += " $value",
                                globals.name.split(" ")[1],
                                true),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: size.width,
                              child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      addName(newName);
                                      setState(() {
                                        globals.name = newName;
                                      });
                                      Get.back();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text("Save",
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
                      ))
                    ]),
                  ),
                );
        });
  }

  Widget profilesPictureStack(double radius, Color color, AssetImage image) {
    return Stack(alignment: Alignment.center, children: [
      CircleAvatar(
        radius: radius + 8.5,
        backgroundColor: color,
        child: CircleAvatar(
            radius: radius + 6,
            backgroundColor: primaryColor,
            child: Container(
              height: (radius + 3) * 2,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )),
      ),
      CircleAvatar(
        radius: radius,
        backgroundColor: white,
        backgroundImage: image,
      ),
    ]);
  }

  Widget menuListItems(
      Icon icon, String title, List<CustomTileItems> children, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.rubik(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: termsText),
              ),
            ],
          ),
        ),
        Container(
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: secondaryColor,
            ),
            child: ListView(
              controller: ScrollController(
                  initialScrollOffset: 0, keepScrollOffset: false),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: children,
            )),
      ],
    );
  }
}
