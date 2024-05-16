import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/components/show-toast.dart';
import 'package:konek_mob_flutter/config.dart';
import 'package:sp_util/sp_util.dart';

class PengaduanMasyarakat extends StatefulWidget {
  const PengaduanMasyarakat({Key? key}) : super(key: key);

  @override
  _PengaduanMasyarakatState createState() => _PengaduanMasyarakatState();
}

class _PengaduanMasyarakatState extends State<PengaduanMasyarakat> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _subjekController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  String? token = SpUtil.getString("token");

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var regBody = {
        "subjek": _subjekController.text,
        "isi": _isiController.text,
        "token": token
      };
      print(regBody);
      var response = await http.post(
          Uri.parse("${URLs.baseUrl}/api/user/pengaduan/tambah"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        showToastMessage("Pengaduan Berhasil Ditambahkan", context);
        Navigator.pop(context);
      } else {
        print(response.statusCode);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaduan Masyarakat'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16.0),
              TextFormField(
                controller: _subjekController,
                decoration: InputDecoration(
                  labelText: 'Subjek Pengaduan',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Subjek tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _isiController,
                decoration: InputDecoration(
                  labelText: 'Isi Pengaduan',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi Pengaduan tidak boleh kosong';
                  }
                  return null;
                },
                maxLines: 5, // Untuk memberikan ruang lebih pada field ini
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
