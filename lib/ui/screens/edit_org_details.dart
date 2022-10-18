import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/models/user_model.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/ui/widgets/otp_input.dart';

class EditOrganisationDetails extends StatefulWidget {
  final UserModel? editOrganisation;
  const EditOrganisationDetails({Key? key, required this.editOrganisation}) : super(key: key);

  @override
  State<EditOrganisationDetails> createState() => _EditOrganisationDetailsState();
}

class _EditOrganisationDetailsState extends State<EditOrganisationDetails> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  final organisation = <String, dynamic>{'fullName': '', 'phone': ''};

  String firebaseOTPVerificationId = '';
  int step = 1;

  String countryCodeValue = '';
  // List of items in our dropdown menu
  var countryCodes = [
    '+91',
  ];

  bool isSaving = false;
  bool isEditOrg = false;
  bool isDeleting = false;

  @override
  void initState() {
    if (countryCodes.isNotEmpty) {
      countryCodeValue = countryCodes[0];
    }
    if (widget.editOrganisation != null) {
      isEditOrg = true;
      countryCodeValue = widget.editOrganisation!.phone.substring(0, 3);
    }
    super.initState();
  }

  String? fullNameValidator(String? inp) {
    if (inp == null) {
      return 'Title is required';
    } else if (inp.length < 3 || inp.length > 64) {
      return 'Title must be 3 to 64 characters';
    }
    return null;
  }

  String? phoneValidator(String? inp) {
    if (inp == null) {
      return 'Phone is required';
    } else if (inp.length != 10) {
      return 'Please enter a valid phone';
    }
    return null;
  }

  addOrganisation() {
    setState(() {
      isSaving = true;
    });
    organisation['type'] = 'buyer';
    AuthService.sendOTP(organisation['phone'] ?? '', (String verificationId, int? resendToken) {
      firebaseOTPVerificationId = verificationId;
      setState(() {
        isSaving = false;
        step = 2;
      });
    }).catchError((err) {
      setState(() {
        isSaving = false;
      });
      const snackBar = SnackBar(content: Text('Error in saving'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  onOTPSubmit(String smsCode) async {
    setState(() {
      isSaving = true;
    });
    try {
      await AuthService.createAccount(
          organisation['fullName'] ?? '', organisation['phone'] ?? '', firebaseOTPVerificationId, smsCode, 'buyer');
      setState(() {
        isSaving = false;
      });
      if (mounted) {
        const snackBar = SnackBar(content: Text('Organisation added'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      setState(() {
        isSaving = false;
      });
      const snackBar = SnackBar(content: Text('Invalid OTP'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  updateOrganisation() {
    setState(() {
      isSaving = true;
    });
    usersCollection.doc(widget.editOrganisation!.id).update(organisation).then((value) {
      setState(() {
        isSaving = false;
      });
    }).catchError((err) {
      setState(() {
        isSaving = false;
      });
      const snackBar = SnackBar(content: Text('Error in saving'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  removeOrganisation() {
    setState(() {
      isDeleting = false;
    });
    usersCollection.doc(widget.editOrganisation!.id).delete().then((value) {
      setState(() {
        isDeleting = false;
      });
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Organisation removed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((err) {
      setState(() {
        isDeleting = false;
      });
      const snackBar = SnackBar(content: Text('Error in saving'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${isEditOrg ? 'Edit' : 'Add'} Organisation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: step == 1
              ? ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Organisation Name'),
                      validator: fullNameValidator,
                      initialValue: widget.editOrganisation?.fullName,
                      onSaved: (String? inp) {
                        organisation['fullName'] = inp ?? '';
                      },
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      height: 64,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: DropdownButton(
                                underline: const SizedBox.shrink(),
                                value: countryCodeValue,
                                items: countryCodes
                                    .map((String countryCode) => DropdownMenuItem(value: countryCode, child: Text(countryCode)))
                                    .toList(),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    countryCodeValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 5,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                initialValue: widget.editOrganisation?.phone.substring(3),
                                decoration: const InputDecoration(labelText: 'Phone'),
                                validator: phoneValidator,
                                onSaved: (String? inp) {
                                  organisation['phone'] = '$countryCodeValue${inp ?? ''}';
                                },
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          bool? isValid = formKey.currentState?.validate();
                          if (isValid == null || isValid == false) {
                            return;
                          }
                          formKey.currentState?.save();
                          if (isEditOrg) {
                            updateOrganisation();
                          } else {
                            addOrganisation();
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isSaving
                                  ? const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: SpinKitRing(
                                        color: Colors.white,
                                        lineWidth: 2,
                                        size: 18.0,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              Text(
                                isEditOrg ? 'Save' : 'Add',
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 12,
                    ),
                    isEditOrg
                        ? ElevatedButton(
                            onPressed: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                        title: const Text('Confirm delete?'),
                                        content: const Text('Are you sure you want to delete this item?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, 'Delete');
                                              removeOrganisation();
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isDeleting
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
                                    'Remove',
                                    style: TextStyle(color: Colors.red, fontSize: 18),
                                  ),
                                ],
                              ),
                            ))
                        : Container()
                  ],
                )
              : OTPInput(phoneNumber: organisation['phone'] ?? '', isLoading: isSaving, onClick: onOTPSubmit),
        ),
      ),
    );
  }
}
