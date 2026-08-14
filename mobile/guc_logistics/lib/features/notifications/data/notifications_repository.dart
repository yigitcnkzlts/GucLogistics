import '../../../core/config/app_config.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/domain/models.dart';
import '../../../core/network/api_client.dart';

class NotificationsRepository {
  NotificationsRepository(this._api);
  final ApiClient _api;

  Future<List<NotificationItem>> list() async {
    if (AppConfig.useMockData) {
      return List.of(MockData.notifications);
    }
    final response = await _api.dio.get('/api/v1/notifications', queryParameters: {'page': 0, 'size': 50});
    final content = response.data['content'] as List? ?? const [];
    return content
        .map((e) => NotificationItem(
              id: e['id'].toString(),
              title: e['title']?.toString() ?? '',
              body: e['body']?.toString() ?? '',
              createdAt: DateTime.tryParse(e['createdAt']?.toString() ?? '') ?? DateTime.now(),
              read: e['readAt'] != null,
            ))
        .toList();
  }
}
