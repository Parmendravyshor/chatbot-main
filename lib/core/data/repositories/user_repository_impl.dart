import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:chadbot/core/constants/chadbot_constants.dart';
import 'package:chadbot/core/data/datasources/auth_source.dart';
import 'package:chadbot/core/data/datasources/shared_pref_helper.dart';
import 'package:chadbot/core/domain/email_auth_params.dart';
import 'package:chadbot/core/domain/repositories/user_repository.dart';
import 'package:chadbot/core/errors/exceptions.dart';
import 'package:chadbot/core/errors/failures.dart';
import 'package:chadbot/core/errors/registration_failures.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_profile.dart';
import 'package:chadbot/feature/verify/domain/usecases/save_single_field.dart';
import 'package:chadbot/feature/verify/domain/usecases/verify_code.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class UserRepositoryImpl implements UserRepository {
  final AuthSource authSource;
  final SharedPrefHelper sharedPrefHelper;

  UserRepositoryImpl(this.authSource, this.sharedPrefHelper);

  Future<Either<Failure, void>> emailSignup(EmailAuthParams params) async {
    try {
      await authSource.emailSignup(params);
      return Right(Void);
    } on CognitoClientException catch (e) {
      return Left(CacheFailure(e.message!));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> emailLogin(EmailAuthParams params) async {
    try {
      final user = await authSource.emailLogin(params);
      sharedPrefHelper.saveEmail(params.email);
      sharedPrefHelper.userLogin();
      sharedPrefHelper.savePassword(params.password);
      sharedPrefHelper.saveIdJwtToken(user.getIdToken().jwtToken!);
      sharedPrefHelper
          .savePayload(user.getIdToken().decodePayload().toString());
      sharedPrefHelper.saveString(
          ChadbotConstants.accessToken, user.getAccessToken().getJwtToken()!);
      sharedPrefHelper.saveExpiryTime("${user.getIdToken().getExpiration()}");
      return Right(Void);
    } on CognitoClientException catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        return Left(UserNotConfirmedFailure(e.message!));
      } else {
        return Left(CacheFailure(e.message!));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  /// This function will call remote datasource to send reset email
  /// if it fails to send reset email it will throw instance of [Failure]
  ///
  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await authSource.sendResetEmail(email);
      return Right(Void);
    } on AuthException catch (e) {
      if (e is UserNotFoundAuthException) {
        return Left(UserNotFoundFailure());
      } else {
        return Left(UnknownAuthenticationFailure(e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String email) async {
    await authSource.resendConfirmationCode(email);
    return Right(Void);
  }

  @override
  Future<Either<Failure, void>> verifyCode(VerifyParams params) async {
    try {
      final result = await authSource.verifyOtp(params);
      if (result) {
        return Right(Void);
      } else {
        return Left(UnknownFailure("Invalid OTP code"));
      }
    } catch (e) {
      return Left(UnknownFailure("Invalid OTP code"));
    }
  }

  @override
  Future<Either<Failure, File>> getTextFile(String chatText) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> getProfile() async {
    try {
      final result = await http.post(
        Uri.https(ChadbotConstants.profileget, ChadbotConstants.profileGetPath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jwttoken': sharedPrefHelper.getIdJwtToken(),
        }),
      );

      var data = convert.jsonDecode(result.body);
      var profile = data['profile'];
      print("getprofile $data");
      var fname = "",
          lname = "",
          phone = "",
          gender = "",
          kname = "",
          temp = 0.9,
          topp = 0.9,
          topk = 10,
          memories = 0,
          pokedelay = 30,
          poketop = 2,
          lastseen = "",
          lastpoked = "",
          model = 0,
          repetition = 1.3,
          contextlen = 10,
          contextprune = 0,
          userpersona = 10,
          isadmin = false,
          debug = false,
          contextrand = false,
          contextoff = false;

      if (profile.containsKey("firstname")) fname = profile['firstname'] ?? "";
      if (profile.containsKey("lastname")) lname = profile['lastname'] ?? "";
      if (profile.containsKey("phone")) phone = profile['phone'] ?? "";
      if (profile.containsKey("gender")) gender = profile['gender'] ?? "";
      if (profile.containsKey("chadbotname"))
        kname = profile['chadbotname'] ?? "Chadbot";
      if (profile.containsKey("temp")) temp = profile['temp'] ?? 0.9;
      if (profile.containsKey("topp")) topp = profile['topp'] ?? 0.9;
      if (profile.containsKey("topk")) topk = profile['topk'] ?? 10;
      if (profile.containsKey("memories")) memories = profile['memories'] ?? 0;
      if (profile.containsKey("pokedelay"))
        pokedelay = profile['pokedelay'] ?? 30;
      if (profile.containsKey("poketop")) poketop = profile['poketop'] ?? 2;
      if (profile.containsKey("lastseen")) lastseen = profile['lastseen'] ?? "";
      if (profile.containsKey("lastpoked"))
        lastpoked = profile['lastpoked'] ?? "";
      if (profile.containsKey("model")) model = profile['model'] ?? 0;
      if (profile.containsKey("repetition"))
        repetition = profile['repetition'] ?? 1.3;
      if (profile.containsKey("isadmin")) isadmin = profile['isadmin'] ?? false;
      if (profile.containsKey("contextlen"))
        contextlen = profile['contextlen'] ?? 10;
      if (profile.containsKey("userpersona"))
        userpersona = profile['userpersona'] ?? 10;
      if (profile.containsKey("contextprune"))
        contextprune = profile['contextprune'] ?? 0;
      if (profile.containsKey("contextrand"))
        contextrand = profile['contextrand'] ?? false;
      if (profile.containsKey("debug")) debug = profile['debug'] ?? false;
      if (profile.containsKey("contextoff"))
        contextoff = profile['contextoff'] ?? false;

      /* 'debug': params.debug,
          'contextlen': params.contextlen,
          'contextprune': params.contextprune,
          'contextrand': params.contextrand,
          'contextoff': params.contextoff, */

      sharedPrefHelper.saveInt(ChadbotConstants.memories, memories);
      sharedPrefHelper.saveInt(ChadbotConstants.pokedelay, pokedelay);
      sharedPrefHelper.saveInt(ChadbotConstants.poketop, poketop);
      sharedPrefHelper.saveInt(ChadbotConstants.contextprune, contextprune);
      sharedPrefHelper.saveString(ChadbotConstants.lastpoked, lastpoked);
      sharedPrefHelper.saveString(ChadbotConstants.lastseen, lastseen);
      sharedPrefHelper.saveString(ChadbotConstants.fname, fname ?? "");
      sharedPrefHelper.saveString(ChadbotConstants.lname, lname ?? "");
      sharedPrefHelper.saveString(ChadbotConstants.phone, phone ?? "");
      sharedPrefHelper.saveString(
          ChadbotConstants.chadbotName, kname ?? "Chadbot");
      sharedPrefHelper.saveString(ChadbotConstants.chadbotGender, gender ?? "");
      sharedPrefHelper.saveDouble(ChadbotConstants.temp, temp);
      sharedPrefHelper.saveDouble(ChadbotConstants.topp, topp);
      sharedPrefHelper.saveDouble(ChadbotConstants.repetition, repetition);
      sharedPrefHelper.saveBoolean(ChadbotConstants.isadmin, isadmin);
      sharedPrefHelper.saveBoolean(ChadbotConstants.debug, debug);
      sharedPrefHelper.saveBoolean(ChadbotConstants.contextoff, contextoff);
      sharedPrefHelper.saveBoolean(ChadbotConstants.contextrand, contextrand);
      sharedPrefHelper.saveInt(ChadbotConstants.topk, topk);
      sharedPrefHelper.saveInt(ChadbotConstants.userpersona, userpersona);
      sharedPrefHelper.saveInt(ChadbotConstants.model, model);
      sharedPrefHelper.saveInt(ChadbotConstants.contextlen, contextlen);

      saveRegistrationId();
      return Right(Void);
    } catch (e) {
      print("getprofile1 $e");
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDebug(ProfileParams params) async {
    try {
      final result = await http.post(
        Uri.https(
            ChadbotConstants.profilepost, ChadbotConstants.profilePostPath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'jwttoken': sharedPrefHelper.getIdJwtToken(),
          'debug': params.debug!,
          'contextlen': params.contextlen!,
          'contextprune': params.contextprune!,
          'contextrand': params.contextrand!,
          'contextoff': params.contextoff!,
          'model': params.model!,
          'temp': params.temp!,
          'topp': params.topp!,
          'topk': params.topk!,
          'repetition': params.repetition!,
          'poketop': params.pokeTop!,
          'pokedelay': params.pokeDelay!,
          'lastseen': params.lastseen!,
          'lastpoked': params.lastpoked!,
          'userpersona': params.userpersona!,
          'memories': params.memories!,
        }),
      );

      var jsonResponse = convert.jsonDecode(result.body);
      print("saveprofile $jsonResponse ${result.request!.url}");
      sharedPrefHelper.saveInt(ChadbotConstants.contextlen, params.contextlen!);
      sharedPrefHelper.saveBoolean(
          ChadbotConstants.contextoff, params.contextoff!);
      try {
        sharedPrefHelper.saveInt(
            ChadbotConstants.contextprune, params.contextprune!);
      } catch (e) {
        sharedPrefHelper.saveInt(ChadbotConstants.contextprune, 0);
      }

      sharedPrefHelper.saveBoolean(
          ChadbotConstants.contextrand, params.contextrand!);
      sharedPrefHelper.saveBoolean(ChadbotConstants.debug, params.debug!);

      sharedPrefHelper.saveDouble(ChadbotConstants.temp, params.temp!);
      sharedPrefHelper.saveDouble(ChadbotConstants.topp, params.topp!);
      sharedPrefHelper.saveDouble(
          ChadbotConstants.repetition, params.repetition!);
      sharedPrefHelper.saveInt(ChadbotConstants.topk, params.topk!);

      sharedPrefHelper.saveInt(ChadbotConstants.memories, params.memories!);
      sharedPrefHelper.saveInt(
          ChadbotConstants.userpersona, params.userpersona!);
      sharedPrefHelper.saveInt(ChadbotConstants.pokedelay, params.pokeDelay!);
      sharedPrefHelper.saveInt(ChadbotConstants.poketop, params.pokeTop!);

      sharedPrefHelper.saveString(
          ChadbotConstants.lastpoked, params.lastpoked!);
      sharedPrefHelper.saveString(ChadbotConstants.lastseen, params.lastseen!);
      return Right(Void);
    } catch (e) {
      print("profilepost $e");
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile(ProfileParams params) async {
    try {
      final result = await http.post(
        Uri.https(
            ChadbotConstants.profilepost, ChadbotConstants.profilePostPath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'jwttoken': sharedPrefHelper.getIdJwtToken(),
          'firstname': params.fname!,
          'lastname': params.lname!,
          'email': params.email!,
          'phone': params.phone!,
          'chadbotname': params.chadbotname!,
          'gender': params.chadbotGender!,
        }),
      );

      var jsonResponse = convert.jsonDecode(result.body);
      print("saveprofile1 $jsonResponse ${result.request!.url}");

      sharedPrefHelper.saveString(ChadbotConstants.fname, params.fname!);
      sharedPrefHelper.saveString(ChadbotConstants.lname, params.lname!);
      sharedPrefHelper.saveString(ChadbotConstants.phone, params.phone!);
      sharedPrefHelper.saveString(
          ChadbotConstants.chadbotName, params.chadbotname!);
      sharedPrefHelper.saveString(
          ChadbotConstants.chadbotGender, params.chadbotGender!);
      return Right(Void);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createProfile() async {
    try {
      final result = await http.post(
        Uri.https(
            ChadbotConstants.profilecreate, ChadbotConstants.profileCreatePath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jwttoken': sharedPrefHelper.getIdJwtToken(),
        }),
      );
      var jsonResponse = convert.jsonDecode(result.body);
      saveRegistrationId();
      print("createprofile $jsonResponse ${result.request!.url}");
      return Right(Void);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfile() async {
    try {
      final result = await http.post(
        Uri.https(
            ChadbotConstants.profiledelete, ChadbotConstants.profileDeletePath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jwttoken': sharedPrefHelper.getIdJwtToken(),
        }),
      );
      var jsonResponse = convert.jsonDecode(result.body);
      print("deleteprofile $jsonResponse ${result.request!.url}");
      return Right(Void);
    } catch (e) {
      print("deleteprofile $e");
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteContext() async {
    try {
      final result = await http.post(
        Uri.https(
            ChadbotConstants.contextDelete, ChadbotConstants.contextDeletePath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jwttoken': sharedPrefHelper.getIdJwtToken(),
        }),
      );
      var jsonResponse = convert.jsonDecode(result.body);
      print("deleteContext $jsonResponse ${result.request!.url}");
      return Right(Void);
    } catch (e) {
      print("deleteContext $e");
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCognitoAccount() async {
    try {
      authSource.deleteAccount(sharedPrefHelper.getEmail(),
          sharedPrefHelper.getStringByKey(ChadbotConstants.accessToken, ""));
      return Right(Void);
    } catch (e) {
      print("deleteCognitoAccount $e");
      return Left(ApiFailure(e.toString()));
    }
  }

  void reportBug(
      String label, String email, String subject, String description) async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }

    http.post(
      Uri.https(ChadbotConstants.githubdomain, ChadbotConstants.githubendpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'label': label,
        'email': email,
        'subject': subject,
        'issue': "$description \n ${deviceData.toString()}",
      }),
    );
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Future<Either<Failure, void>> setNewPassword(
      {String? email, String? otp, String? password}) async {
    try {
      return Right(authSource.resetNewPassword(email!, otp!, password!));
    } catch (e) {
      return Left(UnknownFailure("Unknow error occurred"));
    }
  }

  @override
  Future<Either<Failure, void>> saveRegistrationId() async {
    print("registration calleddd");
    try {
      String? registrationId = await FirebaseMessaging.instance.getToken();
      print("registration $registrationId");
      String savedId =
          sharedPrefHelper.getStringByKey(ChadbotConstants.registrationId, "");
      if (registrationId == savedId) {
        return Right(Void);
      }
      final result = await http.post(
        Uri.https(
            ChadbotConstants.profilepost, ChadbotConstants.profilePostPath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'jwttoken': sharedPrefHelper.getIdJwtToken(),
          'registrationid': registrationId!,
        }),
      );
      if (result.statusCode == 200) {
        sharedPrefHelper.saveString(
            ChadbotConstants.registrationId, registrationId);
      }
      return Right(Void);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSingleField(
      SingleProfileParam params) async {
    try {
      await http.post(
        Uri.https(
            ChadbotConstants.profilepost, ChadbotConstants.profilePostPath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'jwttoken': sharedPrefHelper.getIdJwtToken(),
          params.key: params.value,
        }),
      );

      return Right(Void);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }
}
