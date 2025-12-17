import 'package:beewear_app/routing/routes.dart';
import 'package:beewear_app/ui/core/themes/colors.dart';
import 'package:beewear_app/ui/core/themes/dimens.dart';
import 'package:beewear_app/ui/core/ui/google_auth_button.dart';
import 'package:beewear_app/ui/core/ui/or_divider.dart';
import 'package:beewear_app/ui/core/ui/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimens.paddingHorizontal),
          child: Column(
            spacing: 28,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/landing.png"),
              Text("Giving clothes\n"
                   "new life,\n"
                   "one outfit at a time.",
                   style: Theme.of(context).textTheme.headlineLarge),
              Column(
                spacing: 12,
                children: [
                  GoogleAuthButton(),
                  OrDivider(),
                  ElevatedButton(
                      onPressed: () {
                        context.push(Routes.register);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: AppColors.grey1),
                        ),
                      ),
                      child: Text(
                        "Create account",
                        style: Theme.of(context).textTheme.bodyLarge
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          context.push(Routes.login);
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20)
            ],
          )
        )
      )
    );
  }
}
