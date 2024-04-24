class InformasiDesaModel {
  int? status;
  List<Values>? values;

  InformasiDesaModel({this.status, this.values});

  InformasiDesaModel.fromJson(Map<String, dynamic> json) {
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
  int? informasiDesaId;
  String? namaDesa;
  String? deskripsi;
  int? luasLahanPertanian;
  int? lahanPeternakan;

  Values(
      {this.informasiDesaId,
      this.namaDesa,
      this.deskripsi,
      this.luasLahanPertanian,
      this.lahanPeternakan});

  Values.fromJson(Map<String, dynamic> json) {
    informasiDesaId = json['informasi_desa_id'];
    namaDesa = json['nama_desa'];
    deskripsi = json['deskripsi'];
    luasLahanPertanian = json['luas_lahan_pertanian'];
    lahanPeternakan = json['lahan_peternakan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['informasi_desa_id'] = this.informasiDesaId;
    data['nama_desa'] = this.namaDesa;
    data['deskripsi'] = this.deskripsi;
    data['luas_lahan_pertanian'] = this.luasLahanPertanian;
    data['lahan_peternakan'] = this.lahanPeternakan;
    return data;
  }
}
