import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // test comment

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health & Fitness App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      home: const LoginScreen(),
    ); 
  }
}
