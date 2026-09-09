# GucLogistics Türkiye–Avrupa Mobil Ürün Yol Haritası

Bu belge, mobil uygulamayı çalışan bir demodan güvenilir bir Türkiye–Avrupa lojistik platformuna dönüştürmek için hazırlanmıştır.

Öncelikler:

- **P0:** Ana ticari akış veya güvenlik için zorunlu
- **P1:** İlk güçlü pazar sürümü için gerekli
- **P2:** Ölçeklenme ve rekabet avantajı

## Pazar ve ana işlem akışı

1. **P0 — Rol bazlı kayıt ve çalışma alanı (geliştir):** Yük veren, lojistik şirketi, filo sahibi ve bağımsız şoför farklı veri ve ekranlarla kaydolmalı. İlk oturumda eksik profil adımları gösterilmeli; kullanıcı yanlış role ait işleme erişememeli.

2. **P0 — Şirket ve taşıyıcı doğrulama merkezi (geliştir):** Vergi/VAT, ticaret sicili, yetki belgesi, sürücü belgesi ve araç ruhsatı doğrulanmalı. Sonuç profilde `Doğrulandı`, `İnceleniyor`, `Süresi doldu` şeklinde görünmeli.

3. **P0 — Akıllı yük oluşturma sihirbazı (geliştir):** Çıkış/varış, tarih aralığı, ağırlık, palet, ölçüler, araç tipi, ADR, sıcaklık, gümrük ve yükleme ekipmanı tek yönlendirilmiş akışta alınmalı. Eksik veya birbiriyle uyumsuz bilgiyle ilan yayımlanmamalı.

4. **P0 — Araç ve şoför bağlı teklif (geliştir):** Her teklif plaka, araç tipi, şoför, telefon, hazır olma zamanı ve tahmini taşıma süresi içermeli. Araç değişirse yük veren bilgilendirilmeli ve yeniden onay istenmeli.

5. **P0 — Otomatik uygunluk kontrolü (yeni):** Araç kapasitesi, kasa tipi, ADR belgesi, soğuk zincir ve tarih uygunluğu yük şartlarıyla karşılaştırılmalı. Uygunsuz teklif engellenmeli veya açık uyarıyla gönderilmeli.

6. **P0 — Güvenli pazarlık ve teklif geçmişi (geliştir):** Her karşı teklif değiştirilemez bir tur olarak saklanmalı; tutar, para birimi, geçerlilik süresi ve tarafı görünmeli. Kabul anındaki son şartlar sözleşmeye sabitlenmeli.

7. **P0 — Eşleşme ve dijital taşıma sözleşmesi (geliştir):** Teklif kabul edilince yük, araç, şoför, fiyat, ödeme şartı ve iptal koşullarını içeren bir taşıma emri oluşmalı. Her iki taraf zaman damgalı olarak onaylamalı.

8. **P1 — Açıklanabilir akıllı eşleştirme (yeni):** Sistem yükleri yalnızca yakınlığa göre değil; rota, araç, boş kilometre, evrak, puan ve takvime göre sıralamalı. Kullanıcı “neden %92 uygun?” açıklamasını görebilmeli.

9. **P1 — Koridor ve talep ısı haritası (geliştir):** İstanbul–Almanya, Bursa–Benelüks gibi koridorlarda yük yoğunluğu, ortalama fiyat ve bekleme süresi gösterilmeli. Kesin şirket konumları gizlenerek toplulaştırılmış veri kullanılmalı.

10. **P1 — Dönüş yükü ve zincirleme sefer planı (geliştir):** Teslimat noktasına yakın dönüş yükleri otomatik önerilmeli. İki veya üç yük birleştirildiğinde toplam gelir, boş kilometre ve tahmini kâr gösterilmeli.

## Evrak ve mevzuat

11. **P0 — e‑CMR ve teslimat kanıtı (yeni):** Gönderici, taşıyıcı ve alıcı bilgileriyle elektronik CMR oluşturulmalı; imza, fotoğraf, teslim zamanı ve değişiklik geçmişi bütünlüğü korunarak saklanmalı.

12. **P1 — eFTI uyum katmanı (yeni):** Veri modeli eFTI ortak veri kümelerine hazırlanmalı; yetkili kontrolünde QR veya benzersiz erişim bağlantısıyla yalnızca istenen bilgi paylaşılmalı. Hedef, 9 Temmuz 2027 tam uygulama tarihinden önce sertifikasyon mimarisine hazır olmaktır.

13. **P0 — Gümrük ve sınır evrak kasası (yeni):** Fatura, paketleme listesi, MRN/T1, menşe, CMR ve izinler sefer bazında tutulmalı. Sınır geçişinde çevrimdışı görüntülenebilen, yetki kontrollü bir belge paketi olmalı.

14. **P1 — OCR ve belge süre takibi (yeni):** Ruhsat, sigorta, muayene, SRC/ehliyet ve yetki belgelerinden alanlar otomatik okunmalı. Süre dolmadan 30/7/1 gün bildirim gönderilmeli ve süresi dolan araç teklif verememeli.

15. **P1 — Sürücü görevlendirme/ülke kural asistanı (yeni):** Sefer türüne göre sürücü görevlendirme beyanı ve istenebilecek belgeler kontrol listesi oluşturulmalı. Hukuki karar vermek yerine resmi portallara yönlendiren ülke bazlı uyum yardımcısı olmalı.

16. **P1 — Sürüş ve dinlenme süresi planı (yeni):** Planlanan rota mevcut sürüş süresiyle karşılaştırılmalı; gerçekçi olmayan ETA veya dinlenme ihlali riski gösterilmeli. Takograf entegrasyonu daha sonra bağlanabilecek biçimde tasarlanmalı.

## Sefer operasyonu

17. **P0 — Canlı GPS, geofence ve güvenilir ETA (geliştir):** Konum yalnızca aktif sefer sırasında ve açık rızayla paylaşılmalı. Yükleme, sınır ve teslim noktalarına giriş/çıkış otomatik olay üretmeli; ETA trafik ve mola bilgisiyle güncellenmeli.

18. **P0 — Şoför için çevrimdışı çalışma (geliştir):** Aktif sefer, adresler, telefonlar ve evraklar internetsiz açılmalı. Fotoğraf, imza ve durum değişiklikleri kuyruklanıp bağlantı gelince yinelenmeden senkronize edilmeli.

19. **P0 — Yükleme ve teslim kontrol listesi (yeni):** Mühür no, palet sayısı, hasar fotoğrafı, sıcaklık, imza ve teslim alan kişi kaydedilmeli. Zorunlu kanıtlar tamamlanmadan teslim işlemi kapatılamamalı.

20. **P1 — Gecikme, hasar ve uyuşmazlık merkezi (geliştir):** Taraflar olay türü, açıklama, fotoğraf, konum ve tutarla dosya açabilmeli. Mesajlar ve belgeler zaman çizelgesinde korunmalı; çözüm ve itiraz durumu izlenmeli.

## Para, güven ve kalite

21. **P0 — Güvenli ödeme ve aşamalı hakediş (geliştir):** Ödeme sağlayıcısı üzerinden bloke, teslimat kanıtı sonrası serbest bırakma, komisyon ve iade akışları gerçek işlem kimlikleriyle yürütülmeli. API hatasında asla sahte başarılı sonuç gösterilmemeli.

22. **P1 — Çok para birimi, KDV ve e‑fatura (geliştir):** EUR/TRY başta olmak üzere kur tarihi, komisyon, KDV ve net hakediş ayrı gösterilmeli. Türkiye e‑fatura/e‑arşiv ve Avrupa fatura entegrasyonları adaptörlerle ayrılmalı.

23. **P1 — Koridor fiyat zekâsı (geliştir):** Geçmiş kabul edilmiş anonim teklifler, yakıt, mesafe, geçiş ve boş dönüş etkisiyle fiyat aralığı verilmeli. “Öneri” açıkça belirtilmeli; kullanıcı kendi maliyetini düzenleyebilmeli.

24. **P0 — Dolandırıcılık ve hesap riski motoru (yeni):** Aynı cihazdan çoklu hesap, IBAN/şirket uyuşmazlığı, olağan dışı fiyat, sahte evrak ve hesap ele geçirme sinyalleri izlenmeli. Yüksek riskli ödeme ve eşleşme manuel incelemeye alınmalı.

25. **P1 — Kanıta dayalı puan ve itibar (geliştir):** Zamanında yükleme/teslim, iptal, belge tamlığı, hasar ve ödeme davranışı ayrı puanlanmalı. Yorum yalnızca tamamlanan seferden sonra yapılmalı; itiraz ve kötüye kullanım denetimi bulunmalı.

## İletişim, ekip ve büyüme

26. **P1 — Çok dilli sefer sohbeti ve çeviri (yeni):** Türkçe, İngilizce, Almanca, Fransızca ve Lehçe mesajlar isteğe bağlı çevrilmeli. Orijinal metin her zaman erişilebilir olmalı; adres, fiyat ve resmi şartlar otomatik çeviriyle değiştirilmemeli.

27. **P0 — Olay tabanlı bildirim merkezi (geliştir):** Yeni teklif, karşı teklif, kabul, evrak süresi, gecikme, konum sapması ve ödeme için push/e‑posta tercihleri olmalı. Bildirime dokununca doğrudan ilgili yük veya sefere gidilmeli.

28. **P0 — Şirket ekibi, yetki ve denetim kaydı (geliştir):** Yönetici, dispeçer, muhasebe ve şoför yetkileri ayrılmalı. Teklif kabulü, banka değişikliği ve ödeme serbest bırakma gibi kritik işlemler ayrıca kaydedilmeli ve gerekirse çift onay istemeli.

29. **P1 — ERP/TMS, telematik ve açık API merkezi (geliştir):** Yük oluşturma, durum, konum, belge ve fatura için sürümlü API/webhook sağlanmalı. SAP ve yaygın TMS sistemleri için bağlantı şablonları; telematik sağlayıcıları için ortak adaptör arayüzü oluşturulmalı.

30. **P2 — Sefer kârlılığı ve karbon kontrol kulesi (yeni):** Yakıt, otoyol, feribot, sürücü, boş kilometre ve komisyonla tahmini/net kâr hesaplanmalı. Aynı ekranda mesafe temelli emisyon tahmini ve daha düşük boş kilometreli alternatif önerilmelidir.

## Önerilen teslim sırası

- **Aşama 1 — Güvenli işlem çekirdeği:** 1–7, 21, 24, 27, 28
- **Aşama 2 — Gerçek sefer operasyonu:** 13, 17–20, 22, 25
- **Aşama 3 — Avrupa uyumu ve büyüme:** 8–12, 14–16, 23, 26, 29
- **Aşama 4 — Akıllı optimizasyon:** 30 ve gelişmiş eşleştirme modelleri

## Başarı ölçüleri

- Yayımlanan yükten ilk nitelikli teklife geçen medyan süre
- Tekliften eşleşmeye dönüşüm oranı
- Boş kilometrede sağlanan azalma
- Zamanında yükleme ve teslim oranı
- Evrak nedeniyle bloke olan sefer oranı
- Uyuşmazlık ve iptal oranı
- Teslimden ödemeye geçen medyan süre
- 30 ve 90 günlük aktif şirket/taşıyıcı devamlılığı

## Resmî referanslar

- Avrupa Komisyonu eFTI: https://transport.ec.europa.eu/transport-themes/logistics-and-multimodal-transport/efti-regulation_en
- UNECE e‑CMR rehberi: https://unece.org/trade/documents/2023/10/executive-guide-e-cmr
- Avrupa Komisyonu sürücü görevlendirme kuralları: https://transport.ec.europa.eu/transport-modes/road/mobility-package-i/posting-rules_en
- Avrupa Komisyonu sürüş ve dinlenme süreleri: https://transport.ec.europa.eu/transport-modes/road/mobility-package-i/driving-rest-times_en
- KVKK mobil uygulamalarda mahremiyet tavsiyeleri: https://kvkk.gov.tr/SharedFolderServer/CMSFiles/8ba209bb-fa93-4479-84f0-dd55aac97a0f.pdf
