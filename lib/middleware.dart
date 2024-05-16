import 'package:http/http.dart' as http;
import 'package:konek_mob_flutter/config.dart';
import 'package:sp_util/sp_util.dart';

Future<bool> verifyToken() async {
  // Ambil token dari Shared Preferences
  String? token = SpUtil.getString("token");
  print("middleware ${token}");

  if (token != null && token.isNotEmpty) {
    try {
      final response = await http.get(
        Uri.parse('${URLs.baseUrl}/api/user/check/${SpUtil.getString("token")}'), // Ubah sesuai dengan endpoint API Anda
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Token masih valid
        return true;
      } else {
        // Token tidak valid, atau terjadi kesalahan lain
        return false;
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau lainnya
      print('Error: $e');
      return false;
    }
  } else {
    // Token tidak tersedia di Shared Preferences
    return false;
  }
}
