import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtdl/screens/simulation.dart';
import 'package:dtdl/screens/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> takeScreenshotAndUpload({required String errorMessage, required StackTrace stackTrace}) async {
    try {
      var uuid = const Uuid();
      String errorId = uuid.v1();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      // Take screenshot
      final imageFile = await screenshotController.capture();
      if (imageFile == null) return;

      // Save the screenshot to a temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/$errorId.png').create();
      file.writeAsBytesSync(imageFile);

      // Upload the screenshot to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('err_screenshots/$errorId.png');
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Ensure all necessary data is included in the Firestore document
      var errLogsRef = FirebaseFirestore.instance.collection('error_logs').doc(errorId);
      await errLogsRef.set({
        'error_id': errorId,
        'error_message': errorMessage,
        'stack_trace': stackTrace.toString(),
        'timestamp': DateTime.now(),
        "screenshot_url": downloadUrl,
        'priority': 'HIGH',
        'device_model': androidInfo.model,
        'device_brand': androidInfo.brand,
        'device_host': androidInfo.host,
        'device_version': androidInfo.version.release,
        "error_code_link": "https://vscode.dev/github/Vasanth-Korada/shop-infy",
        "ai_rca": "https://devguard.s3.amazonaws.com/AI+RCA+-+ER_8762.pdf",
        "ai_suggestions": "https://devguard.s3.amazonaws.com/AI+Resolution+-+ER_8762.pdf",
      });

      await createJIRATicket(
        errorId: errorId,
        errorMessage: errorMessage,
        stackTrace: stackTrace.toString(),
        downloadUrl: downloadUrl,
        deviceModel: androidInfo.model,
        deviceBrand: androidInfo.brand,
        deviceHost: androidInfo.host,
        deviceVersion: androidInfo.version.release,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload error to DevGuard AI: $e')),
      );
    }
  }

  Future<void> createJIRATicket({
    required String errorId,
    required String errorMessage,
    required String stackTrace,
    required String downloadUrl,
    required String deviceModel,
    required String deviceBrand,
    required String deviceHost,
    required String deviceVersion,
  }) async {
    const url = 'https://infytech.atlassian.net/rest/api/3/issue';
    final headers = {
      'Authorization':
          'Basic dmFzYW50aGtvcmFkYTk5OUBnbWFpbC5jb206QVRBVFQzeEZmR0YwUzQyWklZSlY3T1BNS29GUnZER0w2YTlNbHpjRjFaNkR5aDVjV3dmMmJjTklxd0phcEVfaE5xcGlpTnhhU3VSX3FNaFA5SlAxQllpNi1uR1lzWVEyYzdaVTh1SDk3OTZOUjIyZTJBbXB5dTB1Q1FLVTZQMkRjOWNOM2k3WFlQWll4TFE4ZzFnTzc2N1NUM2ZZN1J1azYyQUIwUTJtNE0tSE95TDdsMUVSeHl3PUY4RkYzOTYy',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      "fields": {
        "summary": "Error ID: $errorId - $errorMessage",
        "issuetype": {"id": "10001"},
        "project": {"key": "KAN", "id": "10000"},
        "description": {
          "type": "doc",
          "version": 1,
          "content": [
            {
              "type": "paragraph",
              "content": [
                {
                  "text": "Error Details\n\n"
                      "Error ID: $errorId\n\n"
                      "Error Message: $errorMessage\n\n"
                      "Stack Trace:\n```\n$stackTrace\n```\n\n"
                      "Timestamp: ${DateTime.now().toString()}\n\n"
                      "Screenshot URL: $downloadUrl\n\n"
                      "Priority: HIGH\n\n"
                      "Device Details:\n"
                      "Device Model: $deviceModel\n"
                      "Device Brand: $deviceBrand\n"
                      "Device Host: $deviceHost\n"
                      "Device Version: $deviceVersion\n\n"
                      "Error Code Link: https://vscode.dev/github/Vasanth-Korada/shop-infy \n\n"
                      "AI RCA: https://devguard.s3.amazonaws.com/AI+RCA+-+ER_8762.pdf\n\n"
                      "AI Suggestions: https://devguard.s3.amazonaws.com/AI+Resolution+-+ER_8762.pdf",
                  "type": "text"
                }
              ]
            }
          ]
        }
      }
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      print('Issue created successfully');
      print('Response body: ${response.body}');
    } else {
      print('Failed to create issue');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.pink,
          title: const Text(
            "SHOP INFY",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text("Hello, Priyanka"),
                accountEmail: Text("angelme@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://media.licdn.com/dms/image/D5635AQE2mVueX0wykA/profile-framedphoto-shrink_800_800/0/1713593490025?e=1716390000&v=beta&t=Rm9vFRZK4FGi9X56MOqlAlKK5e12isIRd-zvPeQ9zPk"),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const SimulationScreen(),
                    ),
                  );
                },
                leading: const Icon(Icons.accessibility),
                title: const Text(
                  "Simulation",
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 66,
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            onPressed: () async {
              try {
                throw Exception(AppStrings.error);
              } catch (error, stackTrace) {
                await takeScreenshotAndUpload(errorMessage: error.toString(), stackTrace: stackTrace);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 5),
                    backgroundColor: Colors.red,
                    content: Text("Something went wrong!"),
                  ),
                );
              }
            },
            child: const Text(
              "BUY NOW",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  "https://media-ik.croma.com/prod/https://media.croma.com/image/upload/v1708671939/Croma%20Assets/Communication/Mobiles/Images/300679_0_ywgnrd.png",
                ),
                const SizedBox(height: 32),
                const Text(
                  "Apple iPhone 15 (128GB, Pink)",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilterChip(label: const Text("128 GB"), onSelected: (_) {}),
                    const SizedBox(
                      width: 12,
                    ),
                    FilterChip(label: const Text("256 GB"), onSelected: (_) {}),
                    const SizedBox(
                      width: 12,
                    ),
                    FilterChip(label: const Text("1 TB"), onSelected: (_) {})
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "The iPhone 15 marks a significant leap in Apple's flagship smartphone lineup, offering cutting-edge technology and sleek design. It features a stunning 6.1-inch Super Retina XDR display with ProMotion technology for smoother visuals and a more responsive touch experience. Powered by the new A17 Bionic chip, it delivers unprecedented speed and efficiency, supporting advanced AI capabilities and enhanced graphics performance. The camera system has been revamped with a 48MP main sensor, allowing for ultra-high-resolution photos and 8K video recording. Additionally, the iPhone 15 introduces a longer-lasting battery, 5G connectivity, and iOS 17, which brings a host of new features and improvements. With its durable Ceramic Shield front cover and IP68 water resistance, the iPhone 15 is built to withstand the rigors of daily use while providing an exceptional user experience.",
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
