import 'package:flutter/material.dart';
import 'package:hag_cart/States/scanner_state.dart';
import 'package:provider/provider.dart';

class BottomNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xFF356DE5), // Add this
      selectedItemColor: Colors.white, // Add this
      unselectedItemColor: Colors.white.withOpacity(1), // Add this
      //selectedFontSize: 14.0, // Add this
      //unselectedFontSize: 14.0, // Add this
      type: BottomNavigationBarType.fixed, // Add this
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code_2),
          label: 'Scan',
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
          Provider.of<ScannerState>(context,listen: false).setIsLoading(true);
          await Provider.of<ScannerState>(context,listen: false).scanQR();
          Provider.of<ScannerState>(context,listen: false).setIsLoading(false);
          //_scanQR();
        } else if (index == 1) {//clear

        } else if (index == 2) {//about us

        } else if (index == 3) {//exit

        }
      },
    );
  }
}