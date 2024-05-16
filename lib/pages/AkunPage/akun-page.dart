import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:konek_mob_flutter/components/image-picker-circle.dart';
import 'package:konek_mob_flutter/config.dart';
import 'package:konek_mob_flutter/pages/AkunPage/modals/modal-reset-password.dart';
import 'package:konek_mob_flutter/pages/LoginPage/login-pages.dart';
import 'package:konek_mob_flutter/pages/UmkmSayaPage/umkm_saya_page.dart';
import 'package:sp_util/sp_util.dart';

class AkunPage extends StatefulWidget {
  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  TextEditingController _nameController = TextEditingController();
  String nik = '';
  String kk = '';
  String namaLengkap = '';
  String tanggalLahir = '';
  String hakPilih = '';
  String fotoUrl = '';
  File? _pickedImage;

  void _onImageSelected(File image) {
    setState(() {
      _pickedImage = image;
    });
  }

  String convertDateFormat(String inputDate) {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateFormat outputFormat = DateFormat("dd-MM-yyyy");
    DateTime date = inputFormat.parse(inputDate);
    return outputFormat.format(date);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('${URLs.baseUrl}/api/user/${SpUtil.getString("token")}'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final values = jsonData['values'][0];
      setState(() {
        nik = values['nik'];
        kk = values['kk'];
        namaLengkap = values['nama_lengkap'];
        tanggalLahir = convertDateFormat(values['tanggal_lahir']);
        hakPilih = values['hak_pilih'].toString();
        fotoUrl = values['foto'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 5, left: 5),
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  ImagePickerCircle(
                                    onImageSelected: _onImageSelected,
                                    urlImage: fotoUrl,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 5.0),
                              Expanded(
                                child: Container(
                                  transform: Matrix4.translationValues(
                                      0.0, -10.0, 0.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(namaLengkap,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24)),
                                          ),
                                          // IconButton(
                                          //     icon: Icon(
                                          //       Icons.edit_document,
                                          //       size: 15.0,
                                          //       color: Colors.grey.shade600,
                                          //     ),
                                          //     onPressed: () {
                                          //       // showDialog(
                                          //       //   context: context,
                                          //       //   builder: (BuildContext context) {
                                          //       //     return EditNameModal(
                                          //       //       nameController:
                                          //       //           _nameController,
                                          //       //       name: namaLengkap,
                                          //       //     );
                                          //       //   },
                                          //       // ).then((_) {
                                          //       //   fetchData();
                                          //       // });
                                          //     }),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Container(
                                        transform: Matrix4.translationValues(
                                            0.0, -10.0, 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "NIK: $nik",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey.shade700),
                                            ),
                                            Text(
                                              "KK: $kk",
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.grey.shade700),
                                            ),
                                            Text(
                                              "Tanggal Lahir: $tanggalLahir",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 75.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "About",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black),
                              ),
                              Text(
                                "0.0.1",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  // Tombol-tombol
                  Column(
                    children: <Widget>[
                      // Tombol Request Data
                      // Anda bisa menambahkan aksi sesuai kebutuhan
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return UMKMSayaPage();
                              }));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Text(
                              'UMKM Saya',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Tombol Reset Password
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ResetPasswordModal(
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Ubah Password',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Tombol Logout
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 30,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              SpUtil.remove("token");
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                    color: Colors.black, width: 1.0),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
