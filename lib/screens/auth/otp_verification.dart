import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/screens/auth/account_created.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../globals.dart';
import '../hub.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  final int? codeTimeLeft;
  const OtpVerification({super.key, required this.email, this.codeTimeLeft});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();

  int _resendCooldown = -1;
  Timer? _timer;bool
  _isResending = false;
  bool _isResendAvailable = false;

  @override
  void initState() {
    super.initState();
    _startResendCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> resendCode() async {
    if (!_isResendAvailable || _isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      await supabase.auth.signInWithOtp(email: widget.email);
      print("OTP sent");

      setState(() {
        _isResendAvailable = false;
        _resendCooldown = 300;
      });

      _startResendCooldown();
    } catch (e) {
      final obj = e as AuthException;
      String timeLeft = obj.message.replaceAll(RegExp(r'[^0-9]'), '');
      print('Time from error: $timeLeft');
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  void _startResendCooldown() {

    setState(() {
      _resendCooldown = widget.codeTimeLeft ?? 300;
    });

    _isResendAvailable = false;

    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendCooldown == 0) {
        timer.cancel();
        setState(() {
          _isResendAvailable = true;
        });
      } else {
        setState(() {
          _resendCooldown--;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          'OTP Verification',
          style: TextStyle(fontSize: screenWidth * 0.04),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/general/MBTLogo3.png',
            width: screenWidth * 0.4,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'Verification',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.7,
              color: Color(0xffad2d2f),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Text(
              'Kindly check the OTP verification code that has been sent to your email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w300,
                color: Color(0xff808080),
              ),
            ),
          ),
          Center(
            child: Container(
              height: screenHeight * 0.06,
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: OtpPinField(
                key: _otpPinFieldController,
                onSubmit: (val) {},
                onChange: (val) {},
                maxLength: 6,
                keyboardType: TextInputType.number,
                otpPinFieldDecoration:
                OtpPinFieldDecoration.roundedPinBoxDecoration,
                otpPinFieldStyle: OtpPinFieldStyle(
                  activeFieldBorderColor: const Color(0xffad2d2f),
                  defaultFieldBorderColor: const Color(0xFFBCBCBC),
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.001),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: "Didn't Receive? "),
                TextSpan(
                  text: _isResending ? 'Sending...' : _isResendAvailable
                      ? "Resend Code"
                      : "Resend in $_resendCooldown sec",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _isResendAvailable
                        ? Color(0xffad2d2f)
                        : Color(0xff808080),
                  ),
                  recognizer: _isResendAvailable
                      ? (TapGestureRecognizer()..onTap = resendCode)
                      : null,
                )
              ],
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w300,
                color: Color(0xffad2d2f),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.04),
          InkWell(
            onTap: () async {
              final fields = _otpPinFieldController.currentState?.pinsInputed;

              if((fields ?? []).any((e) => e.isEmpty)) {
                print("There's an empty field");

                return;
              }

              String field = (fields ?? []).join();

              print(field);

              try {
                final data = await supabase.auth.verifyOTP(
                    type: OtpType.email,
                    email: widget.email,
                    token: field
                );

                print(data);

                if (supabase.auth.currentUser?.userMetadata?['username'] != null) {
                  Get.offAll(() => const Hub());

                  return;
                }
                Get.offAll(() => const AccountCreated());
              } catch(e) {
                print('Exception: $e');
              }
            },
            child: Container(
              width: screenWidth * 0.4,
              height: screenHeight * 0.06,
              decoration: BoxDecoration(
                color: Color(0xffad2d2f),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined,
                      color: Colors.white, size: screenWidth * 0.05),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'Verify OTP',
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
        ],
      ),
    );
  }
}
