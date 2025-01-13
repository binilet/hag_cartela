import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  final Function(String) onScanned;

  QRCodeScannerScreen({required this.onScanned});

  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  late MobileScannerController _controller;
  bool _isScanned = false; // To prevent multiple scans

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (barcodeCapture) {
          if (!_isScanned && barcodeCapture.barcodes.isNotEmpty) {
            _isScanned = true; // Prevent further scans
            final String? code = barcodeCapture.barcodes.first.rawValue;

            if (code != null) {
              widget.onScanned(code); // Pass scanned result back
              Navigator.pop(context); // Close the scanner screen
            }
          }
        },
      ),
    );
  }
}
