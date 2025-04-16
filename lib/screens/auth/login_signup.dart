import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/screens/auth/otp_verification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginSignup extends StatefulWidget {
  const LoginSignup({super.key});

  @override
  State<LoginSignup> createState() => _LoginSignupState();
}

class _LoginSignupState extends State<LoginSignup> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  Future<void> auth() async {
    try {
      setState(() {
        isLoading = true;
      });
      await supabase
          .auth
          .signInWithOtp(
            email: _emailController.text.trim()
          );

      print("otp sent");
      setState(() {
        isLoading = false;
      });
      Get.to(() => OtpVerification(email: _emailController.text.trim(),));
    } catch (e) {
      final obj = e as AuthException;
      String timeLeft = obj.message.replaceAll(RegExp(r'[^0-9]'), '');
      print('Time from error: $timeLeft');

      if(timeLeft.isNotEmpty) {
        Get.to(() => OtpVerification(email: _emailController.text.trim(), codeTimeLeft: int.parse(timeLeft),));
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F0DE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text('Login or Sign Up',
        style: TextStyle(
          fontSize: screenWidth * 0.04
        ),),
      ),
      body: Container(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/general/MBTLogo3.png',
              width: screenWidth * 0.4,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text('Enter your Email',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
              color: Color(0xffad2d2f),
            ),),
            Center(
              child: Container(
                width: screenWidth * 0.8, // Adjust as needed (e.g. 90% of screen)
                height: screenHeight * 0.06,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email Address',
                    hintStyle: TextStyle(
                      color: Color(0xff808080),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.001),
            Text('receive a 6-digit code via',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w300,
                color: Color(0xffad2d2f),
              ),),
            SizedBox(height: screenHeight * 0.04),
            InkWell(
              onTap: () => auth(),
              child: Container(
                width: screenWidth * 0.4,
                height: screenHeight * 0.06,
                decoration: BoxDecoration(
                  color: Color(0xffad2d2f),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: isLoading? CupertinoActivityIndicator(color: Colors.white): Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, color: Colors.white, size: screenWidth * 0.05),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth * 0.035,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            //   child: Align(
            //     alignment: Alignment.centerLeft,
            //     child: Text(
            //       'By logging in or creating an account, you agree to abide by our Terms of Service and acknowledge that you have read and understood our Privacy Policy.',
            //       style: TextStyle(
            //         fontSize: screenWidth * 0.035,
            //         color: Color(0xff808080),
            //       ),
            //       textAlign: TextAlign.left,
            //     ),
            //   ),
            // ),


          ],
        ),
      ),
    );
  }
}
