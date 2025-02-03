import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menu.dart';
import 'map.dart';
import 'app_state.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MyApp(),
  )
);

enum MojPopupMenu {zoomIn, zoomOut, changeFont, changeTheme, resetSize, darkMode, highlightLinks, underlineLinks}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  late List<Widget> _pages = [
    HomePage(),
    Menu(),
    Karta(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: appState.fontFamily,
        primaryColor: appState.primaryColor,
        scaffoldBackgroundColor: appState.bodyColor
      ),
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Semantics(
          label: "Navigacijska traga za odabir stranice",
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Semantics(
                  label: "Naslovnica",
                  hint: "Prebaci na nslovnicu",
                  child: const Icon(Icons.home)),
                label: 'Naslovnica'
              ),
              BottomNavigationBarItem(
                icon: Semantics(
                  label: 'Izbornik',
                  hint: "Prebaci na stranicu izbornika",
                  child: const Icon(Icons.menu)),
                label: 'Izbornik'
              ),
              BottomNavigationBarItem(
                icon: Semantics(
                  label: "Karta",
                  hint: "Prebaci na stranicu karte",
                  child: const Icon(Icons.map)),
                label: 'Karta'
              ),
            ],
            backgroundColor: appState.bodyColor,
            selectedItemColor: appState.textColor,
            unselectedItemColor: appState.textColor.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.bodyColor,
        title: Text(
          'Naslovnica',
          style: TextStyle(color: appState.textColor),
        ),
        centerTitle: true,
        actions: [
          Semantics(
            label: 'Postavke pristupačnosti',
            hint: 'Kliknite za otkrivanje postavki pristupačnosti',
            button: true,
            child: IconButton(
                icon: Icon(Icons.accessibility, color: appState.textColor),
                onPressed: () async {
                  //final RenderBox button = context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                  final RelativeRect position = RelativeRect.fromLTRB(overlay.size.width,70,0,0);
                  
                  await showMenu(
                    context: context,
                    position: position,
                    items: [
                      PopupMenuItem<MojPopupMenu>(
                        value: MojPopupMenu.zoomIn,
                        child: Semantics(
                          label: 'Povećaj font',
                          hint: 'Pritisnite za povećanje fonta',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              appState.increaseSize();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.add),
                              title: Text('Povećanje fonta'),
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<MojPopupMenu>(
                        value: MojPopupMenu.zoomOut,
                        child: Semantics(
                          label: 'Smanji font',
                          hint: 'Pritisnite za smanjenje fonta',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              appState.decreaseSize();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.remove),
                              title: Text('Smanjenje fonta'),
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<MojPopupMenu>(
                        value: MojPopupMenu.changeFont,
                        child: Semantics(
                          label: 'Promijeni font',
                          hint: 'Pritisnite za promjenu fonta',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              appState.toggleFont();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.font_download_outlined),
                              title: Text('Promjena fonta'),
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<MojPopupMenu>(
                        value: MojPopupMenu.changeTheme,
                        child: Semantics(
                          label: 'Promijeni temu',
                          hint: 'Pritisnite za promjenu teme',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              appState.cycleTheme();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.wb_sunny_outlined),
                              title: Text('Promjena teme'),
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<MojPopupMenu>(
                        value: MojPopupMenu.darkMode,
                        child: Semantics(
                          label: 'Tamni način',
                          hint: 'Postavite tamni način rada',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              appState.setDarkMode();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.wb_sunny_outlined),
                              title: Text('Tamni način'),
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<MojPopupMenu>(
                        value: MojPopupMenu.highlightLinks,
                        child: Semantics(
                          label: 'Naglasi poveznice',
                          hint: 'Naglasite poveznice prikazane na stranici',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              appState.highlightLinks();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.link),
                              title: Text('Naglasi poveznice'),
                            ),
                          ),
                        ),
                      ),
                      PopupMenuItem<MojPopupMenu>(
                        value: MojPopupMenu.underlineLinks,
                        child: Semantics(
                          label: 'Podcrtaj poveznice',
                          hint: 'Podcrtajte poveznice prikazane na stranici',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              appState.underlineLinks();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.format_underline),
                              title: Text('Podcrtaj poveznice'),
                            ),
                          ),
                        ),
                      ),                      
                      PopupMenuItem<MojPopupMenu>(
                        value: MojPopupMenu.resetSize,
                        child: Semantics(
                          label: 'Vraćanje na zadano',
                          hint: 'Vratite postavke pristupačnosti na zadano',
                          button: true,
                          child: GestureDetector(
                            onTap: () {
                              appState.resetSize();
                            },
                            child: const ListTile(
                              leading: Icon(Icons.restart_alt_outlined),
                              title: Text('Vraćanje na zadano'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Prototip pristupačne aplikacije za turizam. Razvijena je u sklopu diplomskog rada "Model procesa razvoja programskih rješenja za pristupačni turizam" Pera Paskovića pod mentorstvom prof. dr. sc. Željke Car, ak. godina 2024/2025, Sveučilište u Zagrebu Fakultet elektrotehnike i računarstva',
            style: TextStyle(fontSize: appState.fontSize, fontFamily: appState.fontFamily, color: appState.textColor),
            textAlign: TextAlign.center
          ),
        ),
      ),
    );
  }
}
