import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefHelper {
  Future<void> userLogin();
  Future<void> saveIdJwtToken(String jwtToken);
  Future<void> saveEmail(String email);
  Future<void> savePassword(String password);
  Future<void> savePayload(String payload);
  Future<void> saveExpiryTime(String expiryTime);
  Future<void> saveString(String key, String value);
  Future<void> saveBoolean(String key, bool value);
  Future<void> saveInt(String key, int value);
  Future<void> saveDouble(String key, double value);
  String getIdJwtToken();
  String getEmail();
  String getPassword();
  String getPayload();
  String getExpiryTime();
  double getDouble(String key, double defaultValue);
  String getStringByKey(String key, String defaultValue);
  bool isLoggedin();
  bool getBoolByKey(String key, bool defaultValue);
  int getIntByKey(String key, int defaultValue);
}

class SharedPrefHelperImpl implements SharedPrefHelper {
  SharedPreferences sharedPreferences;
  SharedPrefHelperImpl(this.sharedPreferences);
  @override
  String getIdJwtToken() {
    return sharedPreferences.getString(ChadbotConstants.idjwtToken) ?? "";
  }

  @override
  Future<void> saveIdJwtToken(String jwtToken) {
    return sharedPreferences.setString(ChadbotConstants.idjwtToken, jwtToken);
  }

  @override
  Future<void> userLogin() {
    return sharedPreferences.setBool(ChadbotConstants.isloggedIn, true);
  }

  @override
  String getEmail() {
    return sharedPreferences.getString(ChadbotConstants.email) ?? "";
  }

  @override
  String getPassword() {
    return sharedPreferences.getString(ChadbotConstants.password) ?? "";
  }

  @override
  Future<void> saveEmail(String email) {
    return sharedPreferences.setString(ChadbotConstants.email, email);
  }

  @override
  Future<void> savePassword(String password) {
    return sharedPreferences.setString(ChadbotConstants.password, password);
  }

  @override
  String getPayload() {
    return sharedPreferences.getString(ChadbotConstants.payload) ?? "";
  }

  @override
  Future<void> savePayload(String payload) {
    return sharedPreferences.setString(ChadbotConstants.payload, payload);
  }

  @override
  String getExpiryTime() {
    return sharedPreferences.getString(ChadbotConstants.tokenExpiry) ?? "0";
  }

  @override
  Future<void> saveExpiryTime(String expiryTime) {
    return sharedPreferences.setString(
        ChadbotConstants.tokenExpiry, expiryTime);
  }

  @override
  bool isLoggedin() {
    return sharedPreferences.getBool(ChadbotConstants.isloggedIn) ?? false;
  }

  @override
  String getStringByKey(String key, String defaultValue) {
    return sharedPreferences.getString(key) ?? defaultValue;
  }

  @override
  Future<void> saveString(String key, String value) {
    return sharedPreferences.setString(key, value);
  }

  @override
  bool getBoolByKey(String key, bool defaultValue) {
    return sharedPreferences.getBool(key) ?? defaultValue;
  }

  @override
  Future<void> saveBoolean(String key, bool value) {
    return sharedPreferences.setBool(key, value);
  }

  @override
  int getIntByKey(String key, int defaultValue) {
    return sharedPreferences.getInt(key) ?? defaultValue;
  }

  @override
  Future<void> saveInt(String key, int value) {
    return sharedPreferences.setInt(key, value);
  }

  @override
  Future<void> saveDouble(String key, double value) {
    return sharedPreferences.setDouble(key, value);
  }

  @override
  double getDouble(String key, double defaultValue) {
    return sharedPreferences.getDouble(key) ?? defaultValue;
  }
}
