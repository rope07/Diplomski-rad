// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dipl2/app_state.dart';
import 'package:dipl2/tekstovi.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

enum MojPopupMenu {zoomIn, zoomOut, changeFont, changeTheme, resetSize, darkMode, highlightLinks, underlineLinks}

class SvetiVlaho extends StatefulWidget {

  @override
  State<SvetiVlaho> createState() => _SvetiVlahoState();
}

class _SvetiVlahoState extends State<SvetiVlaho> {
  Tekstovi tekst = Tekstovi();
  late VideoPlayerController _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/sv_vlaho.mp4')
      ..setLooping(true)
      ..setVolume(0.0)
      ..initialize().then((_) {
        setState(() {
          _videoController.pause();
        });
      });
    
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleAudio() async {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      await _audioPlayer.play(
        AssetSource('audio/sv_vlaho.aac'),
        volume: 1.0,
        ctx: AudioContext(
          android: const AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: true,
          usageType: AndroidUsageType.media,
          contentType: AndroidContentType.music,
          audioFocus: AndroidAudioFocus.none, // Prevents stopping video
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient, // Automatically includes mixWithOthers
        ),
        )
      );
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _resetMedia(){
    _videoController.seekTo(Duration.zero);
    _videoController.pause();

    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return FocusScope(
      node: focusScopeNode,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appState.bodyColor,
          title: Text(
            'Crkva sv. Vlaha',
            style: TextStyle(color: appState.textColor)
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tekst katedrale
                  Text(
                    tekst.sv_vlaho,
                    style: TextStyle(
                      fontSize: appState.fontSize,
                      fontFamily: appState.fontFamily,
                      color: appState.textColor, // Osnovna boja teksta
                    ),
                  ),
                  const SizedBox(height: 5),

                  Semantics(
                    label: 'Poveznica za web stranicu Crkve sv. Vlaha',
                    hint: 'Klik na poveznicu vas vodi na web stranicu Crkve sv. Vlaha',
                    link: true,
                    child: GestureDetector(
                      onTap: () async {
                        final Uri uri = Uri.parse('https://katedraladubrovnik.hr/zborna-crkva-sv-vlaha/');
                        if (!await launchUrl(uri)) {
                          print('Could not launch $uri');
                        } else {
                          print('Successfully launched $uri');
                        }
                      },
                      child: Consumer<AppState>(
                        builder: (context, appState, child) {
                          return Text(
                            'Crkva sv. Vlaha',
                            style: TextStyle(
                              color: appState.highlightLinksActive
                                  ? Colors.red
                                  : appState.underlineLinksActive
                                    ? Colors.black
                                    : Colors.blue,
                              backgroundColor: appState.highlightLinksActive
                                  ? Colors.yellow
                                  : Colors.transparent,
                              decoration: TextDecoration.underline,
                              fontSize: appState.fontSize
                            ),
                          );
                        }
                      )
                    ),
                  ),

                  const SizedBox(height: 5), // Razmak između teksta i gumba
      
                  SizedBox(
                    height: 250,
                    child: PageView(
                      controller: PageController(
                        viewportFraction: 0.8, // Adjusts how much of the next item is visible
                        initialPage: 0, // Start from the last image
                      ),
                      reverse: false, // Reverses the order of scrolling
                      scrollDirection: Axis.horizontal,
                      children: [
                        Semantics(
                          label: 'Crkva sv. Vlaha iz smjera Straduna',
                          child: Image.asset('assets/images/sv_vlaho/sv_vlaho2.jpg', width: 600, height: 600),
                        ),
                        Semantics(
                          label: 'Pročelje crkve sv. Vlaha iz smjera Straduna',
                          child: Image.asset('assets/images/sv_vlaho/sv_vlaho3.jpg', width: 600, height: 600),
                        ),
                        Semantics(
                          label: 'Istočna vrata crkve sv. Vlaha',
                          child: Image.asset('assets/images/sv_vlaho/sv_vlaho1.jpg', width: 600, height: 600),
                        ),
                        Semantics(
                          label: 'Istočna vrata crkve sv. Vlaha',
                          child: Image.asset('assets/images/sv_vlaho/sv_vlaho4.jpg', width: 600, height: 600),
                        ),
                        Semantics(
                          label: 'Pogled na oltar sa glavnog ulaza u crkvu sv. Vlaha',
                          child: Image.asset('assets/images/sv_vlaho/sv_vlaho5.jpg', width: 600, height: 600, fit: BoxFit.fill,),
                        ),
                      ],
                    ),
                  ),      
      
                  // Audio gumb
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: Semantics(
                      label: 'Gumb za pokretanje audio zapisa',
                      hint: 'Pritisnite jednom za pokretanje te jednom za zaustavljanje audio zapisa',
                      button: true,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(appState.bodyColor),
                          side: WidgetStateProperty.all(BorderSide(color: appState.textColor, width: 3.0)),
                          foregroundColor: WidgetStateProperty.all(appState.textColor),
                        ),
                        onPressed: _toggleAudio,
                        child: Text(_isPlaying ? 'Zaustavi audio zapis' : 'Pokreni audio zapis'),
                      ),
                    ),
                  ),
      
                  const SizedBox(height: 10), // Razmak između gumbova
      
                  // Video player
                  _videoController.value.isInitialized
                      ? Column(
                          children: [
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: Semantics(
                                label: 'Gumb za pokretanje video zapisa',
                                hint: 'Pritisnite jednom za pokretanje te jednom za zaustavljanje video zapisa',
                                button: true,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(appState.bodyColor),
                                    side: WidgetStateProperty.all(BorderSide(color: appState.textColor, width: 3.0)),
                                    foregroundColor: WidgetStateProperty.all(appState.textColor),
                                  ),
                                  onPressed: () {
                                    if (_videoController.value.isPlaying) {
                                      _videoController.pause();
                                    } else {
                                      _videoController.play();
                                    }
                                    setState(() {});
                                  },
                                  child: Text(_videoController.value.isPlaying ? 'Zaustavi video' : 'Pokreni video'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 200,
                              child: AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
