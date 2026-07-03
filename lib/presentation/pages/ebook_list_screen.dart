import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ebook_controller.dart';
import 'upload_ebook_screen.dart';
import 'pdf_viewer_screen.dart';

class EbookListScreen extends StatelessWidget {
  const EbookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EbookController controller = Get.find<EbookController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Ebook Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(() => const UploadEbookScreen()),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by title, author or filename...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.ebooks.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.fetchEbooks(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.ebooks.isEmpty) {
                return const Center(child: Text('No ebooks found.'));
              }

              return ListView.builder(
                itemCount: controller.ebooks.length,
                itemBuilder: (context, index) {
                  final ebook = controller.ebooks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.red,
                        size: 40,
                      ),
                      title: Text(
                        ebook.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${ebook.author}\n${ebook.filename}'),
                      isThreeLine: true,
                      onTap: () {
                        Get.to(
                          () => PdfViewerScreen(
                            pdfUrl: ebook.pdfUrl,
                            title: ebook.title,
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Delete Ebook',
                            middleText:
                                'Are you sure you want to delete "${ebook.title}"?',
                            textConfirm: 'Yes',
                            textCancel: 'No',
                            confirmTextColor: Colors.white,
                            onConfirm: () {
                              controller.deleteEbook(ebook.id);
                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
