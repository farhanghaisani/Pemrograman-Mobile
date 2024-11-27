import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/modules/home/views/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final HomeController controller =
      Get.put(HomeController()); // Menambahkan controller menggunakan GetX

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lokasi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(), // Menampilkan HomeView
    );
  }
}
