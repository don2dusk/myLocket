import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/colors.dart';

class PicturePreview extends StatefulWidget {
  const PicturePreview({super.key, required this.file});

  final File file;

  @override
  State<PicturePreview> createState() => _PicturePreviewState();
}

class _PicturePreviewState extends State<PicturePreview> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseStorage storage = FirebaseStorage.instance;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String message = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      "Send to...",
                      style: GoogleFonts.rubik(
                          fontSize: 20,
                          color: white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                    width: size.width,
                    height: size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),
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
                                      child: Image.file(widget.file),
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: secondaryColor,
                                ),
                                child: IntrinsicWidth(
                                  child: TextFormField(
                                    onSaved: (value) => message = value!,
                                    scrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                    maxLines: 1,
                                    initialValue: "Add Message",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50)
                      .copyWith(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close_outlined,
                            size: 45, color: white),
                      ),
                      TextButton(
                        onPressed: () async {
                          _formKey.currentState!.save();
                          String fileName =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          Reference reference =
                              storage.ref().child('images/$fileName');
                          UploadTask uploadTask =
                              reference.putFile(widget.file);
                          TaskSnapshot storageTaskSnapshot =
                              await uploadTask.whenComplete(() {});
                          String downloadUrl =
                              await storageTaskSnapshot.ref.getDownloadURL();
                          var imageRef = users
                              .doc(_auth.currentUser!.uid)
                              .collection('images')
                              .doc(fileName);
                          await imageRef.set({
                            'message': message,
                            'url': downloadUrl,
                            'visibility': true
                          });
                          Get.back();
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: secondaryColor,
                            shape: const CircleBorder(
                              side: BorderSide.none,
                            )),
                        child: const Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Iconsax.send_2,
                            size: 40,
                            color: white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {},
                          icon: const Icon(CupertinoIcons.tray_arrow_down,
                              size: 45),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "History",
                            style: GoogleFonts.rubik(
                                textStyle: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          ),
                          const Icon(Iconsax.arrow_down_1, size: 30)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
