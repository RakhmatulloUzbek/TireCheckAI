import 'package:flutter/material.dart';

class LastikYazilar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Lastik Üzerindeki Yazılar",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Metin rengi
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(3, 6, 14, 1.0), // AppBar arka plan rengi
          elevation: 1, // Gölgelendirme miktarı, 0 yaparak gölgeyi kaldırabilirsiniz
          actionsIconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              ImageCard(
                imagePath: 'assets/yazi/1.jpg',
                title: 'Lastik ebadı nasıl okunur?',
                description: 'P: Binek Araç \nLT: Kamyonet \nC : Ticari araç van lastiği \nXL, HL veya Güçlendirilmiş: Boyutlarına göre normalden daha yüksek yük kapasitesine sahip lastikler. Bu tür lastikler muadilleriyle değiştirilmelidir (örnek: bir HL lastiği başka bir HL lastikle değiştirilebilir) \n T: Geçici (yedek lastik)\n'
                    "Lastik genişliği ve en boy oranı nasıl okunur?\n"
                    "Örnek: 205 / 55\n\n"
                    "Bunlar, değiştirmeniz gerektiğinde doğru lastiği bulmanıza yardımcı olacak önemli lastik işaretleridir.\n\n"
                    "İki sayıdan ilki, lastiğin nominal kesit genişliğidir. Lastiğin iç ve dış yanağı arasındaki mesafeyi milimetre cinsinden gösterir. Örneğin 205, lastiğinizin nominal olarak 205 mm genişliğinde olduğu anlamına gelir.\n\n"
                    "İkinci sayı, lastiğin yanağının yüksekliği ile lastiğin genişliği arasındaki ilişkidir. Bu sayı yüzde olarak ifade edilir. Örneğin 55, lastik sırtının üst kısmı ile jant arasındaki yanak yüksekliğini belirtmekte ve lastik genişliğinin %55 olduğunu göstermektedir. \n\n"
                    "Lastik yapı tipi ve tekerlek çapı nasıl okunur?\n\n"
                    "Örnek: R 17\n"
                    "Bu lastik işaretleri genellikle bir harf ve bir sayıdan oluşur.\n\n"
                    "R harfi, lastiğin iç yapısının radyal olduğunu gösterir.\n\n"
                    "Michelin tarafından keşfedilen radyal teknolojide, sırt bölgesinde son derece sağlam yapının yanı sıra esnek yanaklar oluşturmak için kauçuk, metal ve tekstil ile güçlendirilmiş malzemelerin bir kombinasyonu kullanılır. Bu, yuvarlanma direncinin azalması sayesinde daha uzun lastik sırtı ömrü sunar ve yakıt tüketimini azaltır.\n\n"
                    "Harften sonra bir sayı görürsünüz. Örneğimizde: 17.\n"
                    "Bu sayı inç cinsinden ifade edilir ve lastiğin takılacak şekilde tasarlandığı tekerleğin çapını gösterir.",
              ),
              ImageCard(
                imagePath: 'assets/yazi/2.jpg',
                title: 'Lastik azami yükü ve endeksi nasıl okunur?',
                description: 'Yük ve hız endeksi yazımızda bu kodlar ve bunların değerleri arasındaki ilişkilere dair bir tablo bulacaksınız. Bu değerler, özellikle aracınıza yeni lastik seçmeyi düşünürken lastik ebadı gibi önemli bilgilerdir. \n\nÖrnek : 91 V Lastiğinizin yanağında bir sayı ve ardından bir harf bulacaksınız. Lastik yük endeksi veya yük endeksi (örneğimizde: 91), tek bir lastik tarafından taşınabilecek maksimum yüke (kg cinsinden) karşılık gelen bir koddur. Lastik hız endeksi (örneğimizde: V), bir lastiğin azami yük taşıyabileceği maksimum hıza karşılık gelen bir koddur.',
              ),
              ImageCard(
                imagePath: 'assets/yazi/3.jpg',
                title: 'Marka adı ve lastiğin menzili nasıl belirlenir?',
                description: 'Bu işlem oldukça kolaydır. Üreticinin marka adını, lastiğin menzili gibi, her zaman lastik yanağında görebilirsiniz. \nBu resimde MICHELIN ve Michelin Lastik Adamımız açıkça görülmekte ve "Pilot Sport 4 S" ismi lastiğin menzilini ifade etmektedir..',
              ),
              ImageCard(
                imagePath: 'assets/yazi/4.jpg',
                title: 'Lastik tipi nasıl belirlenir? ',
                description: 'Lastiğinizin yanağındaki "Tubeless” (iç lastikli) ifadesi, lastiğinizin bir iç lastiğe gereksinim duymadığını gösterir. Bazı tekerlekler için bazen bir iç lastiğin (şambrel) gerekli olduğunu unutmayın, ancak bu gibi durumlarda şambrel ve lastiğin uyumlu olup olmadığını değerlendirmek gerekir. \n\nAksine, "Tube type" (iç lastikli) ibaresi lastiğe şambrel (iç lastik) takılması gerektiğini gösterir. \n\nPeki avantajı nedir? İç lastiksiz lastikler daha hafiftir, daha fazla yakıt tasarrufu sağlar ve kullanım sırasında şambrele gelebilecek hasarlar nedeniyle genellikle daha güvenilirdir.',
              ),
              // Diğer resim kartları buraya eklenir
            ],
          ),
        ),

    );
  }
}

class ImageCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const ImageCard({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(3, 6, 14, 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          SizedBox(height: 30),
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
