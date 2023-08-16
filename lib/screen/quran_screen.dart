import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/model/ayah.dart';
import 'package:quran_app/screen/asset.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  Asset asset = Asset();

  int pageNumber = 0;
  List<List<Ayah>>? pages = [];
  bool isLoading = false;
 double scale = 1 ;
  String basmal = '‏ ‏‏ ‏‏‏‏ ‏‏‏‏‏‏ ‏';

  Future<void> getData() async {
    pages = await asset.fetchData();
    setState(() {
      isLoading = true;
    });
    // Uri uri = Uri.parse(
    //     'http://api.alquran.cloud/v1/page/$currentNumber/quran-uthmani');
    // var response = await http.get(uri);
    // if (response.statusCode == 200) {
    //   var data = jsonDecode(response.body);
    //   result = data['data']['ayahs'] as List;
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: !isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: PageView.builder(
                  itemCount: 604,
                  itemBuilder: (context, index) {
                    List<InlineSpan> listTextSpan = [];
                    Set<String?> surah = {};
                    Set<int?> jozz = {};
                    for (Ayah ayah in pages![index]) {
                      surah.add(ayah.suraNameAr);
                      jozz.add(ayah.jozz);
                      if (ayah.ayaNo == 1) {
                        listTextSpan.add(WidgetSpan(
                            child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          width: double.infinity,
                          height: 70,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('images/headOfSurah.jpg'))),
                          child: Text(
                            '${surah.first}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        )));
                      }
                      if (ayah.suraNameAr != 'الفَاتِحة' &&
                          ayah.suraNameAr != 'التوبَة' &&
                          ayah.ayaNo == 1) {
                        listTextSpan.add(WidgetSpan(
                            child: Center(
                          child: Text(
                            basmal,
                            style: const TextStyle(
                                fontSize: 20, fontFamily: 'HafsSmart'),
                          ),
                        )));
                      }
                      listTextSpan.add(TextSpan(
                        // recognizer: LongPressGestureRecognizer(
                        //     duration: const Duration(microseconds: 250))
                        //   ..onLongPress = () {
                        //     showModalBottomSheet(
                        //         context: context,
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(15)),
                        //         builder: (BuildContext context) {
                        //           return Container(
                        //             padding: EdgeInsets.all(16),
                        //             height: 300,
                        //             child: const Text('test'),
                        //           );
                        //         });
                        //   },
                        text: '${ayah.ayaText}',
                        style: const TextStyle(fontSize: 18, fontFamily: 'HafsSmart'),
                      ));
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      textDirection: (index + 1) % 2 == 0
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          color: Colors.grey,
                          width: 1,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: (index + 1) % 2 == 0
                                    ? const LinearGradient(colors: [
                                        Color(0xffefc795),
                                        Color(0xffFFF0CF),
                                        Color(0xfffdfcfa)
                                      ])
                                    : const LinearGradient(colors: [
                                        Color(0xfffdfcfa),
                                        Color(0xffFFF0CF),
                                        Color(0xffefc795),
                                      ])),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('${surah.first}'),
                                      Text('${jozz.first}'),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text.rich(
                                      TextSpan(children: listTextSpan),
                                      textAlign: TextAlign.justify,textScaleFactor: scale,
                                    )),
                                const Spacer(),
                                Text((index + 1).toString())
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
