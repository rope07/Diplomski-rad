import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'locations/sv_vlaho.dart';
import 'locations/katedrala.dart';
import 'locations/mala_braca.dart';

enum MojPopupMenu {zoomIn, zoomOut, changeFont, changeTheme, resetSize, darkMode, underlineLinks, highlightLinks}

class Menu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appState.bodyColor,
        title: Text('Izbornik', style: TextStyle(color: appState.textColor)),
        centerTitle: true,
        actions: [
          IconButton(
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
                        label: 'Smanj font',
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
                        label: 'Podcratj poveznice',
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
                  ],
                );
              },
            ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.church, size: appState.iconSize),
            title: Text('Crkva sv. Vlaha', style: TextStyle(fontSize: appState.fontSize, color: appState.textColor)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SvetiVlaho()));
            },
          ),
          ListTile(
            leading: Icon(Icons.church, size: appState.iconSize),
            title: Text('Katedrala Uznesenja Blažene Djevice Marije', style: TextStyle(fontSize: appState.fontSize, color: appState.textColor)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Katedrala()));
            },
          ),
          ListTile(
            leading: Icon(Icons.church, size: appState.iconSize),
            title: Text('Samostan Male braće', style: TextStyle(fontSize: appState.fontSize, color: appState.textColor)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MalaBraca()));
            },
          ),
        ],
      ),
    );
  }
}
