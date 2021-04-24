@Skip('Decision about components')
import 'package:app/ui/views/image_upload/image_uploader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';

class ImagePickerMock extends Mock implements ImagePicker {}

main() {
  var imagePickerMock;
  final imageTestFilePath = 'test/assets/IMG_20180118_145943.jpg';

  setUp(() {
    imagePickerMock = ImagePickerMock();
  });

  tearDown(() {
    // ignore: unnecessary_statements
    imagePickerMock == null;
  });

  void setUpImagePickerWithImage() {
    when(imagePickerMock.getImage(source: ImageSource.camera))
        .thenAnswer((_) async => PickedFile(imageTestFilePath));
  }

  group('pickImage tests', () {
    test('Given ImagePicker returns image, returns the same image', () async {
      setUpImagePickerWithImage();

      var file = await ImageUploader.pickImage(ImageSource.camera, imagePicker: imagePickerMock);

      expect(file.path, imageTestFilePath);
    });

    test('Given non functioning ImagePicker throws FileSystemException', () async {
      expect(
          () async =>
              await ImageUploader.pickImage(ImageSource.camera, imagePicker: imagePickerMock),
          throwsException);
    });
  });

  group('cropImage tests', () {
    test('Given empty file path throws FormatException', () async {
      expect(() async => await ImageUploader.cropImage(''), throwsException);
    });

    test('Given null file path throws FormatException', () async {
      expect(() async => await ImageUploader.cropImage(null), throwsException);
    });
  });
}
