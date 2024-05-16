import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:konek_mob_flutter/components/show-toast.dart';
import 'package:konek_mob_flutter/config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sp_util/sp_util.dart';
import 'package:toastification/toastification.dart';

class ImagePickerCircle extends StatefulWidget {
  final String urlImage;
  final Function(File) onImageSelected;

  const ImagePickerCircle({
    Key? key,
    required this.onImageSelected,
    required this.urlImage,
  }) : super(key: key);

  @override
  State<ImagePickerCircle> createState() => _ImagePickerCircleState();
}

class _ImagePickerCircleState extends State<ImagePickerCircle> {
  File? imageFile;
  bool _isLoading = false;

  final picker = ImagePicker();

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 9,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: const [
                        Icon(Icons.image, size: 35.0),
                        SizedBox(height: 4.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: SizedBox(
                      child: Column(
                        children: const [
                          Icon(Icons.camera_alt, size: 35.0),
                          SizedBox(height: 4.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _imgFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  _imgFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: "Image Cropper",
        )
      ],
    );
    if (croppedFile != null) {
      _showConfirmationDialog(context, croppedFile);
    }
  }

  Future<void> editImage(croppedFile) async {
    setState(() {
      _isLoading =
          true; // Atur nilai _isLoading menjadi true saat proses pengiriman data dimulai
    });

    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(croppedFile.path,
            filename: 'image.jpg'),
      });

      Response response = await dio.put(
          "${URLs.baseUrl}/api/user/update/profile/${SpUtil.getString("token")}",
          data: formData);

      if (response.statusCode == 200) {
        showToastMessage("Gambar Berhasil Diubah", context);
        imageCache.clear();
        setState(() {
          imageFile = File(croppedFile.path);
        });
        widget.onImageSelected(imageFile!);
      } else {
        // Proses gagal, tampilkan pesan kesalahan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit image. Please try again.'),
          ),
        );
      }
    } catch (e) {
      // Tangani kesalahan jaringan
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    } finally {
      setState(() {
        _isLoading =
            false; // Atur kembali nilai _isLoading menjadi false setelah proses selesai
      });
    }
  }

  void _showConfirmationDialog(BuildContext context, croppedFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black, // Warna latar belakang container
                    borderRadius: BorderRadius.circular(
                        12), // Membuat sudut menjadi bulat
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Konfirmasi",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        "Apakah anda yakin ingin mengubah foto profil anda?",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                editImage(croppedFile);
                              },
                              child: Text('Edit'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImagePicker(context),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            _buildCircularImage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularImage(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          child: imageFile == null
              ? widget.urlImage == ''
                  ? CircleAvatar(
                      backgroundImage: AssetImage('assets/images/account.png'),
                      radius: 60.0,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.urlImage,
                      ),
                      radius: 60.0,
                    )
              : CircleAvatar(
                  backgroundImage: FileImage(imageFile!),
                  radius: 60.0,
                ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _showImagePicker(context);
            },
            borderRadius: BorderRadius.circular(50.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade700,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
