import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typewritertext/typewritertext.dart';
import 'About_Section.dart';
import 'Animation_Background.dart';
import 'package:flip_card/flip_card.dart';

import 'Contact_File.dart';
import 'Project_Screen.dart';
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
      menuBackgroundColor: Color(0xffE5E5EA),
      shadowLayer1Color: Colors.yellowAccent.shade200,
      shadowLayer2Color: Colors.purpleAccent.shade200,

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
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                child:
              ClipRect(
                clipBehavior: Clip.antiAlias,
                child: ClipOval(
                  child: Image.asset('assets/images/ghibli-transformed-1743487333821.png',

                  ),
                ),
              )
              ),
            ),
            _drawerItem(Icons.info, "About Me", context,AboutScreen()),
            _drawerItem(Icons.design_services, "Services", context,AnimatedContainerScreenservice()),
            _drawerItem(Icons.developer_mode, "Projects", context,ProjectsScreen()),
            _drawerItem(Icons.phone, "Contact Me", context,ContactPage()),
            _drawerItem(Icons.file_present, "Resume", context,AboutScreen()),
          ],
        ),
      ),
    );
  }



//This is the Function of the DrawerItem in the ListView I Pass this function make sure of that
  Widget _drawerItem(IconData icon, String title, BuildContext context, Widget widgets) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
      onTap: () {

       Future.delayed(Duration(milliseconds: 500),(){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>widgets));
       });
      },
    );
  }
}


//This is the Main Screen of the Ui of Home Screen Make sure of that
/// 📌 Portfolio Home Screen with Speed Dial & Theme Toggle
class HomeScreenProject extends ConsumerStatefulWidget {
  const HomeScreenProject({super.key});

  @override
  _HomeScreenProjectState createState() => _HomeScreenProjectState();
}

class _HomeScreenProjectState extends ConsumerState<HomeScreenProject> with SingleTickerProviderStateMixin{

   late AnimationController sizecontroller;
   late Animation<double>sizeanimation;



   void initState(){
   super.initState();
   sizecontroller=AnimationController(vsync: this,duration: Duration(seconds: 5));
   sizeanimation=Tween<double>(begin: 0,end: 100).animate(
     CurvedAnimation(parent: sizecontroller, curve: Curves.bounceInOut),
   );
   sizecontroller.forward();
   }
  @override
  Widget build(BuildContext context) {
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
            AnimatedBuilder(

                animation:sizecontroller
                , builder: (context,child){
              return FlipCard(

                back:CircleAvatar(
                  radius: sizeanimation.value,
                  backgroundImage: AssetImage('assets/images/ghibli-transformed-1743487333821.png'),
                ),
                front: CircleAvatar(
                  radius: sizeanimation.value,
                  backgroundImage: AssetImage('assets/images/IMG-20250322-WA0060.jpg'
                  ),
                ),
              );
            })
            , SizedBox(height: 10),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                       const Text(
                        "Priyanshu Satija",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    const SizedBox(height: 5),
                    const Text(
                      "Flutter Developer | AI Enthusiast",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Hi, I'm Priyanshu, a passionate Flutter developer with a strong interest in AI. I'm always eager to learn new things and share my knowledge with others. I'm currently working as a software engineer at a startup, where I'm responsible for developing and maintaining mobile applications.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Hire Me"),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        spacing: 12,
        closeManually: false,
        overlayOpacity: 0.4,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.yellow,
            child: const Icon(Icons.info,color: Colors.black,),
            label: "About Me",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AboutScreen();

              }));
            }
          ),
          SpeedDialChild(
            backgroundColor: Colors.greenAccent,
            child: const Icon(Icons.design_services,color: Colors.black,),
            label: "Service",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AnimatedContainerScreenservice();
              }));
            }
          ),
          SpeedDialChild(
            backgroundColor: Colors.blueAccent.shade200,
            child: const Icon(Icons.developer_mode,color: Colors.black,),
            label: "Project",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return ProjectsScreen();
              }));
            }
          ),
          SpeedDialChild(
            backgroundColor: Colors.redAccent.shade200,
            child: const Icon(Icons.phone,color: Colors.black,),
            label: "Contact Me",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ContactPage();
              }));
            }
          ),
          SpeedDialChild(
            backgroundColor: Colors.purple.shade200,
            child: const Icon(Icons.file_present,color: Colors.black,),
            label: "Resume",
          ),
        ],
      ),
    );
  }
}
