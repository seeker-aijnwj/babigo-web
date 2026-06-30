import 'package:flutter/material.dart';
import 'package:babigo/app/core/utils/colors.dart';
import 'package:babigo/modules/booking_module/screens/passenger/passenger_main_screen.dart';
import 'package:babigo/app/widgets/button_component.dart';
import 'package:babigo/app/widgets/space.dart';
import 'package:babigo/app/widgets/txt_components.dart';

class ConfirmChangeScreen extends StatefulWidget {
  const ConfirmChangeScreen({super.key});

  @override
  State<ConfirmChangeScreen> createState() => _ConfirmChangeScreenState();
}

class _ConfirmChangeScreenState extends State<ConfirmChangeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 150),
              spaceHeight(20),
              TxtComponents(
                txt: "Modificaiton effectué ! ",
                fw: FontWeight.bold,
                family: "Bold",
                txtSize: 28,
              ),
              spaceHeight(20),
              TxtComponents(
                txt: "Votre mot de passe a été modifié avec succes ",
                txtSize: 20,
                txtAlign: TextAlign.center,
              ),
              spaceHeight(20),
              ButtonComponent(
                txtButton: "Acceuil",
                colorButton: AppColors.mainColor,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PassengerMainScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
