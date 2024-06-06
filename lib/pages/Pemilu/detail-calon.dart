import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/config.dart';
import 'package:sp_util/sp_util.dart';

class DetailCalonPage extends StatefulWidget {
  final int calonKetuaId;

  const DetailCalonPage({
    Key? key,
    required this.calonKetuaId,
  }) : super(key: key);

  @override
  _DetailCalonPageState createState() => _DetailCalonPageState();
}

class _DetailCalonPageState extends State<DetailCalonPage> {
  Map<String, dynamic> _calonData = {};
  String? token = SpUtil.getString("token");
  String foto = '';
  int hakPilih = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    checkVotingRights();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        '${URLs.baseUrl}/api/detail-calon-pemilihan-ketua/${widget.calonKetuaId}/$token'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final Map<String, dynamic> data = jsonData['data'];
      setState(() {
        _calonData = data;
        foto = data['foto'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> checkVotingRights() async {
    final response = await http.get(Uri.parse(
        '${URLs.baseUrl}/api/cek-hak-pilih/$token'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        hakPilih = jsonData['hak_pilih'];
      });
    } else {
      throw Exception('Failed to check voting rights');
    }
  }

  Future<void> _refreshData() async {
    await fetchData();
    await checkVotingRights();
  }

  Future<void> _vote() async {
    final response = await http.put(
      Uri.parse('${URLs.baseUrl}/api/user/vote/'),
      body: jsonEncode({
        'token': token,
        'calon_ketua_id': widget.calonKetuaId,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 200) {
        // Refresh the page after successful voting
        await _refreshData();
      }
    } else {
      throw Exception('Failed to vote');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Calon Kepala Desa'),
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                foto != ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          foto,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                        child: Image.asset('assets/images/account.png'),
                      ),
                SizedBox(height: 16.0),
                Text(
                  _calonData['nama_lengkap'] ?? '',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  _calonData['deskripsi'] ?? '',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Color(0xff1F5876),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    'Total Pemilih: ${_calonData['total_pemilih'] ?? ''}',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: hakPilih == 1 ? _vote : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: hakPilih == 1 ? Color(0xff1F5876) : Colors.grey,
          ),
          child: Text(
            'Vote',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
