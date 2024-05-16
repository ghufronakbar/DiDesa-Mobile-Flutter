import 'package:flutter/material.dart';
import 'package:konek_mob_flutter/middleware.dart';
import 'package:konek_mob_flutter/pages/HomePage/home_page.dart';
import 'package:konek_mob_flutter/pages/LoginPage/login-pages.dart';
import 'package:sp_util/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: verifyToken(), // Gunakan middleware untuk memeriksa token
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Jika proses memeriksa token sedang berlangsung, tampilkan loading indicator
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          if (snapshot.hasError || snapshot.data == false) {
            print("cek ${SpUtil.getString("token")}");
            // Jika terjadi kesalahan atau token tidak valid, arahkan ke halaman login
            return MaterialApp(
              title: 'Lestari',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
                useMaterial3: true,
              ),
              home: LoginPage(),
            );
          } else {
            // Jika token valid, arahkan ke layar utama
            return MaterialApp(
              title: 'Lestari',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
                useMaterial3: true,
              ),
              home: HomePage(),
            );
          }
        }
      },
    );
  }
}
