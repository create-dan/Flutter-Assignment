// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blackcoffer_flutter/Screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String? verificationId;

  bool _isSendingOTP = false;
  bool _validateOTP = false;



  Future<void> _verifyPhoneNumber() async {

    setState(() {
      _isSendingOTP = true; // Set to true when sending OTP
    });
    final String phoneNumber = "+91" + mobileController.text.trim();

    try {
      print('inside verifyphone');
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Navigate to the main screen or perform other actions.
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification Failed: ${e}");
        },
        codeSent: (String verificationId, int? resendToken) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("OTP Sent"),
          ));
          this.verificationId = verificationId;
          setState(() {
            _isSendingOTP = false; // Set back to false after OTP is sent
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
      );
    } catch (e) {
      print("Error sending OTP: $e");
    }
  }




  Future<void> _signInWithOTP() async {

    setState(() {
      _validateOTP = true; // Set back to false after OTP is sent
    });
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otpController.text.trim(),
    );

    try {
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      print(userCredential);

      // Check if the user already exists in the Firestore collection
      final userUid = userCredential.user?.uid;
      print(userUid);
      final mobileNumber = mobileController.text.trim();

      if (userUid != null && mobileNumber.isNotEmpty) {
        // Reference to the Firestore collection
        final usersCollection = FirebaseFirestore.instance.collection('users');

        // Create a document with the mobile number as the ID
        DocumentReference userDocument = usersCollection.doc(mobileNumber);

        await userDocument.set({
          'uid': userUid,
          'mobileNumber': mobileNumber,
        });



        // Print success message
        print('User data saved to Firestore');
        setState(() {
          _validateOTP = true; // Set back to false after OTP is sent
        });

         if(mounted) {
           Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(),), // Replace with your MainScreen widget
        );
         }
      } else {
        print('User data could not be saved');
      }
    } catch (e) {
      print("Error verifying OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Login"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextFormField(
              //   controller: emailController,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: InputDecoration(
              //     labelText: "Email",
              //   ),
              // ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                ),
              ),
              SizedBox(height: 16.0),
              // ElevatedButton(
              //   onPressed: _verifyPhoneNumber,
              //   child: Text("Send OTP"),
              // ),
              ElevatedButton(
                onPressed: _verifyPhoneNumber,
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal, // Set your desired button color
                  elevation: 3, // Add elevation for a raised effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Set border radius
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.send, // Set your desired icon
                      size: 24,
                      color: Colors.white, // Set the icon color
                    ),
                    SizedBox(width: 8),
                    _isSendingOTP
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ):
// Add spacing between icon and text
                    Text(
                      "Send OTP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Set text color
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.0),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                ),
              ),
              SizedBox(height: 16.0),

              ElevatedButton(
                onPressed: _signInWithOTP,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Set your desired button color
                  elevation: 3, // Add elevation for a raised effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Set border radius
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.send, // Set your desired icon
                      size: 24,
                      color: Colors.white, // Set the icon color
                    ),
                    SizedBox(width: 8),

                    _validateOTP
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ):
// Add spacing between icon and text
                    Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Set text color
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
