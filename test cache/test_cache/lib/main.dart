import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_cache/lazy_loading_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPlatformCache();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lazy Loading Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LazyLoadingList(),
    );
  }
}

initPlatformCache() async {
  if (!kIsWeb) {
    if(Platform.isAndroid) {
      await adjustImageCacheSizeAndroid();
    } else if(Platform.isIOS){
      await adjustImageCacheSizeIOS();
    }
  }else{
    // necessario??
  }
}

adjustImageCacheSizeAndroid() async {
  var deviceInfo = DeviceInfoPlugin();
  var androidInfo = await deviceInfo.androidInfo;
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.wifi)) {
    if (androidInfo.isLowRamDevice) { // Quanta ram considera?
      PaintingBinding.instance.imageCache.maximumSizeBytes = 256 * 1024 * 1024; // 256MB
    } else {
      PaintingBinding.instance.imageCache.maximumSizeBytes = 512 * 1024 * 1024; // 512MB
    }
  } else {
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024; // 100MB
  }
}

adjustImageCacheSizeIOS() async {
  //var deviceInfo = DeviceInfoPlugin();
  //var iosInfo = await deviceInfo.iosInfo;
  //var memory = iosInfo.memory ?; -> Ios non permette di accedere alla dimensione della ram dio porco, basarsi sul modello ?
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult.contains(ConnectivityResult.wifi)) {
    //if (memory > 2000000000) {
    PaintingBinding.instance.imageCache.maximumSizeBytes = 512 * 1024 * 1024; // 512 MB
    // } else {
    //PaintingBinding.instance.imageCache.maximumSizeBytes = 256 * 1024 * 1024; // 256MB
    // }
  } else {
    PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024; // 100MB
  }
}