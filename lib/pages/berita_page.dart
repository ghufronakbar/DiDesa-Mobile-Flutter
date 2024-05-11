import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:konek/models/BeritaModel.dart'; // Sesuaikan dengan lokasi file model Anda
import 'package:intl/intl.dart';
import 'package:konek/config.dart';

void main() {
  runApp(BeritaPage());
}

class BeritaPage extends StatefulWidget {
  const BeritaPage({Key? key}) : super(key: key);

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

// Fungsi untuk memformat tanggal
String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDate =
      DateFormat('EEEE, dd MMMM yyyy', 'en_US').format(dateTime);
  return formattedDate;
}

class _BeritaPageState extends State<BeritaPage> {
  late Future<BeritaModel> _beritaModelFuture;

  @override
  void initState() {
    super.initState();
    _beritaModelFuture = fetchBeritaData();
  }

  Future<BeritaModel> fetchBeritaData() async {
    final response =
        await http.get(Uri.parse('${URLs.baseUrl}/api/user/berita'));
    if (response.statusCode == 200) {
      return BeritaModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load berita');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Berita",
          style: GoogleFonts.outfit().copyWith(
            fontSize: 21,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<BeritaModel>(
        future: _beritaModelFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.values!.length,
                    itemBuilder: (context, index) {
                      return buildBeritaCard(snapshot.data!.values![index]);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildBeritaCard(Values beritaData) {
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                beritaData.gambar!,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.width * 0.4 * 0.6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    beritaData.judul!,
                    maxLines: 1,
                    style: GoogleFonts.outfit().copyWith(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                  Text(
                    beritaData.subjudul!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit().copyWith(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        formatDate(beritaData.tanggal!),
                        maxLines: 1,
                        style: GoogleFonts.outfit().copyWith(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                        ),
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
    );
  }
}
