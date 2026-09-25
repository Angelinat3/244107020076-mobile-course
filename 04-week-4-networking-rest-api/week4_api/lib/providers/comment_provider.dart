import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api_client.dart';
import '../data/models/comment.dart';
import '../data/repositories/comment_repository.dart';

final commentRepositoryProvider = Provider((ref) {
  final dio = createDio();
  return CommentRepository(dio);
});

// 1. Gunakan AsyncNotifier standar (tanpa kata 'Family' di namanya)
class CommentNotifier extends AsyncNotifier<List<Comment>> {
  @override
  Future<List<Comment>> build(int postId) async {
    try {
      final repository = ref.watch(commentRepositoryProvider);
      return await repository.fetchComments(postId);
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Terjadi kesalahan yang tidak diketahui: $e');
    }
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Waktu koneksi habis. Periksa kembali jaringan internet Anda.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return 'Data komentar tidak ditemukan (404).';
        } else if (statusCode == 500) {
          return 'Terjadi gangguan pada server (500). Silakan coba lagi nanti.';
        }
        return 'Kesalahan server dengan kode: $statusCode';
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      default:
        return 'Terjadi kesalahan jaringan.';
    }
  }
}

// 2. Terapkan .family dan .autoDispose di level provider-nya secara langsung
final commentsProvider = AsyncNotifierProvider.autoDispose.family<CommentNotifier, List<Comment>, int>(
  CommentNotifier.new,
);