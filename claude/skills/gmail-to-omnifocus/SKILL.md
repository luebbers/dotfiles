---
name: gmail-to-omnifocus
description: >
  Überführt alle mit Stern markierten Gmail-Nachrichten vollautomatisch in
  actionable OmniFocus-Todos, ohne Rückfrage. Aktiviere diesen Skill
  ausschließlich über den /gmail-to-omnifocus Slash-Command (auch per
  /loop stündlich). Legt pro gestarnter Mail direkt ein Todo in der
  OmniFocus-Inbox an (Notiz = Gmail-Link + kurzer Kontext) und archiviert +
  entsternt die Mail danach in Gmail.
---

# Gmail-Sterne zu OmniFocus

Enno benutzt den Stern in Gmail als Action-Item-Marker: "hier muss noch
etwas gemacht werden". Dieser Skill löst diese Merkliste auf, indem er
jede gestarnte Mail in ein echtes OmniFocus-Todo überführt — Aktionen
gehören dorthin, nicht als Sternchen in der Mailbox liegen.

Der Skill läuft vollautomatisch, ohne Rückfrage — das Setzen des Sterns
ist bereits die bewusste Enno-Entscheidung, dass hier eine Aktion nötig
ist. Eine zweite Bestätigung davor wäre doppelte Arbeit. Das macht den
Skill auch für den unbeaufsichtigten `/loop`-Betrieb (z.B. stündlich)
geeignet: kein Blockieren auf eine Antwort, die nie kommt.

## Ablauf

```
Phase 1: Gestarnte Mails sammeln (alle, nicht nur Inbox)
         ↓
Phase 2: Pro Mail Todo-Titel formulieren (ohne Rückfrage)
         ↓
Phase 3: Pro Mail:
  ├── OmniFocus-Todo anlegen (Inbox, Notiz = Link + Kontext)
  └── bei Erfolg: Mail archivieren + entsternen
         ↓
Phase 4: Zusammenfassung (erstellt / übersprungen / Fehler)
```

Der Stern ist gleichzeitig der Fortschritts-Marker: eine Mail ohne Stern
gilt als bereits verarbeitet und taucht beim nächsten Lauf nicht mehr
auf. Dadurch ist der Skill von Natur aus idempotent — mehrfaches
Ausführen erzeugt keine doppelten Todos.

## Phase 1: Gestarnte Mails sammeln

Nutze `mcp__claude_ai_Gmail__search_threads` mit der Query `is:starred`
(kein `in:inbox` — auch längst archivierte, aber weiterhin gestarnte
Mails zählen). Paginiere mit `pageToken`, bis alle Treffer eingesammelt
sind (Batches von z.B. 50).

Für jeden Thread: nimm die Nachricht, die aktuell das Label `STARRED`
trägt (steht in `labelIds`); falls mehrere Nachrichten im Thread
gestarnt sind, reicht die neueste davon für Betreff/Snippet. Merke dir
`threadId`, Absender, Betreff, Snippet und Datum.

## Phase 2: Todo-Titel formulieren

**Todo-Titel-Stil:** verb-first und actionable, auf Deutsch — nicht
einfach der Mail-Betreff. Frag dich "was ist die nächste physische
Handlung?" und formuliere das. Der Betreff "Ihre Kündigung - wir möchten
Sie gern als Kunden behalten" wird z.B. zu "Telekom-Kündigung
bestätigen/klären", nicht zum unveränderten Betreff.

Wenn aus Betreff + Snippet keine sinnvolle Handlung erkennbar ist (reine
Newsletter/FYI, aber trotzdem gestarnt), leg trotzdem ein Todo an — im
Zweifel als "... zur Kenntnis nehmen" formuliert. Kein Anlass, die Mail
zu überspringen: Enno hat sie bewusst markiert, also verdient sie ein
Todo, auch wenn die Handlung nur "anschauen" ist.

## Phase 3: Todos anlegen + Mail archivieren

Pro Mail:

1. `mcp__omnifocus__create_task` mit:
   - `name`: der abgestimmte Todo-Titel
   - `note`: Gmail-Link + 1-2 Zeilen Kontext (Absender/Kernaussage), z.B.:
     ```
     https://mail.google.com/mail/u/0/#all/<threadId>

     BWT-Rechnung über 447,33 € vom 10.09., noch keine Zahlung in
     MoneyMoney gefunden.
     ```
   - kein `project` (landet in der Inbox, wie gewünscht)

2. Nur bei Erfolg: `mcp__claude_ai_Gmail__unlabel_thread` mit
   `labelIds: ["STARRED", "INBOX"]` — ein Aufruf entfernt Stern und
   Inbox-Zugehörigkeit gleichzeitig (Archivieren = INBOX-Label
   entfernen; falls die Mail schon archiviert war, ist das ein no-op).

Schlägt die Todo-Erstellung fehl, NICHT archivieren/entsternen — die
Mail bleibt gestarnt und taucht im nächsten Lauf wieder auf. Lieber ein
doppelter Versuch als ein verlorenes Action-Item.

## Phase 4: Zusammenfassung

Kurzer Abschluss-Bericht: Anzahl angelegter Todos, etwaige Fehler. Wenn
keine gestarnten Mails gefunden wurden, als **erste Zeile exakt** `NO_OP`
ausgeben (fester, maschinenlesbarer Marker — der Skill läuft auch
unbeaufsichtigt per Cron, und `NO_OP` lässt den Wrapper stündliche
"nichts zu tun"-Benachrichtigungen zuverlässig unterdrücken, ohne auf
den variablen LLM-Text danach angewiesen zu sein), danach in normaler
Sprache kurz begründen. Kein episches Protokoll bei jedem stündlichen
Lauf, vor allem wenn nichts zu tun war.
