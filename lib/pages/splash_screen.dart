import 'package:flutter/material.dart';
import 'home_page.dart'; // Pastikan import file home_page.dart

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Future.delayed untuk menunggu 1 detik sebelum navigasi
    Future.delayed(Duration(seconds: 1), () {
      // Memulai navigasi ke HomePage menggunakan pushReplacement
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            width: 200,
            height: 200,
            padding: EdgeInsets.all(3),
            child: Image(
              image: AssetImage(
                  "konek.png"),
            ),
          ),
        ),
      ),
    );
  }
}
