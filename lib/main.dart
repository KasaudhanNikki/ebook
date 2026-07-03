import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/network/dio_client.dart';
import 'data/repositories/ebook_repository_impl.dart';
import 'domain/repositories/ebook_repository.dart';
import 'presentation/controllers/ebook_controller.dart';
import 'presentation/pages/ebook_list_screen.dart';

void main() {
  final dioClient = DioClient();

  final EbookRepository ebookRepository = EbookRepositoryImpl(
    dioClient,
    useMock: true,
  );

  Get.put(EbookController(ebookRepository));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Digital Ebook Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EbookListScreen(),
    );
  }
}
