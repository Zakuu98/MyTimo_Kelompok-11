import '../models/item.dart';

/// Sumber data sementara (dummy). Nanti bisa diganti dengan API/database.
class ItemRepository {
  // Data dummy sesuai petunjuk praktikum Latihan 2
  static const List<Item> _items = [
    Item(
      id: '1',
      title: 'Late Blight (Busuk Daun)',
      subtitle: 'Phytophthora infestans',
      description: 'Penyakit busuk daun yang disebabkan oleh jamur Phytophthora infestans. Menyerang daun dan buah tanaman tomat.',
    ),
    Item(
      id: '2',
      title: 'Septoria Leaf Spot',
      subtitle: 'Septoria lycopersici',
      description: 'Bintik daun Septoria disebabkan oleh jamur Septoria lycopersici. Menyebeabkan bercak cokelat kecil pada daun bagian bawah.',
    ),
    Item(
      id: '3',
      title: 'Tanaman Sehat',
      subtitle: 'Kondisi Optimal',
      description: 'Tanaman tomat dalam kondisi sehat tanpa gejala serangan hama maupun penyakit.',
    ),
  ];

  /// Mengambil daftar item.
  /// simulateError: true -> sengaja dibuat gagal untuk menguji error state.
  Future<List<Item>> fetchItems({bool simulateError = false}) async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi waktu tunggu server
    if (simulateError) {
      throw Exception('Gagal memuat data. Periksa koneksi internet.');
    }
    return _items;
  }
}
