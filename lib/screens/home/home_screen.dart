import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_sizes.dart';
import 'widgets/disease_encyclopedia_section.dart';
import 'widgets/home_header_card.dart';
import 'widgets/recent_diagnosis_section.dart';
import 'widgets/scan_banner_card.dart';
import 'widgets/stats_summary_row.dart';
import 'widgets/weather_info_card.dart';

/// Halaman Dashboard Utama (Home) MyTimo sesuai Frame 4 Figma & PRD FR-01
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card with Gradient & Weather
              Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.homeHeaderGradient,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(AppSizes.radius2XL),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + AppSizes.p16,
                  bottom: AppSizes.p20,
                  left: AppSizes.p20,
                  right: AppSizes.p20,
                ),
                child: const Column(
                  children: [
                    HomeHeaderCard(),
                    SizedBox(height: AppSizes.p16),
                    WeatherInfoCard(),
                  ],
                ),
              ),

              // Content Body
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p20,
                  vertical: AppSizes.p16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Call-To-Action Banner: Foto Daun Tomat Sekarang
                    const ScanBannerCard(),

                    const SizedBox(height: AppSizes.p16),

                    // Metrics Stats Row (24, 88%, 3)
                    const StatsSummaryRow(),

                    const SizedBox(height: AppSizes.p24),

                    // Ensiklopedia Penyakit (Late Blight, Septoria)
                    const DiseaseEncyclopediaSection(),

                    const SizedBox(height: AppSizes.p24),

                    // Riwayat Diagnosa Terbaru
                    const RecentDiagnosisSection(),

                    const SizedBox(height: AppSizes.p32),
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
