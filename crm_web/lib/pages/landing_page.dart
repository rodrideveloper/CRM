import 'package:flutter/material.dart';

import '../widgets/navbar.dart';
import '../sections/hero_section.dart';
import '../sections/features_section.dart';
import '../sections/how_it_works_section.dart';
import '../sections/pricing_section.dart';
import '../sections/lead_capture_section.dart';
import '../sections/faq_section.dart';
import '../sections/cta_section.dart';
import '../sections/footer_section.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _featuresKey = GlobalKey();
  final _howItWorksKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _leadCaptureKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80), // Space for fixed navbar
                HeroSection(onDemo: () => _scrollTo(_leadCaptureKey)),
                FeaturesSection(key: _featuresKey),
                HowItWorksSection(key: _howItWorksKey),
                PricingSection(key: _pricingKey),
                LeadCaptureSection(key: _leadCaptureKey),
                const FaqSection(),
                const CtaSection(),
                const FooterSection(),
              ],
            ),
          ),
          // Fixed navbar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Navbar(
              onFeatures: () => _scrollTo(_featuresKey),
              onPricing: () => _scrollTo(_pricingKey),
              onHowItWorks: () => _scrollTo(_howItWorksKey),
            ),
          ),
        ],
      ),
    );
  }
}
