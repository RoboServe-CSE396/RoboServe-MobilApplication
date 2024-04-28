import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  bool isQRScanned = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Our Restaurant',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              isQRScanned
                  ? Text(
                      'QR Code Scanned',
                      style: TextStyle(fontSize: 18),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isQRScanned = true;
                        });
                      },
                      child: Text(
                        'Scan QR Code',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
              isQRScanned
                  ? Expanded(
                      flex: 4,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        if (await canLaunch(scanData.code!)) {
          await launch(scanData.code!);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Invalid QR Code'),
                content: Text('The QR code you scanned is not valid.'),
              );
            },
          );
        }
      }
      controller.pauseCamera();
      setState(() {
        isQRScanned = true;
      });
    });
  }

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }
}
