import 'package:IITDAPP/modules/attendance/data/attendanceProvider.dart';
import 'package:IITDAPP/ThemeModel.dart';
import 'package:IITDAPP/modules/events/EventsTabProvider.dart';
import 'package:IITDAPP/modules/login/LoginScreen.dart';
import 'package:IITDAPP/modules/login/LoginStateProvider.dart';
import 'package:IITDAPP/modules/news/data/newsData.dart';
import 'package:IITDAPP/modules/settings/data/SettingsData.dart';
import 'package:IITDAPP/modules/settings/data/SettingsHandler.dart';
import 'package:IITDAPP/routes/router.dart' as app_router;
import 'package:IITDAPP/values/Constants.dart';
import 'package:IITDAPP/values/colors/colors.dart';
import 'package:IITDAPP/values/colors/darkColors.dart';
import 'package:IITDAPP/push_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:IITDAPP/routes/Routes.dart';

// import 'package:global_configuration/global_configuration.dart';
// import 'package:syncfusion_flutter_core/core.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
// import 'package:IITDAPP/modules/discussionForum/discuss.dart';
import 'package:IITDAPP/modules/courses/screens/search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   await GlobalConfiguration().loadFromAsset('secrets');
  //   SyncfusionLicense.registerLicense(
  //       // ignore: deprecated_member_use
  //       GlobalConfiguration().getString('calendar_api_key'));
  // } catch (e) {
  //   print('secrets.json file is required');
  // }
  unawaited(extractAppVersion());
  // unawaited(initialiseNotifications());
  unawaited(initialisePreferences());
  await savedstate.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => NewsProvider<TrendingNews>(),
    ),
    ChangeNotifierProvider(
      create: (_) => NewsProvider<RecentNews>(),
    ),
    ChangeNotifierProvider(
      create: (_) => NewsProvider<OldNews>(),
    ),
    ChangeNotifierProvider(
      create: (_) => AttendanceProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => NewsHistoryProvider(),
    ),
    ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
    ),
    ChangeNotifierProvider(
      create: (_) => EventsTabProvider(),
    ),
    ChangeNotifierProvider(create: (_) => LoginStateProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'IITD APP',
      theme: Provider.of<ThemeModel>(context).themeType == ThemeType.Dark
          ? darkTheme
          : lightTheme,
      darkTheme: Provider.of<ThemeModel>(context).themeType == ThemeType.Light
          ? lightTheme
          : darkTheme,
      home: LoginScreen(),
      onGenerateRoute: app_router.Router.generateRoute,
    );
  }
}

// ignore: always_declare_return_types
initialisePreferences() async {
  var res = await SettingsHandler.getSettingValue(commonKeys[0]);
  defaultScreen = res;
  res = await SettingsHandler.getSettingValue(commonKeys[3]);
  avImage = avatars[res];
}

// ignore: always_declare_return_types
extractAppVersion() async =>
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

// ignore: always_declare_return_types

var fcm;
initialiseNotifications(context) async {
  print('Initialising Notifications');
  await Firebase.initializeApp();
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
    if (message != null) {
      print('A new message was published! ${message.data}');
      Navigator.pushReplacementNamed(context, Routes.events);
    }
  });
  print('Testing Push Notifications');
  var pushNotificationsManager = PushNotificationsManager();
  fcm = await pushNotificationsManager.init();
  print("fcm " + fcm);
  // try {
  //   await Calendarnotificationprovider.setPackageName('com.example.IITDAPP');
  //   await Calendarnotificationprovider.setDescription(
  //       start: 'Time:- ', end: '', text: DynamicTextEventKeys.RangeTime);
  //   await Calendarnotificationprovider.setTitle(
  //       start: 'Event:- ', text: DynamicTextEventKeys.Title);
  // } on PlatformException {
  //   print('Error Occured');
  // }
}
