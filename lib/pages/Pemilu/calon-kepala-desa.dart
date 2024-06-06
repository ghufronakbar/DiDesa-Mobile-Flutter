import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/config.dart';
import 'package:konek_mob_flutter/pages/Pemilu/detail-calon.dart';
import 'package:sp_util/sp_util.dart';

class CalonKepalaDesaPage extends StatefulWidget {
  final int pemilihanKetuaId;

  const CalonKepalaDesaPage({
    Key? key,
    required this.pemilihanKetuaId,
  }) : super(key: key);

  @override
  _CalonKepalaDesaPageState createState() => _CalonKepalaDesaPageState();
}

class _CalonKepalaDesaPageState extends State<CalonKepalaDesaPage> {
  List<Map<String, dynamic>> _calonList = [];
  String? token = SpUtil.getString("token");

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        '${URLs.baseUrl}/api/calon-pemilihan-ketua/${widget.pemilihanKetuaId}/$token'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> dataList = jsonData['data'];
      setState(() {
        _calonList = dataList.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calon Kepala Desa'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _calonList.length,
          itemBuilder: (context, index) {
            final calon = _calonList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailCalonPage(
                        calonKetuaId: calon['calon_ketua_id']),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.0),
                      ),
                      child: Image.network(
                        calon['foto'],
                        height: 120.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Flexible(
                        child: Text(
                          calon['nama_lengkap'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
