class SesiPengguna {
  final String token;
  final String email;
  final String nama;
  final String peran;
  final String masukPada;
  final String kedaluwarsaPada;

  const SesiPengguna({
    required this.token,
    required this.email,
    required this.nama,
    required this.peran,
    required this.masukPada,
    required this.kedaluwarsaPada,
  });

  Duration sisaWaktu(DateTime sekarang) {
    final DateTime? batas = DateTime.tryParse(kedaluwarsaPada);
    if (batas == null) return Duration.zero;
    final Duration sisa = batas.difference(sekarang);
    return sisa.isNegative ? Duration.zero : sisa;
  }

  bool sudahKedaluwarsa(DateTime sekarang) {
    final DateTime? batas = DateTime.tryParse(kedaluwarsaPada);
    if (batas == null) return true;
    return !sekarang.isBefore(batas);
  }

  static String labelPeran(String peran) {
    switch (peran) {
      case 'dosen':
        return 'Dosen';
      case 'mahasiswa':
        return 'Mahasiswa';
      default:
        return 'Pengguna';
    }
  }
}