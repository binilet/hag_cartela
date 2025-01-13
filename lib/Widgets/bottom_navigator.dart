import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hag_cart/States/scanner_state.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import './Jackpot/jackpot.dart';


class BottomNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,//Color(0xFF356DE5), // Add this
      selectedItemColor: Colors.blue, // Add this
      unselectedItemColor: Colors.blue.withOpacity(1.0), // Add this
      //selectedFontSize: 14.0, // Add this
      //unselectedFontSize: 14.0, // Add this
      type: BottomNavigationBarType.fixed, // Add this
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_2),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.gamepad),
          label: 'Jackpot',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cleaning_services_rounded),
          label: 'Clear',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle),
          label: 'About Us',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'Exit',
        ),
      ],
      onTap: (index) async {
        if (index == 0) {//scan
          final cameraStatus = await Permission.camera.status;
          final storageStatus = await Permission.storage.status;

          if(cameraStatus.isDenied ){
            await Permission.camera.request();
          }
          if(storageStatus.isDenied){
            await Permission.storage.request();
          }
          Provider.of<ScannerState>(context,listen: false).setIsLoading(true);
          await Provider.of<ScannerState>(context,listen: false).scanQR(context);
          Provider.of<ScannerState>(context,listen: false).setIsLoading(false);

        }else if(index == 1){
          Navigator.push(context,MaterialPageRoute(builder: (context) => Jackpot()));
        }
        else if (index == 2) {//clear
          Provider.of<ScannerState>(context,listen:false).resetBoards();
        } else if (index == 3) {//about us
          showAboutUsPopup(context);
        } else if (index == 4) {//exit
          SystemNavigator.pop();
        }
      },
    );
  }

  void showAboutUsPopup(BuildContext context) {
    final currentYear = DateTime.now().year;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Us'),
          content: Column(
            children: [
              Text('Welcome to Hagere Games!'),
          SizedBox(height: 10),
          Text('We create exciting and innovative games for you to enjoy.'),
          SizedBox(height: 10),
          Text('Copyright © $currentYear Hagere Games. All rights reserved.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}