---
name: daily-review
description: >
  Tägliches Review von OmniFocus-Projekten, Google Calendar und Obsidian-Vault.
  Aktiviere diesen Skill ausschließlich über den /daily Slash-Command.
  Sammelt Kalender-Termine, OmniFocus-Projekte und offene Punkte aus
  Tagesnotizen, zeigt ein kompaktes Dashboard mit Problemmarkierungen,
  und bietet interaktive Vertiefung. Schreibt eine Review-Zusammenfassung
  in die heutige Tagesnotiz.
---

# Daily Review

Ein 10–15-minütiges tägliches Review über alle aktiven Systeme:
Google Calendar, OmniFocus und Obsidian-Vault.

## Ablauf

```
Phase 1: Daten sammeln (parallel)
  ├── Kalender: heute + morgen
  ├── OmniFocus: Projekte + Tasks
  └── Obsidian: Tagesnotizen + Projektübersicht
         ↓
Phase 2: Dashboard anzeigen
  ├── Kalender-Übersicht
  ├── OmniFocus mit Problemmarkierungen
  ├── Offene Punkte aus Tagesnotizen
  └── Vorschläge
         ↓
Phase 3: Interaktive Vertiefung
  └── User wählt Punkte zum Vertiefen
         ↓
Phase 4: Zusammenfassung in Tagesnotiz
```

---

## Phase 1: Daten sammeln

Starte drei parallele Agents, die gleichzeitig Daten sammeln. Jeder Agent
bekommt eine klare Aufgabe und liefert strukturierte Ergebnisse zurück.

### Agent 1 — Kalender

Verwende die Google Calendar MCP-Tools:

- `gcal_list_events` für **heute** (ganzer Tag)
- `gcal_list_events` für **morgen** (ganzer Tag)

Liefere pro Termin: Uhrzeit, Titel, Dauer. Ganztägige Events als solche
markieren. Bei leeren Tagen: "Keine Termine" melden.

### Agent 2 — OmniFocus

Verwende die OmniFocus MCP-Tools:

- `list_projects` — alle aktiven Projekte abrufen
- `list_tasks` — überfällige Tasks und heute fällige Tasks identifizieren

Analysiere die Ergebnisse und markiere Probleme:
- Projekte **ohne nächste Aktion**
- Tasks die **überfällig** sind (Fälligkeitsdatum in der Vergangenheit)
- Tasks die **heute fällig** sind
- Projekte die **länger als 2 Wochen keine Aktivität** hatten (falls erkennbar)

### Agent 3 — Obsidian

Verwende den Obsidian CLI (`/Applications/Obsidian.app/Contents/MacOS/obsidian`),
Ausgabe immer durch `grep -v "Loading updated\|installer is out"` pipen.

Falls Obsidian nicht läuft, auf direkte Dateioperationen zurückfallen.

Aufgaben:
1. **Letzte Tagesnotizen lesen** — die letzten 3 vorhandenen Tagesnotizen
   im Ordner `Tagesnotizen/` finden und auf offene Punkte prüfen
   (lose Enden, Fragen, unerledigte Erwähnungen)
2. **Heutige Tagesnotiz** — prüfen ob sie existiert, falls nicht anlegen:
   ```
   Tagesnotizen/YYYY-MM-DD.md
   ```
   mit Frontmatter:
   ```yaml
   ---
   date: YYYY-MM-DD
   ---
   ```
3. **Projektübersicht** — `Projekte/0 - README.md` lesen für die aktuelle
   Projektliste und deren nächste Aktionen

---

## Phase 2: Dashboard

Baue aus den gesammelten Daten ein kompaktes Dashboard. Halte dich an
dieses Format:

```markdown
# Daily Review – YYYY-MM-DD

## Kalender

### Heute (Wochentag, DD. Monat)
- HH:MM – Terminname (Dauer)
- Ganztägig: Eventname

### Morgen (Wochentag, DD. Monat)
- HH:MM – Terminname

---

## OmniFocus

### Braucht Aufmerksamkeit
- **Projektname** – Grund (keine nächste Aktion / Task überfällig seit X Tagen / etc.)

### Heute fällig
- Taskname (Projekt)

### Aktive Projekte (Anzahl)
- Projektname -> nächste Aktion
- ...

---

## Offene Punkte aus Tagesnotizen
- DD.MM.: Beschreibung des offenen Punkts

---

## Vorschläge
- Projektname: Letztes Review vor X Wochen – heute kurz draufschauen?
- X Projekte ohne nächste Aktion – Tasks anlegen?
```

### Formatierungsregeln

- **Problemfälle zuerst** — der Abschnitt "Braucht Aufmerksamkeit" steht
  oben im OmniFocus-Block
- **Kompakt bleiben** — pro Projekt maximal eine Zeile (Name + nächste Aktion)
- **Leere Abschnitte nicht weglassen** — stattdessen "Keine Termine" /
  "Alles auf Kurs" / "Keine offenen Punkte" schreiben, damit klar ist dass
  der Bereich geprüft wurde
- **Vorschläge am Ende** — nicht aufdringlich, als Impulse formuliert
- **Sprache: Deutsch** — technische Begriffe (MCP, CLI, etc.) bleiben englisch

---

## Phase 3: Interaktive Vertiefung

Nach dem Dashboard, frage:

> **Wo willst du tiefer einsteigen?** Du kannst z.B.:
> - Einen Projektnamen nennen — ich zeige Details und OmniFocus-Tasks
> - "Tasks anlegen" — wir gehen die Vorschläge durch
> - "Fertig" — ich schreibe die Zusammenfassung in die Tagesnotiz

### Mögliche Aktionen

**Projekt vertiefen:**
- Projektnotiz aus Obsidian lesen (unter `Projekte/`)
- Zugehörige Tasks aus OmniFocus via `search_tasks` laden
- Momentum und "Letztes Review" aus der Projektnotiz zeigen
- Falls gewünscht: "Letztes Review"-Datum in der Projektnotiz auf heute setzen

**Tasks anlegen:**
- Für Projekte ohne nächste Aktion: gemeinsam eine formulieren
- Via `create_task` in OmniFocus anlegen (dem richtigen Projekt zuordnen)

**Offenen Punkt klären:**
- Eintrag aus Tagesnotiz besprechen
- Ergebnis: als Task nach OmniFocus (`create_task`) oder als Notiz festhalten

Der User kann mehrere Punkte nacheinander vertiefen.
Erst bei "Fertig" weiter zu Phase 4.

---

## Phase 4: Zusammenfassung

Wenn der User "Fertig" sagt:

1. **Review-Block in die heutige Tagesnotiz schreiben** — via Obsidian CLI
   `daily:append` (oder `append path="Tagesnotizen/YYYY-MM-DD.md"`):

   ```markdown
   ## Daily Review

   - X Termine heute, Y morgen
   - Z aktive Projekte, N brauchen Aufmerksamkeit
   - Neue Tasks angelegt: "Taskname" (Projekt)
   - Projekt "Name" reviewed, Momentum aktualisiert
   - Offener Punkt von DD.MM. als Task erfasst
   ```

2. **Nur Fakten** — was wurde geprüft, was wurde geändert. Keine
   generischen Floskeln. Nur Einträge für Dinge die tatsächlich passiert sind.

3. **Kurze Bestätigung** an den User:
   > Review abgeschlossen. Zusammenfassung steht in der Tagesnotiz.

---

## Wichtige Hinweise

- **Tasks gehören nach OmniFocus** — niemals Tasks als Checklisten in
  Obsidian anlegen (siehe CLAUDE.md)
- **Termine gehören in Google Calendar** — nicht in Obsidian speichern
- **Projektnotizen folgen der Vorlage** — bei neuen Projekten immer
  `Referenz/Vorlage Projekt` verwenden
- **Archivierte Notizen nicht anfassen** — Inhalte unter `Archiv/` sind tabu
- Der Vault liegt in iCloud — Dateipfade enthalten `iCloud~md~obsidian`
