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
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var display = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,

      child: Scaffold(
        appBar: AppBar(
            title: const Text("SignUp Screen")
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30,),
              Center(child: Image.asset('assets/images/AudioTale_logo.png', height: 220, width: 250,)),
              const SizedBox(height: 50,),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.all(10.0),
                    //   child: TextFormField(
                    //     controller: nameController,
                    //     keyboardType: TextInputType.name,
                    //     decoration: const InputDecoration(
                    //       prefixIcon: Icon(Icons.drive_file_rename_outline),
                    //       hintText: "Name",
                    //     ),
                    //     validator: (value){
                    //       if(value!.isEmpty){
                    //         return "Enter your name";
                    //       }
                    //       else{
                    //         return null;
                    //       }
                    //     },
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
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
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: display,
                        decoration:  InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  display = !display;
                                });
                              },
                              icon: const Icon(Icons.remove_red_eye)),
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter your password";
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
              RoundButton(
                title: 'Register',
                onTap: () {
                  if(_formKey.currentState!.validate()) {
                    _auth.createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString()).then((value){
                          toastMesage("Account Created Successfully", Colors.green);
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=> const Home())
                          );

                    }).onError((error, stackTrace){
                        toastMesage(error.toString(), Colors.red);
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Already registered? ", style: TextStyle(color: Colors.white),),
                  InkWell(onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                      child: const Text('Login', style: TextStyle(color: Colors.blue),)),
                  const Text(' here', style: TextStyle(color: Colors.white)),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
