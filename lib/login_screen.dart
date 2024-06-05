import 'package:audio_tale/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'signup_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen")
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            Center(child: Image.asset('assets/images/AudioTale_logo.png', height: 220, width: 250,)),
            const SizedBox(height: 50,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.remove_red_eye),
                      hintText: "Password",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    const Text("Not Registered? ", style: TextStyle(color: Colors.white),),
                    InkWell(onTap: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                        child: const Text('Sign up', style: TextStyle(color: Colors.blue),)),
                    const Text(' here', style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                RoundButton(
                  title: 'Login',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
