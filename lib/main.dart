import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:auth_firebase/firebase_options.dart';
import 'splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: 'AIzaSyBH4d5dfJRHIYz_1fR6PW80EMD94bhFcz8');
  await Firebase.initializeApp(
      options:
      const FirebaseOptions(
        apiKey: 'AIzaSyBH4d5dfJRHIYz_1fR6PW80EMD94bhFcz8',
        appId: 'appId',
        messagingSenderId: 'messagingSenderId',
        projectId: 'audio-tale',
        storageBucket: 'audio-tale.appspot.com',   )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1499C6),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff10263C)),
        scaffoldBackgroundColor: const Color(0xff10263C),
        dividerColor: const Color(0xFF1499C6),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 13,
          )
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff10263C),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1499C6),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xff10263C), // Background color of the input field
          hintStyle: TextStyle(color: Colors.white70), // Hint text style
          labelStyle: TextStyle(color: Colors.white), // Label text style
          errorStyle: TextStyle(color: Colors.redAccent), // Error text style
          prefixIconColor: Colors.blue,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Default border color
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white), // Enabled border color
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1499C6)), // Focused border color
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent), // Error border color
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent), // Focused error border color
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 22.0, horizontal: 16.0), // Padding inside the input field
        ),
      ),
      home:  SplashScreen(),
    );
    // This is the theme of your application.
  }
}





Future<void> requestPermissions() async {
  if (await Permission.storage.request().isGranted) {
    // The permission is granted
  } else if (await Permission.storage.isPermanentlyDenied) {
    // Open app settings if the permission is permanently denied
    openAppSettings();
  }
}

@override
void initState() {
  // super.initState();
  requestPermissions();
}
