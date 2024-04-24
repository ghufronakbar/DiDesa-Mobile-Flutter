import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:konek/models/PengurusDesaAnggotaModel.dart';

class PengurusDesaPage extends StatefulWidget {
  const PengurusDesaPage({Key? key}) : super(key: key);

  @override
  State<PengurusDesaPage> createState() => _PengurusDesaPageState();
}

class _PengurusDesaPageState extends State<PengurusDesaPage> {
  late Future<PengurusDesaAnggotaModel> pengurusDesaFuture;

  @override
  void initState() {
    super.initState();
    pengurusDesaFuture = fetchData();
  }

  Future<PengurusDesaAnggotaModel> fetchData() async {
    final response =
        await http.get(Uri.parse("http://localhost:5000/api/published/pengurusdesa"));

    if (response.statusCode == 200) {
      return PengurusDesaAnggotaModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengurus Desa",
          style: GoogleFonts.outfit().copyWith(
            fontSize: 21,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<PengurusDesaAnggotaModel>(
        future: pengurusDesaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.values?.length ?? 0,
              itemBuilder: (context, index) {
                final pengurus = snapshot.data!.values![index];
                return Container(
                  height: 120, // Tentukan tinggi yang diinginkan di sini
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
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                bottomLeft: Radius.circular(12.0),
                              ),
                              child: Image.network(
                                pengurus.foto ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pengurus.namaLengkap ?? "",
                                    maxLines: 1,
                                    style: GoogleFonts.outfit().copyWith(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Color(0xff1F5876),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      pengurus.jabatan ?? "",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
