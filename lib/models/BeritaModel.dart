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
  String? gambar;

  Values({this.beritaId, this.judul, this.subjudul, this.tanggal, this.gambar});

  Values.fromJson(Map<String, dynamic> json) {
    beritaId = json['berita_id'];
    judul = json['judul'];
    subjudul = json['subjudul'];
    tanggal = json['tanggal'];
    gambar = json['gambar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['berita_id'] = this.beritaId;
    data['judul'] = this.judul;
    data['subjudul'] = this.subjudul;
    data['tanggal'] = this.tanggal;
    data['gambar'] = this.gambar;
    return data;
  }
}