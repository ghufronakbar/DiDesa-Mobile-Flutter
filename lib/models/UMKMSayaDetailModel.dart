class UMKMSayaDetailModel {
  int? status;
  List<Values>? values;

  UMKMSayaDetailModel({this.status, this.values});

  UMKMSayaDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? jenisUmkmId;
  String? deskripsi;
  String? gambar;
  String? lokasi;
  int? approve;
  int? status;
  int? wargaId;
  String? namaJenisUmkm;
  String? nik;
  String? kk;
  String? namaLengkap;
  String? tanggalLahir;
  String? foto;
  int? hakPilih;
  String? password;

  Values(
      {this.umkmId,
      this.nama,
      this.jenisUmkmId,
      this.deskripsi,
      this.gambar,
      this.lokasi,
      this.approve,
      this.status,
      this.wargaId,
      this.namaJenisUmkm,
      this.nik,
      this.kk,
      this.namaLengkap,
      this.tanggalLahir,
      this.foto,
      this.hakPilih,
      this.password});

  Values.fromJson(Map<String, dynamic> json) {
    umkmId = json['umkm_id'];
    nama = json['nama'];
    jenisUmkmId = json['jenis_umkm_id'];
    deskripsi = json['deskripsi'];
    gambar = json['gambar'];
    lokasi = json['lokasi'];
    approve = json['approve'];
    status = json['status'];
    wargaId = json['warga_id'];
    namaJenisUmkm = json['nama_jenis_umkm'];
    nik = json['nik'];
    kk = json['kk'];
    namaLengkap = json['nama_lengkap'];
    tanggalLahir = json['tanggal_lahir'];
    foto = json['foto'];
    hakPilih = json['hak_pilih'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['umkm_id'] = this.umkmId;
    data['nama'] = this.nama;
    data['jenis_umkm_id'] = this.jenisUmkmId;
    data['deskripsi'] = this.deskripsi;
    data['gambar'] = this.gambar;
    data['lokasi'] = this.lokasi;
    data['approve'] = this.approve;
    data['status'] = this.status;
    data['warga_id'] = this.wargaId;
    data['nama_jenis_umkm'] = this.namaJenisUmkm;
    data['nik'] = this.nik;
    data['kk'] = this.kk;
    data['nama_lengkap'] = this.namaLengkap;
    data['tanggal_lahir'] = this.tanggalLahir;
    data['foto'] = this.foto;
    data['hak_pilih'] = this.hakPilih;
    data['password'] = this.password;
    return data;
  }
}