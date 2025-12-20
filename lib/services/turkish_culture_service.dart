/// Turkish Culture Service
/// 
/// Provides random information about Turkish history, science, art, and historical Turkish states
/// 
/// @author Alpay Bilgiç
library;

import 'dart:math';

/// Turkish culture information data
class TurkishCultureService {
  static final Random _random = Random();
  
  /// Turkish historical figures and achievements in science and art
  static final List<Map<String, String>> _turkishFigures = [
    {
      'name': 'İbn-i Sina',
      'info': 'Tıp alanında "El-Kanun fi\'t-Tıb" adlı eseriyle Orta Çağ\'ın en önemli tıp ansiklopedisini yazdı. Avicenna olarak bilinen bu büyük bilim insanı, modern tıbbın temellerini attı.',
    },
    {
      'name': 'Ali Kuşçu',
      'info': '15. yüzyılda matematik ve astronomi alanında çığır açan çalışmalar yaptı. Fatih Sultan Mehmet\'in davetiyle İstanbul\'a geldi ve medreselerde ders verdi.',
    },
    {
      'name': 'Uluğ Bey',
      'info': 'Timur İmparatorluğu\'nun hükümdarı ve büyük bir astronom. Semerkant\'ta kurduğu rasathanede yıldız katalogları hazırladı. "Zic-i Uluğ Bey" adlı eseri yüzyıllarca kullanıldı.',
    },
    {
      'name': 'Farabi',
      'info': 'İslam felsefesinin kurucularından. "İkinci Öğretmen" unvanıyla anıldı. Müzik teorisi, mantık ve siyaset felsefesi alanlarında önemli eserler verdi.',
    },
    {
      'name': 'Mimar Sinan',
      'info': 'Osmanlı İmparatorluğu\'nun baş mimarı. 300\'den fazla eser verdi. Süleymaniye ve Selimiye camileri gibi dünya mimarlık tarihine geçen eserler yarattı.',
    },
    {
      'name': 'Evliya Çelebi',
      'info': '17. yüzyılın büyük seyyahı. "Seyahatname" adlı 10 ciltlik eseriyle Osmanlı coğrafyasını ve kültürünü kayıt altına aldı. Dünya seyahat edebiyatının önemli isimlerinden.',
    },
    {
      'name': 'Katip Çelebi',
      'info': 'Osmanlı\'nın önemli coğrafyacı ve tarihçisi. "Cihannüma" adlı coğrafya eseri ve "Keşfü\'z-Zünun" bibliyografya eseriyle tanınır.',
    },
    {
      'name': 'Piri Reis',
      'info': 'Osmanlı denizcisi ve haritacı. 1513 yılında çizdiği dünya haritası, Amerika kıtasının en eski haritalarından biri olarak kabul edilir.',
    },
    {
      'name': 'Cahit Arf',
      'info': 'Türk matematikçi. "Arf Sabiti" ve "Arf Halkaları" teorisiyle matematik dünyasında önemli bir yer edindi. Modern cebir ve sayılar teorisine katkıları büyüktür.',
    },
    {
      'name': 'Aziz Sancar',
      'info': '2015 Nobel Kimya Ödülü sahibi. DNA onarım mekanizmalarını keşfetti. Türkiye\'den Nobel alan ilk bilim insanı.',
    },
    {
      'name': 'Fazıl Say',
      'info': 'Dünya çapında tanınan piyanist ve besteci. Klasik müzik alanında önemli eserler verdi ve birçok uluslararası ödül kazandı.',
    },
    {
      'name': 'Yunus Emre',
      'info': '13. yüzyıl Türk şairi ve mutasavvıf. Türkçe şiirin öncülerinden. "Risaletü\'n-Nushiyye" ve "Divan" adlı eserleriyle tanınır.',
    },
    {
      'name': 'Mehmet Akif Ersoy',
      'info': 'İstiklal Marşı\'nın şairi. Milli mücadele döneminde yazdığı şiirlerle Türk edebiyatının önemli isimlerinden biri oldu.',
    },
    {
      'name': 'Nazım Hikmet',
      'info': '20. yüzyılın önemli şairlerinden. Türk şiirinde serbest ölçüyü yaygınlaştırdı. "Memleketimden İnsan Manzaraları" gibi büyük eserler verdi.',
    },
    {
      'name': 'Osman Hamdi Bey',
      'info': 'Türk ressam, arkeolog ve müzeci. İlk Türk arkeoloğu. "Kaplumbağa Terbiyecisi" gibi ünlü tablolarıyla tanınır.',
    },
  ];
  
  /// Historical Turkish states with years and flag emojis
  static final List<Map<String, String>> _turkishStates = [
    {
      'name': 'Göktürk Kağanlığı',
      'years': '552-744',
      'flag': '🏹',
      'info': 'Orta Asya\'da kurulan ilk Türk devleti. Türk adını kullanan ilk devlet. Doğu ve Batı olmak üzere ikiye ayrıldı.',
    },
    {
      'name': 'Uygur Kağanlığı',
      'years': '744-840',
      'flag': '🦅',
      'info': 'Göktürklerden sonra Orta Asya\'da kurulan Türk devleti. Tarım ve ticaretle gelişti. Maniheizm dinini benimsedi.',
    },
    {
      'name': 'Karahanlılar',
      'years': '840-1212',
      'flag': '⚔️',
      'info': 'İslam\'ı kabul eden ilk Türk devleti. Türk-İslam kültürünün gelişmesinde önemli rol oynadı. Kaşgar ve Semerkant merkezliydi.',
    },
    {
      'name': 'Gazneliler',
      'years': '963-1186',
      'flag': '🛡️',
      'info': 'Hindistan\'a kadar genişleyen Türk devleti. Sultan Mahmud döneminde en parlak çağını yaşadı. Fars ve Türk kültürünü birleştirdi.',
    },
    {
      'name': 'Büyük Selçuklu İmparatorluğu',
      'years': '1037-1194',
      'flag': '👑',
      'info': 'Anadolu\'nun kapılarını Türklere açan devlet. Malazgirt Zaferi ile Anadolu\'nun fethi başladı. Nizamiye Medreseleri kuruldu.',
    },
    {
      'name': 'Anadolu Selçuklu Devleti',
      'years': '1077-1308',
      'flag': '🏛️',
      'info': 'Anadolu\'da kurulan ilk Türk devleti. Konya merkezli. Çifte Minareli Medrese, İnce Minareli Medrese gibi eserler bıraktı.',
    },
    {
      'name': 'Osmanlı İmparatorluğu',
      'years': '1299-1922',
      'flag': '🌙',
      'info': 'Üç kıtaya yayılan büyük imparatorluk. 600 yıldan fazla hüküm sürdü. İstanbul\'un fethi ile Orta Çağ\'ı kapattı, Yeni Çağ\'ı açtı.',
    },
    {
      'name': 'Timur İmparatorluğu',
      'years': '1370-1507',
      'flag': '⚡',
      'info': 'Timur tarafından kurulan devlet. Semerkant merkezli. Bilim ve sanat alanında büyük gelişmeler gösterdi.',
    },
    {
      'name': 'Babür İmparatorluğu',
      'years': '1526-1858',
      'flag': '🐘',
      'info': 'Hindistan\'da kurulan Türk devleti. Babür Şah tarafından kuruldu. Tac Mahal gibi dünya çapında eserler bıraktı.',
    },
    {
      'name': 'Altın Orda Devleti',
      'years': '1242-1502',
      'flag': '🐎',
      'info': 'Cengiz Han\'ın torunları tarafından kurulan devlet. Volga bölgesinde hüküm sürdü. Rus prensliklerini etkisi altına aldı.',
    },
    {
      'name': 'Harezmşahlar',
      'years': '1077-1231',
      'flag': '🗡️',
      'info': 'Orta Asya\'da kurulan Türk devleti. Harzem bölgesinde hüküm sürdü. Moğol istilasına kadar güçlü bir devletti.',
    },
    {
      'name': 'Akkoyunlular',
      'years': '1378-1508',
      'flag': '🐑',
      'info': 'Doğu Anadolu ve İran\'da hüküm süren Türk devleti. Uzun Hasan döneminde en güçlü çağını yaşadı.',
    },
  ];
  
  /// Get random Turkish culture information
  /// Returns either a historical figure or a Turkish state
  static Map<String, String> getRandomInfo() {
    // 70% chance for historical figure, 30% for Turkish state
    if (_random.nextDouble() < 0.7) {
      final figure = _turkishFigures[_random.nextInt(_turkishFigures.length)];
      return {
        'type': 'figure',
        'title': figure['name']!,
        'content': figure['info']!,
      };
    } else {
      final state = _turkishStates[_random.nextInt(_turkishStates.length)];
      return {
        'type': 'state',
        'title': '${state['flag']} ${state['name']}',
        'content': '${state['info']!}\n\nYıllar: ${state['years']}',
      };
    }
  }
}

