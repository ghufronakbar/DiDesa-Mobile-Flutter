class BeritaModel {
  int? status;
  List<Values>? values;

  BeritaModel({this.status, this.values});

  BeritaModel.fromJson(Map<String, dynamic> json) {
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
  int? beritaId;
  String? judul;
  String? subjudul;
  String? tanggal;
  String? isi;
  String? gambar;
  List<Komentar>? komentar;

  Values(
      {this.beritaId,
      this.judul,
      this.subjudul,
      this.tanggal,
      this.isi,
      this.gambar,
      this.komentar});

  Values.fromJson(Map<String, dynamic> json) {
    beritaId = json['berita_id'];
    judul = json['judul'];
    subjudul = json['subjudul'];
    tanggal = json['tanggal'];
    isi = json['isi'];
    gambar = json['gambar'];
    if (json['komentar'] != null) {
      komentar = <Komentar>[];
      json['komentar'].forEach((v) {
        komentar!.add(new Komentar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['berita_id'] = this.beritaId;
    data['judul'] = this.judul;
    data['subjudul'] = this.subjudul;
    data['tanggal'] = this.tanggal;
    data['isi'] = this.isi;
    data['gambar'] = this.gambar;
    if (this.komentar != null) {
      data['komentar'] = this.komentar!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Komentar {
  int? komentarId;
  String? isi;
  String? tanggal;
  int? wargaId;
  String? namalengkap;
  String? foto;

  Komentar(
      {this.komentarId,
      this.isi,
      this.tanggal,
      this.wargaId,
      this.namalengkap,
      this.foto});

  Komentar.fromJson(Map<String, dynamic> json) {
    komentarId = json['komentar_id'];
    isi = json['isi'];
    tanggal = json['tanggal'];
    wargaId = json['warga_id'];
    namalengkap = json['namalengkap'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['komentar_id'] = this.komentarId;
    data['isi'] = this.isi;
    data['tanggal'] = this.tanggal;
    data['warga_id'] = this.wargaId;
    data['namalengkap'] = this.namalengkap;
    data['foto'] = this.foto;
    return data;
  }
}
