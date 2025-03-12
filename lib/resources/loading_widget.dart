import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotpot/resources/assets_manager.dart';
import 'package:hotpot/resources/color_manager.dart';
import 'package:hotpot/resources/reponsive_utils.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primary.withOpacity( 0.2),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              width: context.width * 0.1,
              height: context.height * 0.1,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(
                ImageAssets.logo,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              "LANH",
              style: GoogleFonts.montserrat(
                  shadows: [
                    const BoxShadow(
                      color: Colors.white,
                      spreadRadius: 1,
                      offset: Offset(1, 2),
                    ),
                  ],
                  letterSpacing: 3,
                  color: ColorsManager.primary,
                  fontSize: UtilsReponsive.height(30, context),
                  height: 1.5,
                  fontWeight: FontWeight.w900),
            ),
            Center(
              child: SizedBox(
                height: UtilsReponsive.height(100, context),
                width: UtilsReponsive.width(100, context),
                child: SpinKitFadingCircle(
                  color: ColorsManager.primary, // Màu của nét đứt
                  size: 50.0, // Kích thước của CircularProgressIndicator
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
