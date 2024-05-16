import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:konek_mob_flutter/components/show-toast.dart';
import 'package:konek_mob_flutter/config.dart';
import 'package:konek_mob_flutter/models/DetailBeritaModel.dart';
import 'package:sp_util/sp_util.dart';

class DetailPage extends StatefulWidget {
  final String idBerita;

  const DetailPage({Key? key, required this.idBerita}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _komentarController = TextEditingController();
  late Future<BeritaDetail> _beritaFuture;
  String? token = SpUtil.getString("token");
  bool showWarning = false;

  @override
  void initState() {
    super.initState();
    _beritaFuture = fetchBeritaDetail(widget.idBerita);
    print("Cek " + widget.idBerita);
  }

  String convertDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateFormat outputFormat = DateFormat("dd-MM-yyyy");
    DateTime date = inputFormat.parse(inputDate);
    return outputFormat.format(date);
  }

  Future<BeritaDetail> fetchBeritaDetail(String beritaId) async {
    final response = await http
        .get(Uri.parse('${URLs.baseUrl}/api/user/berita/$beritaId/$token'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final data = json['values'][0] as Map<String, dynamic>;
      return BeritaDetail.fromJson(data);
    } else {
      throw Exception('Failed to fetch berita detail');
    }
  }

  Future<void> submitComment(String komentar) async {
    if (komentar.isEmpty) {
      setState(() {
        showWarning = true;
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          showWarning = false;
        });
      });
      return;
    }

    final response = await http.post(
      Uri.parse('${URLs.baseUrl}/api/user/berita/komentar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'isi': komentar,
        'token': token!,
        'berita_id': widget.idBerita,
      }),
    );

    if (response.statusCode == 200) {
      _refreshData();
      showToastMessage("Komentar berhasil ditambahkan", context);
      // Komentar berhasil dikirim
      print('Komentar berhasil dikirim');
    } else {
      // Komentar gagal dikirim
      print('Komentar gagal dikirim');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _beritaFuture = fetchBeritaDetail(widget.idBerita);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Berita'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<BeritaDetail>(
          future: _beritaFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final beritaDetail = snapshot.data!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        beritaDetail.judul,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        beritaDetail.subjudul,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16.0),
                      Image.network(beritaDetail.gambar),
                      SizedBox(height: 16.0),
                      ExpandableText(
                        text: beritaDetail.isi,
                      ),
                      SizedBox(height: 35.0),
                      Text(
                        'Komentar',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      beritaDetail.komentar[0].isi == '' &&
                              beritaDetail.komentar[0].namalengkap == ''
                          ? Center(
                              child: Text(
                                'Tidak ada komentar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: beritaDetail.komentar.length,
                              itemBuilder: (context, index) {
                                final komentar = beritaDetail.komentar[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(komentar.foto),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(komentar.namalengkap),
                                      Text(
                                        convertDateFormat(komentar.tanggal),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(komentar.isi),
                                );
                              },
                            ),
                      SizedBox(height: 16.0),
                      // Form komentar section
                      Column(
                        children: [
                          if (showWarning)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Komentar tidak boleh kosong',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          TextField(
                            controller: _komentarController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan komentar anda...',
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                final komentar = _komentarController.text;
                                submitComment(komentar);
                                _komentarController.clear();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.grey.shade100,
                              ),
                              child: Text(
                                'Kirim',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;

  const ExpandableText({Key? key, required this.text}) : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            widget.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            widget.text,
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Sembunyikan' : 'Tampilkan semua',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
