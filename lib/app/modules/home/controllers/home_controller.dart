import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  var currentPosition = Rxn<Position>();
  var locationMessage = "Mencari Lat dan Long...".obs;
  var loading = false.obs;

  // Fungsi untuk mendapatkan lokasi saat ini
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    loading.value = true;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Location service not enabled');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied forever');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Debugging output to print latitude and longitude
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

      currentPosition.value = position;
      locationMessage.value =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";

      loading.value = false;
    } catch (e) {
      loading.value = false;
      locationMessage.value = 'Gagal mendapatkan lokasi: $e';
    }
  }

  void openGoogleMaps() {
    if (currentPosition.value != null) {
      final latitude = currentPosition.value!.latitude;
      final longitude = currentPosition.value!.longitude;

      // Membuka Google Maps dengan koordinat yang benar
      final url =
          'https://www.google.com/maps?q=$latitude,$longitude&zoom=15'; // Anda bisa menyesuaikan zoom level
      _launchURL(url);
    } else {
      locationMessage.value = 'Lokasi belum tersedia!';
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
