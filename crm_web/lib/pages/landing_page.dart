import 'package:flutter/material.dart';

import '../widgets/navbar.dart';
import '../sections/hero_section.dart';
import '../sections/features_section.dart';
import '../sections/how_it_works_section.dart';
import '../sections/pricing_section.dart';
import '../sections/cta_section.dart';
import '../sections/footer_section.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              children: const [
                SizedBox(height: 80), // Space for fixed navbar
                HeroSection(),
                FeaturesSection(),
                HowItWorksSection(),
                PricingSection(),
                CtaSection(),
                FooterSection(),
              ],
            ),
          ),
          // Fixed navbar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Navbar(),
          ),
        ],
      ),
    );
  }
}
