---
name: ki-news
description: >
  Wöchentlicher KI-News-Ingest ins Obsidian-Wiki (Wiki/Professionell/KI-News):
  holt per Gemini die wichtigsten Entwicklungen der letzten 7 Tage zu
  Anthropic/Claude, MCP, AI Agents und Google Gemini, sortiert sie auf die
  Topic-Seiten, aktualisiert index.md und log.md. Aktivieren bei "hol mir neue
  AI-News", "ki-news", "/ki-news" oder wenn der LaunchAgent ki-news-weekly
  diesen Skill aufruft.
---

# KI-News Ingest

Aktiviere diesen Skill wenn der Nutzer sagt: "hol mir neue AI-News", "ki-news", "/ki-news", oder wenn ein Scheduled Agent diesen Skill aufruft.

## Ablauf

Führe diese Schritte in dieser Reihenfolge aus:

### 1. Gemini fragen

Rufe `mcp__gemini-mcp__ask-gemini` auf mit folgendem Prompt (ersetze YYYY-MM-DD durch das heutige Datum):

```
Du bist ein Senior AI Research Analyst. Deine Aufgabe ist es, einen tiefgehenden Bericht über die wichtigsten KI-Entwicklungen der letzten 7 Tage (Referenz heute: YYYY-MM-DD) zu erstellen.

Suche nach den relevantesten YouTube-Videos, Blogposts und technischen News zu diesen vier Themen:
1. Anthropic / Claude (Releases, API-Updates, Features, Company News)
2. MCP - Model Context Protocol (neue Server, Integrationen, Spec-Änderungen, Community)
3. AI Agents (Frameworks wie LangGraph/CrewAI, Patterns, neue Papers, Praxisberichte)
4. Google Gemini (Modell-Updates, Multimodalität, Google Cloud AI, API-Änderungen)

PRO THEMA: Liefere mindestens 2-3 fundierte Treffer.

FORMAT PRO TREFFER (Strikt einhalten):
## [TITEL DES FUNDSTÜCKS]
- **Datum:** [YYYY-MM-DD]
- **Quelle:** [Kanalname / Medium]
- **URL:** [Direkter, verifizierter Link]
- **Kategorie:** [Themenname aus den vier oben]
- **Typ:** [YouTube-Video / Blogpost / Release Notes / Paper / Sonstiges]
- **Analyse (min. 150 Wörter):**
  [Beschreibe hier:
  1. Den Kerninhalt: Was genau wurde veröffentlicht/gezeigt?
  2. Technische Details: Welche Parameter, Architekturen oder APIs sind betroffen?
  3. Relevanz: Warum ist das für die Community wichtig?
  4. Praxis-Check: Für welchen Use Case ist das sofort einsetzbar?]

WICHTIGE REGELN:
- Schreibe auf Deutsch, bleibe bei Fachbegriffen aber im Englischen (z.B. "Chain-of-Thought", "Inference").
- Erfinde keine URLs. Wenn kein direkter Link gefunden wird, nenne die offizielle Homepage des Anbieters.
- Priorisiere technische Tiefe vor allgemeinem "Hype".
- Priorisiere Primärquellen (offizielle Blogs von Anthropic/Google, GitHub Repos, Dokumentation).
```

### 2. Ergebnisse sortieren

Ordne die Treffer den vier Topics zu:
- Anthropic/Claude → `Anthropic-Claude.md`
- MCP → `MCP.md`
- AI Agents → `AI-Agents.md`
- Gemini → `Gemini.md`

Ein Treffer kann in mehrere Topics fallen — dann in beide Seiten einfügen (ggf. mit Querverweis wie `Auch in [[MCP]]`).

### 3. Wiki-Index lesen

Lese `Wiki/Professionell/KI-News/index.md` um den aktuellen Stand zu kennen und zu prüfen welche Topic-Seiten bereits existieren.

### 4. Topic-Seiten aktualisieren

Für jede Topic-Seite mit neuen Treffern: neue Einträge **oben** einfügen (nach dem Frontmatter/Titel, vor bestehenden Einträgen).

Falls eine Topic-Seite noch nicht existiert, lege sie zuerst an mit diesem Frontmatter:

```markdown
---
title: [Topic-Name]
updated: YYYY-MM-DD
---

# [Topic-Name]
```

Format pro Eintrag:

```
## [YYYY-MM-DD] Titel des Videos/Artikels
**Quelle:** [Plattform: Kanalname/Autorenname – Titel](URL)  
**Kanal/Autor:** Name | **Typ:** YouTube-Video / Blog / Release Notes

Ausführliche Zusammenfassung auf Deutsch (min. 150 Wörter). Was ist die Kernaussage?
Was ist neu oder überraschend? Warum ist das relevant für jemanden der Claude, MCP
und AI Agents aktiv nutzt? Querverweise auf andere Topic-Seiten wo sinnvoll
(z.B. [[MCP]] oder [[Anthropic-Claude]]).

---
```

### 5. index.md aktualisieren

- Falls neue Topic-Seiten entstanden sind: in `Wiki/Professionell/KI-News/index.md` eintragen
- Das `updated`-Datum im Frontmatter auf heute setzen
- Die Einzeiler-Beschreibung jeder aktualisierten Seite ggf. anpassen

### 6. Log-Eintrag anhängen

An `Wiki/Professionell/KI-News/log.md` anhängen:

```
## [YYYY-MM-DD] ingest | Wöchentliche KI-News
N Einträge: X zu Anthropic/Claude, Y zu Gemini, Z zu MCP, W zu AI Agents.
```
