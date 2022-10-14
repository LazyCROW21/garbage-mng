import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/ui/widgets/otp_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int step = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onStepOneComplete() {
    setState(() {
      step = 2;
    });
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
                  : OTPInput(
                      phoneNumber: '',
                      onClick: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Full Name'),
            controller: fullNameInp,
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Phone Number'),
            controller: phoneInp,
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
                      try {
                        widget.onStepComplete();
                      } on FirebaseAuthException catch (e) {
                        print(e);
                      }
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
