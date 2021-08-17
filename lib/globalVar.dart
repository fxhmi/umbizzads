// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

String userId = "";
String userEmail = "";
String getUserImageUrl = "";
String getUserName = "";
String getUserNum = "";
bool isDarkMode = true;
String getAbout = "";
String getUserId = "";
String getNameChatId = "";
String adUserName = "";
String adUserImageUrl = "";

String completeAddress = "";
List<Placemark> placemarks;
Position position;

