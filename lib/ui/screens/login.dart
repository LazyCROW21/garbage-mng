import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/ui/widgets/otp_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phone = '', firebaseOTPVerificationId = '';
  int step = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                  'Waste Management App',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.lightGreen, fontSize: 24),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                          'https://img.icons8.com/external-justicon-flat-justicon/64/000000/external-recycle-ecology-justicon-flat-justicon.png'),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'GarBage',
                            style: TextStyle(color: Colors.lightGreen, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text('Don\'t Throw, Grow!')
                        ],
                      )
                    ],
                  )),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Welcome to GarBage!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(child: Container()),
              step == 1
                  ? StepOne(
                      onStepComplete: (String phoneNumber) async {
                        phone = phoneNumber;
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phone,
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
                      },
                    )
                  : OTPInput(
                      phoneNumber: phone,
                      onClick: (String smsCode) async {
                        try {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(verificationId: firebaseOTPVerificationId, smsCode: smsCode);
                          await auth.signInWithCredential(credential);
                          Navigator.of(context).pushReplacementNamed('/home');
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
              Expanded(child: Container()),
              const Text(
                'By signing in you agree to our terms & conditions',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              )
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
  final phoneInpController = TextEditingController();
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
    phoneInpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Please provide your Mobile number',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
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
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneInpController,
                    ))
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                String phone = phoneInpController.text;
                if (phone.length == 10) {
                  widget.onStepComplete(countryCodeValue + phone);
                } else {
                  const snackBar = SnackBar(content: Text('Enter a valid phone'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Send OTP',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          const SizedBox(
            height: 8.0,
          ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'New to GarBage? ',
                  style: const TextStyle(color: Colors.black, fontFamily: 'Poppins', fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/signup');
                          },
                        text: 'Signup now',
                        style: const TextStyle(
                            color: Colors.lightBlue,
                            decoration: TextDecoration.underline,
                            fontFamily: 'Poppins',
                            fontSize: 16)),
                  ])),
        ],
      ),
    );
  }
}
