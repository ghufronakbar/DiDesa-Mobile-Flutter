import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/config.dart';
import 'package:konek_mob_flutter/models/BeritaModel.dart' as BeritaModel;
import 'package:konek_mob_flutter/pages/BeritaPage/detail_berita.dart';
import 'package:sp_util/sp_util.dart';

class BeritaPage extends StatefulWidget {
  const BeritaPage({Key? key}) : super(key: key);

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  late Future<List<BeritaModel.Values>> _beritaFuture;
  String? token = SpUtil.getString("token");

  @override
  void initState() {
    super.initState();
    _beritaFuture = fetchBerita();
  }

  String convertDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateFormat outputFormat = DateFormat("dd-MM-yyyy");
    DateTime date = inputFormat.parse(inputDate);
    return outputFormat.format(date);
  }

  Future<List<BeritaModel.Values>> fetchBerita() async {
    final response =
        await http.get(Uri.parse('${URLs.baseUrl}/api/user/berita/$token'));

    if (response.statusCode == 200) {
      final beritaModel =
          BeritaModel.BeritaModel.fromJson(json.decode(response.body));
      return beritaModel.values ?? [];
    } else {
      throw Exception('Failed to load Berita');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _beritaFuture = fetchBerita();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Berita",
            style: GoogleFonts.outfit()
                .copyWith(color: Colors.black, fontSize: 30),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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

  Container beritaList(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
      child: Column(
        children: [
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
                  children: beritaData.map((berita) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(idBerita: berita.beritaId.toString()),
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 190,
                            child: Center(
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
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
                                          berita.gambar ?? '',
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                              style: GoogleFonts.outfit()
                                                  .copyWith(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                              textAlign: TextAlign.left,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    berita.subjudul ?? '',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                      berita.tanggal
                                                          .toString()),
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
}
