import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/config.dart';
import 'dart:convert';
import 'package:konek_mob_flutter/models/UMKMModel.dart';
import 'package:sp_util/sp_util.dart';

class DetailUMKMPage extends StatefulWidget {
  final String idUMKM;

  const DetailUMKMPage({Key? key, required this.idUMKM}) : super(key: key);

  @override
  State<DetailUMKMPage> createState() => _DetailUMKMPageState();
}

class _DetailUMKMPageState extends State<DetailUMKMPage> {
  late Future<UMKMModel> _umkmFuture;
  String? token = SpUtil.getString("token");

  @override
  void initState() {
    super.initState();
    _umkmFuture = fetchUMKMDetail(widget.idUMKM);
  }

  Future<UMKMModel> fetchUMKMDetail(String umkmId) async {
    final response = await http.get(Uri.parse('${URLs.baseUrl}/api/user/umkm/$umkmId/$token'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UMKMModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch UMKM detail');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _umkmFuture = fetchUMKMDetail(widget.idUMKM);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail UMKM'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<UMKMModel>(
          future: _umkmFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final umkmDetail = snapshot.data!.values![0];
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    umkmDetail.gambar != ''
                        ? Image.network(
                            umkmDetail.gambar!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/image_default.png',
                            fit: BoxFit.fill,
                          ),
                    SizedBox(height: 16.0),
                    Text(
                      umkmDetail.nama ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Jenis UMKM: ${umkmDetail.namaJenisUmkm ?? ''}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Deskripsi: ${umkmDetail.deskripsi ?? ''}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Lokasi: ${umkmDetail.lokasi ?? ''}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Pemilik: ${umkmDetail.namaLengkap ?? ''}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
