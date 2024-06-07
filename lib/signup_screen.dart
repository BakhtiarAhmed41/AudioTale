import 'package:audio_tale/home.dart';
import 'package:audio_tale/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audio_tale/utils/toast.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var display = true;
  bool loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void register() {
    if(_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      _auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString()).then((value){
        setState(() {
          loading = false;
        });
        toastMesage("Account Created Successfully!", Colors.green);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=> const Home())
        );
      }).onError((error, stackTrace){
        setState(() {
          loading = false;
        });
        toastMesage(error.toString(), Colors.red);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SignUp Screen"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Center(
              child: Image.asset('assets/images/AudioTale_logo.png', height: 220, width: 250),
            ),
            const SizedBox(height: 50),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: "Email",
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter your email";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: display,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              display = !display;
                            });
                          },
                          icon: const Icon(Icons.remove_red_eye),
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Enter your password";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            RoundButton(
              title: 'Register',
              loading: loading,
              onTap: register,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text("Already registered? ", style: TextStyle(color: Colors.white)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text('Login', style: TextStyle(color: Colors.blue)),
                ),
                const Text(' here', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
