// // ==============================
// // 📌 IMPORTS
// // ==============================
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'firebase_options.dart';

// // Your pages
// import 'package:app/features/forms/register.dart';
// // TODO: add your other screens here
// // import 'package:app/features/forms/login.dart';
// // import 'package:app/features/dashboard/job_seeker_dashboard.dart';
// // import 'package:app/features/dashboard/employer_dashboard.dart';

// // ==============================
// // 🔔 BACKGROUND NOTIFICATION HANDLER
// // ==============================
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   debugPrint('📩 Background message: ${message.data}');
// }

// // ==============================
// // 🔔 LOCAL NOTIFICATION INSTANCE
// // ==============================
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // ==============================
// // 🔧 SETUP FIREBASE NOTIFICATIONS
// // ==============================
// Future<void> setupFirebaseNotifications() async {
//   if (!kIsWeb &&
//       !(Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
//     debugPrint('⚠️ Notifications not supported on this platform.');
//     return;
//   }

//   // Register background handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   final messaging = FirebaseMessaging.instance;

//   // Request permission
//   final settings = await messaging.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   debugPrint('🔐 Permission: ${settings.authorizationStatus}');

//   // ============================
//   // ANDROID: Notification Channel
//   // ============================
//   if (Platform.isAndroid) {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'default_channel',
//       'Default Notifications',
//       description: 'Used for PESO App notifications',
//       importance: Importance.high,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     await flutterLocalNotificationsPlugin.initialize(
//       const InitializationSettings(
//         android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//       ),
//     );
//   }

//   // ============================
//   // FOREGROUND NOTIFICATIONS
//   // ============================
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     debugPrint('🟦 FOREGROUND: ${message.data}');
//     final notif = message.notification;

//     if (notif != null && Platform.isAndroid) {
//       flutterLocalNotificationsPlugin.show(
//         notif.hashCode,
//         notif.title,
//         notif.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             'default_channel',
//             'Default Notifications',
//             importance: Importance.high,
//             priority: Priority.high,
//             styleInformation: BigTextStyleInformation(notif.body ?? ''),
//           ),
//         ),
//       );
//     }
//   });

//   // ============================
//   // APP OPENED FROM BACKGROUND
//   // ============================
//   FirebaseMessaging.onMessageOpenedApp.listen((message) {
//     debugPrint('🟢 Notification tapped (background): ${message.data}');
//     _handleNotificationClick(message.data);
//   });

//   // ============================
//   // DEVICE TOKEN
//   // ============================
//   try {
//     final token = await messaging.getToken();
//     debugPrint("📱 DEVICE FCM TOKEN: $token");
//   } catch (e) {
//     debugPrint("❌ ERROR getting FCM token: $e");
//   }
// }

// // ==============================
// // 🔀 NOTIFICATION NAVIGATION LOGIC
// // ==============================
// void _handleNotificationClick(Map<String, dynamic> data) {
//   if (globalNavigateTo == null) return;

//   switch (data['screen']) {
//     case 'employer_dashboard':
//       globalNavigateTo!(PageType.employerDashboard);
//       break;

//     case 'jobseeker_dashboard':
//       globalNavigateTo!(PageType.jobSeekerDashboard);
//       break;

//     case 'login':
//       globalNavigateTo!(PageType.login);
//       break;

//     case 'register':
//       globalNavigateTo!(PageType.register);
//       break;

//     default:
//       debugPrint('⚠️ Unknown screen: ${data['screen']}');
//   }
// }

// // ==============================
// // 🩵 APP ENTRY POINT
// // ==============================
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   await setupFirebaseNotifications();

//   // ============================
//   // HANDLE TERMINATED NOTIFICATION TAPS
//   // ============================
//   RemoteMessage? initialMessage =
//       await FirebaseMessaging.instance.getInitialMessage();

//   if (initialMessage != null) {
//     debugPrint("🚀 Launched from terminated: ${initialMessage.data}");

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _handleNotificationClick(initialMessage.data);
//     });
//   }

//   runApp(const MyApp());
// }

// // ==============================
// // 🧩 APP STRUCTURE
// // ==============================
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "PESO Mendez",
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const MainScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // ==============================
// // 📌 PAGE NAVIGATION WITH ENUM
// // ==============================
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// enum PageType {
//   home,
//   register,
//   login,
//   jobSeekerDashboard,
//   jobSeekerEditProfile,
//   employerDashboard,
// }

// typedef NavigateToCallback = void Function(PageType page);
// NavigateToCallback? globalNavigateTo;

// class _MainScreenState extends State<MainScreen> {
//   PageType _currentPage = PageType.home;

//   void _navigateTo(PageType page) {
//     setState(() {
//       _currentPage = page;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     globalNavigateTo = _navigateTo;
//   }

//   @override
//   void dispose() {
//     globalNavigateTo = null;
//     super.dispose();
//   }

//   // ============================
//   // ROUTING FUNCTION
//   // ============================
//   Widget _getPage() {
//     switch (_currentPage) {
//       case PageType.home:
//         return const Register(); // Replace with your HomePage();

//       case PageType.register:
//         return const Register();

//       case PageType.login:
//         return Text("Login Page Placeholder"); // TODO

//       case PageType.jobSeekerDashboard:
//         return Text("Job Seeker Dashboard Placeholder"); // TODO

//       case PageType.jobSeekerEditProfile:
//         return Text("Edit Profile Placeholder"); // TODO

//       case PageType.employerDashboard:
//         return Text("Employer Dashboard Placeholder"); // TODO;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: _getPage());
//   }
// }







// ==============================
// 📌 IMPORTS
// ==============================
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:app/features/forms/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'firebase_options.dart';

// Your pages
import 'package:app/features/forms/register.dart';

// ==============================
// 🔧 PLATFORM CHECK
// ==============================
bool get isMobileOrWeb {
  return kIsWeb ||
      (Platform.isAndroid || Platform.isIOS);
}

// ==============================
// 🔔 BACKGROUND NOTIFICATION HANDLER
// ==============================
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('📩 Background message: ${message.data}');
}

// ==============================
// 🔔 LOCAL NOTIFICATION INSTANCE
// ==============================
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// ==============================
// 🔧 SETUP FIREBASE NOTIFICATIONS
// ==============================
Future<void> setupFirebaseNotifications() async {
  if (!isMobileOrWeb) {
    debugPrint('⚠️ Firebase Messaging is skipped on this platform.');
    return;
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final messaging = FirebaseMessaging.instance;

  // Permissions
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint('🔐 Permission: ${settings.authorizationStatus}');

  // ANDROID CHANNEL
  if (Platform.isAndroid) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel',
      'Default Notifications',
      description: 'Used for PESO App notifications',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  // FOREGROUND NOTIFICATIONS
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('🟦 FOREGROUND: ${message.data}');
    final notif = message.notification;

    if (notif != null && Platform.isAndroid) {
      flutterLocalNotificationsPlugin.show(
        notif.hashCode,
        notif.title,
        notif.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel',
            'Default Notifications',
            importance: Importance.high,
            priority: Priority.high,
            styleInformation: BigTextStyleInformation(notif.body ?? ''),
          ),
        ),
      );
    }
  });

  // APP OPENED FROM BACKGROUND (tap)
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint('🟢 Notification tapped (background): ${message.data}');
    _handleNotificationClick(message.data);
  });

  // GET TOKEN
  try {
    final token = await messaging.getToken();
    debugPrint("📱 DEVICE FCM TOKEN: $token");
  } catch (e) {
    debugPrint("❌ ERROR getting FCM token: $e");
  }
}

// ==============================
// 🔀 NOTIFICATION NAVIGATION LOGIC
// ==============================
void _handleNotificationClick(Map<String, dynamic> data) {
  if (globalNavigateTo == null) return;

  switch (data['screen']) {
    case 'employer_dashboard':
      globalNavigateTo!(PageType.employerDashboard);
      break;
    case 'jobseeker_dashboard':
      globalNavigateTo!(PageType.jobSeekerDashboard);
      break;
    case 'login':
      globalNavigateTo!(PageType.login);
      break;
    case 'register':
      globalNavigateTo!(PageType.register);
      break;
    default:
      debugPrint('⚠️ Unknown screen: ${data['screen']}');
  }
}

// ==============================
// 🩵 APP ENTRY POINT
// ==============================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // SAFELY RUN NOTIFICATIONS ONLY ON SUPPORTED DEVICES (Android/iOS/Web)
  if (isMobileOrWeb) {
    await setupFirebaseNotifications();

    // Handle app launched from terminated state
    try {
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        debugPrint("🚀 Launched from terminated: ${initialMessage.data}");

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleNotificationClick(initialMessage.data);
        });
      }
    } catch (e) {
      debugPrint("⚠️ getInitialMessage() skipped: $e");
    }
  } else {
    debugPrint("⚠️ Firebase Messaging is skipped on Windows/macOS/Linux.");
  }

  runApp(const MyApp());
}


// ==============================
// 🧩 APP STRUCTURE
// ==============================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PESO Mendez",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ==============================
// 📌 PAGE NAVIGATION WITH ENUM
// ==============================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum PageType {
  home,
  register,
  login,
  jobSeekerDashboard,
  jobSeekerEditProfile,
  employerDashboard,
}

typedef NavigateToCallback = void Function(PageType page);
NavigateToCallback? globalNavigateTo;

class _MainScreenState extends State<MainScreen> {
  PageType _currentPage = PageType.home;

  void _navigateTo(PageType page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void initState() {
    super.initState();
    globalNavigateTo = _navigateTo;
  }

  @override
  void dispose() {
    globalNavigateTo = null;
    super.dispose();
  }

  Widget _getPage() {
    switch (_currentPage) {
      case PageType.home:
        return const Login();
      case PageType.register:
        return const Register();
      case PageType.login:
        return const Text("Login Page Placeholder");
      case PageType.jobSeekerDashboard:
        return const Text("Job Seeker Dashboard Placeholder");
      case PageType.jobSeekerEditProfile:
        return const Text("Edit Profile Placeholder");
      case PageType.employerDashboard:
        return const Text("Employer Dashboard Placeholder");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _getPage());
  }
}
