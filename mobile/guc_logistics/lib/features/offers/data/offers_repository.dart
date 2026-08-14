import '../../../core/config/app_config.dart';
import '../../../core/data/mock/mock_data.dart';
import '../../../core/domain/models.dart';
import '../../../core/network/api_client.dart';

class OffersRepository {
  OffersRepository(this._api);

  final ApiClient _api;

  Future<List<OfferItem>> listMine() async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return List.of(MockData.offers);
    }
    final response = await _api.dio.get('/api/v1/offers/mine');
    final data = response.data;
    final list = data is List ? data : (data['content'] as List? ?? const []);
    return list.map((e) => OfferItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<OfferItem> getOffer(String id) async {
    if (AppConfig.useMockData) {
      return MockData.offers.firstWhere((e) => e.id == id, orElse: () => MockData.offers.first);
    }
    final response = await _api.dio.get('/api/v1/offers/$id');
    return OfferItem.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<void> submitOffer({
    required String loadId,
    required double amount,
    required String currency,
    String? message,
  }) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      LoadItem? load;
      for (final item in MockData.loads) {
        if (item.id == loadId) {
          load = item;
          break;
        }
      }
      final now = DateTime.now();
      MockData.offers.insert(
        0,
        OfferItem(
          id: 'offer-${now.millisecondsSinceEpoch}',
          loadId: loadId,
          amount: amount,
          currency: currency,
          status: 'PENDING',
          message: message,
          loadTitle: load?.title,
          carrierName: MockData.driverDisplayName,
          rounds: [
            OfferRound(
              amount: amount,
              currency: currency,
              byRole: 'CARRIER',
              createdAt: now,
              message: message,
            ),
          ],
        ),
      );
      return;
    }
    await _api.dio.post('/api/v1/loads/$loadId/offers', data: {
      'offererType': 'DRIVER',
      'amount': amount,
      'currency': currency,
      'message': message,
    });
  }

  Future<void> counterOffer({
    required String offerId,
    required double amount,
    required String byRole,
    String? message,
  }) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final index = MockData.offers.indexWhere((e) => e.id == offerId);
      if (index < 0) return;
      final current = MockData.offers[index];
      final round = OfferRound(
        amount: amount,
        currency: current.currency,
        byRole: byRole,
        createdAt: DateTime.now(),
        message: message,
      );
      MockData.offers[index] = current.copyWith(
        amount: amount,
        status: byRole == 'SHIPPER' ? 'COUNTERED' : 'PENDING',
        message: message ?? current.message,
        rounds: [...current.rounds, round],
      );
      return;
    }
    await _api.dio.post('/api/v1/offers/$offerId/counter', data: {
      'amount': amount,
      'message': message,
    });
  }

  Future<String?> accept(String id) async {
    if (AppConfig.useMockData) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      final index = MockData.offers.indexWhere((e) => e.id == id);
      if (index < 0) return null;
      final current = MockData.offers[index];
      final matchId = 'match-${DateTime.now().millisecondsSinceEpoch}';
      MockData.offers[index] = current.copyWith(status: 'ACCEPTED', matchId: matchId);

      LoadItem? load;
      final loadIndex = MockData.loads.indexWhere((e) => e.id == current.loadId);
      if (loadIndex >= 0) {
        load = MockData.loads[loadIndex];
        MockData.loads[loadIndex] = load.copyWith(
          status: 'MATCHED',
          matchId: matchId,
          offerStatus: 'ACCEPTED',
        );
      }

      final shipperPhone = load?.contactPhone ?? MockData.shipperPhone;
      final carrierPhone = MockData.driverPhone;
      final route = load == null ? null : '${load.pickupCity} → ${load.dropoffCity}';

      MockData.matches.insert(
        0,
        MatchThread(
          id: matchId,
          loadId: current.loadId,
          offerId: current.id,
          loadTitle: current.loadTitle ?? current.loadId,
          agreedAmount: current.amount,
          currency: current.currency,
          shipperName: load?.companyName ?? MockData.companyName,
          carrierName: current.carrierName ?? MockData.driverDisplayName,
          createdAt: DateTime.now(),
          shipperPhone: shipperPhone,
          carrierPhone: carrierPhone,
          routeLabel: route,
        ),
      );
      MockData.messages.add(
        ChatMessage(
          id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
          matchId: matchId,
          senderRole: 'SHIPPER',
          body: 'Offer accepted. Call or message to align loading. Shipper: $shipperPhone · Carrier: $carrierPhone',
          createdAt: DateTime.now(),
        ),
      );
      // Auto-accumulate carrier earnings (demo: credit TRY equivalent / agreed amount).
      final tryAmount = current.currency == 'TRY' ? current.amount : current.amount * 36;
      MockData.earnings.insert(
        0,
        EarningsEntry(
          id: 'earn-${DateTime.now().millisecondsSinceEpoch}',
          matchId: matchId,
          title: current.loadTitle ?? current.loadId,
          route: route ?? '-',
          amount: tryAmount,
          currency: 'TRY',
          at: DateTime.now(),
          status: 'CREDITED',
        ),
      );
      return matchId;
    }
    await _api.dio.post('/api/v1/offers/$id/accept');
    return null;
  }

  Future<void> reject(String id, {String? reason}) async {
    if (AppConfig.useMockData) {
      final index = MockData.offers.indexWhere((e) => e.id == id);
      if (index < 0) return;
      final current = MockData.offers[index];
      MockData.offers[index] = current.copyWith(status: 'REJECTED', rejectReason: reason ?? 'Rejected by shipper');
      MockData.notifications.insert(
        0,
        NotificationItem(
          id: 'n-${DateTime.now().millisecondsSinceEpoch}',
          title: 'Offer rejected',
          body: '${current.carrierName ?? 'Carrier'}: ${reason ?? 'Rejected'}',
          createdAt: DateTime.now(),
        ),
      );
      return;
    }
    await _api.dio.post('/api/v1/offers/$id/reject', data: {'reason': reason});
  }

  void _updateStatus(String id, String status) {
    final index = MockData.offers.indexWhere((e) => e.id == id);
    if (index < 0) return;
    final current = MockData.offers[index];
    MockData.offers[index] = current.copyWith(status: status);
  }
}
