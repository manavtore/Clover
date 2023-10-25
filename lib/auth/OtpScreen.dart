import 'package:blackoffer/Screens/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OptView extends StatefulWidget {
  OptView({
    Key? key,
    required this.value,
  }) : super(key: key);

  final String value;

  @override
  State<OptView> createState() => _OptViewState();
}

class _OptViewState extends State<OptView> {
  var otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
      ),
      body: Center(
        child: OTPTextField(
          length: 6,
          width: MediaQuery.of(context).size.width,
          // fieldWidth: 80,
          style: const TextStyle(
            fontSize: 17,
          ),
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.underline,
          onCompleted: (pin) async {
            final auth = FirebaseAuth.instance;
            PhoneAuthCredential credential = PhoneAuthProvider.credential(
              verificationId: widget.value,
              smsCode: pin,
            );

            try {
              await auth.signInWithCredential(credential);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Homepage(),
                ),
              );
            } catch (e) {
              // Handle sign-in error, e.g., wrong OTP
              print("Sign-in error: $e");
            }
          },
        ),
      ),
    );
  }
}
