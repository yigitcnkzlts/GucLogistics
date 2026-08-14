import '../../domain/models.dart';
import '../../domain/ops_models.dart';

class MockData {
  static String companyName = 'Alpine Freight GmbH';
  static bool companyVerified = true;
  static String companyVat = 'DE123456789';
  static String companyHq = 'Munich, DE';
  static String driverDisplayName = 'Jonas Weber';
  static bool driverVerified = true;
  static String driverLicense = 'C+E';
  static String driverExperience = '8';
  static String driverBase = 'Berlin, DE';
  static String driverPhone = '+49 170 111 2233';
  static String shipperPhone = '+49 89 000 1122';
  static String carrierCompanyName = 'Nordic Haulage';
  static CarrierAvailability carrierAvailability = const CarrierAvailability();
  static final earnings = <EarningsEntry>[
    EarningsEntry(
      id: 'earn-1',
      matchId: 'match-1',
      title: 'Machinery · Milano to Wien',
      route: 'Milan → Vienna',
      amount: 20000,
      currency: 'TRY',
      at: DateTime.now().subtract(const Duration(days: 22)),
      status: 'CREDITED',
    ),
    EarningsEntry(
      id: 'earn-2',
      matchId: 'match-hist-2',
      title: 'FMCG · Rotterdam to Warsaw',
      route: 'Rotterdam → Warsaw',
      amount: 20000,
      currency: 'TRY',
      at: DateTime.now().subtract(const Duration(days: 12)),
      status: 'CREDITED',
    ),
    EarningsEntry(
      id: 'earn-3',
      matchId: 'match-hist-3',
      title: 'Steel · Berlin to Antwerp',
      route: 'Berlin → Antwerp',
      amount: 20000,
      currency: 'TRY',
      at: DateTime.now().subtract(const Duration(days: 3)),
      status: 'CREDITED',
    ),
  ];
  static double get earningsBalanceTry =>
      earnings.where((e) => e.status == 'CREDITED' || e.status == 'PAID').fold<double>(0, (a, b) => a + (b.currency == 'TRY' ? b.amount : b.amount * 36));
  static final verificationUploads = <String, String>{
    'identity': 'APPROVED',
    'business': 'APPROVED',
    'tax': 'PENDING',
    'insurance': 'MISSING',
  };
  static String invoiceEmail = 'billing@alpinefreight.de';
  static String billingVat = companyVat;
  /// Logged-in carrier identity used by marketplace favorites-only filtering.
  static String currentCarrierId = 'car-1';
  static String contractTemplate = 'Standard EU freight match agreement v1';
  static String? erpEndpoint;
  static final ratings = <DeliveryRating>[];
  static DispatcherPermissions dispatcherPermissions = const DispatcherPermissions();
  static String invoiceLocale = 'en';
  static bool contractSigned = false;
  static DateTime? contractSignedAt;
  static double? lastDriverLat;
  static double? lastDriverLng;
  static DateTime? lastDriverLocationAt;
  static final claims = <DisputeClaim>[
    DisputeClaim(
      id: 'claim-1',
      loadId: 'load-3',
      matchId: 'match-1',
      type: 'DELAY',
      title: 'Transit delay near Innsbruck',
      status: 'OPEN',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      details: 'ETA slipped by 4 hours. Waiting for CMR.',
      amount: 150,
    ),
  ];
  static final ledger = <PaymentLedgerEntry>[
    PaymentLedgerEntry(
      id: 'led-1',
      shipmentId: 'ship-1',
      label: 'Escrow hold on match',
      amount: 2050,
      currency: 'EUR',
      kind: 'HOLD',
      at: DateTime.now().subtract(const Duration(hours: 20)),
    ),
    PaymentLedgerEntry(
      id: 'led-2',
      shipmentId: 'ship-1',
      label: 'Platform fee reserved',
      amount: 61.5,
      currency: 'EUR',
      kind: 'FEE',
      at: DateTime.now().subtract(const Duration(hours: 20)),
    ),
  ];
  static final cityLatLng = <String, List<double>>{
    'Munich': [48.137, 11.575],
    'Lyon': [45.764, 4.835],
    'Rotterdam': [51.922, 4.479],
    'Warsaw': [52.229, 21.012],
    'Milan': [45.464, 9.190],
    'Vienna': [48.208, 16.373],
    'Istanbul': [41.008, 28.978],
    'Sofia': [42.697, 23.321],
    'Prague': [50.075, 14.437],
    'Budapest': [47.497, 19.040],
    'Berlin': [52.520, 13.405],
    'Antwerp': [51.219, 4.402],
    'Bergen': [60.391, 5.322],
  };
  static final routeTemplates = <RouteTemplate>[
    const RouteTemplate(
      id: 'tpl-1',
      name: 'Munich → Lyon weekly',
      factoryName: 'BMW Logistics Plant',
      pickupCity: 'Munich',
      pickupCountry: 'DE',
      dropoffCity: 'Lyon',
      dropoffCountry: 'FR',
      loadType: 'Palletized',
      weightTons: 8.2,
      vehicleType: 'Curtain trailer',
      doorRamp: 'Dock B2',
      contactPerson: 'Anna Keller',
      contactPhone: '+49 89 000 1122',
      forklift: true,
    ),
    const RouteTemplate(
      id: 'tpl-2',
      name: 'Rotterdam → Warsaw FMCG',
      factoryName: 'Unilever DC Rotterdam',
      pickupCity: 'Rotterdam',
      pickupCountry: 'NL',
      dropoffCity: 'Warsaw',
      dropoffCountry: 'PL',
      loadType: 'Mixed',
      weightTons: 12.4,
      vehicleType: 'Box truck 18t',
      doorRamp: 'Gate 4',
      contactPerson: 'Pieter de Vries',
      contactPhone: '+31 10 000 3344',
      coldChain: true,
      tailLift: true,
    ),
  ];

  static final loads = <LoadItem>[
    LoadItem(
      id: 'load-1',
      title: 'Automotive parts · Munich to Lyon',
      loadType: 'Palletized',
      pickupCountry: 'DE',
      pickupCity: 'Munich',
      pickupRegion: 'Bavaria',
      dropoffCountry: 'FR',
      dropoffCity: 'Lyon',
      weightKg: 8200,
      vehicleType: 'Curtain trailer',
      loadDate: DateTime.now().add(const Duration(days: 2)).copyWith(hour: 8, minute: 0),
      deliveryDate: DateTime.now().add(const Duration(days: 4)).copyWith(hour: 17, minute: 0),
      status: 'PUBLISHED',
      currency: 'EUR',
      price: 1450,
      companyVerified: true,
      matchScore: 92,
      description: 'Temperature-neutral automotive components. Loading dock available from 08:00.',
      factoryName: 'BMW Logistics Plant',
      companyName: 'Alpine Freight GmbH',
      contactPhone: '+49 89 000 1122',
      contactPerson: 'Anna Keller',
      doorRamp: 'Dock B2',
      referenceNo: 'REF-BMW-441',
      forklift: true,
      palletCount: 22,
    ),
    LoadItem(
      id: 'load-2',
      title: 'Retail FMCG · Rotterdam to Warsaw',
      loadType: 'Mixed',
      pickupCountry: 'NL',
      pickupCity: 'Rotterdam',
      pickupRegion: 'South Holland',
      dropoffCountry: 'PL',
      dropoffCity: 'Warsaw',
      weightKg: 12400,
      vehicleType: 'Box truck 18t',
      loadDate: DateTime.now().add(const Duration(days: 1)).copyWith(hour: 9, minute: 30),
      deliveryDate: DateTime.now().add(const Duration(days: 3)).copyWith(hour: 16, minute: 0),
      status: 'PUBLISHED',
      currency: 'EUR',
      price: 1680,
      companyVerified: true,
      matchScore: 84,
      description: 'Mixed retail pallets. ADR not required.',
      factoryName: 'Unilever DC Rotterdam',
      companyName: 'Benelux Retail Logistics BV',
      contactPhone: '+31 10 000 3344',
      contactPerson: 'Pieter de Vries',
      doorRamp: 'Gate 4',
      referenceNo: 'REF-UNI-902',
      coldChain: true,
      tailLift: true,
      palletCount: 30,
    ),
    LoadItem(
      id: 'load-3',
      title: 'Machinery · Milano to Wien',
      loadType: 'Oversized',
      pickupCountry: 'IT',
      pickupCity: 'Milan',
      pickupRegion: 'Lombardy',
      dropoffCountry: 'AT',
      dropoffCity: 'Vienna',
      weightKg: 15600,
      vehicleType: 'Lowbed',
      loadDate: DateTime.now().add(const Duration(days: 5)).copyWith(hour: 7, minute: 0),
      deliveryDate: DateTime.now().add(const Duration(days: 7)).copyWith(hour: 18, minute: 0),
      status: 'MATCHED',
      currency: 'EUR',
      price: 2100,
      companyVerified: true,
      offerStatus: 'ACCEPTED',
      matchId: 'match-1',
      matchScore: 96,
      description: 'Escort may be required at pickup.',
      factoryName: 'Milan Heavy Works',
      companyName: 'ItalPlant SpA',
      contactPhone: '+39 02 000 5566',
    ),
    LoadItem(
      id: 'load-4',
      title: 'Packaging · Istanbul to Sofia',
      loadType: 'General',
      pickupCountry: 'TR',
      pickupCity: 'Istanbul',
      pickupRegion: 'Marmara',
      dropoffCountry: 'BG',
      dropoffCity: 'Sofia',
      weightKg: 9600,
      vehicleType: 'Tautliner',
      loadDate: DateTime.now().add(const Duration(days: 3)).copyWith(hour: 10, minute: 0),
      deliveryDate: DateTime.now().add(const Duration(days: 5)).copyWith(hour: 14, minute: 0),
      status: 'PUBLISHED',
      currency: 'EUR',
      price: 980,
      companyVerified: true,
      matchScore: 78,
      factoryName: 'Anadolu Pack Factory',
      companyName: 'Anadolu Pack A.Ş.',
      contactPhone: '+90 212 000 7788',
      favoritesOnly: true,
      offerSlaHours: 2,
      photos: const ['packaging_dock.jpg'],
      adr: true,
    ),
    LoadItem(
      id: 'load-5',
      title: 'Electronics · Prague to Budapest',
      loadType: 'Palletized',
      pickupCountry: 'CZ',
      pickupCity: 'Prague',
      pickupRegion: 'Prague',
      dropoffCountry: 'HU',
      dropoffCity: 'Budapest',
      weightKg: 5400,
      vehicleType: 'Box truck 12t',
      loadDate: DateTime.now().subtract(const Duration(days: 8)),
      deliveryDate: DateTime.now().subtract(const Duration(days: 6)),
      status: 'COMPLETED',
      currency: 'EUR',
      price: 720,
      companyVerified: true,
      matchScore: 88,
      factoryName: 'Prague Tech Hub',
      companyName: 'Central EU Electronics s.r.o.',
      contactPhone: '+420 2 000 9900',
    ),
    LoadItem(
      id: 'load-6',
      title: 'Steel coils · Berlin to Antwerp',
      loadType: 'Industrial',
      pickupCountry: 'DE',
      pickupCity: 'Berlin',
      pickupRegion: 'Berlin',
      dropoffCountry: 'BE',
      dropoffCity: 'Antwerp',
      weightKg: 18000,
      vehicleType: 'Flatbed',
      loadDate: DateTime.now().add(const Duration(days: 2)).copyWith(hour: 11, minute: 0),
      deliveryDate: DateTime.now().add(const Duration(days: 3)).copyWith(hour: 18, minute: 0),
      status: 'PUBLISHED',
      currency: 'EUR',
      price: 1550,
      companyVerified: true,
      matchScore: 81,
      description: 'Coil cradles required. Factory gate booking mandatory.',
      factoryName: 'Spree Steel Works',
      companyName: 'NordOst Stahl AG',
      contactPhone: '+49 30 000 2211',
      contactPerson: 'Markus Vogel',
      doorRamp: 'Gate A1',
      palletCount: 0,
    ),
    LoadItem(
      id: 'load-7',
      title: 'Seafood coldchain · Bergen to Antwerp',
      loadType: 'Cold chain',
      pickupCountry: 'NO',
      pickupCity: 'Bergen',
      pickupRegion: 'Vestland',
      dropoffCountry: 'BE',
      dropoffCity: 'Antwerp',
      weightKg: 11000,
      vehicleType: 'Reefer trailer',
      loadDate: DateTime.now().add(const Duration(days: 4)).copyWith(hour: 6, minute: 0),
      deliveryDate: DateTime.now().add(const Duration(days: 6)).copyWith(hour: 20, minute: 0),
      status: 'PUBLISHED',
      currency: 'EUR',
      price: 3200,
      companyVerified: true,
      matchScore: 90,
      description: 'Pickup from Vestland district warehouse. Keep -18C. Phone for gate code after match.',
      factoryName: 'NordFjord Seafood Hub',
      companyName: 'Fjord Export AS',
      contactPhone: '+47 55 000 441',
      contactPerson: 'Ingrid Holm',
      coldChain: true,
      palletCount: 26,
      offerSlaHours: 6,
    ),
  ];

  static final offers = <OfferItem>[
    OfferItem(
      id: 'offer-1',
      loadId: 'load-1',
      amount: 1380,
      currency: 'EUR',
      status: 'PENDING',
      loadTitle: 'Automotive parts · Munich to Lyon',
      message: 'Ready tomorrow morning',
      carrierName: carrierCompanyName,
      carrierId: 'car-1',
      transitHours: 28,
      trustScore: 4.8,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      expiresAt: DateTime.now().add(const Duration(hours: 21)),
      rounds: [
        OfferRound(
          amount: 1380,
          currency: 'EUR',
          byRole: 'CARRIER',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          message: 'Ready tomorrow morning',
        ),
      ],
    ),
    OfferItem(
      id: 'offer-2',
      loadId: 'load-2',
      amount: 1600,
      currency: 'EUR',
      status: 'COUNTERED',
      loadTitle: 'Retail FMCG · Rotterdam to Warsaw',
      message: 'Can do 1,720 if loading stays morning',
      carrierName: 'Baltic Fleet',
      carrierId: 'car-2',
      transitHours: 36,
      trustScore: 4.6,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      expiresAt: DateTime.now().add(const Duration(hours: 16)),
      rounds: [
        OfferRound(
          amount: 1600,
          currency: 'EUR',
          byRole: 'CARRIER',
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
          message: 'Initial offer',
        ),
        OfferRound(
          amount: 1720,
          currency: 'EUR',
          byRole: 'SHIPPER',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          message: 'Budget is higher — can you meet 1,720?',
        ),
      ],
    ),
    OfferItem(
      id: 'offer-3',
      loadId: 'load-3',
      amount: 2050,
      currency: 'EUR',
      status: 'ACCEPTED',
      loadTitle: 'Machinery · Milano to Wien',
      message: 'Lowbed confirmed',
      carrierName: driverDisplayName,
      matchId: 'match-1',
      carrierId: 'car-3',
      transitHours: 40,
      trustScore: 4.9,
      rounds: [
        OfferRound(
          amount: 2050,
          currency: 'EUR',
          byRole: 'CARRIER',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          message: 'Lowbed confirmed',
        ),
      ],
    ),
  ];

  static final matches = <MatchThread>[
    MatchThread(
      id: 'match-1',
      loadId: 'load-3',
      offerId: 'offer-3',
      loadTitle: 'Machinery · Milano to Wien',
      agreedAmount: 2050,
      currency: 'EUR',
      shipperName: companyName,
      carrierName: driverDisplayName,
      createdAt: DateTime.now().subtract(const Duration(hours: 20)),
      shipperPhone: shipperPhone,
      carrierPhone: driverPhone,
      routeLabel: 'Milan → Vienna',
    ),
  ];

  static final messages = <ChatMessage>[
    ChatMessage(
      id: 'msg-1',
      matchId: 'match-1',
      senderRole: 'SHIPPER',
      body: 'Match confirmed. Loading address will be shared tomorrow morning.',
      createdAt: DateTime.now().subtract(const Duration(hours: 19)),
    ),
    ChatMessage(
      id: 'msg-2',
      matchId: 'match-1',
      senderRole: 'CARRIER',
      body: 'Understood. Lowbed arrives at 07:30. Please confirm dock number.',
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
    ),
    ChatMessage(
      id: 'msg-3',
      matchId: 'match-1',
      senderRole: 'SHIPPER',
      body: 'Dock B2. Contact on site: +49 170 000000.',
      createdAt: DateTime.now().subtract(const Duration(hours: 17)),
    ),
  ];

  static final vehicles = <VehicleItem>[
    const VehicleItem(id: 'veh-1', plate: 'B-GL 4421', type: 'Curtain trailer', capacityKg: 24000, status: 'ACTIVE'),
    const VehicleItem(id: 'veh-2', plate: 'M-TR 1188', type: 'Box truck 12t', capacityKg: 12000, status: 'ACTIVE'),
  ];

  static final notifications = <NotificationItem>[
    NotificationItem(id: 'n1', title: 'New offer received', body: 'A carrier offered €1,380 on Munich → Lyon.', createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    NotificationItem(id: 'n2', title: 'Counter-offer sent', body: 'You proposed €1,720 on Rotterdam → Warsaw.', createdAt: DateTime.now().subtract(const Duration(hours: 5))),
    NotificationItem(id: 'n3', title: 'Match confirmed', body: 'Machinery Milano → Wien is matched. Open the conversation.', createdAt: DateTime.now().subtract(const Duration(hours: 20))),
    NotificationItem(id: 'n4', title: 'Load matches you', body: 'DE → FR curtain trailer load near Munich fits your vehicle and min price.', createdAt: DateTime.now().subtract(const Duration(minutes: 40))),
    NotificationItem(id: 'n5', title: 'Backhaul opportunity', body: 'Istanbul → Sofia can fill your return after Vienna.', createdAt: DateTime.now().subtract(const Duration(hours: 3))),
  ];

  static const corridors = <CorridorPreset>[
    CorridorPreset(id: 'de-fr', label: 'DE → FR', fromCountries: ['DE'], toCountries: ['FR']),
    CorridorPreset(id: 'nl-pl', label: 'NL → PL', fromCountries: ['NL'], toCountries: ['PL']),
    CorridorPreset(id: 'tr-eu', label: 'TR → EU', fromCountries: ['TR'], toCountries: ['BG', 'DE', 'FR', 'PL', 'AT', 'HU', 'CZ', 'IT']),
    CorridorPreset(id: 'benelux', label: 'Benelux', fromCountries: ['NL', 'BE', 'LU'], toCountries: ['DE', 'FR', 'PL', 'IT', 'AT']),
    CorridorPreset(id: 'it-at', label: 'IT → AT', fromCountries: ['IT'], toCountries: ['AT']),
    CorridorPreset(id: 'cz-hu', label: 'CZ → HU', fromCountries: ['CZ'], toCountries: ['HU']),
    CorridorPreset(id: 'all-eu', label: 'All Europe', fromCountries: const [], toCountries: const []),
  ];

  static const priceBands = <MarketPriceBand>[
    MarketPriceBand(corridorId: 'de-fr', minEur: 1200, maxEur: 1650, avgEur: 1450),
    MarketPriceBand(corridorId: 'nl-pl', minEur: 1400, maxEur: 1900, avgEur: 1680),
    MarketPriceBand(corridorId: 'tr-eu', minEur: 800, maxEur: 1400, avgEur: 1050),
    MarketPriceBand(corridorId: 'benelux', minEur: 900, maxEur: 1600, avgEur: 1250),
    MarketPriceBand(corridorId: 'it-at', minEur: 1700, maxEur: 2400, avgEur: 2100),
    MarketPriceBand(corridorId: 'cz-hu', minEur: 550, maxEur: 900, avgEur: 720),
    MarketPriceBand(corridorId: 'all-eu', minEur: 700, maxEur: 2200, avgEur: 1400),
  ];

  static final carriers = <CarrierListing>[
    const CarrierListing(
      id: 'car-1',
      name: 'Nordic Haulage',
      baseCountry: 'DE',
      baseCity: 'Berlin',
      vehicleType: 'Curtain trailer',
      capacityKg: 24000,
      verified: true,
      trust: TrustStats(rating: 4.8, completedJobs: 214, onTimeRate: 0.96, delayRate: 0.04),
      corridors: ['de-fr', 'benelux', 'nl-pl'],
      availableHours: 36,
      mapX: 0.45,
      mapY: 0.32,
      plate: 'B-GL 4421',
      matchScore: 94,
    ),
    const CarrierListing(
      id: 'car-2',
      name: 'Baltic Fleet',
      baseCountry: 'PL',
      baseCity: 'Warsaw',
      vehicleType: 'Box truck 18t',
      capacityKg: 18000,
      verified: true,
      trust: TrustStats(rating: 4.6, completedJobs: 168, onTimeRate: 0.93, delayRate: 0.07),
      corridors: ['nl-pl', 'cz-hu', 'benelux'],
      availableHours: 18,
      mapX: 0.58,
      mapY: 0.35,
      plate: 'WA-88421',
      matchScore: 88,
    ),
    const CarrierListing(
      id: 'car-3',
      name: 'Jonas Weber',
      baseCountry: 'DE',
      baseCity: 'Munich',
      vehicleType: 'Lowbed',
      capacityKg: 28000,
      verified: true,
      trust: TrustStats(rating: 4.9, completedJobs: 96, onTimeRate: 0.98, delayRate: 0.02),
      corridors: ['it-at', 'de-fr'],
      availableHours: 48,
      mapX: 0.42,
      mapY: 0.45,
      plate: 'M-TR 1188',
      matchScore: 96,
    ),
    const CarrierListing(
      id: 'car-4',
      name: 'Anadolu Transit',
      baseCountry: 'TR',
      baseCity: 'Istanbul',
      vehicleType: 'Tautliner',
      capacityKg: 24000,
      verified: false,
      trust: TrustStats(rating: 4.3, completedJobs: 71, onTimeRate: 0.89, delayRate: 0.11),
      corridors: ['tr-eu'],
      availableHours: 12,
      mapX: 0.72,
      mapY: 0.58,
      plate: '34 AT 1907',
      matchScore: 81,
    ),
    const CarrierListing(
      id: 'car-5',
      name: 'Rhine Logistics BV',
      baseCountry: 'NL',
      baseCity: 'Rotterdam',
      vehicleType: 'Box truck 12t',
      capacityKg: 12000,
      verified: true,
      trust: TrustStats(rating: 4.7, completedJobs: 302, onTimeRate: 0.95, delayRate: 0.05),
      corridors: ['benelux', 'nl-pl', 'de-fr'],
      availableHours: 8,
      mapX: 0.30,
      mapY: 0.30,
      plate: 'NL-77-XH',
      matchScore: 90,
    ),
  ];

  static const cityPins = <String, List<double>>{
    'Munich': [0.42, 0.45],
    'Lyon': [0.35, 0.52],
    'Rotterdam': [0.30, 0.30],
    'Warsaw': [0.58, 0.35],
    'Milan': [0.40, 0.55],
    'Vienna': [0.50, 0.48],
    'Istanbul': [0.72, 0.58],
    'Sofia': [0.62, 0.55],
    'Prague': [0.48, 0.38],
    'Budapest': [0.55, 0.48],
    'Berlin': [0.45, 0.32],
    'Antwerp': [0.28, 0.34],
    'Bergen': [0.42, 0.12],
  };

  static final documents = <DocItem>[
    DocItem(id: 'doc-1', type: 'ID', title: 'Identity document', status: 'APPROVED', fileName: 'id_card.pdf', updatedAt: DateTime.now().subtract(const Duration(days: 20))),
    DocItem(id: 'doc-2', type: 'LICENSE', title: 'Driver license C+E', status: 'APPROVED', fileName: 'license.pdf', updatedAt: DateTime.now().subtract(const Duration(days: 12))),
    DocItem(id: 'doc-3', type: 'INSURANCE', title: 'Cargo insurance', status: 'PENDING', fileName: 'insurance.pdf', updatedAt: DateTime.now().subtract(const Duration(days: 1))),
    DocItem(id: 'doc-4', type: 'K1', title: 'Vehicle registration (K1)', status: 'MISSING'),
    DocItem(id: 'doc-5', type: 'CMR', title: 'CMR insurance certificate', status: 'APPROVED', fileName: 'cmr.pdf', updatedAt: DateTime.now().subtract(const Duration(days: 40))),
  ];

  static final shipments = <ShipmentTrack>[
    ShipmentTrack(
      id: 'ship-1',
      matchId: 'match-1',
      loadId: 'load-3',
      title: 'Machinery · Milano to Wien',
      route: 'Milan → Vienna',
      agreedAmount: 2050,
      currency: 'EUR',
      paymentStatus: 'HELD',
      escrowHeld: true,
      cmrPhotoName: null,
      steps: [
        TrackingStep(code: 'ACCEPTED', labelKey: 'trackAccepted', done: true, at: DateTime.now().subtract(const Duration(hours: 20))),
        TrackingStep(code: 'PICKED_UP', labelKey: 'trackPickedUp', done: true, at: DateTime.now().subtract(const Duration(hours: 6)), note: 'Dock B2'),
        TrackingStep(code: 'IN_TRANSIT', labelKey: 'trackInTransit', done: true, at: DateTime.now().subtract(const Duration(hours: 4))),
        TrackingStep(code: 'DELIVERED', labelKey: 'trackDelivered', done: false),
      ],
    ),
  ];

  static final team = <TeamMember>[
    const TeamMember(id: 'tm-1', name: 'Elena Vogel', role: 'ADMIN', email: 'elena@alpinefreight.de'),
    const TeamMember(id: 'tm-2', name: 'Marco Rossi', role: 'DISPATCHER', email: 'marco@alpinefreight.de'),
    const TeamMember(id: 'tm-3', name: 'Jonas Weber', role: 'DRIVER', email: 'jonas@nordichaulage.de'),
  ];

  static final fleet = <FleetVehicle>[
    const FleetVehicle(id: 'fv-1', plate: 'B-GL 4421', type: 'Curtain trailer', capacityKg: 24000, status: 'ACTIVE', docStatus: 'APPROVED', driverName: 'Jonas Weber', availableHours: 36),
    const FleetVehicle(id: 'fv-2', plate: 'M-TR 1188', type: 'Lowbed', capacityKg: 28000, status: 'IN_TRANSIT', docStatus: 'PENDING', driverName: 'Jonas Weber', availableHours: 0),
    const FleetVehicle(id: 'fv-3', plate: 'HH-90 KL', type: 'Box truck 12t', capacityKg: 12000, status: 'ACTIVE', docStatus: 'MISSING', availableHours: 48),
  ];

  static final subscriptions = <CorridorSubscription>[
    const CorridorSubscription(corridorId: 'de-fr', label: 'DE → FR', active: true, minAcceptPrice: 1300),
    const CorridorSubscription(corridorId: 'nl-pl', label: 'NL → PL', active: true, minAcceptPrice: 1550),
    const CorridorSubscription(corridorId: 'tr-eu', label: 'TR → EU', active: false, minAcceptPrice: 900),
  ];

  static final backhauls = <BackhaulSuggestion>[
    const BackhaulSuggestion(
      id: 'bh-1',
      loadId: 'load-4',
      title: 'Packaging · Istanbul to Sofia',
      route: 'Istanbul → Sofia',
      reason: 'Backhaul after Vienna delivery corridor',
      matchScore: 86,
    ),
    const BackhaulSuggestion(
      id: 'bh-2',
      loadId: 'load-1',
      title: 'Automotive parts · Munich to Lyon',
      route: 'Munich → Lyon',
      reason: 'Vehicle type and schedule match',
      matchScore: 92,
    ),
  ];
}
