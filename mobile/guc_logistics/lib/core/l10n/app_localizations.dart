import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('tr'),
    Locale('de'),
    Locale('pl'),
    Locale('fr'),
  ];
  static const LocalizationsDelegate<AppLocalizations> delegate = _Delegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static final Map<String, Map<String, String>> _t = {
    'en': {
      'appTitle': 'GucLogistics',
      'tagline': 'European freight, matched with confidence',
      'splashLoading': 'Preparing your workspace…',
      'onboarding1Title': 'Ship with clarity',
      'onboarding1Body': 'Publish freight and receive competitive offers from verified carriers.',
      'onboarding2Title': 'Drive with opportunity',
      'onboarding2Body': 'Discover loads across Europe that match your vehicle and schedule.',
      'onboarding3Title': 'Built for trust',
      'onboarding3Body': 'Verification, secure sessions, and transparent offer workflows.',
      'continueLabel': 'Continue',
      'getStarted': 'Get started',
      'skip': 'Skip',
      'login': 'Sign in',
      'register': 'Create account',
      'forgotPassword': 'Forgot password',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm password',
      'sendResetLink': 'Send reset link',
      'resetSent': 'If the account exists, a reset link has been sent.',
      'roleTitle': 'Select your role',
      'roleSubtitle': 'We will tailor the workspace to how you operate.',
      'roleShipper': 'Shipper company',
      'roleLogistics': 'Logistics company',
      'roleDriver': 'Independent driver',
      'roleFleet': 'Fleet owner',
      'home': 'Home',
      'loads': 'Loads',
      'myLoads': 'My loads',
      'offers': 'Offers',
      'myOffers': 'My offers',
      'profile': 'Profile',
      'settings': 'Settings',
      'notifications': 'Notifications',
      'language': 'Language',
      'theme': 'Theme',
      'themeSystem': 'System',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'logout': 'Sign out',
      'activeLoads': 'Active loads',
      'pendingOffers': 'Pending offers',
      'completedShipments': 'Completed',
      'createLoad': 'Create load',
      'recentLoads': 'Recently published loads',
      'recentOffers': 'Latest incoming offers',
      'welcomeBack': 'Welcome back',
      'homeShipperSubtitle': 'Publish freight and review carrier offers.',
      'homeDriverSubtitle': 'Find matching freight and manage your offers.',
      'seeAll': 'See all',
      'verifiedCompany': 'Verified company',
      'verifiedDriver': 'Verified driver',
      'verificationPending': 'Verification pending',
      'verificationBodyPending': 'Identity and business documents are under review. You can continue browsing while verification completes.',
      'verificationBodyVerified': 'Your account is verified. Partners can trust your profile across the marketplace.',
      'companyNameLabel': 'Company',
      'vatLabel': 'VAT',
      'hqLabel': 'Headquarters',
      'licenseLabel': 'License',
      'experienceLabel': 'Experience',
      'baseLabel': 'Base',
      'years': 'years',
      'statusPublished': 'Published',
      'statusMatched': 'Matched',
      'statusCompleted': 'Completed',
      'statusPending': 'Pending',
      'statusAccepted': 'Accepted',
      'statusRejected': 'Rejected',
      'statusActive': 'Active',
      'saved': 'Saved',
      'browseLoads': 'Browse loads',
      'expectedPrice': 'Expected price',
      'negotiation': 'Negotiation',
      'counterOffer': 'Counter offer',
      'openNegotiation': 'Open negotiation',
      'offerRoom': 'Offer room',
      'matchChat': 'Match conversation',
      'matched': 'Matched',
      'openChat': 'Open chat',
      'sendMessage': 'Send',
      'typeMessage': 'Type a message',
      'matchScore': 'Match score',
      'agreedPrice': 'Agreed price',
      'carrier': 'Carrier',
      'shipper': 'Shipper',
      'yourCounter': 'Your counter offer',
      'rounds': 'Offer rounds',
      'acceptAndMatch': 'Accept & match',
      'statusCountered': 'Countered',
      'matchingHint': 'Carriers can bid above or below your expected price. You can counter until both sides agree.',
      'chatEmpty': 'No messages yet. Coordinate loading details here after the match.',
      'publishLoad': 'Publish load',
      'europeMarket': 'Europe market',
      'marketShipperSubtitle': 'Discover verified carriers across Europe. Filter by corridor and availability.',
      'marketDriverSubtitle': 'Browse freight across Europe. Filter corridors and bid with confidence.',
      'corridors': 'Corridors',
      'favoriteCorridors': 'Favorite corridors',
      'marketPriceBand': 'Market price band',
      'avg': 'avg',
      'europeMap': 'Europe overview',
      'availableCarriers': 'Available carriers',
      'completedJobs': 'jobs',
      'trustScore': 'Trust score',
      'onTimeRate': 'On-time rate',
      'delayRate': 'Delay rate',
      'liveAvailability': 'Live availability',
      'verifiedCarrier': 'Verified carrier',
      'availableHoursLabel': 'Available',
      'operations': 'Operations',
      'operationsSubtitle': 'Tracking, documents, fleet, payments and corridor alerts.',
      'shipmentTracking': 'Shipment tracking',
      'shipmentTrackingHint': 'Pickup → transit → delivery',
      'documents': 'Documents',
      'documentsHint': 'License, insurance, K1, CMR',
      'agreementsPayments': 'Agreements & payments',
      'agreementsPaymentsHint': 'Escrow, invoice and release',
      'fleetPanel': 'Fleet panel',
      'fleetPanelHint': 'Vehicles, drivers and docs',
      'team': 'Team',
      'teamHint': 'Dispatchers and drivers',
      'corridorAlerts': 'Corridor alerts',
      'corridorAlertsHint': 'Subscriptions and min price',
      'backhaul': 'Backhaul suggestions',
      'backhaulHint': 'Return loads on your route',
      'uploadDocument': 'Upload document',
      'replaceDocument': 'Replace document',
      'cmrPhoto': 'CMR / delivery photo',
      'uploadCmrPhoto': 'Upload CMR photo',
      'advanceStatus': 'Advance status',
      'agreementSummary': 'Agreement summary',
      'escrowHeld': 'Payment held in escrow',
      'escrowHint': 'Funds stay protected until delivery confirmation.',
      'markPaid': 'Mark as paid',
      'route': 'Route',
      'minAcceptPrice': 'Minimum accept price',
      'editMinPrice': 'Edit min price',
      'corridorAlertHint': 'Get notified when matching loads appear',
      'driver': 'Driver',
      'trackAccepted': 'Accepted',
      'trackPickedUp': 'Picked up',
      'trackInTransit': 'In transit',
      'trackDelivered': 'Delivered',
      'docMissing': 'Missing',
      'docPending': 'Under review',
      'docApproved': 'Approved',
      'docRejected': 'Rejected',
      'payPending': 'Payment pending',
      'payHeld': 'Held',
      'payReleased': 'Released',
      'payPaid': 'Paid',
      'roleAdmin': 'Admin',
      'roleDispatcher': 'Dispatcher',
      'roleDriverMember': 'Driver',
      'continueWithGoogle': 'Continue with Google',
      'continueWithApple': 'Continue with Apple',
      'orContinueWith': 'or continue with',
      'chooseAccountType': 'How will you use GucLogistics?',
      'chooseAccountTypeHint': 'Shippers and carriers get different workspaces.',
      'shipperGateTitle': 'I ship freight',
      'shipperGateBody': 'Publish loads, review offers, track deliveries.',
      'carrierGateTitle': 'Find loads',
      'carrierGateBody': 'Browse Europe & Türkiye freight, bid, match, call shippers and grow your wallet.',
      'findLoads': 'Find loads',
      'findLoadsSubtitle': 'Country → region → city filters across Europe and Türkiye. Bid, match, then call or SMS.',
      'earningsWallet': 'Earnings wallet',
      'walletBalance': 'Accumulated balance',
      'thisMonth': 'This month',
      'earningsHint': 'When a job is matched, the agreed amount is credited here automatically (demo). Older jobs stay in history.',
      'jobHistory': 'Job history',
      'myAvailability': 'My availability',
      'availableForLoads': 'Available for loads',
      'availableForLoadsHint': 'Show your current location and preferences to get better matches.',
      'notAvailableNow': 'Not available right now',
      'adrReady': 'ADR ready',
      'callNow': 'Call',
      'sendSms': 'SMS',
      'copyPhone': 'Copy number',
      'phoneCopied': 'Phone copied',
      'phoneNumber': 'Phone number',
      'displayName': 'Display name',
      'searchLoads': 'Search loads',
      'searchLoadsHint': 'Company, factory, city, description…',
      'offlineModeBanner': 'You are offline — showing cached data where available.',
      'adminModeration': 'Admin / moderation',
      'adminModerationHint': 'Review listings, KYC docs and ban abusive companies.',
      'reviewListings': 'Listings review',
      'reviewKyc': 'KYC documents',
      'approve': 'Approve',
      'banCompany': 'Ban company',
      'fleetAssign': 'Assign driver',
      'fleetAssignHint': 'Give a matched job vehicle to a driver on your fleet.',
      'assignDriver': 'Assign driver',
      'driverAssigned': 'Driver assigned to vehicle',
      'activeAssignments': 'Active assignments',
      'unassigned': 'Unassigned',
      'eSignature': 'Contract e-sign',
      'eSignatureHint': 'Sign the standard match agreement with your finger.',
      'signBelow': 'Sign below',
      'clear': 'Clear',
      'confirmSignature': 'Confirm signature',
      'signatureSaved': 'Signature saved',
      'signed': 'Signed',
      'signedAt': 'Signed at',
      'liveGps': 'Live GPS',
      'liveGpsHint': 'Read device location for active hauls.',
      'locating': 'Locating…',
      'locationDenied': 'Location permission denied or unavailable',
      'gpsLive': 'GPS fix active',
      'refreshLocation': 'Refresh location',
      'openOsmMap': 'Open OSM map',
      'lastUpdate': 'Last update',
      'fcmTokenRegistered': 'Push token registered (stub/FCM-ready)',
      'registerShipper': 'Create shipper account',
      'registerCarrier': 'Create Find Loads account',
      'invalidEmail': 'Enter a valid email address',
      'passwordRequired': 'Password is required',
      'passwordTooShort': 'At least 12 characters',
      'passwordNeedUpper': 'Add an uppercase letter',
      'passwordNeedLower': 'Add a lowercase letter',
      'passwordNeedDigit': 'Add a number',
      'passwordNeedSpecial': 'Add a special character (!@#…)',
      'passwordMismatch': 'Passwords do not match',
      'passwordRulesHint': 'Min 12 chars, upper + lower + number + special.',
      'acceptLegalPrefix': 'I accept the Terms, Privacy Policy and KVKK notice',
      'acceptLegalRequired': 'You must accept legal terms to register',
      'privacyPolicy': 'Privacy Policy',
      'termsOfUse': 'Terms of Use',
      'kvkkNotice': 'KVKK / GDPR notice',
      'aboutUs': 'About us',
      'pricing': 'Pricing',
      'aboutAndPricing': 'About & pricing',
      'privacyBody': 'We process account, freight and device data to operate the marketplace, match partners, prevent fraud and improve reliability. Data is retained only as long as needed for contracts, legal duties and security. You may request access, correction or deletion where applicable under GDPR/KVKK.',
      'termsBody': 'GucLogistics provides a B2B freight matching platform. Users must provide accurate company/driver information, comply with transport laws, and treat offers and matches in good faith. Misuse, fake documents or payment abuse may lead to suspension.',
      'kvkkBody': 'As data controller we process identity, contact, company, vehicle and transaction data for service delivery, verification, support and legal compliance. Legal bases include contract performance and legitimate interest. Contact support to exercise KVKK/GDPR rights.',
      'aboutBody': 'GucLogistics connects European shippers, logistics companies, independent drivers and fleet owners in one trusted marketplace — from discovery and negotiation to delivery tracking.',
      'pricingBody': 'Starter: publish/browse free with platform fees on matched jobs. Pro: corridor alerts, team seats and priority support. Enterprise: custom SLA, escrow options and API access. Final commercial terms are confirmed before go-live.',
      'howItWorks': 'How it works',
      'howItWorksIntro': 'Three simple steps from publishing or finding freight to a confirmed match.',
      'howItWorksHomeHint': 'Tap for the full guide',
      'howStep1ShipperTitle': 'Publish your load',
      'howStep1ShipperBody': 'Add factory, route, tonnage, schedule and contacts. It appears on the Europe board.',
      'howStep2ShipperTitle': 'Compare offers',
      'howStep2ShipperBody': 'Carriers bid. Filter by price, trust and SLA, then negotiate or accept.',
      'howStep3ShipperTitle': 'Match, track, pay',
      'howStep3ShipperBody': 'Call or chat, track delivery, release escrow after CMR confirmation.',
      'howStep1CarrierTitle': 'Find loads',
      'howStep1CarrierBody': 'Filter Europe & Türkiye by country, region and city. Set availability and vehicle prefs.',
      'howStep2CarrierTitle': 'Send an offer',
      'howStep2CarrierBody': 'Bid with price and message. Counter until both sides agree.',
      'howStep3CarrierTitle': 'Haul and earn',
      'howStep3CarrierBody': 'After match, call the shipper, deliver, and see earnings accumulate in your wallet.',
      'trustSafety': 'Trust & safety',
      'trustSafetyIntro': 'How GucLogistics keeps freight partners safer on every match.',
      'trustVerifyTitle': 'Company & driver verification',
      'trustVerifyBody': 'Identity, business and insurance docs are reviewed before partners get a verified badge.',
      'trustEscrowTitle': 'Escrow hold',
      'trustEscrowBody': 'Agreed funds are held on match and released after delivery confirmation / CMR.',
      'trustMatchTitle': 'Direct contact after match',
      'trustMatchBody': 'Phone and chat open only after both sides accept — no spam before the deal.',
      'trustClaimsTitle': 'Claims window',
      'trustClaimsBody': 'Delay, damage or payment disputes can be opened from the claims workspace.',
      'supportFaq': 'Support & FAQ',
      'supportIntro': 'Reach the GucLogistics team or browse common questions.',
      'contactUs': 'Contact',
      'supportEmail': 'Email support',
      'supportWhatsapp': 'WhatsApp',
      'faqTitle': 'Frequently asked questions',
      'faq1Q': 'Is publishing a load free?',
      'faq1A': 'Browsing and publishing are free on Starter. Platform fees apply when a job is matched. See Pricing for Pro/Enterprise.',
      'faq2Q': 'When do I see the other party’s phone?',
      'faq2A': 'Only after an offer is accepted and a match is created. Then Call / SMS buttons appear in the match room.',
      'faq3Q': 'How does escrow work?',
      'faq3A': 'On match the agreed amount is held. After delivery steps and CMR, funds can be released to the carrier.',
      'faq4Q': 'Can I filter only my favorite carriers?',
      'faq4A': 'Yes. When creating a load, enable “Favorites only” so only favorited carriers see the listing.',
      'faq5Q': 'Which languages and countries are supported?',
      'faq5A': 'The app supports multiple languages. The board covers Europe corridors and Türkiye provinces/regions.',
      'matches': 'Matches',
      'noMatchesYet': 'No matches yet',
      'noMatchesHint': 'Accept an offer to open a match conversation.',
      'editProfile': 'Edit profile',
      'requiredField': 'This field is required',
      'addVehicle': 'Add vehicle',
      'editVehicle': 'Edit vehicle',
      'addVehicleHint': 'Add your first vehicle to improve load matching.',
      'delete': 'Delete',
      'takePhoto': 'Take photo',
      'chooseGallery': 'Choose from gallery',
      'chooseFile': 'Choose file',
      'documentSubmitted': 'Document submitted for review',
      'verificationWizardHint': 'Upload the documents below. Status updates after review.',
      'verifyIdentity': 'Identity document',
      'verifyBusiness': 'Company registration',
      'verifyTax': 'VAT / tax certificate',
      'verifyInsurance': 'Insurance certificate',
      'verifyLicenseDoc': 'Driver license',
      'verifyVehicleDoc': 'Vehicle registration (K1)',
      'pushNotifications': 'Push notifications',
      'pushNotificationsHint': 'Load alerts, offers and match updates (preference stored on device)',
      'paymentTimeline': 'Payment timeline',
      'paymentTimelineBody': '1) Match → funds held  2) Delivery + CMR → release  3) Mark paid / settle',
      'waitingDeliveryRelease': 'Escrow stays locked until delivery is confirmed.',
      'mapDisclaimer': 'Overview pins (not live GPS map)',
      'factoryName': 'Factory / site name',
      'contactPhone': 'Contact phone',
      'weightTons': 'Weight (tons)',
      'pickupDateTime': 'Pickup date & time',
      'deliveryDateTime': 'Delivery date & time',
      'createLoadIntro': 'Publish a freight listing for carriers across Europe. Fill the factory, load type, tonnage, schedule and phone so carriers can respond confidently.',
      'shipperLoadBasics': 'Load basics',
      'countryCode': 'Country (e.g. DE)',
      'city': 'City',
      'schedule': 'Schedule',
      'extraLoadDetails': 'Extra details',
      'extraLoadDetailsHint': 'Also useful later: ADR, pallet count, loading equipment, door number, reference.',
      'loadPublishedHint': 'Listing published. It appears on the Europe board for carriers.',
      'browseEuropeLoads': 'Browse Europe listings',
      'europeLoadBoard': 'Europe load board',
      'europeLoadBoardHint': 'All active freight listings across Europe for this corridor filter.',
      'locationFilter': 'Country · region · city',
      'locationFilterHint': 'Narrow the board by pickup country, state/region and city.',
      'country': 'Country',
      'regionState': 'State / region',
      'allCountries': 'All countries',
      'allRegions': 'All regions',
      'allCities': 'All cities',
      'shipperCompanies': 'Shipper companies',
      'shipperCompaniesHint': 'Other verified shippers and their factories on this board — see who is publishing nearby.',
      'factories': 'Factories',
      'companyNamePublish': 'Your company name',
      'shipperTools': 'Shipper workspace',
      'shipperToolsHint': 'Templates, compare, escrow, billing, favorites…',
      'routeTemplates': 'Route templates',
      'republishFromTemplate': 'Reuse & publish',
      'republishLoad': 'Republish this route',
      'templates': 'Templates',
      'compareOffers': 'Compare offers',
      'compareOffersHint': 'Price, transit time and trust side by side. Tap a row to open negotiation.',
      'compareOffersEmpty': 'No open offers to compare yet.',
      'transitTime': 'Transit',
      'favorite': 'Favorite',
      'activeTracking': 'Live tracking',
      'escrowSummary': 'Escrow & payments',
      'billingInfo': 'Billing / invoice',
      'invoiceEmail': 'Invoice email',
      'favoriteCarriers': 'Favorite carriers',
      'notificationPrefs': 'Offer notifications',
      'notifyNewOffers': 'New offers',
      'notifyCounters': 'Counter-offers',
      'notifyMatches': 'Matches',
      'batchLoads': 'Batch loads',
      'batchLoadsHint': 'Publish several similar loads for the same day window from your template.',
      'batchCount': 'Number of loads',
      'publishBatch': 'Publish batch',
      'batchPublished': 'Batch published to Europe board',
      'contractTemplates': 'Contract templates',
      'contractTemplateBody': 'Standard terms for matched freight: escrow hold until delivery confirmation, CMR required, dispute window 48h.',
      'ratings': 'Ratings',
      'rateDeliveryHint': 'Rate the carrier after delivery to build marketplace trust.',
      'submitRating': 'Submit rating',
      'apiErp': 'API / ERP link',
      'apiErpHint': 'Store your ERP webhook endpoint. Live sync is enabled when backend integration is connected.',
      'erpEndpoint': 'ERP endpoint URL',
      'liveMapMock': 'Live map (preview)',
      'liveMapMockHint': 'Mock GPS board for active shipments. Real map SDK can replace this later.',
      'eta': 'ETA',
      'delayAlert': 'Possible delay — CMR not uploaded yet',
      'awaitingCmr': 'Awaiting CMR photo',
      'openTracking': 'Open tracking',
      'unverifiedPublishWarning': 'Company not fully verified. You can publish, but carriers may trust verified shippers more.',
      'contactPerson': 'Site contact person',
      'doorRamp': 'Door / ramp',
      'referenceNo': 'Reference no.',
      'palletCount': 'Pallet count',
      'specialRequirements': 'Special requirements',
      'reqAdr': 'ADR / dangerous goods',
      'reqColdChain': 'Cold chain',
      'reqTailLift': 'Tail lift (livar)',
      'reqForklift': 'Forklift at site',
      'saveAsTemplate': 'Save as route template',
      'editLoad': 'Edit listing',
      'unpublishLoad': 'Unpublish listing',
      'statusUnpublished': 'Unpublished',
      'favoritesOnly': 'Favorites only',
      'favoritesOnlyHint': 'Only your favorite carriers can see this listing',
      'favoritesOnlyFilter': 'Favorite carriers',
      'adrLoadsFilter': 'ADR loads',
      'sortPriceAsc': 'Price ↑',
      'sortPriceDesc': 'Price ↓',
      'sortTrust': 'Trust',
      'sortSla': 'SLA deadline',
      'sortNewest': 'Newest first',
      'offerSlaHours': 'Offer response SLA (hours)',
      'slaUntil': 'Respond before',
      'slaExpired': 'SLA expired',
      'rejectOffer': 'Reject offer',
      'rejectReason': 'Rejection reason',
      'loadPhotos': 'Load photos',
      'addPhoto': 'Add photo',
      'claims': 'Claims / disputes',
      'openClaim': 'Open claim',
      'claimDelay': 'Delay',
      'claimDamage': 'Damage',
      'claimPayment': 'Payment dispute',
      'paymentLedger': 'Payment ledger',
      'simulatePayout': 'Simulate release & payout',
      'eInvoice': 'E-invoice',
      'invoiceLanguage': 'Invoice language',
      'sendEInvoice': 'Send e-invoice draft',
      'eInvoiceSent': 'E-invoice draft queued to billing email',
      'reports': 'Reports',
      'monthlySpend': 'Matched spend',
      'activeListings': 'Active listings',
      'matchedLoads': 'Matched loads',
      'corridorSpend': 'Spend by corridor',
      'dispatcherPermissions': 'Dispatcher permissions',
      'dispatcherPermissionsHint': 'Controls what invited dispatchers can do in this company workspace.',
      'permPublish': 'Can publish loads',
      'permAcceptOffers': 'Can accept offers',
      'permManagePayments': 'Can manage payments',
      'permInviteTeam': 'Can invite team',
      'noPublishPermission': 'Your dispatcher role cannot publish loads',
      'pushSimulation': 'Push simulation',
      'pushSimulationHint': 'FCM wiring comes later. This simulates in-app push delivery into Notifications.',
      'simulateNewOfferPush': 'Simulate new-offer push',
      'simulateMatchPush': 'Simulate match push',
      'pushDelivered': 'Push delivered to inbox',
      'liveMapOsm': 'Live map (OpenStreetMap)',
      'gpsLiveHint': 'Truck marker is live GPS preview on OSM tiles.',
      'suitedLoadNotification': 'A load matches your corridor and vehicle',
      'statusInTransit': 'In transit',
      'nearbyLoads': 'Nearby loads',
      'activeOffers': 'Active offers',
      'wonJobs': 'Won jobs',
      'vehicleStatus': 'Vehicle status',
      'recommendedLoads': 'Recommended',
      'availableLoads': 'Available loads',
      'loadDetail': 'Load detail',
      'submitOffer': 'Submit offer',
      'incomingOffers': 'Incoming offers',
      'accept': 'Accept',
      'reject': 'Reject',
      'amount': 'Amount',
      'currency': 'Currency',
      'message': 'Message',
      'vehicles': 'My vehicles',
      'verification': 'Verification',
      'verified': 'Verified',
      'pending': 'Pending',
      'companyProfile': 'Company profile',
      'driverProfile': 'Driver profile',
      'pickup': 'Pickup',
      'dropoff': 'Dropoff',
      'weight': 'Weight',
      'vehicleType': 'Vehicle',
      'loadType': 'Load type',
      'loadDate': 'Loading',
      'deliveryDate': 'Delivery',
      'status': 'Status',
      'retry': 'Retry',
      'noData': 'Nothing here yet',
      'offlineOrError': 'Unable to load data. You can retry or continue with cached information.',
      'save': 'Save',
      'next': 'Next',
      'back': 'Back',
      'title': 'Title',
      'description': 'Description',
      'plate': 'Plate',
      'capacity': 'Capacity',
    },
    'tr': {
      'appTitle': 'GucLogistics',
      'tagline': 'Avrupa yükleri, güvenle eşleşsin',
      'splashLoading': 'Çalışma alanınız hazırlanıyor…',
      'onboarding1Title': 'Net sevkiyat',
      'onboarding1Body': 'Yük yayınlayın, doğrulanmış taşıyıcılardan rekabetçi teklifler alın.',
      'onboarding2Title': 'Fırsatla sürün',
      'onboarding2Body': 'Araç ve programınıza uyan Avrupa yüklerini keşfedin.',
      'onboarding3Title': 'Güven için tasarlandı',
      'onboarding3Body': 'Doğrulama, güvenli oturum ve şeffaf teklif süreçleri.',
      'continueLabel': 'Devam',
      'getStarted': 'Başlayın',
      'skip': 'Atla',
      'login': 'Giriş yap',
      'register': 'Hesap oluştur',
      'forgotPassword': 'Şifremi unuttum',
      'email': 'E-posta',
      'password': 'Şifre',
      'confirmPassword': 'Şifre tekrar',
      'sendResetLink': 'Sıfırlama bağlantısı gönder',
      'resetSent': 'Hesap varsa sıfırlama bağlantısı gönderildi.',
      'roleTitle': 'Rolünüzü seçin',
      'roleSubtitle': 'Çalışma alanını operasyonunuza göre ayarlarız.',
      'roleShipper': 'Yük veren firma',
      'roleLogistics': 'Lojistik firması',
      'roleDriver': 'Bağımsız şoför',
      'roleFleet': 'Filo sahibi',
      'home': 'Ana sayfa',
      'loads': 'Yükler',
      'myLoads': 'Yüklerim',
      'offers': 'Teklifler',
      'myOffers': 'Tekliflerim',
      'profile': 'Profil',
      'settings': 'Ayarlar',
      'notifications': 'Bildirimler',
      'language': 'Dil',
      'theme': 'Tema',
      'themeSystem': 'Sistem',
      'themeLight': 'Açık',
      'themeDark': 'Koyu',
      'logout': 'Çıkış yap',
      'activeLoads': 'Aktif yükler',
      'pendingOffers': 'Bekleyen teklifler',
      'completedShipments': 'Tamamlanan',
      'createLoad': 'Yeni yük',
      'recentLoads': 'Son yayınlanan yükler',
      'recentOffers': 'Son gelen teklifler',
      'welcomeBack': 'Tekrar hoş geldiniz',
      'homeShipperSubtitle': 'Yük yayınlayın ve taşıyıcı tekliflerini inceleyin.',
      'homeDriverSubtitle': 'Uygun yükleri bulun ve tekliflerinizi yönetin.',
      'seeAll': 'Tümünü gör',
      'verifiedCompany': 'Doğrulanmış firma',
      'verifiedDriver': 'Doğrulanmış şoför',
      'verificationPending': 'Doğrulama bekliyor',
      'verificationBodyPending': 'Kimlik ve iş belgeleri inceleniyor. Doğrulama tamamlanırken gezmeye devam edebilirsiniz.',
      'verificationBodyVerified': 'Hesabınız doğrulandı. Partnerler profilinize güvenebilir.',
      'companyNameLabel': 'Firma',
      'vatLabel': 'KDV / VAT',
      'hqLabel': 'Merkez',
      'licenseLabel': 'Ehliyet',
      'experienceLabel': 'Deneyim',
      'baseLabel': 'Üs',
      'years': 'yıl',
      'statusPublished': 'Yayında',
      'statusMatched': 'Eşleşti',
      'statusCompleted': 'Tamamlandı',
      'statusPending': 'Beklemede',
      'statusAccepted': 'Kabul',
      'statusRejected': 'Reddedildi',
      'statusActive': 'Aktif',
      'saved': 'Kaydedildi',
      'browseLoads': 'Yükleri gör',
      'expectedPrice': 'Beklenen fiyat',
      'negotiation': 'Müzakere',
      'counterOffer': 'Karşı teklif',
      'openNegotiation': 'Müzakereyi aç',
      'offerRoom': 'Teklif odası',
      'matchChat': 'Eşleşme sohbeti',
      'matched': 'Eşleşti',
      'openChat': 'Sohbeti aç',
      'sendMessage': 'Gönder',
      'typeMessage': 'Mesaj yazın',
      'matchScore': 'Eşleşme skoru',
      'agreedPrice': 'Anlaşılan fiyat',
      'carrier': 'Taşıyıcı',
      'shipper': 'Yük veren',
      'yourCounter': 'Karşı teklifiniz',
      'rounds': 'Teklif turları',
      'acceptAndMatch': 'Kabul et ve eşleş',
      'statusCountered': 'Karşı teklif',
      'matchingHint': 'Taşıyıcılar beklenen fiyatın üstünde veya altında teklif verebilir. Anlaşana kadar karşı teklif edebilirsiniz.',
      'chatEmpty': 'Henüz mesaj yok. Eşleşmeden sonra yükleme detaylarını burada konuşun.',
      'publishLoad': 'İlanı yayınla',
      'europeMarket': 'Avrupa pazarı',
      'marketShipperSubtitle': 'Avrupa genelinde doğrulanmış taşıyıcıları keşfedin. Koridor ve müsaitliğe göre filtreleyin.',
      'marketDriverSubtitle': 'Avrupa genelinde yükleri gezin. Koridor filtreleyin ve güvenle teklif verin.',
      'corridors': 'Koridorlar',
      'favoriteCorridors': 'Favori koridorlar',
      'marketPriceBand': 'Piyasa fiyat bandı',
      'avg': 'ort.',
      'europeMap': 'Avrupa görünümü',
      'availableCarriers': 'Müsait taşıyıcılar',
      'completedJobs': 'iş',
      'trustScore': 'Güven puanı',
      'onTimeRate': 'Zamanında teslim',
      'delayRate': 'Gecikme oranı',
      'liveAvailability': 'Canlı müsaitlik',
      'verifiedCarrier': 'Doğrulanmış taşıyıcı',
      'availableHoursLabel': 'Müsait',
      'operations': 'Operasyon',
      'operationsSubtitle': 'Takip, belgeler, filo, ödemeler ve koridor uyarıları.',
      'shipmentTracking': 'Taşıma takibi',
      'shipmentTrackingHint': 'Yükleme → yolda → teslim',
      'documents': 'Belgeler',
      'documentsHint': 'Ehliyet, sigorta, K1, CMR',
      'agreementsPayments': 'Anlaşma ve ödeme',
      'agreementsPaymentsHint': 'Escrow, fatura ve serbest bırakma',
      'fleetPanel': 'Filo paneli',
      'fleetPanelHint': 'Araçlar, şoförler ve belgeler',
      'team': 'Ekip',
      'teamHint': 'Dispatcher ve şoförler',
      'corridorAlerts': 'Koridor uyarıları',
      'corridorAlertsHint': 'Abonelik ve minimum fiyat',
      'backhaul': 'Boş dönüş önerileri',
      'backhaulHint': 'Rotanızdaki dönüş yükleri',
      'uploadDocument': 'Belge yükle',
      'replaceDocument': 'Belgeyi değiştir',
      'cmrPhoto': 'CMR / teslim fotoğrafı',
      'uploadCmrPhoto': 'CMR fotoğrafı yükle',
      'advanceStatus': 'Durumu ilerlet',
      'agreementSummary': 'Anlaşma özeti',
      'escrowHeld': 'Ödeme güvencede',
      'escrowHint': 'Teslim onayı gelene kadar tutar korunur.',
      'markPaid': 'Ödendi işaretle',
      'route': 'Rota',
      'minAcceptPrice': 'Minimum kabul fiyatı',
      'editMinPrice': 'Min fiyatı düzenle',
      'corridorAlertHint': 'Uygun yük çıkınca bildirim alın',
      'driver': 'Şoför',
      'trackAccepted': 'Kabul edildi',
      'trackPickedUp': 'Yüklendi',
      'trackInTransit': 'Yolda',
      'trackDelivered': 'Teslim edildi',
      'docMissing': 'Eksik',
      'docPending': 'İnceleniyor',
      'docApproved': 'Onaylandı',
      'docRejected': 'Reddedildi',
      'payPending': 'Ödeme bekliyor',
      'payHeld': 'Bloke',
      'payReleased': 'Serbest',
      'payPaid': 'Ödendi',
      'roleAdmin': 'Yönetici',
      'roleDispatcher': 'Dispatcher',
      'roleDriverMember': 'Şoför',
      'continueWithGoogle': 'Google ile devam et',
      'continueWithApple': 'Apple ile devam et',
      'orContinueWith': 'veya şununla devam et',
      'chooseAccountType': 'GucLogistics’i nasıl kullanacaksınız?',
      'chooseAccountTypeHint': 'Yük veren ve taşıyıcı için çalışma alanı farklıdır.',
      'shipperGateTitle': 'Yük veriyorum',
      'shipperGateBody': 'Yük yayınla, teklif incele, teslimatı takip et.',
      'carrierGateTitle': 'Yük bul',
      'carrierGateBody': 'Avrupa ve Türkiye yüklerini gez, teklif ver, eşleş, ara / SMS at, kazancın biriksin.',
      'findLoads': 'Yük bul',
      'findLoadsSubtitle': 'Avrupa + Türkiye ülke → eyalet/il → şehir filtresi. Teklif ver, eşleş, sonra ara veya SMS gönder.',
      'earningsWallet': 'Kazanç cüzdanı',
      'walletBalance': 'Biriken bakiye',
      'thisMonth': 'Bu ay',
      'earningsHint': 'İş eşleşince anlaşılan tutar otomatik buraya işlenir (demo). Eski işler geçmişte kalır.',
      'jobHistory': 'İş geçmişi',
      'myAvailability': 'Müsaitliğim',
      'availableForLoads': 'Yük için müsaitim',
      'availableForLoadsHint': 'Konum ve tercihlerini göster, daha iyi eşleşme al.',
      'notAvailableNow': 'Şu an müsait değil',
      'adrReady': 'ADR hazır',
      'callNow': 'Ara',
      'sendSms': 'SMS',
      'copyPhone': 'Numarayı kopyala',
      'phoneCopied': 'Telefon kopyalandı',
      'phoneNumber': 'Telefon numarası',
      'displayName': 'Görünen ad',
      'searchLoads': 'Yük ara',
      'searchLoadsHint': 'Firma, fabrika, şehir, açıklama…',
      'offlineModeBanner': 'Çevrimdışısınız — varsa önbellek gösteriliyor.',
      'adminModeration': 'Admin / moderasyon',
      'adminModerationHint': 'İlan, KYC ve ban işlemlerini yönet.',
      'reviewListings': 'İlan inceleme',
      'reviewKyc': 'KYC belgeleri',
      'approve': 'Onayla',
      'banCompany': 'Firmayı banla',
      'fleetAssign': 'Şoför ata',
      'fleetAssignHint': 'Filodaki aracı bir şoföre ata.',
      'assignDriver': 'Şoförü ata',
      'driverAssigned': 'Şoför araca atandı',
      'activeAssignments': 'Aktif atamalar',
      'unassigned': 'Atanmamış',
      'eSignature': 'Sözleşme e-imza',
      'eSignatureHint': 'Eşleşme sözleşmesini parmakla imzala.',
      'signBelow': 'Aşağıya imza at',
      'clear': 'Temizle',
      'confirmSignature': 'İmzayı onayla',
      'signatureSaved': 'İmza kaydedildi',
      'signed': 'İmzalandı',
      'signedAt': 'İmza zamanı',
      'liveGps': 'Canlı GPS',
      'liveGpsHint': 'Aktif sevkiyat için cihaz konumunu oku.',
      'locating': 'Konum alınıyor…',
      'locationDenied': 'Konum izni yok veya kullanılamıyor',
      'gpsLive': 'GPS aktif',
      'refreshLocation': 'Konumu yenile',
      'openOsmMap': 'OSM haritayı aç',
      'lastUpdate': 'Son güncelleme',
      'fcmTokenRegistered': 'Push token kaydedildi (stub/FCM hazır)',
      'registerShipper': 'Yük veren hesabı oluştur',
      'registerCarrier': 'Yük bul hesabı oluştur',
      'invalidEmail': 'Geçerli bir e-posta girin',
      'passwordRequired': 'Şifre zorunlu',
      'passwordTooShort': 'En az 12 karakter',
      'passwordNeedUpper': 'En az bir büyük harf ekleyin',
      'passwordNeedLower': 'En az bir küçük harf ekleyin',
      'passwordNeedDigit': 'En az bir rakam ekleyin',
      'passwordNeedSpecial': 'En az bir özel karakter ekleyin (!@#…)',
      'passwordMismatch': 'Şifreler eşleşmiyor',
      'passwordRulesHint': 'Min 12 karakter, büyük + küçük + rakam + özel karakter.',
      'acceptLegalPrefix': 'Kullanım şartları, gizlilik ve KVKK metnini kabul ediyorum',
      'acceptLegalRequired': 'Kayıt için yasal metinleri kabul etmelisiniz',
      'privacyPolicy': 'Gizlilik Politikası',
      'termsOfUse': 'Kullanım Şartları',
      'kvkkNotice': 'KVKK / GDPR bildirimi',
      'aboutUs': 'Hakkımızda',
      'pricing': 'Ücretlendirme',
      'aboutAndPricing': 'Hakkımızda ve ücretlendirme',
      'privacyBody': 'Hesap, yük ve cihaz verilerini pazaryerini işletmek, eşleştirme, dolandırıcılığı önlemek ve güvenilirliği artırmak için işleriz. Veriler sözleşme, yasal yükümlülük ve güvenlik için gerekli süre kadar saklanır. GDPR/KVKK kapsamında erişim, düzeltme veya silme talep edebilirsiniz.',
      'termsBody': 'GucLogistics B2B yük eşleştirme platformudur. Kullanıcılar doğru firma/şoför bilgisi vermeli, taşıma mevzuatına uymalı ve teklif/eşleşmelerde iyi niyetli davranmalıdır. Sahte belge veya ödeme suistimali hesaba kısıt getirebilir.',
      'kvkkBody': 'Veri sorumlusu olarak kimlik, iletişim, firma, araç ve işlem verilerini hizmet, doğrulama, destek ve yasal uyum için işleriz. Hukuki sebepler sözleşme ifası ve meşru menfaati kapsar. KVKK/GDPR hakları için destek ile iletişime geçin.',
      'aboutBody': 'GucLogistics; Avrupa’daki yük verenleri, lojistik firmalarını, bağımsız şoförleri ve filo sahiplerini keşiften müzakereye ve teslim takipine kadar tek güvenli pazaryerinde buluşturur.',
      'pricingBody': 'Starter: eşleşmede platform ücreti ile ücretsiz yayın/gezinme. Pro: koridor uyarıları, ekip koltukları ve öncelikli destek. Enterprise: özel SLA, escrow seçenekleri ve API. Nihai ticari koşullar canlıya almadan önce teyit edilir.',
      'howItWorks': 'Nasıl çalışır',
      'howItWorksIntro': 'Yük yayınlamadan veya bulmadan eşleşmeye üç net adım.',
      'howItWorksHomeHint': 'Tam rehber için dokun',
      'howStep1ShipperTitle': 'Yükünü yayınla',
      'howStep1ShipperBody': 'Fabrika, rota, tonaj, tarih ve iletişim ekle. İlan Avrupa panosunda görünür.',
      'howStep2ShipperTitle': 'Teklifleri karşılaştır',
      'howStep2ShipperBody': 'Taşıyıcılar teklif verir. Fiyat, güven ve SLA’ya göre filtrele; müzakere et veya kabul et.',
      'howStep3ShipperTitle': 'Eşleş, takip et, öde',
      'howStep3ShipperBody': 'Ara veya yazış, teslimi takip et, CMR sonrası escrow’u serbest bırak.',
      'howStep1CarrierTitle': 'Yük bul',
      'howStep1CarrierBody': 'Avrupa ve Türkiye’yi ülke, eyalet/il ve şehre göre filtrele. Müsaitlik ve araç tercihini ayarla.',
      'howStep2CarrierTitle': 'Teklif gönder',
      'howStep2CarrierBody': 'Fiyat ve mesajla teklif ver. Anlaşana kadar karşı teklifleşin.',
      'howStep3CarrierTitle': 'Taşı ve kazan',
      'howStep3CarrierBody': 'Eşleşmeden sonra yük vereni ara, teslim et; kazanç cüzdanında birikir.',
      'trustSafety': 'Güven ve güvenlik',
      'trustSafetyIntro': 'GucLogistics her eşleşmede tarafları daha güvende tutmak için ne yapar.',
      'trustVerifyTitle': 'Firma ve şoför doğrulama',
      'trustVerifyBody': 'Kimlik, şirket ve sigorta belgeleri incelenir; onaylananlar doğrulanmış rozet alır.',
      'trustEscrowTitle': 'Escrow blokesi',
      'trustEscrowBody': 'Anlaşılan tutar eşleşmede bloke edilir; teslim / CMR sonrası serbest bırakılır.',
      'trustMatchTitle': 'Eşleşmeden sonra doğrudan iletişim',
      'trustMatchBody': 'Telefon ve sohbet yalnızca iki taraf kabul ettikten sonra açılır.',
      'trustClaimsTitle': 'İtiraz / claim penceresi',
      'trustClaimsBody': 'Gecikme, hasar veya ödeme itirazını claim ekranından açabilirsin.',
      'supportFaq': 'Destek ve SSS',
      'supportIntro': 'GucLogistics ekibine ulaş veya sık sorulanlara bak.',
      'contactUs': 'İletişim',
      'supportEmail': 'E-posta destek',
      'supportWhatsapp': 'WhatsApp',
      'faqTitle': 'Sık sorulan sorular',
      'faq1Q': 'İlan yayınlamak ücretsiz mi?',
      'faq1A': 'Starter’da gezinme ve yayın ücretsizdir. Eşleşmede platform ücreti uygulanır. Pro/Enterprise için Ücretlendirme’ye bakın.',
      'faq2Q': 'Karşı tarafın telefonunu ne zaman görürüm?',
      'faq2A': 'Teklif kabul edilip eşleşme oluşunca. Match odasında Ara / SMS butonları açılır.',
      'faq3Q': 'Escrow nasıl işler?',
      'faq3A': 'Eşleşmede tutar bloke edilir. Teslim adımları ve CMR sonrası taşıyıcıya serbest bırakılabilir.',
      'faq4Q': 'Sadece favori taşıyıcılara gösterebilir miyim?',
      'faq4A': 'Evet. İlan oluştururken “Sadece favoriler”i aç; yalnızca favori taşıyıcılar görür.',
      'faq5Q': 'Hangi dil ve ülkeler destekleniyor?',
      'faq5A': 'Uygulama çok dilli. Pano Avrupa koridorlarını ve Türkiye illerini/bölgelerini kapsar.',
      'matches': 'Eşleşmeler',
      'noMatchesYet': 'Henüz eşleşme yok',
      'noMatchesHint': 'Teklifi kabul edince eşleşme sohbeti açılır.',
      'editProfile': 'Profili düzenle',
      'requiredField': 'Bu alan zorunlu',
      'addVehicle': 'Araç ekle',
      'editVehicle': 'Aracı düzenle',
      'addVehicleHint': 'Eşleşmeyi iyileştirmek için ilk aracınızı ekleyin.',
      'delete': 'Sil',
      'takePhoto': 'Fotoğraf çek',
      'chooseGallery': 'Galeriden seç',
      'chooseFile': 'Dosya seç',
      'documentSubmitted': 'Belge incelemeye gönderildi',
      'verificationWizardHint': 'Aşağıdaki belgeleri yükleyin. Durum incelemeden sonra güncellenir.',
      'verifyIdentity': 'Kimlik belgesi',
      'verifyBusiness': 'Şirket belgesi',
      'verifyTax': 'KDV / vergi belgesi',
      'verifyInsurance': 'Sigorta belgesi',
      'verifyLicenseDoc': 'Ehliyet',
      'verifyVehicleDoc': 'Araç ruhsatı (K1)',
      'pushNotifications': 'Anlık bildirimler',
      'pushNotificationsHint': 'Yük, teklif ve eşleşme uyarıları (tercih cihazda saklanır)',
      'paymentTimeline': 'Ödeme zaman çizelgesi',
      'paymentTimelineBody': '1) Eşleşme → tutar bloke  2) Teslim + CMR → serbest  3) Ödendi işaretle',
      'waitingDeliveryRelease': 'Escrow teslim onayı gelene kadar kilitli kalır.',
      'mapDisclaimer': 'Genel pin görünümü (canlı GPS harita değil)',
      'factoryName': 'Fabrika / tesis adı',
      'contactPhone': 'İletişim telefonu',
      'weightTons': 'Ağırlık (ton)',
      'pickupDateTime': 'Yükleme tarih ve saat',
      'deliveryDateTime': 'Teslim tarih ve saat',
      'createLoadIntro': 'Avrupa’daki taşıyıcılar için yük ilanı yayınlayın. Fabrika, yük türü, tonaj, tarih-saat ve telefonu doldurun ki taşıyıcılar net teklif verebilsin.',
      'shipperLoadBasics': 'Yük bilgileri',
      'countryCode': 'Ülke (örn. DE)',
      'city': 'Şehir',
      'schedule': 'Tarih ve saat',
      'extraLoadDetails': 'Ek detaylar',
      'extraLoadDetailsHint': 'Sonradan eklenebilir: ADR, palet adedi, yükleme ekipmanı, kapı no, referans.',
      'loadPublishedHint': 'İlan yayınlandı. Avrupa panosunda taşıyıcılar görebilir.',
      'browseEuropeLoads': 'Avrupa ilanlarını gör',
      'europeLoadBoard': 'Avrupa yük panosu',
      'europeLoadBoardHint': 'Seçili koridordaki tüm aktif yük ilanları.',
      'locationFilter': 'Ülke · eyalet · şehir',
      'locationFilterHint': 'Panoyu yükleme ülkesi, eyalet/bölge ve şehre göre daraltın.',
      'country': 'Ülke',
      'regionState': 'Eyalet / bölge',
      'allCountries': 'Tüm ülkeler',
      'allRegions': 'Tüm eyaletler',
      'allCities': 'Tüm şehirler',
      'shipperCompanies': 'Yük veren firmalar',
      'shipperCompaniesHint': 'Bu panodaki diğer doğrulanmış yük verenler ve fabrikaları — kim yayınlıyor görün.',
      'factories': 'Fabrikalar',
      'companyNamePublish': 'Firma adınız',
      'shipperTools': 'Yük veren çalışma alanı',
      'shipperToolsHint': 'Şablon, karşılaştırma, escrow, fatura, favoriler…',
      'routeTemplates': 'Rota şablonları',
      'republishFromTemplate': 'Tekrar kullan ve yayınla',
      'republishLoad': 'Bu rotayı yeniden yayınla',
      'templates': 'Şablonlar',
      'compareOffers': 'Teklifleri karşılaştır',
      'compareOffersHint': 'Fiyat, süre ve güven yan yana. Satıra dokununca müzakere açılır.',
      'compareOffersEmpty': 'Karşılaştırılacak açık teklif yok.',
      'transitTime': 'Süre',
      'favorite': 'Favori',
      'activeTracking': 'Canlı takip',
      'escrowSummary': 'Escrow ve ödemeler',
      'billingInfo': 'Fatura bilgileri',
      'invoiceEmail': 'Fatura e-postası',
      'favoriteCarriers': 'Favori taşıyıcılar',
      'notificationPrefs': 'Teklif bildirimleri',
      'notifyNewOffers': 'Yeni teklifler',
      'notifyCounters': 'Karşı teklifler',
      'notifyMatches': 'Eşleşmeler',
      'batchLoads': 'Toplu yük',
      'batchLoadsHint': 'Aynı gün aralığında şablondan birden fazla benzer yük yayınla.',
      'batchCount': 'Yük adedi',
      'publishBatch': 'Toplu yayınla',
      'batchPublished': 'Parti Avrupa panosuna yayınlandı',
      'contractTemplates': 'Sözleşme şablonları',
      'contractTemplateBody': 'Eşleşen yük için standart şartlar: teslim onayına kadar escrow, CMR zorunlu, itiraz 48 saat.',
      'ratings': 'Puanlama',
      'rateDeliveryHint': 'Teslim sonrası taşıyıcıyı puanlayarak güven oluşturun.',
      'submitRating': 'Puanı gönder',
      'apiErp': 'API / ERP bağlantısı',
      'apiErpHint': 'ERP webhook adresini saklayın. Canlı senkron backend bağlanınca aktif olur.',
      'erpEndpoint': 'ERP uç noktası',
      'liveMapMock': 'Canlı harita (önizleme)',
      'liveMapMockHint': 'Aktif sevkiyatlar için mock GPS panosu. Gerçek harita SDK sonra eklenebilir.',
      'eta': 'ETA',
      'delayAlert': 'Olası gecikme — CMR henüz yüklenmedi',
      'awaitingCmr': 'CMR fotoğrafı bekleniyor',
      'openTracking': 'Takibi aç',
      'unverifiedPublishWarning': 'Firma tam doğrulanmadı. Yayınlayabilirsiniz; taşıyıcılar doğrulanmış hesaplara daha çok güvenir.',
      'contactPerson': 'Saha yetkilisi',
      'doorRamp': 'Kapı / rampa',
      'referenceNo': 'Referans no',
      'palletCount': 'Palet adedi',
      'specialRequirements': 'Özel şartlar',
      'reqAdr': 'ADR / tehlikeli madde',
      'reqColdChain': 'Soğuk zincir',
      'reqTailLift': 'Livar (tail lift)',
      'reqForklift': 'Sahada forklift',
      'saveAsTemplate': 'Rota şablonu olarak kaydet',
      'editLoad': 'İlanı düzenle',
      'unpublishLoad': 'Yayından kaldır',
      'statusUnpublished': 'Yayında değil',
      'favoritesOnly': 'Sadece favoriler',
      'favoritesOnlyHint': 'Bu ilanı yalnızca favori taşıyıcılar görür',
      'favoritesOnlyFilter': 'Favori taşıyıcılar',
      'adrLoadsFilter': 'ADR yükler',
      'sortPriceAsc': 'Fiyat ↑',
      'sortPriceDesc': 'Fiyat ↓',
      'sortTrust': 'Güven',
      'sortSla': 'SLA süresi',
      'sortNewest': 'En yeni',
      'offerSlaHours': 'Teklif yanıt SLA (saat)',
      'slaUntil': 'Son yanıt',
      'slaExpired': 'SLA doldu',
      'rejectOffer': 'Teklifi reddet',
      'rejectReason': 'Red gerekçesi',
      'loadPhotos': 'Yük fotoğrafları',
      'addPhoto': 'Fotoğraf ekle',
      'claims': 'Anlaşmazlık / claim',
      'openClaim': 'Claim aç',
      'claimDelay': 'Gecikme',
      'claimDamage': 'Hasar',
      'claimPayment': 'Ödeme itirazı',
      'paymentLedger': 'Ödeme defteri',
      'simulatePayout': 'Serbest bırak + ödeme simüle et',
      'eInvoice': 'E-fatura',
      'invoiceLanguage': 'Fatura dili',
      'sendEInvoice': 'E-fatura taslağı gönder',
      'eInvoiceSent': 'E-fatura taslağı fatura e-postasına kuyruğa alındı',
      'reports': 'Raporlar',
      'monthlySpend': 'Eşleşme harcaması',
      'activeListings': 'Aktif ilanlar',
      'matchedLoads': 'Eşleşen yükler',
      'corridorSpend': 'Koridora göre harcama',
      'dispatcherPermissions': 'Dispatcher yetkileri',
      'dispatcherPermissionsHint': 'Davet edilen dispatcher’ların bu firmada ne yapabileceğini belirler.',
      'permPublish': 'Yük yayınlayabilir',
      'permAcceptOffers': 'Teklif kabul edebilir',
      'permManagePayments': 'Ödeme yönetebilir',
      'permInviteTeam': 'Ekip davet edebilir',
      'noPublishPermission': 'Dispatcher rolünüz yük yayınlayamaz',
      'pushSimulation': 'Push simülasyonu',
      'pushSimulationHint': 'FCM bağlantısı sonra gelir. Bu, bildirim kutusuna in-app push simüle eder.',
      'simulateNewOfferPush': 'Yeni teklif push simüle et',
      'simulateMatchPush': 'Eşleşme push simüle et',
      'pushDelivered': 'Push bildirime düştü',
      'liveMapOsm': 'Canlı harita (OpenStreetMap)',
      'gpsLiveHint': 'Tır işaretçisi OSM karolarında GPS önizlemesi.',
      'suitedLoadNotification': 'Koridor ve aracınıza uyan bir yük var',
      'statusInTransit': 'Yolda',
      'nearbyLoads': 'Yakındaki yükler',
      'activeOffers': 'Aktif teklifler',
      'wonJobs': 'Kazanılan işler',
      'vehicleStatus': 'Araç durumu',
      'recommendedLoads': 'Önerilen',
      'availableLoads': 'Uygun yükler',
      'loadDetail': 'Yük detayı',
      'submitOffer': 'Teklif ver',
      'incomingOffers': 'Gelen teklifler',
      'accept': 'Kabul',
      'reject': 'Reddet',
      'amount': 'Tutar',
      'currency': 'Para birimi',
      'message': 'Mesaj',
      'vehicles': 'Araçlarım',
      'verification': 'Doğrulama',
      'verified': 'Doğrulandı',
      'pending': 'Beklemede',
      'companyProfile': 'Firma profili',
      'driverProfile': 'Şoför profili',
      'pickup': 'Kalkış',
      'dropoff': 'Varış',
      'weight': 'Ağırlık',
      'vehicleType': 'Araç',
      'loadType': 'Yük tipi',
      'loadDate': 'Yükleme',
      'deliveryDate': 'Teslim',
      'status': 'Durum',
      'retry': 'Yeniden dene',
      'noData': 'Henüz içerik yok',
      'offlineOrError': 'Veri yüklenemedi. Yeniden deneyin veya önbellekle devam edin.',
      'save': 'Kaydet',
      'next': 'İleri',
      'back': 'Geri',
      'title': 'Başlık',
      'description': 'Açıklama',
      'plate': 'Plaka',
      'capacity': 'Kapasite',
    },
    'de': {
      'appTitle': 'GucLogistics',
      'home': 'Start',
      'loads': 'Ladungen',
      'myLoads': 'Meine Ladungen',
      'offers': 'Angebote',
      'myOffers': 'Meine Angebote',
      'profile': 'Profil',
      'settings': 'Einstellungen',
      'language': 'Sprache',
      'theme': 'Design',
      'logout': 'Abmelden',
      'europeMarket': 'Europa-Markt',
      'marketShipperSubtitle': 'Entdecken Sie verifizierte Carrier in ganz Europa.',
      'marketDriverSubtitle': 'Finden Sie Ladungen in ganz Europa und bieten Sie sicher.',
      'corridors': 'Korridore',
      'favoriteCorridors': 'Favoritenkorridore',
      'marketPriceBand': 'Marktpreisband',
      'avg': 'Ø',
      'europeMap': 'Europa-Übersicht',
      'availableCarriers': 'Verfügbare Carrier',
      'availableLoads': 'Verfügbare Ladungen',
      'completedJobs': 'Aufträge',
      'trustScore': 'Trust-Score',
      'onTimeRate': 'Pünktlichkeit',
      'delayRate': 'Verspätungsrate',
      'liveAvailability': 'Live-Verfügbarkeit',
      'verifiedCarrier': 'Verifizierter Carrier',
      'matchScore': 'Match-Score',
      'createLoad': 'Ladung erstellen',
      'submitOffer': 'Angebot senden',
      'seeAll': 'Alle anzeigen',
      'notifications': 'Benachrichtigungen',
      'verified': 'Verifiziert',
      'pending': 'Ausstehend',
      'operations': 'Betrieb',
      'backhaul': 'Rückfracht',
      'continueWithGoogle': 'Mit Google fortfahren',
      'continueWithApple': 'Mit Apple fortfahren',
      'orContinueWith': 'oder fortfahren mit',
      'documents': 'Dokumente',
      'shipmentTracking': 'Sendungsverfolgung',
      'agreementsPayments': 'Vereinbarungen & Zahlungen',
      'fleetPanel': 'Fuhrpark',
      'team': 'Team',
      'corridorAlerts': 'Korridor-Alerts',
      'matches': 'Matches',
      'aboutAndPricing': 'Über uns & Preise',
      'privacyPolicy': 'Datenschutz',
      'termsOfUse': 'Nutzungsbedingungen',
      'kvkkNotice': 'DSGVO-Hinweis',
    },
    'pl': {
      'appTitle': 'GucLogistics',
      'home': 'Start',
      'loads': 'Ładunki',
      'myLoads': 'Moje ładunki',
      'offers': 'Oferty',
      'myOffers': 'Moje oferty',
      'profile': 'Profil',
      'settings': 'Ustawienia',
      'language': 'Język',
      'theme': 'Motyw',
      'logout': 'Wyloguj',
      'europeMarket': 'Rynek Europy',
      'marketShipperSubtitle': 'Odkrywaj zweryfikowanych przewoźników w całej Europie.',
      'marketDriverSubtitle': 'Przeglądaj ładunki w Europie i składaj oferty.',
      'corridors': 'Korytarze',
      'favoriteCorridors': 'Ulubione korytarze',
      'marketPriceBand': 'Przedział cen rynkowych',
      'avg': 'śr.',
      'europeMap': 'Mapa Europy',
      'availableCarriers': 'Dostępni przewoźnicy',
      'availableLoads': 'Dostępne ładunki',
      'completedJobs': 'zlecenia',
      'trustScore': 'Ocena zaufania',
      'onTimeRate': 'Punktualność',
      'delayRate': 'Opóźnienia',
      'liveAvailability': 'Dostępność na żywo',
      'verifiedCarrier': 'Zweryfikowany przewoźnik',
      'matchScore': 'Dopasowanie',
      'createLoad': 'Utwórz ładunek',
      'submitOffer': 'Złóż ofertę',
      'seeAll': 'Zobacz wszystkie',
      'notifications': 'Powiadomienia',
      'verified': 'Zweryfikowany',
      'pending': 'Oczekujące',
      'operations': 'Operacje',
      'backhaul': 'Ładunki powrotne',
      'continueWithGoogle': 'Kontynuuj z Google',
      'continueWithApple': 'Kontynuuj z Apple',
      'orContinueWith': 'lub kontynuuj przez',
      'documents': 'Dokumenty',
      'shipmentTracking': 'Śledzenie przesyłki',
      'agreementsPayments': 'Umowy i płatności',
      'fleetPanel': 'Flota',
      'team': 'Zespół',
      'corridorAlerts': 'Alerty korytarzy',
      'matches': 'Dopasowania',
      'aboutAndPricing': 'O nas i cennik',
      'privacyPolicy': 'Polityka prywatności',
      'termsOfUse': 'Regulamin',
      'kvkkNotice': 'RODO',
    },
    'fr': {
      'appTitle': 'GucLogistics',
      'home': 'Accueil',
      'loads': 'Chargements',
      'myLoads': 'Mes chargements',
      'offers': 'Offres',
      'myOffers': 'Mes offres',
      'profile': 'Profil',
      'settings': 'Paramètres',
      'language': 'Langue',
      'theme': 'Thème',
      'logout': 'Déconnexion',
      'europeMarket': 'Marché Europe',
      'marketShipperSubtitle': 'Découvrez des transporteurs vérifiés partout en Europe.',
      'marketDriverSubtitle': 'Parcourez le fret européen et proposez en confiance.',
      'corridors': 'Corridors',
      'favoriteCorridors': 'Corridors favoris',
      'marketPriceBand': 'Fourchette de prix',
      'avg': 'moy.',
      'europeMap': 'Vue Europe',
      'availableCarriers': 'Transporteurs disponibles',
      'availableLoads': 'Chargements disponibles',
      'completedJobs': 'missions',
      'trustScore': 'Score de confiance',
      'onTimeRate': 'Ponctualité',
      'delayRate': 'Retards',
      'liveAvailability': 'Disponibilité live',
      'verifiedCarrier': 'Transporteur vérifié',
      'matchScore': 'Score de matching',
      'createLoad': 'Créer un chargement',
      'submitOffer': 'Soumettre une offre',
      'seeAll': 'Tout voir',
      'notifications': 'Notifications',
      'verified': 'Vérifié',
      'pending': 'En attente',
      'operations': 'Opérations',
      'backhaul': 'Retours à vide',
      'continueWithGoogle': 'Continuer avec Google',
      'continueWithApple': 'Continuer avec Apple',
      'orContinueWith': 'ou continuer avec',
      'documents': 'Documents',
      'shipmentTracking': 'Suivi d’expédition',
      'agreementsPayments': 'Accords & paiements',
      'fleetPanel': 'Flotte',
      'team': 'Équipe',
      'corridorAlerts': 'Alertes corridor',
      'matches': 'Matchs',
      'aboutAndPricing': 'À propos & tarifs',
      'privacyPolicy': 'Politique de confidentialité',
      'termsOfUse': 'Conditions d’utilisation',
      'kvkkNotice': 'Avis RGPD',
    },
  };

  String _v(String key) => _t[locale.languageCode]?[key] ?? _t['en']![key]!;

  String get appTitle => _v('appTitle');
  String get tagline => _v('tagline');
  String get splashLoading => _v('splashLoading');
  String get onboarding1Title => _v('onboarding1Title');
  String get onboarding1Body => _v('onboarding1Body');
  String get onboarding2Title => _v('onboarding2Title');
  String get onboarding2Body => _v('onboarding2Body');
  String get onboarding3Title => _v('onboarding3Title');
  String get onboarding3Body => _v('onboarding3Body');
  String get continueLabel => _v('continueLabel');
  String get getStarted => _v('getStarted');
  String get skip => _v('skip');
  String get login => _v('login');
  String get register => _v('register');
  String get forgotPassword => _v('forgotPassword');
  String get email => _v('email');
  String get password => _v('password');
  String get confirmPassword => _v('confirmPassword');
  String get sendResetLink => _v('sendResetLink');
  String get resetSent => _v('resetSent');
  String get roleTitle => _v('roleTitle');
  String get roleSubtitle => _v('roleSubtitle');
  String get roleShipper => _v('roleShipper');
  String get roleLogistics => _v('roleLogistics');
  String get roleDriver => _v('roleDriver');
  String get roleFleet => _v('roleFleet');
  String get home => _v('home');
  String get loads => _v('loads');
  String get myLoads => _v('myLoads');
  String get offers => _v('offers');
  String get myOffers => _v('myOffers');
  String get profile => _v('profile');
  String get settings => _v('settings');
  String get notifications => _v('notifications');
  String get language => _v('language');
  String get theme => _v('theme');
  String get themeSystem => _v('themeSystem');
  String get themeLight => _v('themeLight');
  String get themeDark => _v('themeDark');
  String get logout => _v('logout');
  String get activeLoads => _v('activeLoads');
  String get pendingOffers => _v('pendingOffers');
  String get completedShipments => _v('completedShipments');
  String get createLoad => _v('createLoad');
  String get recentLoads => _v('recentLoads');
  String get recentOffers => _v('recentOffers');
  String get welcomeBack => _v('welcomeBack');
  String get homeShipperSubtitle => _v('homeShipperSubtitle');
  String get homeDriverSubtitle => _v('homeDriverSubtitle');
  String get seeAll => _v('seeAll');
  String get verifiedCompany => _v('verifiedCompany');
  String get verifiedDriver => _v('verifiedDriver');
  String get verificationPending => _v('verificationPending');
  String get verificationBodyPending => _v('verificationBodyPending');
  String get verificationBodyVerified => _v('verificationBodyVerified');
  String get companyNameLabel => _v('companyNameLabel');
  String get vatLabel => _v('vatLabel');
  String get hqLabel => _v('hqLabel');
  String get licenseLabel => _v('licenseLabel');
  String get experienceLabel => _v('experienceLabel');
  String get baseLabel => _v('baseLabel');
  String get years => _v('years');
  String get statusPublished => _v('statusPublished');
  String get statusMatched => _v('statusMatched');
  String get statusCompleted => _v('statusCompleted');
  String get statusPending => _v('statusPending');
  String get statusAccepted => _v('statusAccepted');
  String get statusRejected => _v('statusRejected');
  String get statusActive => _v('statusActive');
  String get saved => _v('saved');
  String get browseLoads => _v('browseLoads');
  String get expectedPrice => _v('expectedPrice');
  String get negotiation => _v('negotiation');
  String get counterOffer => _v('counterOffer');
  String get openNegotiation => _v('openNegotiation');
  String get offerRoom => _v('offerRoom');
  String get matchChat => _v('matchChat');
  String get matched => _v('matched');
  String get openChat => _v('openChat');
  String get sendMessage => _v('sendMessage');
  String get typeMessage => _v('typeMessage');
  String get matchScore => _v('matchScore');
  String get agreedPrice => _v('agreedPrice');
  String get carrier => _v('carrier');
  String get shipper => _v('shipper');
  String get yourCounter => _v('yourCounter');
  String get rounds => _v('rounds');
  String get acceptAndMatch => _v('acceptAndMatch');
  String get statusCountered => _v('statusCountered');
  String get matchingHint => _v('matchingHint');
  String get chatEmpty => _v('chatEmpty');
  String get publishLoad => _v('publishLoad');
  String get europeMarket => _v('europeMarket');
  String get marketShipperSubtitle => _v('marketShipperSubtitle');
  String get marketDriverSubtitle => _v('marketDriverSubtitle');
  String get corridors => _v('corridors');
  String get favoriteCorridors => _v('favoriteCorridors');
  String get marketPriceBand => _v('marketPriceBand');
  String get avg => _v('avg');
  String get europeMap => _v('europeMap');
  String get availableCarriers => _v('availableCarriers');
  String get completedJobs => _v('completedJobs');
  String get trustScore => _v('trustScore');
  String get onTimeRate => _v('onTimeRate');
  String get delayRate => _v('delayRate');
  String get liveAvailability => _v('liveAvailability');
  String get verifiedCarrier => _v('verifiedCarrier');
  String get availableHoursLabel => _v('availableHoursLabel');
  String get operations => _v('operations');
  String get operationsSubtitle => _v('operationsSubtitle');
  String get shipmentTracking => _v('shipmentTracking');
  String get shipmentTrackingHint => _v('shipmentTrackingHint');
  String get documents => _v('documents');
  String get documentsHint => _v('documentsHint');
  String get agreementsPayments => _v('agreementsPayments');
  String get agreementsPaymentsHint => _v('agreementsPaymentsHint');
  String get fleetPanel => _v('fleetPanel');
  String get fleetPanelHint => _v('fleetPanelHint');
  String get team => _v('team');
  String get teamHint => _v('teamHint');
  String get corridorAlerts => _v('corridorAlerts');
  String get corridorAlertsHint => _v('corridorAlertsHint');
  String get backhaul => _v('backhaul');
  String get backhaulHint => _v('backhaulHint');
  String get uploadDocument => _v('uploadDocument');
  String get replaceDocument => _v('replaceDocument');
  String get cmrPhoto => _v('cmrPhoto');
  String get uploadCmrPhoto => _v('uploadCmrPhoto');
  String get advanceStatus => _v('advanceStatus');
  String get agreementSummary => _v('agreementSummary');
  String get escrowHeld => _v('escrowHeld');
  String get escrowHint => _v('escrowHint');
  String get markPaid => _v('markPaid');
  String get route => _v('route');
  String get minAcceptPrice => _v('minAcceptPrice');
  String get editMinPrice => _v('editMinPrice');
  String get corridorAlertHint => _v('corridorAlertHint');
  String get driver => _v('driver');
  String get continueWithGoogle => _v('continueWithGoogle');
  String get continueWithApple => _v('continueWithApple');
  String get orContinueWith => _v('orContinueWith');
  String get chooseAccountType => _v('chooseAccountType');
  String get chooseAccountTypeHint => _v('chooseAccountTypeHint');
  String get shipperGateTitle => _v('shipperGateTitle');
  String get shipperGateBody => _v('shipperGateBody');
  String get carrierGateTitle => _v('carrierGateTitle');
  String get carrierGateBody => _v('carrierGateBody');
  String get findLoads => _v('findLoads');
  String get findLoadsSubtitle => _v('findLoadsSubtitle');
  String get earningsWallet => _v('earningsWallet');
  String get walletBalance => _v('walletBalance');
  String get thisMonth => _v('thisMonth');
  String get earningsHint => _v('earningsHint');
  String get jobHistory => _v('jobHistory');
  String get myAvailability => _v('myAvailability');
  String get availableForLoads => _v('availableForLoads');
  String get availableForLoadsHint => _v('availableForLoadsHint');
  String get notAvailableNow => _v('notAvailableNow');
  String get adrReady => _v('adrReady');
  String get callNow => _v('callNow');
  String get sendSms => _v('sendSms');
  String get copyPhone => _v('copyPhone');
  String get phoneCopied => _v('phoneCopied');
  String get phoneNumber => _v('phoneNumber');
  String get displayName => _v('displayName');
  String get searchLoads => _v('searchLoads');
  String get searchLoadsHint => _v('searchLoadsHint');
  String get offlineModeBanner => _v('offlineModeBanner');
  String get adminModeration => _v('adminModeration');
  String get adminModerationHint => _v('adminModerationHint');
  String get reviewListings => _v('reviewListings');
  String get reviewKyc => _v('reviewKyc');
  String get approve => _v('approve');
  String get banCompany => _v('banCompany');
  String get fleetAssign => _v('fleetAssign');
  String get fleetAssignHint => _v('fleetAssignHint');
  String get assignDriver => _v('assignDriver');
  String get driverAssigned => _v('driverAssigned');
  String get activeAssignments => _v('activeAssignments');
  String get unassigned => _v('unassigned');
  String get eSignature => _v('eSignature');
  String get eSignatureHint => _v('eSignatureHint');
  String get signBelow => _v('signBelow');
  String get clear => _v('clear');
  String get confirmSignature => _v('confirmSignature');
  String get signatureSaved => _v('signatureSaved');
  String get signed => _v('signed');
  String get signedAt => _v('signedAt');
  String get liveGps => _v('liveGps');
  String get liveGpsHint => _v('liveGpsHint');
  String get locating => _v('locating');
  String get locationDenied => _v('locationDenied');
  String get gpsLive => _v('gpsLive');
  String get refreshLocation => _v('refreshLocation');
  String get openOsmMap => _v('openOsmMap');
  String get lastUpdate => _v('lastUpdate');
  String get fcmTokenRegistered => _v('fcmTokenRegistered');
  String get registerShipper => _v('registerShipper');
  String get registerCarrier => _v('registerCarrier');
  String get invalidEmail => _v('invalidEmail');
  String get passwordRequired => _v('passwordRequired');
  String get passwordTooShort => _v('passwordTooShort');
  String get passwordNeedUpper => _v('passwordNeedUpper');
  String get passwordNeedLower => _v('passwordNeedLower');
  String get passwordNeedDigit => _v('passwordNeedDigit');
  String get passwordNeedSpecial => _v('passwordNeedSpecial');
  String get passwordMismatch => _v('passwordMismatch');
  String get passwordRulesHint => _v('passwordRulesHint');
  String get acceptLegalPrefix => _v('acceptLegalPrefix');
  String get acceptLegalRequired => _v('acceptLegalRequired');
  String get privacyPolicy => _v('privacyPolicy');
  String get termsOfUse => _v('termsOfUse');
  String get kvkkNotice => _v('kvkkNotice');
  String get aboutUs => _v('aboutUs');
  String get pricing => _v('pricing');
  String get aboutAndPricing => _v('aboutAndPricing');
  String get privacyBody => _v('privacyBody');
  String get termsBody => _v('termsBody');
  String get kvkkBody => _v('kvkkBody');
  String get aboutBody => _v('aboutBody');
  String get pricingBody => _v('pricingBody');
  String get howItWorks => _v('howItWorks');
  String get howItWorksIntro => _v('howItWorksIntro');
  String get howItWorksHomeHint => _v('howItWorksHomeHint');
  String get howStep1ShipperTitle => _v('howStep1ShipperTitle');
  String get howStep1ShipperBody => _v('howStep1ShipperBody');
  String get howStep2ShipperTitle => _v('howStep2ShipperTitle');
  String get howStep2ShipperBody => _v('howStep2ShipperBody');
  String get howStep3ShipperTitle => _v('howStep3ShipperTitle');
  String get howStep3ShipperBody => _v('howStep3ShipperBody');
  String get howStep1CarrierTitle => _v('howStep1CarrierTitle');
  String get howStep1CarrierBody => _v('howStep1CarrierBody');
  String get howStep2CarrierTitle => _v('howStep2CarrierTitle');
  String get howStep2CarrierBody => _v('howStep2CarrierBody');
  String get howStep3CarrierTitle => _v('howStep3CarrierTitle');
  String get howStep3CarrierBody => _v('howStep3CarrierBody');
  String get trustSafety => _v('trustSafety');
  String get trustSafetyIntro => _v('trustSafetyIntro');
  String get trustVerifyTitle => _v('trustVerifyTitle');
  String get trustVerifyBody => _v('trustVerifyBody');
  String get trustEscrowTitle => _v('trustEscrowTitle');
  String get trustEscrowBody => _v('trustEscrowBody');
  String get trustMatchTitle => _v('trustMatchTitle');
  String get trustMatchBody => _v('trustMatchBody');
  String get trustClaimsTitle => _v('trustClaimsTitle');
  String get trustClaimsBody => _v('trustClaimsBody');
  String get supportFaq => _v('supportFaq');
  String get supportIntro => _v('supportIntro');
  String get contactUs => _v('contactUs');
  String get supportEmail => _v('supportEmail');
  String get supportWhatsapp => _v('supportWhatsapp');
  String get faqTitle => _v('faqTitle');
  String get faq1Q => _v('faq1Q');
  String get faq1A => _v('faq1A');
  String get faq2Q => _v('faq2Q');
  String get faq2A => _v('faq2A');
  String get faq3Q => _v('faq3Q');
  String get faq3A => _v('faq3A');
  String get faq4Q => _v('faq4Q');
  String get faq4A => _v('faq4A');
  String get faq5Q => _v('faq5Q');
  String get faq5A => _v('faq5A');
  String get matches => _v('matches');
  String get noMatchesYet => _v('noMatchesYet');
  String get noMatchesHint => _v('noMatchesHint');
  String get editProfile => _v('editProfile');
  String get requiredField => _v('requiredField');
  String get addVehicle => _v('addVehicle');
  String get editVehicle => _v('editVehicle');
  String get addVehicleHint => _v('addVehicleHint');
  String get delete => _v('delete');
  String get takePhoto => _v('takePhoto');
  String get chooseGallery => _v('chooseGallery');
  String get chooseFile => _v('chooseFile');
  String get documentSubmitted => _v('documentSubmitted');
  String get verificationWizardHint => _v('verificationWizardHint');
  String get verifyIdentity => _v('verifyIdentity');
  String get verifyBusiness => _v('verifyBusiness');
  String get verifyTax => _v('verifyTax');
  String get verifyInsurance => _v('verifyInsurance');
  String get verifyLicenseDoc => _v('verifyLicenseDoc');
  String get verifyVehicleDoc => _v('verifyVehicleDoc');
  String get pushNotifications => _v('pushNotifications');
  String get pushNotificationsHint => _v('pushNotificationsHint');
  String get paymentTimeline => _v('paymentTimeline');
  String get paymentTimelineBody => _v('paymentTimelineBody');
  String get waitingDeliveryRelease => _v('waitingDeliveryRelease');
  String get mapDisclaimer => _v('mapDisclaimer');
  String get factoryName => _v('factoryName');
  String get contactPhone => _v('contactPhone');
  String get weightTons => _v('weightTons');
  String get pickupDateTime => _v('pickupDateTime');
  String get deliveryDateTime => _v('deliveryDateTime');
  String get createLoadIntro => _v('createLoadIntro');
  String get shipperLoadBasics => _v('shipperLoadBasics');
  String get countryCode => _v('countryCode');
  String get city => _v('city');
  String get schedule => _v('schedule');
  String get extraLoadDetails => _v('extraLoadDetails');
  String get extraLoadDetailsHint => _v('extraLoadDetailsHint');
  String get loadPublishedHint => _v('loadPublishedHint');
  String get browseEuropeLoads => _v('browseEuropeLoads');
  String get europeLoadBoard => _v('europeLoadBoard');
  String get europeLoadBoardHint => _v('europeLoadBoardHint');
  String get locationFilter => _v('locationFilter');
  String get locationFilterHint => _v('locationFilterHint');
  String get country => _v('country');
  String get regionState => _v('regionState');
  String get allCountries => _v('allCountries');
  String get allRegions => _v('allRegions');
  String get allCities => _v('allCities');
  String get shipperCompanies => _v('shipperCompanies');
  String get shipperCompaniesHint => _v('shipperCompaniesHint');
  String get factories => _v('factories');
  String get companyNamePublish => _v('companyNamePublish');
  String get shipperTools => _v('shipperTools');
  String get shipperToolsHint => _v('shipperToolsHint');
  String get routeTemplates => _v('routeTemplates');
  String get republishFromTemplate => _v('republishFromTemplate');
  String get republishLoad => _v('republishLoad');
  String get templates => _v('templates');
  String get compareOffers => _v('compareOffers');
  String get compareOffersHint => _v('compareOffersHint');
  String get compareOffersEmpty => _v('compareOffersEmpty');
  String get transitTime => _v('transitTime');
  String get favorite => _v('favorite');
  String get activeTracking => _v('activeTracking');
  String get escrowSummary => _v('escrowSummary');
  String get billingInfo => _v('billingInfo');
  String get invoiceEmail => _v('invoiceEmail');
  String get favoriteCarriers => _v('favoriteCarriers');
  String get notificationPrefs => _v('notificationPrefs');
  String get notifyNewOffers => _v('notifyNewOffers');
  String get notifyCounters => _v('notifyCounters');
  String get notifyMatches => _v('notifyMatches');
  String get batchLoads => _v('batchLoads');
  String get batchLoadsHint => _v('batchLoadsHint');
  String get batchCount => _v('batchCount');
  String get publishBatch => _v('publishBatch');
  String get batchPublished => _v('batchPublished');
  String get contractTemplates => _v('contractTemplates');
  String get contractTemplateBody => _v('contractTemplateBody');
  String get ratings => _v('ratings');
  String get rateDeliveryHint => _v('rateDeliveryHint');
  String get submitRating => _v('submitRating');
  String get apiErp => _v('apiErp');
  String get apiErpHint => _v('apiErpHint');
  String get erpEndpoint => _v('erpEndpoint');
  String get liveMapMock => _v('liveMapMock');
  String get liveMapMockHint => _v('liveMapMockHint');
  String get eta => _v('eta');
  String get delayAlert => _v('delayAlert');
  String get awaitingCmr => _v('awaitingCmr');
  String get openTracking => _v('openTracking');
  String get unverifiedPublishWarning => _v('unverifiedPublishWarning');
  String get contactPerson => _v('contactPerson');
  String get doorRamp => _v('doorRamp');
  String get referenceNo => _v('referenceNo');
  String get palletCount => _v('palletCount');
  String get specialRequirements => _v('specialRequirements');
  String get reqAdr => _v('reqAdr');
  String get reqColdChain => _v('reqColdChain');
  String get reqTailLift => _v('reqTailLift');
  String get reqForklift => _v('reqForklift');
  String get saveAsTemplate => _v('saveAsTemplate');
  String get editLoad => _v('editLoad');
  String get unpublishLoad => _v('unpublishLoad');
  String get statusUnpublished => _v('statusUnpublished');
  String get favoritesOnly => _v('favoritesOnly');
  String get favoritesOnlyHint => _v('favoritesOnlyHint');
  String get favoritesOnlyFilter => _v('favoritesOnlyFilter');
  String get adrLoadsFilter => _v('adrLoadsFilter');
  String get sortPriceAsc => _v('sortPriceAsc');
  String get sortPriceDesc => _v('sortPriceDesc');
  String get sortTrust => _v('sortTrust');
  String get sortSla => _v('sortSla');
  String get sortNewest => _v('sortNewest');
  String get offerSlaHours => _v('offerSlaHours');
  String get slaUntil => _v('slaUntil');
  String get slaExpired => _v('slaExpired');
  String get rejectOffer => _v('rejectOffer');
  String get rejectReason => _v('rejectReason');
  String get loadPhotos => _v('loadPhotos');
  String get addPhoto => _v('addPhoto');
  String get claims => _v('claims');
  String get openClaim => _v('openClaim');
  String get claimDelay => _v('claimDelay');
  String get claimDamage => _v('claimDamage');
  String get claimPayment => _v('claimPayment');
  String get paymentLedger => _v('paymentLedger');
  String get simulatePayout => _v('simulatePayout');
  String get eInvoice => _v('eInvoice');
  String get invoiceLanguage => _v('invoiceLanguage');
  String get sendEInvoice => _v('sendEInvoice');
  String get eInvoiceSent => _v('eInvoiceSent');
  String get reports => _v('reports');
  String get monthlySpend => _v('monthlySpend');
  String get activeListings => _v('activeListings');
  String get matchedLoads => _v('matchedLoads');
  String get corridorSpend => _v('corridorSpend');
  String get dispatcherPermissions => _v('dispatcherPermissions');
  String get dispatcherPermissionsHint => _v('dispatcherPermissionsHint');
  String get permPublish => _v('permPublish');
  String get permAcceptOffers => _v('permAcceptOffers');
  String get permManagePayments => _v('permManagePayments');
  String get permInviteTeam => _v('permInviteTeam');
  String get noPublishPermission => _v('noPublishPermission');
  String get pushSimulation => _v('pushSimulation');
  String get pushSimulationHint => _v('pushSimulationHint');
  String get simulateNewOfferPush => _v('simulateNewOfferPush');
  String get simulateMatchPush => _v('simulateMatchPush');
  String get pushDelivered => _v('pushDelivered');
  String get liveMapOsm => _v('liveMapOsm');
  String get gpsLiveHint => _v('gpsLiveHint');
  String get suitedLoadNotification => _v('suitedLoadNotification');
  String get statusInTransit => _v('statusInTransit');
  String get nearbyLoads => _v('nearbyLoads');

  String docStatus(String status) => switch (status.toUpperCase()) {
        'APPROVED' => _v('docApproved'),
        'PENDING' => _v('docPending'),
        'REJECTED' => _v('docRejected'),
        _ => _v('docMissing'),
      };

  String trackLabel(String code) => switch (code.toUpperCase()) {
        'ACCEPTED' => _v('trackAccepted'),
        'PICKED_UP' => _v('trackPickedUp'),
        'IN_TRANSIT' => _v('trackInTransit'),
        'DELIVERED' => _v('trackDelivered'),
        _ => code,
      };

  String paymentStatus(String status) => switch (status.toUpperCase()) {
        'HELD' => _v('payHeld'),
        'RELEASED' => _v('payReleased'),
        'PAID' => _v('payPaid'),
        _ => _v('payPending'),
      };

  String teamRole(String role) => switch (role.toUpperCase()) {
        'ADMIN' => _v('roleAdmin'),
        'DISPATCHER' => _v('roleDispatcher'),
        'DRIVER' => _v('roleDriverMember'),
        _ => role,
      };

  String availableInHours(int hours) => locale.languageCode == 'tr'
      ? '$hours saat müsait'
      : locale.languageCode == 'de'
          ? '$hours Std. verfügbar'
          : locale.languageCode == 'pl'
              ? 'dostępny $hours godz.'
              : locale.languageCode == 'fr'
                  ? 'dispo ${hours}h'
                  : '$hours h free';

  String welcomeUser(String name) => switch (locale.languageCode) {
        'tr' => 'Merhaba, $name',
        'de' => 'Hallo, $name',
        'pl' => 'Cześć, $name',
        'fr' => 'Bonjour, $name',
        _ => 'Hello, $name',
      };

  String statusLabel(String status) => switch (status.toUpperCase()) {
        'PUBLISHED' => statusPublished,
        'MATCHED' => statusMatched,
        'COMPLETED' => statusCompleted,
        'PENDING' => statusPending,
        'ACCEPTED' => statusAccepted,
        'REJECTED' => statusRejected,
        'COUNTERED' => statusCountered,
        'ACTIVE' => statusActive,
        'IN_TRANSIT' => statusInTransit,
        'UNPUBLISHED' => statusUnpublished,
        _ => status,
      };
  String get activeOffers => _v('activeOffers');
  String get wonJobs => _v('wonJobs');
  String get vehicleStatus => _v('vehicleStatus');
  String get recommendedLoads => _v('recommendedLoads');
  String get availableLoads => _v('availableLoads');
  String get loadDetail => _v('loadDetail');
  String get submitOffer => _v('submitOffer');
  String get incomingOffers => _v('incomingOffers');
  String get accept => _v('accept');
  String get reject => _v('reject');
  String get amount => _v('amount');
  String get currency => _v('currency');
  String get message => _v('message');
  String get vehicles => _v('vehicles');
  String get verification => _v('verification');
  String get verified => _v('verified');
  String get pending => _v('pending');
  String get companyProfile => _v('companyProfile');
  String get driverProfile => _v('driverProfile');
  String get pickup => _v('pickup');
  String get dropoff => _v('dropoff');
  String get weight => _v('weight');
  String get vehicleType => _v('vehicleType');
  String get loadType => _v('loadType');
  String get loadDate => _v('loadDate');
  String get deliveryDate => _v('deliveryDate');
  String get status => _v('status');
  String get retry => _v('retry');
  String get noData => _v('noData');
  String get offlineOrError => _v('offlineOrError');
  String get save => _v('save');
  String get next => _v('next');
  String get back => _v('back');
  String get title => _v('title');
  String get description => _v('description');
  String get plate => _v('plate');
  String get capacity => _v('capacity');

  String roleLabel(String role) => switch (role) {
        'shipper' => roleShipper,
        'logisticsCompany' => roleLogistics,
        'independentDriver' => roleDriver,
        'fleetOwner' => roleFleet,
        _ => role,
      };
}

class _Delegate extends LocalizationsDelegate<AppLocalizations> {
  const _Delegate();

  @override
  bool isSupported(Locale locale) => ['en', 'tr', 'de', 'pl', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
