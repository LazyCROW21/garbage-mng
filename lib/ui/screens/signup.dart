import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/ui/widgets/otp_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int step = 1;
  bool isLoginningIn = false;
  String firebaseOTPVerificationId = '';
  Map<String, String> userForm = {'fullName': '', 'phone': ''};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onStepOneComplete(Map<String, String> data) {
    userForm['fullName'] = data['fullName'] ?? '';
    userForm['phone'] = data['phone'] ?? '';
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: data['phone'],
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        firebaseOTPVerificationId = verificationId;
        setState(() {
          step = 2;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  onOTPSubmit(String smsCode) async {
    setState(() {
      isLoginningIn = true;
    });
    try {
      await AuthService.createAccount(
          userForm['fullName'] ?? '', userForm['phone'] ?? '', firebaseOTPVerificationId, smsCode, 'seller');
      setState(() {
        isLoginningIn = false;
      });
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      setState(() {
        isLoginningIn = false;
      });
      const snackBar = SnackBar(content: Text('Invalid OTP'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Hello!',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 32),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Let\'s Introduce',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 24),
                ),
              ),
              Expanded(child: Container()),
              step == 1
                  ? StepOne(
                      onStepComplete: onStepOneComplete,
                    )
                  : OTPInput(phoneNumber: userForm['phone'] ?? '', isLoading: isLoginningIn, onClick: onOTPSubmit),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}

class StepOne extends StatefulWidget {
  final Function onStepComplete;

  const StepOne({super.key, required this.onStepComplete});

  @override
  State<StepOne> createState() => _StepOneState();
}

class _StepOneState extends State<StepOne> {
  TextEditingController fullNameInp = TextEditingController();
  TextEditingController phoneInp = TextEditingController();
  String countryCodeValue = '';

  // List of items in our dropdown menu
  var countryCodes = [
    '+91',
  ];

  @override
  void initState() {
    if (countryCodes.isNotEmpty) {
      countryCodeValue = countryCodes[0];
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? fullNameValidator(String? inp) {
    if (inp == null) {
      return 'Full name is required';
    } else if (inp.length < 3 || inp.length > 64) {
      return 'Full name should be 3 to 64 characters long';
    }
    return null;
  }

  String? phoneValidator(String? inp) {
    if (inp == null) {
      return 'Phone is required';
    } else if (inp.length != 10) {
      return 'Phone be 3 to 64 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: 'Full Name'),
            controller: fullNameInp,
            validator: fullNameValidator,
            autovalidateMode: AutovalidateMode.always,
          ),
          const SizedBox(
            height: 16,
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
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(hintText: 'Phone Number'),
                      controller: phoneInp,
                      autovalidateMode: AutovalidateMode.always,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.lightGreen),
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Prev',
                        style: TextStyle(color: Colors.lightGreen),
                      ),
                    )),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () async {
                      if (fullNameValidator(fullNameInp.text) != null || phoneValidator(phoneInp.text) != null) {
                        return;
                      }
                      widget.onStepComplete({'fullName': fullNameInp.text, 'phone': '$countryCodeValue${phoneInp.text}'});
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
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
