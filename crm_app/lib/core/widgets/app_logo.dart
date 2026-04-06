import 'package:flutter/material.dart';

import '../theme/design_tokens.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.width = 156,
    this.height = 156,
    this.fit = BoxFit.contain,
    this.imagePadding = 18,
  });

  static const assetPath = 'assets/branding/logo_transparent.png';

  final double width;
  final double height;
  final BoxFit fit;
  final double imagePadding;

  @override
  Widget build(BuildContext context) {
    final outerRadius = BorderRadius.circular(DesignTokens.radiusXL);
    final innerRadius = BorderRadius.circular(20);

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DesignTokens.surfaceContainerHigh,
              DesignTokens.surfaceContainer,
            ],
          ),
          borderRadius: outerRadius,
          border: Border.all(
            color: DesignTokens.outlineVariant.withValues(alpha: 0.22),
          ),
          boxShadow: DesignTokens.ambientGlow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: innerRadius,
            child: Padding(
              padding: EdgeInsets.all(imagePadding),
              child: Image.asset(
                  assetPath,
                  fit: fit,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (context, error, stackTrace) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: DesignTokens.primaryGradient,
                        borderRadius: innerRadius,
                      ),
                      child: Center(
                        child: Text(
                          'TRATAR',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.6,
                              ),
                        ),
                      ),
                    );
                  },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
