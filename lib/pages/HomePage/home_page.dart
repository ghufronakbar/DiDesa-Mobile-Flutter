import 'dart:math';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:konek_mob_flutter/models/UMKMModel.dart' as UMKMModel;
import 'package:konek_mob_flutter/models/BeritaModel.dart' as BeritaModel;
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/config.dart';
import 'package:konek_mob_flutter/pages/AkunPage/akun-page.dart';
import 'package:konek_mob_flutter/pages/BeritaPage/berita_page.dart';
import 'package:konek_mob_flutter/pages/BeritaPage/detail_berita.dart';
import 'package:konek_mob_flutter/pages/LoginPage/login-pages.dart';
import 'package:konek_mob_flutter/pages/Pemilu/pemilihan.dart';
import 'package:konek_mob_flutter/pages/PendaftaranUmkm/pendaftaran_umkm_page.dart';
import 'package:konek_mob_flutter/pages/PengaduanMasyarakat/pengaduan_masyarakat.dart';
import 'package:konek_mob_flutter/pages/TentangDesa/tentang_desa_page.dart';
import 'package:konek_mob_flutter/pages/UmkmPage/detail_umkm.dart';
import 'package:konek_mob_flutter/pages/UmkmPage/umkm_page.dart';
import 'package:sp_util/sp_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<UMKMModel.Values>> _umkmFuture;
  late Future<List<BeritaModel.Values>> _beritaFuture;
  String? token = SpUtil.getString("token");
  String? nama = '';
  String? fotoProfil = '';
  int? pemilihan_ketua_id=0;
  bool pemilu = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
    duringPemilu();
    _umkmFuture = fetchUMKM(2);
    _beritaFuture = fetchBerita();
  }

  String convertDateFormat(String inputDate) {
    // Format input tanggal
    DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

    // Format output tanggal
    DateFormat outputFormat = DateFormat("dd-MM-yyyy");

    // Parse input tanggal
    DateTime date = inputFormat.parse(inputDate);

    // Format ulang tanggal ke format yang diinginkan
    return outputFormat.format(date);
  }

  void fetchUser() async {
    try {
      final response =
          await http.get(Uri.parse('${URLs.baseUrl}/api/user/$token'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final values = jsonResponse['values'];
        if (values.isNotEmpty) {
          setState(() {
            nama = values[0]['nama_lengkap'];
            fotoProfil = values[0]['foto'];
          });
        } else {
          print('No user data available');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void duringPemilu() async {
    try {
      final response = await http
          .get(Uri.parse('${URLs.baseUrl}/api/user/home/pemilihan/$token'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final values = jsonResponse['values'];
        print("CEk " + values['ada_pemilihan'].toString());
        if (values.isNotEmpty) {
          setState(() {
            pemilu = values['ada_pemilihan'];
            pemilihan_ketua_id = values['pemilihan_ketua_id'];
            print(pemilihan_ketua_id);

          });
        } else {
          print('No user data available');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<List<BeritaModel.Values>> fetchBeritaPrioritas() async {
    final response = await http
        .get(Uri.parse('${URLs.baseUrl}/api/user/berita-prioritas/$token'));

    if (response.statusCode == 200) {
      final beritaModel =
          BeritaModel.BeritaModel.fromJson(json.decode(response.body));
      return beritaModel.values ?? [];
    } else {
      throw Exception('Failed to load Berita Prioritas');
    }
  }

  Future<List<UMKMModel.Values>> fetchUMKM(int limit) async {
    final response = await http
        .get(Uri.parse('${URLs.baseUrl}/api/user/home/umkm/${token}'));

    if (response.statusCode == 200) {
      final umkmModel =
          UMKMModel.UMKMModel.fromJson(json.decode(response.body));
      return umkmModel.values ?? [];
    } else {
      throw Exception('Failed to load UMKM');
    }
  }

  Future<List<BeritaModel.Values>> fetchBerita() async {
    final response = await http
        .get(Uri.parse('${URLs.baseUrl}/api/user/home/berita/$token'));

    if (response.statusCode == 200) {
      final beritaModel =
          BeritaModel.BeritaModel.fromJson(json.decode(response.body));
      return beritaModel.values ?? [];
    } else {
      throw Exception('Failed to load Berita');
    }
  }

  Future<void> _refreshData() async {
    // Panggil metode untuk memuat ulang data yang dibutuhkan di sini
    fetchUser();
    duringPemilu();
    setState(() {
      _umkmFuture = fetchUMKM(2);
      _beritaFuture = fetchBerita();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "DiDesa",
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AkunPage()),
                  );
                },
                child: fotoProfil != ''
                    ? Container(
                        width: 40,
                        height: 40,
                        child: ClipOval(
                          child: Image.network(
                            fotoProfil!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Image.asset('assets/images/profile.png'),
                        onPressed: () {},
                      ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
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
            nama!,
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
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    idBerita: berita.beritaId.toString()),
                              ),
                            );
                          },
                          child: Card(
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
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.4 *
                                              0.6,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 12, 12, 12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          berita.judul ?? '',
                                          maxLines: 1,
                                          style: GoogleFonts.outfit().copyWith(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                          textAlign: TextAlign.left,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                berita.subjudul ?? '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.outfit()
                                                    .copyWith(
                                                        fontSize: 12,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Text(
                                              convertDateFormat(
                                                  berita.tanggal.toString()),
                                              style: GoogleFonts.outfit()
                                                  .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.normal),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
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
                    min(2, umkmData.length),
                    (index) {
                      final umkm = umkmData[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailUMKMPage(
                                idUMKM: umkm.umkmId.toString(),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 4,
                            ),
                            Card(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12.0)),
                                      child: Image.network(
                                        umkm.gambar ?? '',
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.4 *
                                                0.6,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 12, 0, 12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            margin: EdgeInsets.fromLTRB(
                                                0, 30, 0, 0),
                                            decoration: BoxDecoration(
                                              color: Color(0xff1F5876),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            padding:
                                                EdgeInsets.fromLTRB(6, 4, 6, 4),
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
                            ),
                            SizedBox(
                              width: 4,
                            ),
                          ],
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
      child: FutureBuilder<List<BeritaModel.Values>>(
        future: fetchBeritaPrioritas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final beritaPrioritas = snapshot.data!;
            if (beritaPrioritas.isNotEmpty) {
              final berita = beritaPrioritas.first;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPage(idBerita: berita.beritaId.toString()),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: berita.gambar == ''
                            ? Image.asset(
                                'assets/images/background.jpg',
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.width *
                                    0.4 *
                                    0.6,
                              )
                            : Image.network(
                                berita.gambar ?? '',
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.width *
                                    0.4 *
                                    0.6,
                              ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.4,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              berita.judul ?? '',
                              maxLines: 1,
                              style: GoogleFonts.outfit().copyWith(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              berita.subjudul ?? '',
                              maxLines: 1,
                              style: GoogleFonts.outfit().copyWith(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          }
        },
      ),
    );
  }

  Container listMenu(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TentangDesaPage()),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/tentang_desa.png",
                        width: 25,
                        height: 25,
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
                      color: Color(0xff828282),
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrasiUMKM()),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/pendaftaran_umkm.png",
                        width: 25,
                        height: 25,
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
                      color: Color(0xff828282),
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PengaduanMasyarakat()),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/pengaduan_masyarakat.png",
                        width: 25,
                        height: 25,
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
                      color: Color(0xff828282),
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: pemilu,
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PemilihanKetuaDesaPage(pemilihanKetuaId: pemilihan_ketua_id!),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            spreadRadius: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(
                          "assets/images/pemilihan_kepala_desa.png",
                          width: 25,
                          height: 25,
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
                        color: Color(0xff828282),
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
