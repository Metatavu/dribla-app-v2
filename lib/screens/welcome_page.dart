import "package:dribla_app_v2/components/app_drawer.dart";
import "package:dribla_app_v2/components/app_header_appbar.dart";
import "package:dribla_app_v2/screens/account_creation_password_screen.dart";
import "package:dribla_app_v2/screens/main_page_screen.dart";
import 'package:flutter/material.dart';
import "package:sizer/sizer.dart";
import "package:dribla_app_v2/theme/theme.dart";

class WelcomePageScreen extends StatefulWidget {
  const WelcomePageScreen({Key? key}) : super(key: key);

  @override
  State<WelcomePageScreen> createState() => _WelcomePageScreenState();
}

class _WelcomePageScreenState extends State<WelcomePageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeaderAppBar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/dribla_new_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Welcome!'),
                  const SizedBox(height: 16),
                  Text(
                      'Join now for early access and get 6 months of free play time!'),
                  const SizedBox(height: 16),
                  Image(image: AssetImage("assets/promo_image_mat.jpg")),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Navigate to the next screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPageScreen()),
                          );
                        }
                      },
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text('Subscribe now'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )),
      ),
    );
  }
}
