import 'package:hive/hive.dart';

import '../../../core/config/app_config.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/domain/models.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/platform_services.dart';

class MatchesRepository {
  MatchesRepository(this._api, [Box<String>? offlineBox]) : _cache = OfflineCache(offlineBox ?? Hive.box<String>('offline_cache'));

  final ApiClient _api;
  final OfflineCache _cache;

  Future<List<MatchThread>> listMine() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
      return List.of(MockData.matches);
    }
    try {
      final response = await _api.dio.get('/api/v1/matches');
      final list = response.data is List ? response.data as List : (response.data['content'] as List? ?? const []);
      final mapped = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      await _cache.putList('matches', mapped);
      return mapped.map(_fromJson).toList();
    } catch (_) {
      final cached = _cache.getList('matches');
      if (cached == null) rethrow;
      return cached.map(_fromJson).toList();
    }
  }

  Future<MatchThread> getMatch(String id) async {
    if (AppConfig.useMockData) {
      return MockData.matches.firstWhere((e) => e.id == id, orElse: () => MockData.matches.first);
    }
    try {
      final response = await _api.dio.get('/api/v1/matches/$id');
      return _fromJson(Map<String, dynamic>.from(response.data as Map));
    } catch (_) {
      final all = await listMine();
      return all.firstWhere((e) => e.id == id, orElse: () => all.first);
    }
  }

  MatchThread _fromJson(Map<String, dynamic> e) {
    return MatchThread(
      id: e['id'].toString(),
      loadId: e['loadId'].toString(),
      offerId: e['offerId'].toString(),
      loadTitle: e['loadTitle']?.toString() ?? e['status']?.toString() ?? '',
      agreedAmount: (e['agreedAmount'] as num?)?.toDouble() ?? 0,
      currency: e['currency']?.toString() ?? 'EUR',
      shipperName: e['shipperName']?.toString() ?? '',
      carrierName: e['carrierName']?.toString() ?? '',
      createdAt: DateTime.tryParse(e['createdAt']?.toString() ?? e['matchedAt']?.toString() ?? '') ?? DateTime.now(),
      shipperPhone: e['shipperPhone']?.toString(),
      carrierPhone: e['carrierPhone']?.toString(),
      routeLabel: e['routeLabel']?.toString(),
    );
  }

  Future<List<ChatMessage>> listMessages(String matchId) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      return MockData.messages.where((e) => e.matchId == matchId).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    final response = await _api.dio.get('/api/v1/matches/$matchId/messages');
    final list = response.data is List ? response.data as List : const [];
    return list
        .map(
          (e) => ChatMessage(
            id: e['id'].toString(),
            matchId: matchId,
            senderRole: e['senderRole']?.toString() ?? 'SHIPPER',
            body: e['body']?.toString() ?? '',
            createdAt: DateTime.tryParse(e['createdAt']?.toString() ?? '') ?? DateTime.now(),
          ),
        )
        .toList();
  }

  Future<void> sendMessage({
    required String matchId,
    required String body,
    required String senderRole,
  }) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 150));
      MockData.messages.add(
        ChatMessage(
          id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
          matchId: matchId,
          senderRole: senderRole,
          body: body,
          createdAt: DateTime.now(),
        ),
      );
      return;
    }
    await _api.dio.post('/api/v1/matches/$matchId/messages', data: {'body': body});
  }
}
