class UMKMModel {
  int? status;
  List<Values>? values;

  UMKMModel({this.status, this.values});

  UMKMModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  int? umkmId;
  String? nama;
  String? namaJenisUmkm;
  String? deskripsi;
  String? gambar;
  String? lokasi;
  int? wargaId;
  String? namaLengkap;

  Values(
      {this.umkmId,
      this.nama,
      this.namaJenisUmkm,
      this.deskripsi,
      this.gambar,
      this.lokasi,
      this.wargaId,
      this.namaLengkap});

  Values.fromJson(Map<String, dynamic> json) {
    umkmId = json['umkm_id'];
    nama = json['nama'];
    namaJenisUmkm = json['nama_jenis_umkm'];
    deskripsi = json['deskripsi'];
    gambar = json['gambar'];
    lokasi = json['lokasi'];
    wargaId = json['warga_id'];
    namaLengkap = json['nama_lengkap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['umkm_id'] = this.umkmId;
    data['nama'] = this.nama;
    data['nama_jenis_umkm'] = this.namaJenisUmkm;
    data['deskripsi'] = this.deskripsi;
    data['gambar'] = this.gambar;
    data['lokasi'] = this.lokasi;
    data['warga_id'] = this.wargaId;
    data['nama_lengkap'] = this.namaLengkap;
    return data;
  }
}
