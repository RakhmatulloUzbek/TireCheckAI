import 'package:flutter/material.dart';
import 'package:tirecheck/etiketdetay.dart';
import 'package:tirecheck/lastikyazilar.dart';
import 'package:tirecheck/tirecheckpage.dart';

Color buttonColor = const Color.fromRGBO(18, 36, 51, 1.0);

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Libre',fontSize: 35.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(3, 6, 14, 1.0),
        centerTitle: true,
        shadowColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Arka plan resmi için Container widget'ı
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"), // Arka plan resmi
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // İlk butona tıklandığında ikinci sayfaya yönlendirme yapıyoruz
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TireCheckPage()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(250, 70)),
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(3, 6, 14, 1.0)),
                        shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Köşeleri kırık yapma
                        ),
                      ),
                    ),
                  child: const Text(
                      'Lastiği Kontrol Et',
                       style: TextStyle(fontFamily: 'Libre',fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white),
                  ), // Buton metni
                ),
                const SizedBox(height: 15), // Butonlar arasına boşluk ekliyoruz
                ElevatedButton(
                  onPressed: () {
                    // EtiketDetay sayfasına yönlendirme yapıyoruz
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EtiketDetay()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(250, 70)),
                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(3, 6, 14, 1.0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Köşeleri kırık yapma
                      ),
                    ),
                  ),
                  child: const Text(
                    'Lastik Etiket Klavuzu',
                    style: TextStyle(fontFamily: 'Libre',fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)), // Buton metni
                ),
                SizedBox(height: 15), // Butonlar arasına boşluk ekliyoruz
                ElevatedButton(
                  onPressed: () {
                    // EtiketDetay sayfasına yönlendirme yapıyoruz
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LastikYazilar()),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(250, 70)),
                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(3, 6, 14, 1.0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Köşeleri kırık yapma
                      ),
                    ),
                  ),
                  child: const Text(
                    'Lastikdaki Yazılar',
                     style: TextStyle(fontFamily: 'Libre',fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ), // Buton metni
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
