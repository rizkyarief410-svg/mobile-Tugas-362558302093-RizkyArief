import 'package:flutter/material.dart';
import '../controllers/sesi_controller.dart';

class GerbangSesi extends StatelessWidget {
  final SesiController controller;
  final Widget Function(BuildContext) form;
  final Widget Function(BuildContext, dynamic) beranda;

  const GerbangSesi({
    super.key,
    required this.controller,
    required this.form,
    required this.beranda,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        switch (controller.status) {
          case StatusSesi.memeriksa:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          case StatusSesi.masuk:
            return beranda(context, controller.sesi!);
          case StatusSesi.keluar:
          case StatusSesi.memproses:
          case StatusSesi.gagal:
          case StatusSesi.kedaluwarsa:
            return form(context);
        }
      },
    );
  }
}