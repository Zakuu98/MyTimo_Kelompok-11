import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/plant_provider.dart';

/// Modal Bottom Sheet untuk Filter & Opsi Pengelolaan Data Tanaman
class PlantFilterModal extends StatelessWidget {
  const PlantFilterModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PlantFilterModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plantProvider = Provider.of<PlantProvider>(context);
    final statusList = ['Semua', 'Sehat', 'Perlu Rawat', 'Parah'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Image.asset(
                'assets/custom_assets/icons/ic_filter.png',
                width: 20,
                height: 20,
                color: const Color(0xFF178401),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Filter & Pengaturan Tanaman',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Filter Berdasarkan Status
          const Text(
            'Filter Berdasarkan Status',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: statusList.map((status) {
              final isSelected =
                  plantProvider.selectedFilter.toLowerCase() == status.toLowerCase();
              final count = plantProvider.countByFilter(status);

              return ChoiceChip(
                label: Text('$status ($count)'),
                selected: isSelected,
                selectedColor: const Color(0xFFC5F3C1),
                backgroundColor: const Color(0xFFF3EDED),
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF106804)
                      : const Color(0xFF4B5563),
                ),
                onSelected: (_) {
                  plantProvider.setSelectedFilter(status);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),

          // Aksi Cepat Simulasi State (Sesuai Permintaan User: State Data Dummy & State Kosong)
          const Text(
            'Simulasi Tampilan (Data Dummy & Empty State)',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 10),

          // Tombol Kosongkan Semua Data (Empty State)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_sweep_rounded,
                color: Color(0xFFDC2626),
                size: 20,
              ),
            ),
            title: const Text(
              'Kosongkan Semua Tanaman',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDC2626),
              ),
            ),
            subtitle: const Text(
              'Tampilkan halaman belum ada data tanaman (Empty State)',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              plantProvider.clearAllPlants();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Semua tanaman dikosongkan. Menampilkan Empty State.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          // Tombol Reset ke 4 Data Dummy Awal
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.restore_page_rounded,
                color: Color(0xFF16A34A),
                size: 20,
              ),
            ),
            title: const Text(
              'Pulihkan 4 Data Dummy Awal',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF15803D),
              ),
            ),
            subtitle: const Text(
              'Tampilkan daftar tanaman dummy sesuai desain Figma',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              plantProvider.resetToDefault();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data dummy awal dipulihkan.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Tombol Tutup
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF178401),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
