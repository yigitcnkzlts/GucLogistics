import 'package:equatable/equatable.dart';

class DocItem extends Equatable {
  const DocItem({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    this.fileName,
    this.updatedAt,
  });

  final String id;
  final String type; // LICENSE | INSURANCE | K1 | CMR | ID
  final String title;
  final String status; // MISSING | PENDING | APPROVED | REJECTED
  final String? fileName;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, status, fileName];
}

class TrackingStep extends Equatable {
  const TrackingStep({
    required this.code,
    required this.labelKey,
    required this.done,
    this.at,
    this.note,
  });

  final String code; // ACCEPTED | PICKED_UP | IN_TRANSIT | DELIVERED
  final String labelKey;
  final bool done;
  final DateTime? at;
  final String? note;

  @override
  List<Object?> get props => [code, done, at];
}

class ShipmentTrack extends Equatable {
  const ShipmentTrack({
    required this.id,
    required this.matchId,
    required this.loadId,
    required this.title,
    required this.route,
    required this.steps,
    required this.paymentStatus,
    required this.agreedAmount,
    required this.currency,
    this.cmrPhotoName,
    this.escrowHeld = true,
  });

  final String id;
  final String matchId;
  final String loadId;
  final String title;
  final String route;
  final List<TrackingStep> steps;
  final String paymentStatus; // PENDING | HELD | RELEASED | PAID
  final double agreedAmount;
  final String currency;
  final String? cmrPhotoName;
  final bool escrowHeld;

  String get currentCode {
    for (var i = steps.length - 1; i >= 0; i--) {
      if (steps[i].done) return steps[i].code;
    }
    return steps.first.code;
  }

  @override
  List<Object?> get props => [id, steps, paymentStatus, cmrPhotoName];
}

class TeamMember extends Equatable {
  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.active = true,
  });

  final String id;
  final String name;
  final String role; // DISPATCHER | DRIVER | ADMIN
  final String email;
  final bool active;

  @override
  List<Object?> get props => [id, role, active];
}

class FleetVehicle extends Equatable {
  const FleetVehicle({
    required this.id,
    required this.plate,
    required this.type,
    required this.capacityKg,
    required this.status,
    required this.docStatus,
    this.driverName,
    this.availableHours,
  });

  final String id;
  final String plate;
  final String type;
  final double capacityKg;
  final String status;
  final String docStatus;
  final String? driverName;
  final int? availableHours;

  FleetVehicle copyWith({String? driverName, String? status, int? availableHours}) {
    return FleetVehicle(
      id: id,
      plate: plate,
      type: type,
      capacityKg: capacityKg,
      status: status ?? this.status,
      docStatus: docStatus,
      driverName: driverName ?? this.driverName,
      availableHours: availableHours ?? this.availableHours,
    );
  }

  @override
  List<Object?> get props => [id, status, docStatus, driverName];
}

class CorridorSubscription extends Equatable {
  const CorridorSubscription({
    required this.corridorId,
    required this.label,
    required this.active,
    this.minAcceptPrice,
  });

  final String corridorId;
  final String label;
  final bool active;
  final double? minAcceptPrice;

  CorridorSubscription copyWith({bool? active, double? minAcceptPrice}) {
    return CorridorSubscription(
      corridorId: corridorId,
      label: label,
      active: active ?? this.active,
      minAcceptPrice: minAcceptPrice ?? this.minAcceptPrice,
    );
  }

  @override
  List<Object?> get props => [corridorId, active, minAcceptPrice];
}

class BackhaulSuggestion extends Equatable {
  const BackhaulSuggestion({
    required this.id,
    required this.loadId,
    required this.title,
    required this.route,
    required this.reason,
    required this.matchScore,
  });

  final String id;
  final String loadId;
  final String title;
  final String route;
  final String reason;
  final int matchScore;

  @override
  List<Object?> get props => [id];
}
