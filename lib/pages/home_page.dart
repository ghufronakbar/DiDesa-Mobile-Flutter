import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek/models/UMKMModel.dart' as UMKMModel;
import 'package:konek/models/BeritaModel.dart' as BeritaModel;
import 'package:http/http.dart' as http;
import 'package:konek/pages/berita_page.dart';
import 'package:konek/pages/tentang_desa_page.dart';
import 'package:konek/pages/umkm_page.dart';
import 'package:konek/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<UMKMModel.Values>> _umkmFuture;
  late Future<List<BeritaModel.Values>> _beritaFuture;

  @override
  void initState() {
    super.initState();
    _umkmFuture = fetchUMKM(2);
    _beritaFuture = fetchBerita();
  }

  Future<List<UMKMModel.Values>> fetchUMKM(int limit) async {
    final response = await http.get(Uri.parse('${URLs.baseUrl}/api/user/umkm'));

    if (response.statusCode == 200) {
      final umkmModel =
          UMKMModel.UMKMModel.fromJson(json.decode(response.body));
      return umkmModel.values ?? [];
    } else {
      throw Exception('Failed to load UMKM');
    }
  }

  Future<List<BeritaModel.Values>> fetchBerita() async {
    final response =
        await http.get(Uri.parse('${URLs.baseUrl}/api/user/berita'));

    if (response.statusCode == 200) {
      final beritaModel =
          BeritaModel.BeritaModel.fromJson(json.decode(response.body));
      return beritaModel.values ?? [];
    } else {
      throw Exception('Failed to load Berita');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Konek",
            style: GoogleFonts.outfit()
                .copyWith(color: Colors.black, fontSize: 30),
          ),
          leading: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Image.asset('assets/images/konek.png'),
          ),
          actions: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
              width: 40,
              child: IconButton(
                icon: Image.asset('assets/images/profile.png'),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sayHello(),
                  SizedBox(
                    height: 8,
                  ),
                  bannerBerita(context),
                  SizedBox(
                    height: 8,
                  ),
                  listMenu(context),
                  SizedBox(
                    height: 8,
                  ),
                  umkmList(),
                  SizedBox(
                    height: 8,
                  ),
                  beritaList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container sayHello() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateTime.now().hour >= 3 && DateTime.now().hour < 12
                ? "Good Morning,"
                : DateTime.now().hour >= 12 && DateTime.now().hour < 17
                    ? "Good Afternoon,"
                    : DateTime.now().hour >= 17 && DateTime.now().hour < 21
                        ? "Good Evening,"
                        : "Good Night,",
            style: GoogleFonts.outfit()
                .copyWith(color: Colors.black, fontSize: 30),
          ),
          Text(
            "Ghufron Akbar!",
            style: GoogleFonts.outfit()
                .copyWith(color: Colors.black, fontSize: 30),
          ),
        ],
      ),
    );
  }

  Container beritaList(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Berita",
                style: GoogleFonts.outfit().copyWith(
                    fontSize: 21,
                    fontWeight: FontWeight.normal,
                    color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BeritaPage()),
                  );
                },
                child: Text(
                  "See All",
                  style: GoogleFonts.outfit().copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xff1F5876),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          FutureBuilder<List<BeritaModel.Values>>(
            future: _beritaFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final beritaData = snapshot.data!;
                return Column(
                  children: beritaData.take(3).map((berita) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12.0)),
                              child: Image.network(
                                berita.gambar ?? '',
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.width *
                                    0.4 *
                                    0.6,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    berita.judul ??
                                        '', // Penambahan penanganan judul
                                    maxLines: 1,
                                    style: GoogleFonts.outfit().copyWith(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                    textAlign: TextAlign.left,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                    child: Text(
                                      berita.subjudul ??
                                          '', // Penambahan penanganan subjudul
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit().copyWith(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget umkmList() {
    return FutureBuilder<List<UMKMModel.Values>>(
      future: _umkmFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final umkmData = snapshot.data!;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "UMKM",
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UMKMPage()),
                      );
                    },
                    child: Text(
                      "See All",
                      style: GoogleFonts.outfit().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff1F5876),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    // Gunakan min untuk memastikan jumlah item tidak melebihi panjang daftar
                    // atau 2 jika panjang daftar lebih kecil dari 2
                    min(2, umkmData.length),
                    (index) {
                      final umkm = umkmData[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12.0)),
                                child: Image.network(
                                  umkm.gambar ?? '',
                                  fit: BoxFit.cover,
                                  height: MediaQuery.of(context).size.width *
                                      0.4 *
                                      0.6,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 12, 0, 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      umkm.nama ?? '',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.left,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                      decoration: BoxDecoration(
                                        color: Color(0xff1F5876),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                                      child: Text(
                                        umkm.namaJenisUmkm ?? '',
                                        style: TextStyle(
                                            fontSize: 8,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Container bannerBerita(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "https://the-iconomics.storage.googleapis.com/wp-content/uploads/2020/12/11132729/Haus-2.jpg",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.width * 0.4 * 0.6,
                ),
              )),
          Opacity(
            opacity: 0.4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Text(
                "Daftarkan UMKM Segera!",
                style: GoogleFonts.outfit().copyWith(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container listMenu(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TentangDesaPage()),
                  );
                  
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 1,
                              color: Colors.grey)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("assets/images/tentang_desa.png"),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: Text(
                  "Tentang Desa\n",
                  style: GoogleFonts.outfit().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff828282)),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 1,
                              color: Colors.grey)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset("assets/images/pendaftaran_umkm.png"),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: Text(
                  "Pendaftaran\nUMKM",
                  style: GoogleFonts.outfit().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff828282)),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                ),
                width: MediaQuery.of(context).size.width * 0.16,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4, spreadRadius: 1, color: Colors.grey)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                      icon:
                          Image.asset('assets/images/pengaduan_masyarakat.png'),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: Text(
                  "Pengaduan\nMasyarakat",
                  style: GoogleFonts.outfit().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff828282)),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                ),
                width: MediaQuery.of(context).size.width * 0.16,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4, spreadRadius: 1, color: Colors.grey)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                      icon: Image.asset(
                          'assets/images/pemilihan_kepala_desa.png'),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: Text(
                  "Pemilihan\nKepala Desa",
                  style: GoogleFonts.outfit().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xff828282)),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
