import 'package:flutter/cupertino.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';

class ScannerState extends ChangeNotifier{
  String? scannedCompanyId="please";

  Future scanQR() async {
    try {
      String? cameraScanResult = await scanner.scan();
      scannedCompanyId = cameraScanResult;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }
}