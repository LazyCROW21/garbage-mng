import 'package:flutter/material.dart';

class OTPInput extends StatefulWidget {
  final String phoneNumber;
  final Function onClick;
  const OTPInput({super.key, required this.phoneNumber, required this.onClick});

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  String otp1 = '';
  String otp2 = '';
  String otp3 = '';
  String otp4 = '';
  String otp5 = '';
  String otp6 = '';

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
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'We have send code to',
            textAlign: TextAlign.center,
          ),
          Text(
            widget.phoneNumber,
            textAlign: TextAlign.center,
          ),
          const Text(
            'Enter code here and continue',
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLength: 1,
                  decoration: const InputDecoration(counterText: ""),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (String inp) {
                    if (inp.length == 1) {
                      otp1 = inp;
                      FocusScope.of(context).nextFocus();
                    } else {
                      otp1 = '';
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(counterText: ""),
                  textAlign: TextAlign.center,
                  onChanged: (String inp) {
                    if (inp.length == 1) {
                      otp2 = inp;
                      FocusScope.of(context).nextFocus();
                    } else {
                      otp2 = '';
                      FocusScope.of(context).previousFocus();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(counterText: ""),
                  textAlign: TextAlign.center,
                  onChanged: (String inp) {
                    if (inp.length == 1) {
                      otp3 = inp;
                      FocusScope.of(context).nextFocus();
                    } else {
                      otp3 = '';
                      FocusScope.of(context).previousFocus();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(counterText: ""),
                  textAlign: TextAlign.center,
                  onChanged: (String inp) {
                    if (inp.length == 1) {
                      otp4 = inp;
                      FocusScope.of(context).nextFocus();
                    } else {
                      otp4 = '';
                      FocusScope.of(context).previousFocus();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(counterText: ""),
                  textAlign: TextAlign.center,
                  onChanged: (String inp) {
                    if (inp.length == 1) {
                      otp5 = inp;
                      FocusScope.of(context).nextFocus();
                    } else {
                      otp5 = '';
                      FocusScope.of(context).previousFocus();
                    }
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: TextField(
                  maxLength: 1,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(counterText: ""),
                  textAlign: TextAlign.center,
                  onChanged: (String inp) {
                    if (inp.length == 1) {
                      otp6 = inp;
                      FocusScope.of(context).nextFocus();
                    } else {
                      otp6 = '';
                      FocusScope.of(context).previousFocus();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          ElevatedButton(
              onPressed: () {
                String otp = '$otp1$otp2$otp3$otp4$otp5$otp6';
                if (otp.length == 6) {
                  widget.onClick(otp);
                } else {
                  const snackBar =
                      SnackBar(content: Text('Enter a valid phone'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ))
        ],
      ),
    );
  }
}
