import 'package:flutter/material.dart';
import '../models/sesi_pengguna.dart';

class KartuSesi extends StatelessWidget {
  final SesiPengguna sesi;
  final DateTime sekarang;
  final VoidCallback? onKeluar;
  final bool sedangKeluar;

  const KartuSesi({
    super.key,
    required this.sesi,
    required this.sekarang,
    this.onKeluar,
    this.sedangKeluar = false,
  });

  @override
  Widget build(BuildContext context) {
    final Duration sisa = sesi.sisaWaktu(sekarang);
    final int menit = sisa.inMinutes;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${sesi.nama}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Email: ${sesi.email}'),
            Text('Peran: ${SesiPengguna.labelPeran(sesi.peran)}'),
            const Divider(),
            Text('Sisa Waktu: $menit menit'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: sedangKeluar ? null : onKeluar,
                icon: const Icon(Icons.logout),
                label: Text(sedangKeluar ? 'Keluar...' : 'Keluar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}