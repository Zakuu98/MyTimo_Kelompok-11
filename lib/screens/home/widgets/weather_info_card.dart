import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_text_styles.dart';

/// Kartu status cuaca dan indikator kelembapan dengan peringatan dini jamur
class WeatherInfoCard extends StatelessWidget {
  const WeatherInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, _) {
        final weather = dashboard.weatherStat;

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.p14,
            vertical: AppSizes.p12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: AppSizes.roundedL,
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Weather Icon Container
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.warningOrangeLight,
                  borderRadius: AppSizes.roundedM,
                ),
                child: const Icon(
                  Icons.wb_cloudy_outlined,
                  color: AppColors.warningOrange,
                  size: AppSizes.iconSizeMedium,
                ),
              ),
              const SizedBox(width: AppSizes.p12),

              // Location & Temperature
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.location}, ${weather.temperature}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.p2),
                    Text(
                      weather.humidityAlertTitle,
                      style: AppTextStyles.bodyMuted.copyWith(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Alert Pill: Waspada Jamur!
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p10,
                  vertical: AppSizes.p6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warningOrangeLight,
                  borderRadius: AppSizes.roundedFull,
                  border: Border.all(
                    color: AppColors.warningOrange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  weather.humidityBadgeText,
                  style: AppTextStyles.badgeText.copyWith(
                    color: AppColors.warningOrange,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
