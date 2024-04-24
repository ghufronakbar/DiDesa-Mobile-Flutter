class PengurusDesaAnggotaModel {
  int? status;
  List<Values>? values;

  PengurusDesaAnggotaModel({this.status, this.values});

  PengurusDesaAnggotaModel.fromJson(Map<String, dynamic> json) {
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
  int? pengurusDesaAnggotaId;
  String? namaLengkap;
  String? foto;
  String? jabatan;

  Values(
      {this.pengurusDesaAnggotaId, this.namaLengkap, this.foto, this.jabatan});

  Values.fromJson(Map<String, dynamic> json) {
    pengurusDesaAnggotaId = json['pengurus_desa_anggota_id'];
    namaLengkap = json['nama_lengkap'];
    foto = json['foto'];
    jabatan = json['jabatan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pengurus_desa_anggota_id'] = this.pengurusDesaAnggotaId;
    data['nama_lengkap'] = this.namaLengkap;
    data['foto'] = this.foto;
    data['jabatan'] = this.jabatan;
    return data;
  }
}
