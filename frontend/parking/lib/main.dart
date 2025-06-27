import 'package:flutter/material.dart';
import 'package:parking/presentation/routes/routes.dart';
import 'package:parking/presentation/screens/home/user_home.dart';
import 'package:parking/presentation/screens/anrp/anrp.dart';
import 'package:camera/camera.dart';
import 'package:parking/presentation/screens/login/login.dart';
import 'package:parking/presentation/screens/menu/camera/camera_discovery.dart';
import 'package:parking/presentation/widgets/slider.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    runApp(MyApp(cameras: cameras));
  }


class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: CameraDiscoveryPage(),
      routes: Routes,
    );
  }
}

