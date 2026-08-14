/// Country -> region (state/eyalet/il) -> city/district hierarchy for Europe + Turkiye.
class EuropeGeo {
  static const all = '__all__';

  static const countries = <String>[
    'TR', 'DE', 'FR', 'NL', 'BE', 'LU', 'PL', 'IT', 'AT', 'CH', 'CZ', 'HU', 'SK', 'RO', 'BG', 'GR',
    'ES', 'PT', 'NO', 'SE', 'DK', 'FI', 'GB', 'IE', 'HR', 'SI', 'RS', 'UA',
  ];

  static final regionsByCountry = <String, List<String>>{
    'TR': const ['Marmara', 'Ege', 'Akdeniz', 'Ic Anadolu', 'Karadeniz', 'Dogu Anadolu', 'Guneydogu Anadolu'],
    'DE': const ['Bavaria', 'Berlin', 'North Rhine-Westphalia', 'Hamburg', 'Hesse', 'Baden-Wurttemberg', 'Saxony'],
    'FR': const ['Auvergne-Rhone-Alpes', 'Ile-de-France', 'Provence-Alpes-Cote d\'Azur', 'Hauts-de-France', 'Grand Est'],
    'NL': const ['South Holland', 'North Holland', 'North Brabant', 'Utrecht'],
    'BE': const ['Flanders', 'Wallonia', 'Brussels'],
    'LU': const ['Luxembourg'],
    'PL': const ['Masovian', 'Lesser Poland', 'Silesian', 'Pomeranian'],
    'IT': const ['Lombardy', 'Veneto', 'Lazio', 'Piedmont', 'Emilia-Romagna'],
    'AT': const ['Vienna', 'Tyrol', 'Salzburg', 'Upper Austria'],
    'CH': const ['Zurich', 'Geneva', 'Bern'],
    'CZ': const ['Prague', 'Central Bohemia', 'South Moravia'],
    'HU': const ['Budapest', 'Central Hungary', 'Pest'],
    'SK': const ['Bratislava', 'Kosice'],
    'RO': const ['Bucharest', 'Cluj', 'Timis'],
    'BG': const ['Sofia City', 'Plovdiv', 'Varna'],
    'GR': const ['Attica', 'Central Macedonia', 'Crete'],
    'ES': const ['Madrid', 'Catalonia', 'Andalusia', 'Valencia'],
    'PT': const ['Lisbon', 'Porto', 'Algarve'],
    'NO': const ['Oslo', 'Vestland', 'Viken', 'Trondelag', 'Rogaland'],
    'SE': const ['Stockholm', 'Vastra Gotaland', 'Skane'],
    'DK': const ['Capital Region', 'Central Denmark', 'Southern Denmark'],
    'FI': const ['Uusimaa', 'Pirkanmaa', 'Southwest Finland'],
    'GB': const ['England', 'Scotland', 'Wales'],
    'IE': const ['Leinster', 'Munster', 'Connacht'],
    'HR': const ['Zagreb', 'Split-Dalmatia'],
    'SI': const ['Central Slovenia', 'Drava'],
    'RS': const ['Belgrade', 'Vojvodina'],
    'UA': const ['Kyiv', 'Lviv', 'Odesa'],
  };

  static final citiesByRegion = <String, List<String>>{
    'Marmara': const [
      'Istanbul', 'Tekirdag', 'Edirne', 'Kirklareli', 'Balikesir', 'Canakkale', 'Bursa', 'Bilecik', 'Kocaeli', 'Sakarya', 'Yalova',
    ],
    'Ege': const ['Izmir', 'Aydin', 'Manisa', 'Mugla', 'Afyonkarahisar', 'Kutahya', 'Denizli', 'Usak'],
    'Akdeniz': const ['Antalya', 'Adana', 'Mersin', 'Hatay', 'Isparta', 'Burdur', 'Osmaniye', 'Kahramanmaras'],
    'Ic Anadolu': const [
      'Ankara', 'Konya', 'Kayseri', 'Eskisehir', 'Sivas', 'Yozgat', 'Nevsehir', 'Nigde', 'Aksaray', 'Kirsehir', 'Kirikkale', 'Cankiri', 'Karaman',
    ],
    'Karadeniz': const [
      'Samsun', 'Trabzon', 'Ordu', 'Giresun', 'RIZE', 'Artvin', 'Gumushane', 'Bayburt', 'Amasya', 'Tokat', 'Corum', 'Sinop',
      'Kastamonu', 'Zonguldak', 'Bartin', 'Karabuk', 'Duzce', 'Bolu',
    ],
    'Dogu Anadolu': const [
      'Erzurum', 'Erzincan', 'Agri', 'Kars', 'Igdir', 'Ardahan', 'Malatya', 'Elazig', 'Tunceli', 'Bingol', 'Mus', 'Bitlis', 'Van', 'Hakkari',
    ],
    'Guneydogu Anadolu': const [
      'Gaziantep', 'Sanliurfa', 'Diyarbakir', 'Mardin', 'Batman', 'Siirt', 'Sirnak', 'Adiyaman', 'Kilis',
    ],
    'Bavaria': const ['Munich', 'Nuremberg', 'Augsburg'],
    'Berlin': const ['Berlin'],
    'North Rhine-Westphalia': const ['Cologne', 'Dusseldorf', 'Dortmund'],
    'Hamburg': const ['Hamburg'],
    'Hesse': const ['Frankfurt'],
    'Baden-Wurttemberg': const ['Stuttgart'],
    'Saxony': const ['Dresden', 'Leipzig'],
    'Auvergne-Rhone-Alpes': const ['Lyon', 'Grenoble'],
    'Ile-de-France': const ['Paris'],
    'Provence-Alpes-Cote d\'Azur': const ['Marseille', 'Nice'],
    'Hauts-de-France': const ['Lille'],
    'Grand Est': const ['Strasbourg'],
    'South Holland': const ['Rotterdam', 'The Hague'],
    'North Holland': const ['Amsterdam'],
    'North Brabant': const ['Eindhoven'],
    'Utrecht': const ['Utrecht'],
    'Flanders': const ['Antwerp', 'Ghent', 'Bruges'],
    'Wallonia': const ['Liege', 'Namur'],
    'Brussels': const ['Brussels'],
    'Luxembourg': const ['Luxembourg'],
    'Masovian': const ['Warsaw'],
    'Lesser Poland': const ['Krakow'],
    'Silesian': const ['Katowice'],
    'Pomeranian': const ['Gdansk'],
    'Lombardy': const ['Milan', 'Bergamo'],
    'Veneto': const ['Venice', 'Verona'],
    'Lazio': const ['Rome'],
    'Piedmont': const ['Turin'],
    'Emilia-Romagna': const ['Bologna'],
    'Vienna': const ['Vienna'],
    'Tyrol': const ['Innsbruck'],
    'Salzburg': const ['Salzburg'],
    'Upper Austria': const ['Linz'],
    'Zurich': const ['Zurich'],
    'Geneva': const ['Geneva'],
    'Bern': const ['Bern'],
    'Prague': const ['Prague'],
    'Central Bohemia': const ['Kladno'],
    'South Moravia': const ['Brno'],
    'Budapest': const ['Budapest'],
    'Central Hungary': const ['Budapest'],
    'Pest': const ['Erd'],
    'Bratislava': const ['Bratislava'],
    'Kosice': const ['Kosice'],
    'Bucharest': const ['Bucharest'],
    'Cluj': const ['Cluj-Napoca'],
    'Timis': const ['Timisoara'],
    'Sofia City': const ['Sofia'],
    'Plovdiv': const ['Plovdiv'],
    'Varna': const ['Varna'],
    'Attica': const ['Athens'],
    'Central Macedonia': const ['Thessaloniki'],
    'Crete': const ['Heraklion'],
    'Madrid': const ['Madrid'],
    'Catalonia': const ['Barcelona'],
    'Andalusia': const ['Seville', 'Malaga'],
    'Valencia': const ['Valencia'],
    'Lisbon': const ['Lisbon'],
    'Porto': const ['Porto'],
    'Algarve': const ['Faro'],
    'Oslo': const ['Oslo'],
    'Vestland': const ['Bergen', 'Alesund'],
    'Viken': const ['Drammen', 'Fredrikstad'],
    'Trondelag': const ['Trondheim'],
    'Rogaland': const ['Stavanger'],
    'Stockholm': const ['Stockholm'],
    'Vastra Gotaland': const ['Gothenburg'],
    'Skane': const ['Malmo'],
    'Capital Region': const ['Copenhagen'],
    'Central Denmark': const ['Aarhus'],
    'Southern Denmark': const ['Odense'],
    'Uusimaa': const ['Helsinki'],
    'Pirkanmaa': const ['Tampere'],
    'Southwest Finland': const ['Turku'],
    'England': const ['London', 'Manchester', 'Birmingham'],
    'Scotland': const ['Edinburgh', 'Glasgow'],
    'Wales': const ['Cardiff'],
    'Leinster': const ['Dublin'],
    'Munster': const ['Cork'],
    'Connacht': const ['Galway'],
    'Zagreb': const ['Zagreb'],
    'Split-Dalmatia': const ['Split'],
    'Central Slovenia': const ['Ljubljana'],
    'Drava': const ['Maribor'],
    'Belgrade': const ['Belgrade'],
    'Vojvodina': const ['Novi Sad'],
    'Kyiv': const ['Kyiv'],
    'Lviv': const ['Lviv'],
    'Odesa': const ['Odesa'],
  };

  static final Map<String, String> cityToRegion = () {
    final map = <String, String>{};
    citiesByRegion.forEach((region, cities) {
      for (final city in cities) {
        map.putIfAbsent(city, () => region);
      }
    });
    map['Izmir'] = 'Ege';
    map['Milan'] = 'Lombardy';
    return map;
  }();

  static List<String> regionsFor(String? country) {
    if (country == null || country == all) return const [];
    return regionsByCountry[country] ?? const [];
  }

  static List<String> citiesFor({String? country, String? region}) {
    if (region != null && region != all) {
      return List<String>.of(citiesByRegion[region] ?? const []).toSet().toList()..sort();
    }
    if (country == null || country == all) return const [];
    final regions = regionsFor(country);
    return regions.expand((r) => citiesByRegion[r] ?? const <String>[]).toSet().toList()..sort();
  }

  static String? regionOf(String city) => cityToRegion[city];

  static String countryLabel(String code) => switch (code) {
        'TR' => 'Turkiye (TR)',
        'DE' => 'Germany (DE)',
        'FR' => 'France (FR)',
        'NL' => 'Netherlands (NL)',
        'BE' => 'Belgium (BE)',
        'LU' => 'Luxembourg (LU)',
        'PL' => 'Poland (PL)',
        'IT' => 'Italy (IT)',
        'AT' => 'Austria (AT)',
        'CH' => 'Switzerland (CH)',
        'CZ' => 'Czechia (CZ)',
        'HU' => 'Hungary (HU)',
        'SK' => 'Slovakia (SK)',
        'RO' => 'Romania (RO)',
        'BG' => 'Bulgaria (BG)',
        'GR' => 'Greece (GR)',
        'ES' => 'Spain (ES)',
        'PT' => 'Portugal (PT)',
        'NO' => 'Norway (NO)',
        'SE' => 'Sweden (SE)',
        'DK' => 'Denmark (DK)',
        'FI' => 'Finland (FI)',
        'GB' => 'United Kingdom (GB)',
        'IE' => 'Ireland (IE)',
        'HR' => 'Croatia (HR)',
        'SI' => 'Slovenia (SI)',
        'RS' => 'Serbia (RS)',
        'UA' => 'Ukraine (UA)',
        _ => code,
      };
}
