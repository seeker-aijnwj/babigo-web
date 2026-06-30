import 'package:flutter/material.dart';

import 'package:babigo/app/core/utils/colors.dart';
import 'package:babigo/modules/booking_module/screens/passenger/passenger_main_screen.dart'; // Pour HomeScreenState
import 'package:babigo/app/widgets/button_component.dart';
import 'package:babigo/app/widgets/greeting_header.dart';
import 'package:babigo/modules/booking_module/widgets/recent_trips_widget.dart';

class PassengerHomeScreen extends StatelessWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // ✅ Gris très doux
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const GreetingHeader(),
              const SizedBox(height: 30),
              const RecentTripsWidget(),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonComponent(
                      txtButton: "Rechercher",
                      colorButton: AppColors.mainColor,
                      colorText: Colors.white,
                      shadowOpacity: 0.3,
                      shadowColor: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        (context.findAncestorStateOfType<PassengerMainScreenState>())
                            ?.navigateToTab(1);
                      },
                    ),
                    ButtonComponent(
                      txtButton: "Suivre",
                      colorButton: AppColors.mainColor,
                      colorText: Colors.white,
                      shadowOpacity: 0.3,
                      shadowColor: Colors.black,
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        (context.findAncestorStateOfType<PassengerMainScreenState>())
                            ?.navigateToTab(2);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
