import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/common/validators.dart';
import 'package:garbage_mng/services/auth.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isUpdating = false;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  updateUser() async {
    if (isUpdating) {
      return;
    }
    setState(() {
      isUpdating = true;
    });
    try {
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  border: Border.all(color: isDarkMode ? Colors.lightGreen : Colors.black), shape: BoxShape.circle),
              child: const Icon(
                Icons.person,
                size: 64,
              ),
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
                        backgroundColor: MaterialStateProperty.all(isDarkMode ? Colors.black : Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          side: BorderSide(color: isDarkMode ? Colors.redAccent : Colors.red),
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Logout',
                          style: TextStyle(color: isDarkMode ? Colors.redAccent : Colors.red),
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
        ],
      ),
    );
  }
}
