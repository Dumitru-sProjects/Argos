# Prompt per Claude Code — Argos macOS App

Crea un'app macOS nativa in Swift chiamata **Argos**.

---

## Obiettivo

Un'utility per la menu bar che impedisce al Mac di risultare inattivo
muovendo il cursore di 1 pixel a intervalli regolari. Target: utenti
che usano Slack, Teams o simili e non vogliono risultare offline
quando si allontanano brevemente dal computer.

---

## Requisiti funzionali

- Icona nella **menu bar** (non nel Dock, LSUIElement = true)
- **Toggle on/off** dal menu
- **Intervallo personalizzabile** dal menu: 5 / 10 / 15 / 30 / 60 secondi (default 10)
- L'icona cambia visivamente tra stato attivo e inattivo
  (es. colore diverso o badge verde/grigio)
- Quando attivo, muove il cursore di +1px e lo riporta
  alla posizione originale — impercettibile per l'utente
- Voce **"Avvia al login"** che aggiunge/rimuove l'app dai
  Login Items tramite `SMAppService` (API moderna, macOS 13+)
- Voce **"Esci"** per chiudere l'app

---

## Requisiti tecnici

- Swift + SwiftUI o AppKit puro (scegli tu la soluzione più pulita)
- Deployment target: **macOS 13 Ventura** come minimo
- Muovi il cursore con `CGWarpMouseCursorPosition` o `CGEvent`
  — NON usare cliclick o dipendenze esterne
- Nessuna dipendenza esterna: zero CocoaPods, zero SPM packages di terze parti
- Il progetto deve compilare con `xcodebuild` da CLI senza intervento manuale
- Firma: unsigned (l'utente farà tasto destro → Apri al primo avvio)

---

## Distribuzione

- GitHub Actions workflow (`.github/workflows/release.yml`) che:
  1. Compila con `xcodebuild archive`
  2. Esporta il `.app`
  3. Lo zippa come `Argos.app.zip`
  4. Lo pubblica come asset sulla GitHub Release al push di un tag `v*`
- Il workflow deve funzionare su `macos-latest` runner

---

## Struttura repo attesa

```
Argos/
├── Argos.xcodeproj/
├── Argos/
│   ├── App entry point
│   ├── MenuBarManager (logica toggle + timer)
│   ├── Assets.xcassets (icone active/inactive)
│   └── Info.plist
├── .github/
│   └── workflows/
│       └── release.yml
└── README.md
```

---

## README

Il README deve essere curato e rivolto a utenti non tecnici.
Deve includere:

- Descrizione chiara del problema che risolve ("Stay online on Slack
  and Teams while you step away")
- Sezione **Download & Install** con questi passi:
  1. Vai su GitHub Releases e scarica `Argos.app.zip`
  2. Unzippa e trascina in `/Applications`
  3. Al primo avvio: tasto destro → Apri (bypass Gatekeeper per app unsigned)
  4. Vai in *Impostazioni di Sistema → Privacy e Sicurezza →
     Accessibilità* e abilita Argos
- Sezione **Usage** con screenshot placeholder e descrizione del menu
- Sezione **Requirements**: macOS 13+
- Badge GitHub Actions build status
- Licenza MIT

---

## Note implementative

- Il permesso di Accessibilità è necessario per `CGWarpMouseCursorPosition`
  su macOS recenti — l'app deve controllare all'avvio se il permesso
  è stato concesso e, se no, mostrare un alert con il bottone
  "Apri Impostazioni" che apre direttamente il pannello corretto
- Preferenze (intervallo scelto, stato avvia-al-login) persistite
  con `UserDefaults`
- Il timer deve usare `DispatchSourceTimer` o `Timer` su un thread
  in background, non sul main thread
