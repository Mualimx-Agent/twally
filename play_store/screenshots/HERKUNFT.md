# Herkunft dieser Screenshots

Aufgenommen am 22.08.2026 aus der **laufenden Anwendung**: Flutter-Web-Build
von Tawali, gesteuert ueber das Chrome DevTools Protocol, Geraetemasse
1080x1920 im Mobil-Modus.

Es ist derselbe Dart-Code, dieselben Widgets und dasselbe Theme wie in der
Android-App. Kein Bild ist gezeichnet, nichts ist nachtraeglich hineinretuschiert.

Werkzeug: `~/shoot.py`. Wiederholbar mit:

    cd ~/apps/tawali/app/tawali_app
    ~/flutter/bin/flutter build web --release --no-tree-shake-icons \
      --dart-define=FLUTTER_WEB_CANVASKIT_FORCE_CPU_ONLY=true
    cd build/web && python3 -m http.server 8899 &
    chromium --headless=new --no-sandbox --disable-gpu \
      --enable-unsafe-swiftshader --remote-debugging-port=9222 about:blank &
    python3 ~/shoot.py "http://127.0.0.1:8899/" ~/shots-tawali/echt "/home:02_home" ...

Der CPU-Renderer (`FLUTTER_WEB_CANVASKIT_FORCE_CPU_ONLY`) ist noetig, weil der
Oracle-ARM-Server keine GPU und kein funktionierendes SwiftShader-WebGL hat.

## Wichtig vor der Verwendung im Play Store

Die Aufnahmen zeigen die **Demo-Daten** aus `RestaurantProvider._initDemoData()`
(10 Restaurants, 34 Gerichte). Die Restaurantbilder sind Platzhalter-Symbole,
keine Fotos. Solange die App keine echten Daten und keinen Bestell-Backend hat,
sind diese Bilder fuer eine Veroeffentlichung nicht geeignet -- nicht weil sie
unecht waeren, sondern weil die App dahinter noch nichts tut.

## Masse (korrigiert am 22.08.2026)

Aufgenommen mit **360x800 logischen Pixeln** (echte Telefonmasse) und beim
Aufnehmen per `clip.scale = 3` auf **1080x2400 Bildpunkte** hochskaliert.

Der naheliegende Weg -- `deviceScaleFactor: 3` in
`Emulation.setDeviceMetricsOverride` -- funktioniert **nicht**: Flutter-Web
uebernimmt den Wert nicht und rendert unskaliert in die linke obere Ecke,
sodass die App nur ein Neuntel des Bildes einnimmt. Werkzeug: `~/shoot2.py`.

Zweite Falle: Flutter registriert einen **Service Worker**. Wird auf demselben
Port eine andere App ausgeliefert, zeigt der Browser weiter die alte aus dem
Cache. Pro App einen eigenen Port und ein frisches Browserprofil verwenden.
