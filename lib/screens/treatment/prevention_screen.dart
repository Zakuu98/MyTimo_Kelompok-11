import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/mytimo_bottom_nav.dart';

/// Screen 22: Panduan Pencegahan
/// Anggota 3: Athaya Nasywa Mahira - 2411523028
class PreventionScreen extends StatefulWidget {
  const PreventionScreen({super.key});

  @override
  State<PreventionScreen> createState() => _PreventionScreenState();
}

class _PreventionScreenState extends State<PreventionScreen> {
  int _selectedTab = 1; // 0=Penanganan, 1=Pencegahan

  final List<_PreventionTip> _pencegahanTips = const [
    _PreventionTip(
      title: 'Rotasi Tanaman Non-Solanaceae',
      description: 'Hindari menanam famili cabai/terung di lahan yang sama selama 2 musim tanam berturut-turut.',
      benefit: 'Memutus siklus spora jamur dalam tanah',
    ),
    _PreventionTip(
      title: 'Jarak Tanam & Mulsa Plastik',
      description: 'Beri jarak tanam minimal 60 × 70 cm agar sirkulasi udara baik. Gunakan mulsa perak untuk cegah percikan air tanah ke daun.',
      benefit: 'Menjaga helai daun tetap kering',
    ),
    _PreventionTip(
      title: 'Pemilihan Benih Unggul Tahan Penyakit',
      description: 'Gunakan benih bersertifikat dengan toleransi penyakit seperti Servo F1 atau Gustavi F1.',
      benefit: 'Ketahanan genetik tanaman sejak awal',
    ),
    _PreventionTip(
      title: 'Penyiraman Pangkal Pagi Hari',
      description: 'Siram di pagi hari menggunakan drip irrigation langsung ke pangkal. Hindari membasahi daun.',
      benefit: 'Mencegah kelembaban berlebih pada daun',
    ),
    _PreventionTip(
      title: 'Fungisida Preventif Berkala',
      description: 'Semprotkan fungisida protektif berbahan aktif tembaga atau mankozeb sebelum musim hujan.',
      benefit: 'Lapisan proteksi pada permukaan daun',
    ),
  ];

  final List<_PreventionTip> _penangananTips = const [
    _PreventionTip(
      title: 'Pangkas Daun Bawah Berpenyakit',
      description: 'Gunting tangkai daun berbercak dengan gunting bersih, masukkan kantong dan bakar di luar lahan.',
      benefit: 'Menghentikan penyebaran spora jamur',
    ),
    _PreventionTip(
      title: 'Semprot Fungisida Tembaga (2g/L)',
      description: 'Aplikasikan pada pagi hari sebelum sinar matahari terik. Ulangi setiap 7-10 hari.',
      benefit: 'Membunuh spora aktif pada daun',
    ),
    _PreventionTip(
      title: 'Atur Irigasi Pangkal Batang',
      description: 'Siram langsung ke tanah pangkal tanaman. Jangan membasahi helai daun.',
      benefit: 'Mengurangi kelembaban pada daun sakit',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tips = _selectedTab == 1 ? _pencegahanTips : _penangananTips;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        title: const Text(
          'Panduan Pencegahan',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      body: Column(
        children: [
          // Tab switcher sesuai Figma
          _buildTabSwitcher(),
          // Daftar tips
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: tips.length,
              itemBuilder: (context, i) => _buildTipCard(i + 1, tips[i]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MyTimoBottomNav(activeIndex: 2),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedTab == 0 ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: _selectedTab == 0
                        ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2))]
                        : [],
                  ),
                  child: Text(
                    'Penanganan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: _selectedTab == 0 ? FontWeight.w700 : FontWeight.w500,
                      color: _selectedTab == 0 ? AppColors.textPrimary : AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _selectedTab == 1 ? AppColors.primaryGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_selectedTab == 1)
                        const Icon(Icons.shield_outlined, color: Colors.white, size: 16),
                      if (_selectedTab == 1) const SizedBox(width: 6),
                      Text(
                        'Pencegahan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: _selectedTab == 1 ? FontWeight.w700 : FontWeight.w500,
                          color: _selectedTab == 1 ? Colors.white : AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(int number, _PreventionTip tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number. ${tip.title}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            tip.description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          // Badge manfaat
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreenSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.primaryGreen, size: 15),
                const SizedBox(width: 6),
                Text(
                  tip.benefit,
                  style: const TextStyle(
                    color: AppColors.primaryGreenText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreventionTip {
  final String title;
  final String description;
  final String benefit;

  const _PreventionTip({
    required this.title,
    required this.description,
    required this.benefit,
  });
}
