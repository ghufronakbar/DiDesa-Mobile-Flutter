import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/components/image-picker.dart';
import 'package:konek_mob_flutter/components/show-toast.dart';
import 'package:konek_mob_flutter/config.dart';
import 'package:sp_util/sp_util.dart';

class RegistrasiUMKM extends StatefulWidget {
  const RegistrasiUMKM({Key? key}) : super(key: key);

  @override
  _RegistrasiUMKMState createState() => _RegistrasiUMKMState();
}

class _RegistrasiUMKMState extends State<RegistrasiUMKM> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  String? token = SpUtil.getString("token");
  File? _pickedImage;
  int? _selectedJenisUMKM;
  List<dynamic> _jenisUMKMList = [];

  @override
  void initState() {
    super.initState();
    _fetchJenisUMKM();
  }

  void _onImageSelected(File image) {
    setState(() {
      _pickedImage = image;
    });
  }

  Future<void> _fetchJenisUMKM() async {
    final response = await http.get(
      Uri.parse('${URLs.baseUrl}/api/user/jenis-umkm/$token'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _jenisUMKMList = data['values'];
      });
    } else {
      // Handle error
      print('Failed to fetch jenis UMKM');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_pickedImage == null) {
        var regBody = {
          "nama": _namaController.text,
          "jenis_umkm_id": _selectedJenisUMKM,
          "deskripsi": _deskripsiController.text,
          "gambar": "",
          "lokasi": _lokasiController.text,
          "token": token
        };
        print(regBody);
        var response = await http.post(
            Uri.parse("${URLs.baseUrl}/api/user/umkm/tambah"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody));

        if (response.statusCode == 200) {
          Navigator.pop(context);
        } else {
          print(response.statusCode);
        }
      } else {
        Dio dio = Dio();
        FormData formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(_pickedImage!.path,
              filename: 'image.jpg'),
        });

        Response response = await dio.post(
            "${URLs.baseUrl}/upload/umkm/${SpUtil.getString("token")}",
            data: formData);

        if (response.statusCode == 200) {
          // Navigator.pop(context);
          Map<String, dynamic> responseData = response.data;
          var image_url = responseData["image_url"];

          var regBody = {
            "gambar": image_url,
            "nama": _namaController.text,
            "jenis_umkm_id": _selectedJenisUMKM,
            "deskripsi": _deskripsiController.text,
            "lokasi": _lokasiController.text,
            "token": token
          };
          print(regBody);
          var responseup = await http.post(
              Uri.parse("${URLs.baseUrl}/api/user/umkm/tambah"),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(regBody));

          if (responseup.statusCode == 200) {
            showToastMessage("Berhasil Request UMKM", context);
            Navigator.pop(context);
          } else {
            print(responseup.statusCode);
          }
        } else {
          print("cek ${response.statusCode}");
        }
        print("Image Dirubah");
      }

      var regBody = {
        "nama": _namaController.text,
        "jenis": _selectedJenisUMKM,
        "deskripsi": _deskripsiController.text,
        "lokasi": _lokasiController.text,
        "token": token
      };
      print(regBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran UMKM'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: ImagePickerWidget(
                  onImageSelected: _onImageSelected,
                  urlImage: "",
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama UMKM',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama UMKM tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<int>(
                value: _selectedJenisUMKM,
                decoration: InputDecoration(
                  labelText: 'Jenis UMKM',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                items: _jenisUMKMList.map<DropdownMenuItem<int>>((jenisUMKM) {
                  return DropdownMenuItem<int>(
                    value: jenisUMKM['jenis_umkm_id'],
                    child: Text(jenisUMKM['nama_jenis_umkm']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJenisUMKM = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Jenis UMKM tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _deskripsiController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _lokasiController,
                decoration: InputDecoration(
                  labelText: 'Lokasi',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
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
