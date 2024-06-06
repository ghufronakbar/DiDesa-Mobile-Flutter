import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/config.dart';
import 'dart:convert';

import 'package:konek_mob_flutter/models/InformasiDesaModel.dart';
import 'package:konek_mob_flutter/pages/TentangDesa/pengurus_desa_page.dart';
import 'package:sp_util/sp_util.dart';

class TentangDesaPage extends StatefulWidget {
  const TentangDesaPage({Key? key}) : super(key: key);

  @override
  State<TentangDesaPage> createState() => _TentangDesaPageState();
}

class _TentangDesaPageState extends State<TentangDesaPage> {
  late Future<InformasiDesaModel> _informasiDesaFuture;
  String? token = SpUtil.getString("token");

  @override
  void initState() {
    super.initState();
    _informasiDesaFuture = fetchInformasiDesa();
  }

  Future<InformasiDesaModel> fetchInformasiDesa() async {
    final response = await http
        .get(Uri.parse('${URLs.baseUrl}/api/user/informasidesa/$token'));

    if (response.statusCode == 200) {
      return InformasiDesaModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load informasi desa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tentang Desa",
          style: GoogleFonts.outfit().copyWith(
            fontSize: 21,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<InformasiDesaModel>(
          future: _informasiDesaFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final InformasiDesaModel data = snapshot.data!;
              final Values informasiDesa = data.values!.first;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    informasiDesa.namaDesa ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit().copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    informasiDesa.deskripsi ?? '',
                    style: GoogleFonts.outfit().copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.green.shade100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12.0)),
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.all(20),
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width * 0.4,
                                    child: Image.asset(
                                      "assets/images/pertanian.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    "${informasiDesa.luasLahanPertanian ?? 0} Hektar",
                                    style: GoogleFonts.outfit().copyWith(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.brown.shade100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12.0)),
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.all(20),
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.width * 0.4,
                                    child: Image.asset(
                                      "assets/images/peternakan.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    "${informasiDesa.lahanPeternakan ?? 0} Peternakan",
                                    style: GoogleFonts.outfit().copyWith(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PengurusDesaPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.grey.shade100,
                      ),
                      child: Text(
                        'Pengurus Desa?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
