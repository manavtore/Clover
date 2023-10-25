import 'package:blackoffer/auth/OtpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  var number = TextEditingController();
  String verificationId = "";

  Future<void> SendOtp() async {
    final auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+91${number.text}',
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendtoken) {
          setState(() {
            this.verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150),
            TextField(
              controller: number,
              onChanged: (value) {
                number.text = value;
              },
              decoration: InputDecoration(hintText: "Enter Number"),
            ),
            OutlinedButton(
              onPressed: () async {
                await SendOtp();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OptView(value: verificationId),
                  ),
                );
              },
              child: Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
