import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../controllers/ebook_controller.dart';

class UploadEbookScreen extends StatefulWidget {
  const UploadEbookScreen({super.key});

  @override
  State<UploadEbookScreen> createState() => _UploadEbookScreenState();
}

class _UploadEbookScreenState extends State<UploadEbookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  File? _selectedPdf;
  bool _isUploading = false;

  final EbookController _ebookController = Get.find<EbookController>();

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedPdf = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _selectedPdf != null) {
      setState(() => _isUploading = true);
      
      bool success = await _ebookController.uploadEbook(
        _titleController.text,
        _authorController.text,
        _selectedPdf!,
      );
      
      setState(() => _isUploading = false);
      
      if (success) {
        Get.back();
        Get.snackbar('Success', 'Ebook uploaded successfully', snackPosition: SnackPosition.BOTTOM);
      }
    } else if (_selectedPdf == null) {
      Get.snackbar('Error', 'Please select a PDF file', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Ebook')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Enter an author' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickPdf,
                icon: const Icon(Icons.picture_as_pdf),
                label: Text(_selectedPdf == null ? 'Select PDF File' : _selectedPdf!.path.split('/').last),
              ),
              const SizedBox(height: 32),
              _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                      child: const Text('Upload'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
