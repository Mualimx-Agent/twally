# Warum diese Fassungen ersetzt wurden

In beiden stand طوالي falsch: die Buchstaben waren unverbunden und standen in
umgekehrter Reihenfolge.

**Ursache:** Pillow setzt arabische Zeichen ohne Textshaper in ihrer Einzelform
und in logischer statt visueller Reihenfolge. Das Wort zerfaellt dadurch und
erscheint gespiegelt.

**Falscher Loesungsversuch:** `arabic_reshaper` + `python-bidi` waehlen zwar die
Praesentationsformen (U+FEF2 U+FEDF U+FE8D U+FEEE U+FEC3), aber Pillows
Basic-Layout setzt sie ohne kursive Verbindung aneinander -- das Ergebnis bleibt
zerfallen.

**Richtig:** Pillow ist hier mit **libraqm/HarfBuzz** gebaut
(`PIL.features.check("raqm")` -> True). Damit den **Rohtext** uebergeben:

    f = ImageFont.truetype(pfad, groesse, layout_engine=ImageFont.Layout.RAQM)
    d.text(xy, "طوالي", font=f, direction="rtl")

Kein arabic_reshaper davor -- das wuerde die Verbindungen wieder zerstoeren.
Schriftart: NotoNaskhArabic-Bold (aus fonts-noto-core, am 22.08. nachinstalliert;
DejaVu Sans kann Arabisch zwar darstellen, sieht aber generisch aus).
