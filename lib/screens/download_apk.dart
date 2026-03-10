import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class DownloadApk {
  final BuildContext context;
  final Function(String) showSnackBar;

  DownloadApk(this.context, this.showSnackBar);

  Future<void> startDownloadingApk(String url, String fileName) async {
    //print("startDownloadingApk.............................");
    if (await _requestPermission(context)) {
      // Pass context here
      // print("Permission granted, starting download...");
      await _downloadFile(url, fileName);
    } else {
      // Handle permission denied
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Storage permission denied")));
      }
    }
  }

  Future<bool> _requestPermission(BuildContext context) async {
    //print("_requestPermission....");
    var status = await Permission.storage.status;
    //  print("Current permission status: $status");

    if (!status.isGranted) {
      //   print("Requesting storage permission...");
      status = await Permission.storage.request();
      //  print("New permission status after request: $status");
      if (context.mounted) {
        if (status.isDenied) {
          // Permission denied, show a message or dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Storage permission denied. Please enable it in settings.",
              ),
              backgroundColor: Colors.red,
            ),
          );
          return false; // Return false if permission is denied
        } else if (status.isPermanentlyDenied) {
          // Permission permanently denied, show a dialog to open app settings
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Storage permission permanently denied. Opening app settings...",
              ),
            ),
          );
          openAppSettings(); // This will open the app settings
          return false; // Return false if permission is permanently denied
        }
      }
    }

    return status.isGranted; // Return true if permission is granted
  }

  Future<void> _downloadFile(String url, String fileName) async {
    // print("Entering _downloadFile with URL: $url and fileName: $fileName");
    try {
      // Get the directory to save the APK
      Directory? directory = await getExternalStorageDirectory();
      // print("Download directory: ${directory?.path}");
      String filePath = '${directory?.path}/$fileName.apk';

      // Create a Dio instance
      Dio dio = Dio();

      // Start downloading
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // double progress = (received / total) * 100;
            // print("Download progress: ${progress.toStringAsFixed(0)}%");
          }
        },
      );

      // Open the APK after download
      _openNewVersion(filePath);
    } catch (e) {
      if (context.mounted) {
        // print("Download error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error downloading APK")));
      }
    }
  }

  void _openNewVersion(String filePath) {
    // Use the url_launcher package to open the APK
    launchUrl(Uri.file(filePath), mode: LaunchMode.externalApplication);
  }
}
