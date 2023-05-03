import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tesseract_ocr/android_ios.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  final imagePicker = ImagePicker();
  var imageFile = Rx<File?>(null);

  var isPick = false.obs;
  var isLoading = false.obs;
  var isConvert = false.obs;
  var imageProcessText = "".obs;
  var translateText = "".obs;
  var fileS = 0.0.obs;


  @override
  void onInit() {
   // getTesseractFile('eng');
    super.onInit();
  }

  /// <<<<<<<<<<<<<<<<<<<<<<<<<<<< Pick Image >>>>>>>>>>>>>>>>>>>>>>>>>>>>///

  Future pickImage(ImageSource source) async {
    try {
      final image =
          await ImagePicker().pickImage(source: source, imageQuality: 80);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      imageFile.value = img!;
      isPick.value = true;
      Get.back();
    } on PlatformException catch (e) {
      isPick.value = true;
      Get.back();
      return Center(child: Text(e.toString()));
    }
  }

  /// <<<<<<<<<<<<<<<<<<<<<<<<<<<< Crop Image >>>>>>>>>>>>>>>>>>>>>>>>>>>>///

  Future<File?> _cropImage({required File imageFile}) async {
    try {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.deepPurple.shade400,
              cropFrameColor: Colors.grey,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              cropFrameStrokeWidth: 3,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ],
      );
      if (croppedImage == null) return null;
      return File(croppedImage.path);
    } catch (e) {
      print("Error is $e");
    }
    return null;
  }

  /// <<<<<<<<<<<<<<<<<<<<<<<<<<<<  File Size >>>>>>>>>>>>>>>>>>>>>>>>>>>>///



  /// <<<<<<<<<<<<<<<<<<<<<<<<<<<<  File Exists Check >>>>>>>>>>>>>>>>>>>>>>>>>>>>///

  Future<bool> fileExists(String filePath) async {
    return await File(filePath).exists();
  }

  /// <<<<<<<<<<<<<<<<<<<<<<<<<<<< Get Tesseract File  >>>>>>>>>>>>>>>>>>>>>>>>>>>>///

  void getTesseractFile(String language) async {
    bool exists = await fileExists('/data/user/0/com.app.imageToText.image_to_text/app_flutter/tessdata/$language.traineddata');
    if(exists == false){

      print("<<<<<<<< File Not exist >>>>>>>> ");
      HttpClient httpClient = HttpClient();
      final String url = "https://github.com/tesseract-ocr/tessdata/raw/main/$language.traineddata";
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
      HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        print(((response.contentLength/1024)/1024).toStringAsFixed(2));

        Uint8List bytes =await consolidateHttpClientResponseBytes(response);
        String dir = await FlutterTesseractOcr.getTessdataPath().whenComplete(() {
          print("$language Language Download Complete");
        });
        File file =  File('$dir/$language.traineddata');
        print(file);
        await file.writeAsBytes(bytes);

      } else {
        Get.snackbar("Oops", "Error\nStatus Code = ${response.statusCode}",
            icon: const Icon(Icons.error_outline,color: Colors.red,size: 40),
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15));
      }

    }else{
      print("<<<<<<<< File Already exist >>>>>>>>");
    }
  }

  /// <<<<<<<<<<<<<<<<<<<<<<<<<<<< Process Image >>>>>>>>>>>>>>>>>>>>>>>>>>>>///

  Future processImage({required File image, required String language}) async {
    try {
     getTesseractFile(language);
      String text = await FlutterTesseractOcr.extractText(image.path,
          language: language,
          args: {
            "psm": "4",
            "preserve_interword_spaces": "1",
          });

      imageProcessText.value = text;
      isLoading.value = false;
    } on PlatformException catch (e) {
      return Get.snackbar("error", e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30));
    }
  }

  /// <<<<<<<<<<<<<<<<<<<<<<<<<<<< Translate text >>>>>>>>>>>>>>>>>>>>>>>>>>>>///
}
