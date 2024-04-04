import 'package:flutter/material.dart';

class EtiketDetay extends StatelessWidget {
  final List<Map<String, String>> lastikEtiketleri = [
    {
      'imagePath': 'assets/etiket/etiket.jpg',
      'title': 'YENİ AVRUPA LASTİK ETİKETİ',
      'description': '1 ve 2 – "Lastik yakıt verimliliği" ve "ıslak zeminde frenleme" sembolleri, lastikleri A ile E arasında sınıflandırır (A en verimli, E en verimsiz olacak şekilde).\n3 – "Dış gürültü seviyesi" sembolü, desibel olarak (dB) değerlendirilir ve 3 ölçeği vardır (A, B, C).\n4 – "3PMSF" ve/veya "Buzlu yol tutuşu"  sembolleri, uygun lastiklerde "Dış gürültü" sembolünün yanında bulunur.\n5 – Tarayabileceğiniz bir  QR kodu mevcuttur. Bu kod, doğrudan Avrupa veri tabanıyla (EPREL) bağlantılıdır ve size lastik etiketi ve ürün bilgi sayfası hakkında tüm bilgileri verir. \n6 – Lastik üreticisinin marka adı, lastik tanımlayıcı referansı, lastik ebadı gösterimi, lastik sınıfı..',
    },
    {
      'imagePath': 'assets/IslakZeminde.png',
      'title': 'ISLAK ZEMİNDE YOL TUTUŞ DERECESİ',
      'description': "Lastikler, aracın yoldaki tek temas noktası olduğu için hayati güvenlik unsurlarındandır. AB derecelendirmesine göre, 'Islak zeminde yol tutuş' özelliği, lastiğin ıslak zeminde frenleme performansını ifade eder. Bu performans, A'dan E'ye kadar derecelendirilir, yüksek dereceli lastikler ıslak yollarda daha kısa mesafede durabilir. Ancak, frenleme mesafeleri sürüş koşullarına ve çeşitli faktörlere göre değişiklik gösterir, bu yüzden tavsiye edilen durma mesafelerine uyulmalıdır.",
    },
    {
      'imagePath': 'assets/Gurultu.png',
      'title': 'LASTİK GÜRÜLTÜ SES SEVİYELERİ',
      'description': "Yeni Lastik Etiketlerinde, lastiklerin yol sırasında çıkardığı dış ses seviyesi artık A, B, C harfleriyle sınıflandırılır. Ses seviyesi desibel (dB) cinsinden ölçülür; düşük ses 67-71 dB, yüksek ses 72-77 dB aralığında olabilir. Sadece 3 dB'lik bir artış, lastiğin dış gürültüsünü iki katına çıkarır, bu yüzden ses seviyesi önemli bir seçim kriteridir.",
    },
    {
      'imagePath': 'assets/YakitEnerji.png',
      'title': 'LASTİK YAKIT VERİMİ VE ENERJİ VERİMLİLİĞİ',
      'description': "Lastikler, aracınızın yakıt tüketiminin %20'sine kadar etkileyebilir. Lastiklerin yola teması ve dönüş sırasında ısınması yakıt tüketimini ve sera gazı emisyonlarını artırır. Yeni Lastik Etiketi Sembolleri, lastiklerin yakıt verimliliğini A'dan E'ye kadar derecelendirir; A sınıfı en iyi, E sınıfı ise en kötü verimliliği gösterir. Yakıt tüketimi, sınıflar arası her 100 km'de yaklaşık 0,1 litre artar, bu da daha verimli lastiklerin daha az yakıt tüketimi ve azaltılmış CO2 emisyonu sağladığını gösterir..",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lastik Etiket Klavuzu",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Metin rengi
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(3, 6, 14, 1.0), // AppBar arka plan rengi
        elevation: 0, // Gölgelendirme miktarı, 0 yaparak gölgeyi kaldırabilirsiniz
        actionsIconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // İlk resmi ekleyelim
            Image.asset(
              lastikEtiketleri.first['imagePath']!,
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            // İlk resmin altına başlık ve açıklama ekleyelim
            Container(
              color: const Color.fromRGBO(3, 6, 14, 1.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lastikEtiketleri.first['title']!,
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      lastikEtiketleri.first['description']!,
                      style: TextStyle(fontSize: 14.0, color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            // Diğer kartları lastikEtiketleri listesinden oluşturalım
            ...lastikEtiketleri.skip(1).map((etiket) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LastikCard(
                  imagePath: etiket['imagePath']!,
                  title: etiket['title']!,
                  description: etiket['description']!,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class LastikCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const LastikCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(3, 6, 14, 1.0),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  width: 100.0, // Resim genişliğini ayarlayın
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0), // Başlık ve açıklama arasındaki boşluk
            Text(
              description,
              style: TextStyle(fontSize: 14.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }


}
