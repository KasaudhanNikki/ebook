import 'package:file_picker/file_picker.dart';

void main() async {
  try {
    var result = await FilePicker.pickFiles();
    print(result);
  } catch (e) {
    print(e);
  }
}
