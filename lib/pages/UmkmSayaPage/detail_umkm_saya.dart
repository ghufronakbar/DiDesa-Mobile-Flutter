import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/components/show-toast.dart';
import 'package:konek_mob_flutter/config.dart';
import 'package:konek_mob_flutter/models/UMKMSayaDetailModel.dart';
import 'dart:convert';
import 'package:sp_util/sp_util.dart';

class DetailUMKMSayaPage extends StatefulWidget {
  final String idUMKM;

  const DetailUMKMSayaPage({Key? key, required this.idUMKM}) : super(key: key);

  @override
  State<DetailUMKMSayaPage> createState() => _DetailUMKMSayaPageState();
}

class _DetailUMKMSayaPageState extends State<DetailUMKMSayaPage> {
  late Future<UMKMSayaDetailModel> _umkmFuture;
  String? token = SpUtil.getString("token");

  @override
  void initState() {
    super.initState();
    print(widget.idUMKM);
    _umkmFuture = fetchUMKMDetail(widget.idUMKM);
  }

  Future<UMKMSayaDetailModel> fetchUMKMDetail(String umkmId) async {
    final response = await http
        .get(Uri.parse('${URLs.baseUrl}/api/user/umkm-saya/$umkmId/$token'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UMKMSayaDetailModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch UMKM detail');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _umkmFuture = fetchUMKMDetail(widget.idUMKM);
    });
  }

  updateStatus(int umkmId, int status) async {
    var regBody = {"umkm_id": umkmId, "status": status, "token": token};
    final response = await http.put(
        Uri.parse('${URLs.baseUrl}/api/user/umkm/update-status'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      if (status == 0) {
        showToastMessage("Menyembunyikan UMKM", context);
      } else if (status == 1) {
        showToastMessage("Menampilkan UMKM", context);
      }
      _refreshData();
    } else {
      throw Exception('Failed to update UMKM status');
    }
  }

  String getHiddenText(int hide) {
    switch (hide) {
      case 0:
        return 'Perlihatkan';
      case 1:
        return 'Sembunyikan';
      default:
        return 'Unknown';
    }
  }

  String getApprovalText(int approve) {
    switch (approve) {
      case 0:
        return 'Tertunda';
      case 1:
        return 'Ditolak';
      case 2:
        return 'Disetujui';
      default:
        return 'Unknown';
    }
  }

  Color getApprovalColor(int approve) {
    switch (approve) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.red;
      case 2:
        return Colors.green;
      default:
        return Colors.black;
    }
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
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit UMKM page
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<UMKMSayaDetailModel>(
          future: _umkmFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              print(snapshot.data!.values!);
              final umkmDetail = snapshot.data!.values![0];
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                physics: AlwaysScrollableScrollPhysics(),
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
      bottomNavigationBar: FutureBuilder<UMKMSayaDetailModel>(
        future: _umkmFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox.shrink();
          } else if (snapshot.hasError) {
            return SizedBox.shrink();
          } else {
            final umkmDetail = snapshot.data!.values![0];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3, // 30% weight
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: getApprovalColor(umkmDetail.approve ?? 0),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: getApprovalColor(umkmDetail.approve ?? 0),
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          textAlign: TextAlign.center,
                          getApprovalText(umkmDetail.approve ?? 0),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 6, // 60% weight
                      child: ElevatedButton(
                        onPressed: () {
                          if (umkmDetail.status == 0) {
                            updateStatus(umkmDetail.umkmId!, 1);
                          } else if (umkmDetail.status == 1) {
                            updateStatus(umkmDetail.umkmId!, 0);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          backgroundColor: Color(0xff1F5876),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Color(0xff1F5876),
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: Text(
                          getHiddenText(umkmDetail.status!),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
