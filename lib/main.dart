import 'package:flutter/material.dart';
import 'package:konek/pages/berita_page.dart';
import 'package:konek/pages/home_page.dart';
import 'package:konek/pages/pengurus_desa_page.dart';
import 'package:konek/pages/splash_screen.dart';
import 'package:konek/pages/tentang_desa_page.dart';
import 'package:konek/pages/umkm_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Konek",      
      home: HomePage(),
    );
  }
}