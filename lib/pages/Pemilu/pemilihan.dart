import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:konek_mob_flutter/config.dart';
import 'package:konek_mob_flutter/pages/Pemilu/calon-kepala-desa.dart';
import 'package:sp_util/sp_util.dart';

class PemilihanKetuaDesaPage extends StatefulWidget {
  final int pemilihanKetuaId;

  const PemilihanKetuaDesaPage({Key? key, required this.pemilihanKetuaId})
      : super(key: key);

  @override
  _PemilihanKetuaDesaPageState createState() => _PemilihanKetuaDesaPageState();
}

class _PemilihanKetuaDesaPageState extends State<PemilihanKetuaDesaPage> {
  late Future<Map<String, dynamic>> _pemilihanKetuaFuture;

  @override
  void initState() {
    super.initState();
    _pemilihanKetuaFuture = fetchPemilihanKetuaDetail(widget.pemilihanKetuaId);
  }

  Future<Map<String, dynamic>> fetchPemilihanKetuaDetail(
      int pemilihanKetuaId) async {
    final response = await http.get(Uri.parse(
        '${URLs.baseUrl}/api/pemilihan-ketua/$pemilihanKetuaId/${SpUtil.getString("token")}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pemilihan Kepala Desa'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _pemilihanKetuaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['judul'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    '${data['deskripsi']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Periode Pelaksanaan: ',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '${DateFormat('dd-MM-yyyy').format(DateTime.parse(data['tanggal_mulai']))} - ${DateFormat('dd-MM-yyyy').format(DateTime.parse(data['tanggal_selesai']))}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Total Calon: ${data['jumlah_calon']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalonKepalaDesaPage(
                                      pemilihanKetuaId: widget.pemilihanKetuaId),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Color(0xff1F5876),
                            ),
                            child: Text(
                              'Lihat Calon',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
