import 'package:equatable/equatable.dart';

class LoadItem extends Equatable {
  const LoadItem({
    required this.id,
    required this.title,
    required this.loadType,
    required this.pickupCountry,
    required this.pickupCity,
    required this.dropoffCountry,
    required this.dropoffCity,
    required this.weightKg,
    required this.vehicleType,
    required this.loadDate,
    required this.deliveryDate,
    required this.status,
    required this.currency,
    this.price,
    this.offerStatus,
    this.companyVerified = false,
    this.description,
    this.matchScore,
    this.matchId,
    this.factoryName,
    this.companyName,
    this.contactPhone,
    this.contactPerson,
    this.doorRamp,
    this.referenceNo,
    this.adr = false,
    this.coldChain = false,
    this.tailLift = false,
    this.forklift = false,
    this.palletCount,
    this.batchId,
    this.favoritesOnly = false,
    this.offerSlaHours = 24,
    this.photos = const [],
    this.pickupRegion,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.pickupAddress,
    this.dropoffAddress,
    this.volumeM3,
    this.packagingType,
    this.cargoValue,
    this.customsRequired = false,
    this.customsReference,
    this.unNumber,
    this.temperatureMin,
    this.temperatureMax,
    this.insuranceRequired = false,
  });

  final String id;
  final String title;
  final String loadType;
  final String pickupCountry;
  final String pickupCity;
  final String dropoffCountry;
  final String dropoffCity;
  final double weightKg;
  final String vehicleType;
  final DateTime loadDate;
  final DateTime deliveryDate;
  final String status;
  final String currency;
  final double? price;
  final String? offerStatus;
  final bool companyVerified;
  final String? description;
  final int? matchScore;
  final String? matchId;
  final String? factoryName;
  /// Shipper company that published the listing (visible to other shippers on the board).
  final String? companyName;
  final String? contactPhone;
  final String? contactPerson;
  final String? doorRamp;
  final String? referenceNo;
  final bool adr;
  final bool coldChain;
  final bool tailLift;
  final bool forklift;
  final int? palletCount;
  final String? batchId;
  final bool favoritesOnly;
  final int offerSlaHours;
  final List<String> photos;
  /// State / province / eyalet for pickup (e.g. Bavaria, Lombardy).
  final String? pickupRegion;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? pickupAddress;
  final String? dropoffAddress;
  final double? volumeM3;
  final String? packagingType;
  final double? cargoValue;
  final bool customsRequired;
  final String? customsReference;
  final String? unNumber;
  final double? temperatureMin;
  final double? temperatureMax;
  final bool insuranceRequired;

  double get weightTons => weightKg / 1000;

  factory LoadItem.fromJson(Map<String, dynamic> json) {
    return LoadItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Load',
      loadType: json['loadType']?.toString() ?? json['vehicleRequirements']?.toString() ?? 'General',
      pickupCountry: json['pickupCountry']?.toString() ?? '',
      pickupCity: json['pickupCity']?.toString() ?? '',
      dropoffCountry: json['dropoffCountry']?.toString() ?? '',
      dropoffCity: json['dropoffCity']?.toString() ?? '',
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      vehicleType: json['vehicleType']?.toString() ?? json['vehicleRequirements']?.toString() ?? 'Truck',
      loadDate: DateTime.tryParse(json['readyFrom']?.toString() ?? json['loadDate']?.toString() ?? '') ?? DateTime.now(),
      deliveryDate: DateTime.tryParse(json['readyTo']?.toString() ?? json['deliveryDate']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'PUBLISHED',
      currency: json['currency']?.toString() ?? 'EUR',
      price: (json['price'] as num?)?.toDouble() ?? (json['expectedPrice'] as num?)?.toDouble(),
      offerStatus: json['offerStatus']?.toString(),
      companyVerified: json['companyVerified'] == true,
      description: json['description']?.toString(),
      matchScore: (json['matchScore'] as num?)?.toInt(),
      matchId: json['matchId']?.toString(),
      factoryName: json['factoryName']?.toString(),
      companyName: json['companyName']?.toString(),
      contactPhone: json['contactPhone']?.toString(),
      contactPerson: json['contactPerson']?.toString(),
      doorRamp: json['doorRamp']?.toString(),
      referenceNo: json['referenceNo']?.toString(),
      adr: json['adr'] == true,
      coldChain: json['coldChain'] == true,
      tailLift: json['tailLift'] == true,
      forklift: json['forklift'] == true,
      palletCount: (json['palletCount'] as num?)?.toInt(),
      batchId: json['batchId']?.toString(),
      favoritesOnly: json['favoritesOnly'] == true,
      offerSlaHours: (json['offerSlaHours'] as num?)?.toInt() ?? 24,
      photos: (json['photos'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      pickupRegion: json['pickupRegion']?.toString(),
      pickupLat: (json['pickupLat'] as num?)?.toDouble(),
      pickupLng: (json['pickupLng'] as num?)?.toDouble(),
      dropoffLat: (json['dropoffLat'] as num?)?.toDouble(),
      dropoffLng: (json['dropoffLng'] as num?)?.toDouble(),
      pickupAddress: json['pickupAddress']?.toString(),
      dropoffAddress: json['dropoffAddress']?.toString(),
      volumeM3: (json['volumeM3'] as num?)?.toDouble(),
      packagingType: json['packagingType']?.toString(),
      cargoValue: (json['cargoValue'] as num?)?.toDouble(),
      customsRequired: json['customsRequired'] == true,
      customsReference: json['customsReference']?.toString(),
      unNumber: json['unNumber']?.toString(),
      temperatureMin: (json['temperatureMin'] as num?)?.toDouble(),
      temperatureMax: (json['temperatureMax'] as num?)?.toDouble(),
      insuranceRequired: json['insuranceRequired'] == true,
    );
  }

  LoadItem copyWith({
    String? title,
    String? loadType,
    String? pickupCountry,
    String? pickupCity,
    String? dropoffCountry,
    String? dropoffCity,
    double? weightKg,
    String? vehicleType,
    DateTime? loadDate,
    DateTime? deliveryDate,
    String? status,
    String? matchId,
    String? offerStatus,
    double? price,
    String? description,
    String? factoryName,
    String? companyName,
    String? contactPhone,
    String? contactPerson,
    String? doorRamp,
    String? referenceNo,
    bool? adr,
    bool? coldChain,
    bool? tailLift,
    bool? forklift,
    int? palletCount,
    String? batchId,
    bool? favoritesOnly,
    int? offerSlaHours,
    List<String>? photos,
    String? pickupRegion,
    double? pickupLat,
    double? pickupLng,
    double? dropoffLat,
    double? dropoffLng,
    String? pickupAddress,
    String? dropoffAddress,
    double? volumeM3,
    String? packagingType,
    double? cargoValue,
    bool? customsRequired,
    String? customsReference,
    String? unNumber,
    double? temperatureMin,
    double? temperatureMax,
    bool? insuranceRequired,
  }) {
    return LoadItem(
      id: id,
      title: title ?? this.title,
      loadType: loadType ?? this.loadType,
      pickupCountry: pickupCountry ?? this.pickupCountry,
      pickupCity: pickupCity ?? this.pickupCity,
      dropoffCountry: dropoffCountry ?? this.dropoffCountry,
      dropoffCity: dropoffCity ?? this.dropoffCity,
      weightKg: weightKg ?? this.weightKg,
      vehicleType: vehicleType ?? this.vehicleType,
      loadDate: loadDate ?? this.loadDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      status: status ?? this.status,
      currency: currency,
      price: price ?? this.price,
      offerStatus: offerStatus ?? this.offerStatus,
      companyVerified: companyVerified,
      description: description ?? this.description,
      matchScore: matchScore,
      matchId: matchId ?? this.matchId,
      factoryName: factoryName ?? this.factoryName,
      companyName: companyName ?? this.companyName,
      contactPhone: contactPhone ?? this.contactPhone,
      contactPerson: contactPerson ?? this.contactPerson,
      doorRamp: doorRamp ?? this.doorRamp,
      referenceNo: referenceNo ?? this.referenceNo,
      adr: adr ?? this.adr,
      coldChain: coldChain ?? this.coldChain,
      tailLift: tailLift ?? this.tailLift,
      forklift: forklift ?? this.forklift,
      palletCount: palletCount ?? this.palletCount,
      batchId: batchId ?? this.batchId,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
      offerSlaHours: offerSlaHours ?? this.offerSlaHours,
      photos: photos ?? this.photos,
      pickupRegion: pickupRegion ?? this.pickupRegion,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      volumeM3: volumeM3 ?? this.volumeM3,
      packagingType: packagingType ?? this.packagingType,
      cargoValue: cargoValue ?? this.cargoValue,
      customsRequired: customsRequired ?? this.customsRequired,
      customsReference: customsReference ?? this.customsReference,
      unNumber: unNumber ?? this.unNumber,
      temperatureMin: temperatureMin ?? this.temperatureMin,
      temperatureMax: temperatureMax ?? this.temperatureMax,
      insuranceRequired: insuranceRequired ?? this.insuranceRequired,
    );
  }

  @override
  List<Object?> get props => [id, status, matchId, price, factoryName, companyName, photos, favoritesOnly];
}

class ShipperCompanyListing extends Equatable {
  const ShipperCompanyListing({
    required this.companyName,
    required this.country,
    required this.region,
    required this.city,
    required this.factories,
    required this.activeLoads,
    this.verified = false,
  });

  final String companyName;
  final String country;
  final String region;
  final String city;
  final List<String> factories;
  final int activeLoads;
  final bool verified;

  @override
  List<Object?> get props => [companyName, country, city, activeLoads];
}

class RouteTemplate extends Equatable {
  const RouteTemplate({
    required this.id,
    required this.name,
    required this.factoryName,
    required this.pickupCity,
    required this.pickupCountry,
    required this.dropoffCity,
    required this.dropoffCountry,
    required this.loadType,
    required this.weightTons,
    required this.vehicleType,
    this.doorRamp,
    this.contactPerson,
    this.contactPhone,
    this.adr = false,
    this.coldChain = false,
    this.tailLift = false,
    this.forklift = false,
  });

  final String id;
  final String name;
  final String factoryName;
  final String pickupCity;
  final String pickupCountry;
  final String dropoffCity;
  final String dropoffCountry;
  final String loadType;
  final double weightTons;
  final String vehicleType;
  final String? doorRamp;
  final String? contactPerson;
  final String? contactPhone;
  final bool adr;
  final bool coldChain;
  final bool tailLift;
  final bool forklift;

  @override
  List<Object?> get props => [id];
}

class OfferRound extends Equatable {
  const OfferRound({
    required this.amount,
    required this.currency,
    required this.byRole,
    required this.createdAt,
    this.message,
  });

  final double amount;
  final String currency;
  final String byRole; // SHIPPER | CARRIER
  final DateTime createdAt;
  final String? message;

  @override
  List<Object?> get props => [amount, currency, byRole, createdAt, message];
}

class OfferItem extends Equatable {
  const OfferItem({
    required this.id,
    required this.loadId,
    required this.amount,
    required this.currency,
    required this.status,
    this.message,
    this.loadTitle,
    this.carrierName,
    this.matchId,
    this.rounds = const [],
    this.transitHours,
    this.trustScore,
    this.carrierId,
    this.rejectReason,
    this.createdAt,
    this.expiresAt,
    this.vehicleId,
    this.vehiclePlate,
    this.vehicleType,
    this.driverName,
    this.driverPhone,
    this.availableAt,
  });

  final String id;
  final String loadId;
  final double amount;
  final String currency;
  final String status; // PENDING | COUNTERED | ACCEPTED | REJECTED
  final String? message;
  final String? loadTitle;
  final String? carrierName;
  final String? matchId;
  final List<OfferRound> rounds;
  final int? transitHours;
  final double? trustScore;
  final String? carrierId;
  final String? rejectReason;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final String? vehicleId;
  final String? vehiclePlate;
  final String? vehicleType;
  final String? driverName;
  final String? driverPhone;
  final DateTime? availableAt;

  bool get slaExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  factory OfferItem.fromJson(Map<String, dynamic> json) {
    return OfferItem(
      id: json['id']?.toString() ?? '',
      loadId: json['loadId']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? 'EUR',
      status: json['status']?.toString() ?? 'PENDING',
      message: json['message']?.toString(),
      loadTitle: json['loadTitle']?.toString(),
      carrierName: json['carrierName']?.toString(),
      matchId: json['matchId']?.toString(),
      transitHours: (json['transitHours'] as num?)?.toInt() ?? (json['estimatedTransitHours'] as num?)?.toInt(),
      trustScore: (json['trustScore'] as num?)?.toDouble(),
      carrierId: json['carrierId']?.toString(),
      rejectReason: json['rejectReason']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      expiresAt: DateTime.tryParse(json['expiresAt']?.toString() ?? ''),
      vehicleId: json['vehicleId']?.toString(),
      vehiclePlate: json['vehiclePlate']?.toString(),
      vehicleType: json['vehicleType']?.toString(),
      driverName: json['driverName']?.toString(),
      driverPhone: json['driverPhone']?.toString(),
      availableAt: DateTime.tryParse(json['availableAt']?.toString() ?? ''),
    );
  }

  OfferItem copyWith({
    double? amount,
    String? status,
    String? message,
    String? matchId,
    List<OfferRound>? rounds,
    String? rejectReason,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return OfferItem(
      id: id,
      loadId: loadId,
      amount: amount ?? this.amount,
      currency: currency,
      status: status ?? this.status,
      message: message ?? this.message,
      loadTitle: loadTitle,
      carrierName: carrierName,
      matchId: matchId ?? this.matchId,
      rounds: rounds ?? this.rounds,
      transitHours: transitHours,
      trustScore: trustScore,
      carrierId: carrierId,
      rejectReason: rejectReason ?? this.rejectReason,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      vehicleId: vehicleId,
      vehiclePlate: vehiclePlate,
      vehicleType: vehicleType,
      driverName: driverName,
      driverPhone: driverPhone,
      availableAt: availableAt,
    );
  }

  @override
  List<Object?> get props => [id, amount, status, matchId, rounds, rejectReason];
}

class DisputeClaim extends Equatable {
  const DisputeClaim({
    required this.id,
    required this.loadId,
    required this.matchId,
    required this.type,
    required this.title,
    required this.status,
    required this.createdAt,
    this.details,
    this.amount,
  });

  final String id;
  final String loadId;
  final String matchId;
  final String type; // DELAY | DAMAGE | PAYMENT
  final String title;
  final String status; // OPEN | REVIEW | RESOLVED
  final DateTime createdAt;
  final String? details;
  final double? amount;

  @override
  List<Object?> get props => [id, status];
}

class PaymentLedgerEntry extends Equatable {
  const PaymentLedgerEntry({
    required this.id,
    required this.shipmentId,
    required this.label,
    required this.amount,
    required this.currency,
    required this.kind,
    required this.at,
  });

  final String id;
  final String shipmentId;
  final String label;
  final double amount;
  final String currency;
  final String kind; // HOLD | RELEASE | PAYOUT | FEE
  final DateTime at;

  @override
  List<Object?> get props => [id];
}

class DispatcherPermissions extends Equatable {
  const DispatcherPermissions({
    this.canPublish = true,
    this.canAcceptOffers = true,
    this.canManagePayments = false,
    this.canInviteTeam = false,
  });

  final bool canPublish;
  final bool canAcceptOffers;
  final bool canManagePayments;
  final bool canInviteTeam;

  DispatcherPermissions copyWith({
    bool? canPublish,
    bool? canAcceptOffers,
    bool? canManagePayments,
    bool? canInviteTeam,
  }) {
    return DispatcherPermissions(
      canPublish: canPublish ?? this.canPublish,
      canAcceptOffers: canAcceptOffers ?? this.canAcceptOffers,
      canManagePayments: canManagePayments ?? this.canManagePayments,
      canInviteTeam: canInviteTeam ?? this.canInviteTeam,
    );
  }

  @override
  List<Object?> get props => [canPublish, canAcceptOffers, canManagePayments, canInviteTeam];
}

class DeliveryRating extends Equatable {
  const DeliveryRating({
    required this.id,
    required this.matchId,
    required this.carrierName,
    required this.score,
    this.comment,
  });

  final String id;
  final String matchId;
  final String carrierName;
  final int score;
  final String? comment;

  @override
  List<Object?> get props => [id, score];
}

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.matchId,
    required this.senderRole,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String matchId;
  final String senderRole; // SHIPPER | CARRIER
  final String body;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id];
}

class MatchThread extends Equatable {
  const MatchThread({
    required this.id,
    required this.loadId,
    required this.offerId,
    required this.loadTitle,
    required this.agreedAmount,
    required this.currency,
    required this.shipperName,
    required this.carrierName,
    required this.createdAt,
    this.shipperPhone,
    this.carrierPhone,
    this.routeLabel,
  });

  final String id;
  final String loadId;
  final String offerId;
  final String loadTitle;
  final double agreedAmount;
  final String currency;
  final String shipperName;
  final String carrierName;
  final DateTime createdAt;
  final String? shipperPhone;
  final String? carrierPhone;
  final String? routeLabel;

  @override
  List<Object?> get props => [id, shipperPhone, carrierPhone];
}

class EarningsEntry extends Equatable {
  const EarningsEntry({
    required this.id,
    required this.matchId,
    required this.title,
    required this.route,
    required this.amount,
    required this.currency,
    required this.at,
    this.status = 'CREDITED',
  });

  final String id;
  final String matchId;
  final String title;
  final String route;
  final double amount;
  final String currency;
  final DateTime at;
  /// PENDING | CREDITED | PAID
  final String status;

  @override
  List<Object?> get props => [id, amount, status];
}

class CarrierAvailability extends Equatable {
  const CarrierAvailability({
    this.available = true,
    this.country = 'TR',
    this.region = 'Marmara',
    this.city = 'Istanbul',
    this.minPriceTry = 15000,
    this.vehicleFilter = 'Any',
    this.adrReady = false,
    this.maxDeadheadKm = 150,
    this.capacityKg = 24000,
    this.preferredDestination = 'Any',
    this.refrigerated = false,
    this.tailLift = false,
    this.availableFrom,
    this.availableUntil,
  });

  final bool available;
  final String country;
  final String region;
  final String city;
  final double minPriceTry;
  final String vehicleFilter;
  final bool adrReady;
  final int maxDeadheadKm;
  final double capacityKg;
  final String preferredDestination;
  final bool refrigerated;
  final bool tailLift;
  final DateTime? availableFrom;
  final DateTime? availableUntil;

  CarrierAvailability copyWith({
    bool? available,
    String? country,
    String? region,
    String? city,
    double? minPriceTry,
    String? vehicleFilter,
    bool? adrReady,
    int? maxDeadheadKm,
    double? capacityKg,
    String? preferredDestination,
    bool? refrigerated,
    bool? tailLift,
    DateTime? availableFrom,
    DateTime? availableUntil,
  }) {
    return CarrierAvailability(
      available: available ?? this.available,
      country: country ?? this.country,
      region: region ?? this.region,
      city: city ?? this.city,
      minPriceTry: minPriceTry ?? this.minPriceTry,
      vehicleFilter: vehicleFilter ?? this.vehicleFilter,
      adrReady: adrReady ?? this.adrReady,
      maxDeadheadKm: maxDeadheadKm ?? this.maxDeadheadKm,
      capacityKg: capacityKg ?? this.capacityKg,
      preferredDestination: preferredDestination ?? this.preferredDestination,
      refrigerated: refrigerated ?? this.refrigerated,
      tailLift: tailLift ?? this.tailLift,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
    );
  }

  @override
  List<Object?> get props => [available, country, city, minPriceTry, vehicleFilter, adrReady, maxDeadheadKm, capacityKg, preferredDestination, refrigerated, tailLift, availableFrom, availableUntil];
}

class VehicleItem extends Equatable {
  const VehicleItem({
    required this.id,
    required this.plate,
    required this.type,
    required this.capacityKg,
    required this.status,
  });

  final String id;
  final String plate;
  final String type;
  final double capacityKg;
  final String status;

  factory VehicleItem.fromJson(Map<String, dynamic> json) {
    return VehicleItem(
      id: json['id']?.toString() ?? '',
      plate: json['plate']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      capacityKg: (json['capacityKg'] as num?)?.toDouble() ?? 0,
      status: json['status']?.toString() ?? 'ACTIVE',
    );
  }

  @override
  List<Object?> get props => [id];
}

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  @override
  List<Object?> get props => [id];
}

class CorridorPreset extends Equatable {
  const CorridorPreset({
    required this.id,
    required this.label,
    required this.fromCountries,
    required this.toCountries,
  });

  final String id;
  final String label;
  final List<String> fromCountries;
  final List<String> toCountries;

  @override
  List<Object?> get props => [id];
}

class MarketPriceBand extends Equatable {
  const MarketPriceBand({
    required this.corridorId,
    required this.minEur,
    required this.maxEur,
    required this.avgEur,
  });

  final String corridorId;
  final double minEur;
  final double maxEur;
  final double avgEur;

  @override
  List<Object?> get props => [corridorId];
}

class TrustStats extends Equatable {
  const TrustStats({
    required this.rating,
    required this.completedJobs,
    required this.onTimeRate,
    required this.delayRate,
  });

  final double rating;
  final int completedJobs;
  final double onTimeRate;
  final double delayRate;

  @override
  List<Object?> get props => [rating, completedJobs];
}

class CarrierListing extends Equatable {
  const CarrierListing({
    required this.id,
    required this.name,
    required this.baseCountry,
    required this.baseCity,
    required this.vehicleType,
    required this.capacityKg,
    required this.verified,
    required this.trust,
    required this.corridors,
    required this.availableHours,
    required this.mapX,
    required this.mapY,
    this.plate,
    this.matchScore,
  });

  final String id;
  final String name;
  final String baseCountry;
  final String baseCity;
  final String vehicleType;
  final double capacityKg;
  final bool verified;
  final TrustStats trust;
  final List<String> corridors;
  final int availableHours;
  final double mapX; // 0..1 relative Europe board
  final double mapY;
  final String? plate;
  final int? matchScore;

  @override
  List<Object?> get props => [id];
}

class MapPin extends Equatable {
  const MapPin({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.mapX,
    required this.mapY,
    required this.kind, // load | carrier
    this.verified = false,
  });

  final String id;
  final String label;
  final String subtitle;
  final double mapX;
  final double mapY;
  final String kind;
  final bool verified;

  @override
  List<Object?> get props => [id, kind];
}
