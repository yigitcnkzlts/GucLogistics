enum UserRole {
  shipper,
  logisticsCompany,
  independentDriver,
  fleetOwner;

  bool get isShipperSide =>
      this == UserRole.shipper || this == UserRole.logisticsCompany;

  bool get isDriverSide =>
      this == UserRole.independentDriver || this == UserRole.fleetOwner;

  String get apiValue => switch (this) {
        UserRole.shipper => 'SHIPPER',
        UserRole.logisticsCompany => 'LOGISTICS_COMPANY',
        UserRole.independentDriver => 'INDEPENDENT_DRIVER',
        UserRole.fleetOwner => 'FLEET_OWNER',
      };

  static UserRole? fromApi(String? value) {
    return switch (value) {
      'SHIPPER' => UserRole.shipper,
      'LOGISTICS_COMPANY' => UserRole.logisticsCompany,
      'INDEPENDENT_DRIVER' => UserRole.independentDriver,
      'FLEET_OWNER' => UserRole.fleetOwner,
      _ => null,
    };
  }
}
