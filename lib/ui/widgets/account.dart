import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/services/auth.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isUpdating = false;
  TextEditingController fullNameController = TextEditingController();

  String? fullNameValidator(String? inp) {
    if (inp == null) {
      return 'Full name is required';
    } else if (inp.length < 3 || inp.length > 64) {
      return 'Full name should be 3 to 64 characters long';
    }
    return null;
  }

  updateUser() async {
    if (isUpdating) {
      return;
    }
    setState(() {
      isUpdating = true;
    });
    try {
      var userCollection = FirebaseFirestore.instance.collection("users");
      await userCollection.doc(AuthService.user!.id).update({
        'fullName': fullNameController.text,
      });
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.black), shape: BoxShape.circle),
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
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
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
        ],
      ),
    );
  }
}
