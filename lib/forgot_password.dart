import 'package:audio_tale/utils/toast.dart';
import 'package:audio_tale/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40,),
                  Image.asset('assets/images/AudioTale_logo.png', height: 220, width: 250),
                  const SizedBox(height: 50,),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your email to reset password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  RoundButton(
                    title: "Reset Password",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        auth.sendPasswordResetEmail(email: emailController.text).then((value) {
                          toastMesage("An email has been sent to you for password reset!", Colors.green);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => const Login()));
                        }).onError((error, stackTrace) {
                          toastMesage("Enter correct email address!", Colors.red);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
