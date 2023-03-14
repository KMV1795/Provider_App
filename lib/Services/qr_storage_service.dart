import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;

class QrStorageService {
  /* Convert QR to image File  */

  ScreenshotController screenshotController = ScreenshotController();

  late File qrFile;
  late File fullQrFile;

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    qrFile = await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> widgetToImageFile(
    Uint8List capturedImage,
  ) async {
    Directory newTempDir = await getTemporaryDirectory();
    String newTempPath = newTempDir.path;
    final newTime = DateTime.now().millisecondsSinceEpoch.toString();
    String path = '$newTempPath/$newTime.png';
    fullQrFile = await File(path).writeAsBytes(capturedImage);
  }

  /* Convert QR to image and save to Firebase Storage */

  covertQrtoImage(String randomData, String loginDate, String loginTime) async {
    final qrValidationResult = QrValidator.validate(
      data: randomData,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        color: const Color(0xFF000000),
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
      );

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      final time = DateTime.now().millisecondsSinceEpoch.toString();
      final path = '$tempPath/$time.png';

      // ui is from import 'dart:ui' as ui;
      final picData =
          await painter.toImageData(2048, format: ui.ImageByteFormat.png);

      // writeToFile is seen in code snippet below
      await writeToFile(
        picData!,
        path,
      );

      await screenshotController
          .captureFromWidget(
        Image.file(qrFile),
      )
          .then((capturedImage) async {
        await widgetToImageFile(capturedImage);
      });
    } else {
      if (kDebugMode) {
        print("Image not captured");
      }
    }

    String result = await storeIamge(loginDate, loginTime);
    return result;
  }

  storeIamge(String loginDate, String loginTime) async {
    /* qrStorage is a reference to a folder in firebase storage */

    await FirebaseStorage.instance
        .ref('qrStorage')
        .child('$loginDate/$loginTime')
        .putFile(fullQrFile);

    String url = await FirebaseStorage.instance
        .ref('qrStorage')
        .child('$loginDate/$loginTime')
        .getDownloadURL();
    if (url.isNotEmpty) {
      return url;
    } else {
      return "No Url Downloaded";
    }
  }
}
