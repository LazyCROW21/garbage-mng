import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/common/validators.dart';
import 'package:garbage_mng/providers/theme_provider.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isUpdating = false;
  bool darkMode = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  File? imageFile;
  String? imageFirebaseURL;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
      if (image == null) return;
      setState(() {
        imageFile = File(image.path);
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  updateUser() async {
    if (isUpdating) {
      return;
    }
    setState(() {
      isUpdating = true;
    });
    try {
      if (imageFile != null) {
        String path = 'files/user_${AuthService.user!.id}';
        await FirebaseStorage.instance.ref().child(path).putFile(imageFile!);
      }
      var userCollection = FirebaseFirestore.instance.collection("users");
      await userCollection
          .doc(AuthService.user!.id)
          .update({'fullName': fullNameController.text, 'address': addressController.text});
    } catch (e) {
      const snackBar = SnackBar(content: Text('Something went wrong'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() {
      isUpdating = false;
    });
  }

  @override
  void initState() {
    fullNameController.text = AuthService.user!.fullName;
    addressController.text = AuthService.user!.address;
    darkMode = context.read<ThemeNotifier>().isDarkMode;
    String path = 'files/user_${AuthService.user!.id}';
    FirebaseStorage.instance.ref().child(path).getDownloadURL().then((value) {
      setState(() {
        imageFirebaseURL = value;
      });
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
    });
    super.initState();
  }

  saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    border: Border.all(color: context.watch<ThemeNotifier>().isDarkMode ? Colors.lightGreen : Colors.black),
                    shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(64),
                  child: imageFile != null
                      ? Image.file(
                          imageFile!,
                          height: 128,
                          width: 128,
                          fit: BoxFit.cover,
                        )
                      : (imageFirebaseURL == null
                          ? Image.asset(
                              'assets/images/account.png',
                              height: 128,
                              width: 128,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              imageFirebaseURL!,
                              height: 128,
                              width: 128,
                              fit: BoxFit.cover,
                            )),
                ),
              ),
            ),
            TextButton(
              onPressed: () => pickImage(),
              child: const Text(
                'Upload Image',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: fullNameValidator,
              autovalidateMode: AutovalidateMode.always,
              controller: fullNameController,
            ),
            const SizedBox(
              height: 32,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 4,
              validator: addressValidator,
              autovalidateMode: AutovalidateMode.always,
              controller: addressController,
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              context.watch<ThemeNotifier>().isDarkMode ? Colors.black : Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ))),
                ),
                const SizedBox(
                  width: 32,
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: updateUser,
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isUpdating
                                ? const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: SpinKitRing(
                                      color: Colors.white,
                                      lineWidth: 2,
                                      size: 18.0,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            SwitchListTile(
              title: const Text('Dark mode'),
              onChanged: (value) {
                setState(() {
                  darkMode = value;
                  context.read<ThemeNotifier>().toggleMode(value);
                  saveSettings();
                });
              },
              value: darkMode,
            )
          ],
        ),
      ),
    );
  }
}
