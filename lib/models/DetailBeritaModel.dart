class BeritaDetail {
  final int beritaId;
  final String judul;
  final String subjudul;
  final String isi;
  final String gambar;
  final List<Komentar> komentar;

  BeritaDetail({
    required this.beritaId,
    required this.judul,
    required this.subjudul,
    required this.isi,
    required this.gambar,
    required this.komentar,
  });

  factory BeritaDetail.fromJson(Map<String, dynamic> json) {
    return BeritaDetail(
      beritaId: json['berita_id'] as int,
      judul: json['judul'] as String,
      subjudul: json['subjudul'] as String,
      isi: json['isi'] as String,
      gambar: json['gambar'] as String,
      komentar: (json['komentar'] as List<dynamic>)
          .map((komentar) => Komentar.fromJson(komentar))
          .toList(),
    );
  }
}

class Komentar {
  final int komentarId;
  final String isi;
  final String tanggal;
  final int wargaId;
  final String namalengkap;
  final String foto;

  Komentar({
    required this.komentarId,
    required this.isi,
    required this.tanggal,
    required this.wargaId,
    required this.namalengkap,
    required this.foto,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      komentarId: json['komentar_id'] as int,
      isi: json['isi'] as String,
      tanggal: json['tanggal'] as String,
      wargaId: json['warga_id'] as int,
      namalengkap: json['namalengkap'] as String,
      foto: json['foto'] as String,
    );
  }
}
