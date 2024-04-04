import 'dart:ffi';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_image_camera/camera_file.dart';
import 'package:multiple_image_camera/multiple_image_camera.dart';
import 'dart:developer' as devtools;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:image/image.dart' as img;






class TireCheckPage extends StatefulWidget {
  const TireCheckPage({super.key});

  @override
  State<TireCheckPage> createState() => _TireCheckPageState();
}

class _TireCheckPageState extends State<TireCheckPage> with SingleTickerProviderStateMixin {
  List<String> imgPath = [];
  List<Widget> imageSliders = [];
  List<String> imgList = [];
  File? filePath;
  String label = '';
  double confidence = 0.0;
  List<Int> confidenceArry = [];
  List<String> labelArry = [];
  int index = 4;
  double avg = 0.0;
  double avgScore = 0.0;
  String avgLabel = "";
  int avgLabelCount = 0;
  int avgLabelGood = 0;
  int avgLabelBad = 0;
  double toplam = 0.0;
  List<File> resimler = [];
  List<int> son = [];
  List<String> confidenceLabes = [];
  List<double> confidenceScores = [];
  bool interpreterBusy = false;


  List<MediaModel> images = [] ;


  Future<void> intilizeVerables() async {
    filePath = null;
    confidenceScores.clear();
    confidenceLabes.clear();
    imageSliders.clear();
    images.clear();
    imgPath.clear();
    imgList.clear();
    avg = 0;
    toplam = 0;
    confidence = 0;
    label = "";
    avgLabelGood=0;
    avgLabelBad=0;
    avgScore=0;
    avgLabel = "";
    avgLabelCount=0;
  }

  Future<void> _tfLteInit() async {
    String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset: true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate: false // defaults to false, set to true to use GPU delegate
    );
    print("Model yükleme sonucu: $res");
  }
  multiplePickImageGallery() async {
    SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context);
    final List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        //imgList.add(pickedFiles.map((file) => File(file.path)).toString());
        for (var p in pickedFiles) {
          imgList.add(p.path);
        }
      });
      _dialog.show(message: 'İşlem yapılıyor...', type: SimpleFontelicoProgressDialogType.normal,  width: 200.0, height: 100.0, loadingIndicator: const Text('C', style: TextStyle(fontSize: 24.0),));
      for (var imagePath in imgList) {
        await multipleImageClassify(imagePath, 1);
      }
      _dialog.hide();
      if((imgList.length/2).floor() <= avgLabelCount){
        avgLabel ="Yıpranmış";
      }else{
        avgLabel ="Sağlam";
      }

      print("imgList length: "+imgList.length.toString());
      print("avg: "+avg.toString());
      print("toplam: "+toplam.toString());
      avgScore=toplam/imgList.length;
      imageSliders = imgList
          .map((item) => Container(
        child: Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.file(File(item), fit: BoxFit.cover, width: 1000.0, height: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        "Resim ${imgList.indexOf(item)+1} / ${confidenceLabes[imgList.indexOf(item)]} ${confidenceScores[imgList.indexOf(item)].toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ))
          .toList();
    }
  }

  pickImageGallery() async {
    SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context);

    final ImagePicker picker = ImagePicker();// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    File originalImageFile = File(image.path);

    img.Image originalImage = img.decodeImage(originalImageFile.readAsBytesSync())!;
    // Orjinal resmin boyutlarını yazdır
    devtools.log("Orjinal Resim Boyutu: ${originalImage.width}x${originalImage.height}");

    img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);
    // Yeniden boyutlandırılmış resmin boyutlarını yazdır
    devtools.log("Yeni Resim Boyutu: ${resizedImage.width}x${resizedImage.height}");

    // Yeniden boyutlandırılmış resmi geçici bir dosyaya kaydet
    String tempPath = image.path.replaceAll('.jpg', '_temp.jpg');
    File(tempPath)..writeAsBytesSync(img.encodeJpg(resizedImage));


    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });
    _dialog.show(message: 'İşlem yapılıyor...', type: SimpleFontelicoProgressDialogType.normal,  width: 200.0, height: 100.0, loadingIndicator: const Text('C', style: TextStyle(fontSize: 24.0),));
    var recognitions = await Tflite.runModelOnImage(
        path: tempPath,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.2,   // defaults to 0.1
        asynch: true      // defaults to true
    );
    _dialog.hide();

    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
      index = recognitions[0]['index'];
      avgScore = confidence;
      avgLabel = label;
    });
    devtools.log(confidence.toString());
  }

  Future<void> multipleImageClassify(String path, int sec) async {
    File originalImageFile = File(path);

    img.Image originalImage = img.decodeImage(originalImageFile.readAsBytesSync())!;
    // Orjinal resmin boyutlarını yazdır
    devtools.log("Orjinal Resim Boyutu: ${originalImage.width}x${originalImage.height}");

    img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);
    // Yeniden boyutlandırılmış resmin boyutlarını yazdır
    devtools.log("Yeni Resim Boyutu: ${resizedImage.width}x${resizedImage.height}");

    // Yeniden boyutlandırılmış resmi geçici bir dosyaya kaydet
    String tempPath = path.replaceAll('.jpg', '_temp.jpg');
    File(tempPath)..writeAsBytesSync(img.encodeJpg(resizedImage));

    try {
      // Yorumlayıcının meşgul olup olmadığını kontrol et
      while (interpreterBusy) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      interpreterBusy = true;

      var recognitions = await Tflite.runModelOnImage(
        path: tempPath,   // gereklidir
        imageMean: 0.0,   // varsayılan 117.0
        imageStd: 255.0,  // varsayılan 1.0
        numResults: 2,    // varsayılan 5
        threshold: 0.2,   // varsayılan 0.1
        asynch: true,     // varsayılan true
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        double confidence = recognitions[0]['confidence']*100;
        String label = recognitions[0]['label'];
        if(label == "Yıpranmış"){avgLabelCount++;}
        setState(() {
          confidenceScores.add(confidence);
          confidenceLabes.add(label);
          toplam =  toplam + confidence;
        });
      }
    } catch (e) {
      print("Sınıflandırma hatası: $e");
    } finally {
      interpreterBusy = false;
    }
  }

  multiplePickCamera() async {
    SimpleFontelicoProgressDialog _dialog = SimpleFontelicoProgressDialog(context: context);
    var value = await MultipleImageCamera.capture(context: context);
    setState(() {
        images = value;
        for (var p in value) {
          imgList.add(p.file.path.toString());
        }
    });
    _dialog.show(message: 'İşlem yapılıyor...', type: SimpleFontelicoProgressDialogType.normal,  width: 200.0, height: 100.0, loadingIndicator: const Text('C', style: TextStyle(fontSize: 24.0),));
    for (var imagePath in imgList) {
      await multipleImageClassify(imagePath, 1);
    }
    _dialog.hide();
    if((imgList.length/2).floor() <= avgLabelCount){
      avgLabel ="Yıpranmış";
    }else{
      avgLabel ="Sağlam";
    }
    avgScore=toplam/imgList.length;
      imageSliders = imgList
          .map((item) => Container(
        child: Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.file(File(item), fit: BoxFit.cover, width: 1000.0, height: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        "Resim ${imgList.indexOf(item)+1} / ${confidenceLabes[imgList.indexOf(item)]} ${confidenceScores[imgList.indexOf(item)].toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ))
          .toList();


    devtools.log(confidenceScores.toString());

  }

  pickImageCamera() async {
    SimpleFontelicoProgressDialog? _dialog = SimpleFontelicoProgressDialog(context: context);
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, maxWidth: 450, maxHeight: 450);
    if (image == null) return;

    File originalImageFile = File(image.path);
    img.Image originalImage = img.decodeImage(originalImageFile.readAsBytesSync())!;
    // Orjinal resmin boyutlarını yazdır
    devtools.log("Orjinal Resim Boyutu: ${originalImage.width}x${originalImage.height}");

    img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);
    // Yeniden boyutlandırılmış resmin boyutlarını yazdır
    devtools.log("Yeni Resim Boyutu: ${resizedImage.width}x${resizedImage.height}");

    // Yeniden boyutlandırılmış resmi geçici bir dosyaya kaydet
    String tempPath = image.path.replaceAll('.jpg', '_temp.jpg');
    File(tempPath)..writeAsBytesSync(img.encodeJpg(resizedImage));

    var imageMap = File(image.path);
    //var imageMap = File(tempPath);

    setState(() {
      filePath = imageMap;
    });
    _dialog.show(message: 'İşlem yapılıyor...', type: SimpleFontelicoProgressDialogType.normal,  width: 200.0, height: 100.0, loadingIndicator: const Text('C', style: TextStyle(fontSize: 24.0),));
    var recognitions = await Tflite.runModelOnImage(
        path: tempPath,  // required
        imageMean: 0.0,     // defaults to 117.0
        imageStd: 255.0,    // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0.1,     // defaults to 0.1
        asynch: true // defaults to true
    );
    _dialog.hide();


    if (recognitions == null) {
      devtools.log("recognitions is Null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
      index = recognitions[0]['index'];
      avgScore = confidence;
      avgLabel = label;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tfLteInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Tflite.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Lastiği Kontrol Et",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Libre',
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/back.jpg"), // Arka plan resmi
                fit: BoxFit.cover,
              ),
            ),
            child: Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 0,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: 350,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 0,
                            ),
                            Container(
                              height: 350,
                              width: 400,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                image: const DecorationImage(
                                  image: AssetImage("assets/tire_image.png"),
                                ),
                              ),
                              child: filePath != null ? Image.file(filePath!, fit: BoxFit.cover,) : CarouselSlider(options: CarouselOptions(autoPlay: false, aspectRatio: 1.3, enlargeCenterPage: true), items: imageSliders),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  LinearPercentIndicator(
                                    animation: true,
                                    animationDuration: 1000,
                                    lineHeight: 30,
                                    percent: avgScore/100,
                                    progressColor: avgLabel == "Sağlam" ? Colors.green: Colors.red,
                                    backgroundColor: Colors.grey,
                                    center: Text( avgLabelCount != 0 ? (imgList.length/2) <= avgLabelCount ? "Yıpranmış "+(avgScore.floor()).toStringAsFixed(0) +"% " : "Sağlam "+(avgScore.floor()).toStringAsFixed(0) +"%": avgLabel+" "+(avgScore.floor()).toStringAsFixed(0) +" % ",
                                      style: TextStyle( fontWeight: FontWeight.bold, fontSize: 20.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: 'cameraHero',
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        onPressed: () {
                          intilizeVerables();
                          // Kullanıcıya tekli veya çoklu çekim seçeneği sunulur
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "Fotoğraf Çekim Seçeneği",
                                  style: TextStyle(fontFamily: 'Montserrat' ,fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        pickImageCamera(); // Tekli çekim için
                                      },
                                      child: const Text("Tekli Çekim"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        multiplePickCamera(); // Çoklu çekim için
                                      },
                                      child: const Text("Çoklu Çekim(Min 4)"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.camera_alt,color: Colors.black,size: 30,),
                      ),
                      const SizedBox(
                        height: 8,
                        width: 50,
                      ),
                      FloatingActionButton(
                        heroTag: 'galleryHero',
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        onPressed: () {
                          intilizeVerables();
                          // Kullanıcıya tekli veya çoklu çekim seçeneği sunulur
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "Fotoğraf Yükleme Seçeneği",
                                  style: TextStyle(fontFamily: 'Montserrat' ,fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        pickImageGallery(); // Tekli çekim için
                                      },
                                      child: const Text("Tekli Yükleme"),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          multiplePickImageGallery(); // Tekli çekim için
                                        },
                                        child: const Text("Çoklu Yükleme(Min 4)"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(Icons.image_rounded,color: Colors.black,size: 30,),
                      ),



                      const SizedBox(
                        height: 100,
                      ),
                    ],

                  )

                ],
              ),
            ),

          ),
        ],
      ),
    );
  }
}