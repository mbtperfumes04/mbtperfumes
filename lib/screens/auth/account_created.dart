import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/screens/hub.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountCreated extends StatefulWidget {
  const AccountCreated({super.key});

  @override
  State<AccountCreated> createState() => _AccountCreatedState();
}

class _AccountCreatedState extends State<AccountCreated> {
  bool isLoading = false;
  final TextEditingController _usernameController = TextEditingController();

  Future<void> updateUsername() async {
    if(_usernameController.text.trim().isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {

      final data = await supabase
          .auth
          .updateUser(
            UserAttributes(
              data: {
                'username': _usernameController.text.trim()
              }
            )
          );

      Get.offAll(() => const Hub());

    } catch(e) {
      print('Exception: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(
          'Successful',
          style: TextStyle(fontSize: screenWidth * 0.04),
        ),
      ),
      body: Container(
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/general/MBTLogo3.png',
              width: screenWidth * 0.4,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'What should we call you?',
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
                'Enter a username that we can use to call you, make sure it is unique!',
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
                  controller: _usernameController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      color: Color(0xff808080),
                    ),
                  ),
                ),
              ),
            ),
            Text('finish account setup by clicking',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w300,
                color: Color(0xffad2d2f),
              ),),
            SizedBox(height: screenHeight * 0.04),
            InkWell(
              onTap: () => updateUsername(),
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
                    Icon(Icons.check_circle, color: Colors.white, size: screenWidth * 0.05),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Done',
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
          ],
        ),
      ),
    );
  }
}
