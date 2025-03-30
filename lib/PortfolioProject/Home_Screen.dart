import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'About_Section.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// 🌙 Theme Provider using Riverpod
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

/// 🎨 Theme Notifier for Dark Mode
 class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  /// 🔄 Toggle Between Light & Dark Mode
  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(state);
  }

  /// 📥 Load Theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  /// 💾 Save Theme Preference
  Future<void> _saveTheme(ThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', theme == ThemeMode.dark);

  }
}

/// 🔥 Main App with Theme Support & Zoom Drawer
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const ZoomDrawerScreen(),
    );
  }
}

/// 📌 Zoom Drawer Implementation
class ZoomDrawerScreen extends StatefulWidget {
  const ZoomDrawerScreen({super.key});

  @override
  State<ZoomDrawerScreen> createState() => _ZoomDrawerScreenState();
}

class _ZoomDrawerScreenState extends State<ZoomDrawerScreen> {
  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _zoomDrawerController,
      style: DrawerStyle.defaultStyle,
      menuScreenWidth: 200,
      menuScreen: const DrawerMenu(),
      mainScreen: const HomeScreenProject(),
      borderRadius: 24.0,
      showShadow: true,
      angle: -10.0,
      duration: Duration(seconds: 3),
      slideWidth: MediaQuery.of(context).size.width * 0.7,
      openCurve: Curves.bounceIn,
      closeCurve: Curves.bounceInOut,
      drawerShadowsBackgroundColor: Color(0xff000000),
      clipMainScreen: EditableText.debugDeterministicCursor,
  menuBackgroundColor: Colors.lightBlueAccent,
      shadowLayer1Color: Colors.yellowAccent,
      shadowLayer2Color: Colors.purpleAccent,

      //    mainScreenOverlayColor: Colors.green.shade200,
    );
  }
}

/// 📌 Drawer Menu
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.purple.shade50,
      child: Container(
        color: Colors.blueGrey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Material(
              child: const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey),
                child: Text("Portfolio Menu", style: TextStyle(color: Colors.white, fontSize: 22)),
              ),
            ),
            _drawerItem(Icons.info, "About Me", context),
            _drawerItem(Icons.design_services, "Services", context),
            _drawerItem(Icons.developer_mode, "Projects", context),
            _drawerItem(Icons.phone, "Contact Me", context),
            _drawerItem(Icons.file_present, "Resume", context),
          ],
        ),
      ),
    );
  }



//This is the Function of the DrawerItem in the ListView I Pass this function make sure of that
  Widget _drawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$title clicked")));
      },
    );
  }
}


//This is the Main Screen of the Ui of Home Screen Make sure of that
/// 📌 Portfolio Home Screen with Speed Dial & Theme Toggle
class HomeScreenProject extends ConsumerWidget {
  const HomeScreenProject({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Portfolio"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(themeProvider) == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              themeNotifier.toggleTheme();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/fluttersocial.jpg'),
            ),
            const SizedBox(height: 10),
            const Text(
              "Dev Guru",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "Flutter Developer | AI Enthusiast",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Hire Me"),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        spacing: 12,
        closeManually: false,
        overlayColor: Colors.white,
        overlayOpacity: 0.4,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.yellow,
            child: const Icon(Icons.info),
            label: "About Me",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AboutScreen();

              }));
            }
          ),
          SpeedDialChild(
            backgroundColor: Colors.greenAccent,
            child: const Icon(Icons.design_services),
            label: "Service",
          ),
          SpeedDialChild(
            backgroundColor: Colors.blueAccent.shade200,
            child: const Icon(Icons.developer_mode),
            label: "Project",
          ),
          SpeedDialChild(
            backgroundColor: Colors.redAccent.shade200,
            child: const Icon(Icons.phone, color: Colors.greenAccent),
            label: "Contact Me",
          ),
          SpeedDialChild(
            backgroundColor: Colors.purple.shade200,
            child: const Icon(Icons.file_present, color: Colors.white),
            label: "Resume",
          ),
        ],
      ),
    );
  }
}
