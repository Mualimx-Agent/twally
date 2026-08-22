# Data Safety — Tawali v1.0.0

Vorlage zum Ausfuellen des Formulars in der Play Console.
`com.mualimx.tawali` · Stand 22.08.2026

> **Diese Angaben beschreiben den geplanten Zustand mit echtem Backend.**
> Der heutige Code speichert alles nur im Arbeitsspeicher und verschickt
> nichts. Vor dem Ausfuellen pruefen, was die App zu diesem Zeitpunkt
> tatsaechlich tut — falsche Angaben im Data-Safety-Formular sind ein
> Verstoss gegen die Play-Richtlinien.

## Werden Daten erhoben oder geteilt?

Ja.

| Kategorie | Datentyp | Erhoben | Geteilt | Zweck | Pflicht |
|---|---|---|---|---|---|
| Personenbezogen | Name | Ja | Ja (Restaurant/Fahrer) | App-Funktion | Ja |
| Personenbezogen | Telefonnummer | Ja | Ja (Restaurant/Fahrer) | App-Funktion, Anmeldung | Ja |
| Personenbezogen | Adresse | Ja | Ja (Restaurant/Fahrer) | App-Funktion | Ja |
| Standort | Ungefaehrer Standort | Ja | Nein | App-Funktion | Nein |
| App-Aktivitaet | Bestellverlauf | Ja | Nein | App-Funktion | Ja |
| Geraete-ID | Push-Token | Ja | Nein | Benachrichtigungen | Nein |

**Finanzdaten: keine.** Bezahlung ausschliesslich bar bei Lieferung.

## Sicherheitspraktiken

- Uebertragung verschluesselt: **Ja** (HTTPS/TLS zu Firebase)
- Nutzer koennen Loeschung verlangen: **Ja** (per E-Mail, Umsetzung in 30 Tagen)
- Unabhaengige Sicherheitspruefung: **Nein**

## Berechtigungen im Manifest

| Berechtigung | Begruendung fuer die Konsole |
|---|---|
| `INTERNET` | Kommunikation mit dem Bestellsystem |
| `ACCESS_FINE_LOCATION` | Restaurants in der Naehe, Adresse vorschlagen |
| `ACCESS_COARSE_LOCATION` | dasselbe, groebere Genauigkeit |
| `ACCESS_NETWORK_STATE` | Hinweis bei fehlender Verbindung |

Kein Hintergrund-Standort, keine Kamera, keine Kontakte, kein Speicherzugriff.
