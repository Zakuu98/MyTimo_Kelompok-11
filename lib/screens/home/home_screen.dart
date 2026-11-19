import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import 'widgets/home_header_card.dart';
import 'widgets/main_menu_section.dart';
import 'widgets/recent_diagnosis_section.dart';
import 'widgets/scan_banner_card.dart';
import 'widgets/stats_summary_row.dart';

/// Halaman Dashboard Utama (Home) MyTimo sesuai Desain Figma Frame: home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.homeBackground,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Gradient Section (Height: ~230px, bottom radius 28px)
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.homeHeaderGradientFigma,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(
                  top: topPadding + 14,
                  bottom: 24,
                  left: 24,
                  right: 24,
                ),
                child: const HomeHeaderCard(),
              ),

              // Content Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    SizedBox(height: 18),

                    // Banner Scan Card
                    ScanBannerCard(),

                    SizedBox(height: 18),

                    // 3 Stats Cards: Total Tanaman, Perlu Rawat, Daun Sehat
                    StatsSummaryRow(),

                    SizedBox(height: 20),

                    // Menu Utama (Data Tanaman, Riwayat Scan, Rencana Rawat, Monitoring)
                    MainMenuSection(),

                    SizedBox(height: 22),

                    // Pemeriksaan Terbaru (Tomat Cherry Blok A & Tomat Servo Bedeng 1)
                    RecentDiagnosisSection(),

                    SizedBox(height: 32),
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
