import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mbtperfumes/customs/custom_body.dart';
import 'package:mbtperfumes/globals.dart';
import 'package:mbtperfumes/main.dart';
import 'package:mbtperfumes/screens/auth/login_signup.dart';
import 'package:mbtperfumes/screens/hub.dart';

import '../customs/reusables/custom_option_sheet.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        isGradient: false,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.1,
              left: screenWidth * 0.07,
              right: screenWidth * 0.07
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDD5BC),
                          shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: Icon(
                        Icons.person,
                        size: screenWidth * 0.08,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Container(
                      decoration: const BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello!',
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: screenWidth * 0.031,
                                color: const Color(0xFF808080)
                            ),
                          ),
                          Text(supabase.auth.currentUser?.userMetadata?['username'] ?? 'User',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: screenWidth * 0.05
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  child: supabase.auth.currentUser == null ?
                  ElevatedButton(
                    onPressed: () => Get.to(() => const LoginSignup()),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary
                    ),
                    child: Text('Sign In',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ) : InkWell(
                    onTap: () {
                      showCustomOptionSheet(
                        context: context,
                        options: [
                          OptionItem(
                            icon: Icons.power_settings_new_outlined,
                            title: 'Log out',
                            onTap: () async {
                              await supabase.auth.signOut();

                              Get.offAll(() => const Hub());
                            },
                          ),
                        ],
                      );
                    },
                    child: Icon(Icons.more_horiz)
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
