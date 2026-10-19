import 'package:flutter/foundation.dart';
import '../../../modul_06/models/sesi_pengguna.dart';
import '../../../modul_06/services/auth_api.dart';
import '../repositories/sesi_repository.dart';

enum StatusSesi { memeriksa, keluar, memproses, masuk, gagal, kedaluwarsa }

class SesiController extends ChangeNotifier {
  final AuthApi api;
  final SesiRepository repository;
  final DateTime Function() jam;

  StatusSesi _status = StatusSesi.memeriksa;
  SesiPengguna? _sesi;
  String? _pesanError;

  SesiController({
    required this.api,
    required this.repository,
    this.jam = DateTime.now,
  });

  StatusSesi get status => _status;
  SesiPengguna? get sesi => _sesi;
  String? get pesanError => _pesanError;
  SesiRepository get repo => repository;

  Future<void> pulihkan() async {
    _ubahStatus(StatusSesi.memeriksa);
    final tersimpan = await repository.baca();

    if (tersimpan == null) {
      _ubahStatus(StatusSesi.keluar);
      return;
    }

    if (tersimpan.sudahKedaluwarsa(jam())) {
      await repository.hapus();
      _sesi = null;
      _ubahStatus(StatusSesi.kedaluwarsa, pesan: 'Sesi Anda sudah berakhir. Silakan masuk kembali.');
      return;
    }

    _sesi = tersimpan;
    _ubahStatus(StatusSesi.masuk);
  }

  Future<void> login(String email, String sandi) async {
    if (_status == StatusSesi.memproses) return;
    _ubahStatus(StatusSesi.memproses, pesan: null);

    try {
      final hasil = await api.masuk(email: email, sandi: sandi);
      await repository.simpan(hasil);
      _sesi = hasil;
      _ubahStatus(StatusSesi.masuk);
    } on AuthException catch (e) {
      _ubahStatus(StatusSesi.gagal, pesan: e.pesan);
    } catch (e) {
      _ubahStatus(StatusSesi.gagal, pesan: 'Terjadi kesalahan tak terduga.');
    }
  }

  Future<void> logout() async {
    await repository.hapus();
    _sesi = null;
    _ubahStatus(StatusSesi.keluar, pesan: null);
  }

  void _ubahStatus(StatusSesi baru, {String? pesan}) {
    _status = baru;
    if (pesan != null) _pesanError = pesan;
    notifyListeners();
  }
}