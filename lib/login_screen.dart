import 'package:audio_tale/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var display = true;

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login Screen")
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
                            return "Enter email";
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
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
                            return "Enter Password";
                          }
                          else{
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const SizedBox(
                    //       height: 30,
                    //     ),
                    //     const Text("Don't have an account? ", style: TextStyle(color: Colors.white),),
                    //     InkWell(onTap: (){
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (context) => const SignUp()),
                    //       );
                    //     },
                    //         child: const Text('Sign up', style: TextStyle(color: Colors.blue),)),
                    //     const Text(' here', style: TextStyle(color: Colors.white)),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
                  RoundButton(
                    title: 'Login',
                    onTap: () {
                      if(_formKey.currentState!.validate()) {

                      }
                    },
                  ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.white),),
                  InkWell(onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUp()),
                    );
                  },
                      child: const Text('Sign up', style: TextStyle(color: Colors.blue),)),
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
