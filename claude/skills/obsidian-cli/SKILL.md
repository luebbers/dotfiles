---
name: obsidian-cli
description: >
  How to use the Obsidian CLI to interact with Enno's Obsidian vault. Use this
  skill whenever reading, writing, searching, or managing notes in the vault —
  including daily notes, properties, tags, backlinks, tasks, and file
  operations. Prefer the CLI over raw filesystem operations when Obsidian is
  likely running (it gives Obsidian-aware results: correct daily note paths,
  live search index, backlink graph, property types). Trigger on any vault
  interaction: "add to today's note", "search the vault", "create a project
  note", "what links to X", "list tasks", "set a property", etc.
---

# Obsidian CLI

The Obsidian app ships a CLI that talks to the **running Obsidian instance**.
It gives you access to Obsidian's live index: correct daily note paths, full-
text search, the backlink graph, property types, and more — things raw file
reads can't provide.

## Setup

```bash
OBSIDIAN="/Applications/Obsidian.app/Contents/MacOS/obsidian"
# Strip startup noise (goes to stdout, not stderr):
$OBSIDIAN <command> [options] | grep -v "Loading updated\|installer is out"
```

Active vault is **"Obsidian Vault"** (default when Obsidian is open).
To target it explicitly: `vault="Obsidian Vault"` as first argument.

> If Obsidian is not running, fall back to direct filesystem operations.

---

## Common Commands

### Daily Notes

```bash
$OBSIDIAN daily:path          # → Tagesnotizen/2026-03-17.md
$OBSIDIAN daily:read          # read today's note
$OBSIDIAN daily:append content="Text to add"
$OBSIDIAN daily:prepend content="Text to prepend"
```

### Read & Write Files

```bash
$OBSIDIAN read path="Projekte/Foo.md"
$OBSIDIAN read file="Foo"           # resolves by name (like wikilinks)

$OBSIDIAN create path="Projekte/Foo.md" content="# Foo\n\nContent here"
$OBSIDIAN create path="Projekte/Foo.md" template="Vorlage Projekt"

$OBSIDIAN append path="Projekte/Foo.md" content="New paragraph"
$OBSIDIAN prepend file="Foo" content="Prepended line"
```

`file=` resolves by note name (wikilink-style). `path=` is exact (relative to vault root). Quote values with spaces.

### Search

```bash
$OBSIDIAN search query="kubernetes"
$OBSIDIAN search query="kubernetes" path="Projekte"   # limit to folder
$OBSIDIAN search:context query="kubernetes"           # includes matching lines
$OBSIDIAN search query="kubernetes" format=json
```

### Properties (Frontmatter)

```bash
$OBSIDIAN property:read name="status" file="Foo"
$OBSIDIAN property:set name="status" value="active" type=text file="Foo"
$OBSIDIAN property:set name="due" value="2026-03-20" type=date file="Foo"
$OBSIDIAN property:remove name="draft" file="Foo"
$OBSIDIAN properties path="Projekte/Foo.md"    # list all properties of a file
```

### Tags

```bash
$OBSIDIAN tags                            # all tags in vault
$OBSIDIAN tags file="Foo"                 # tags on one file
$OBSIDIAN tags counts sort=count          # sorted by frequency
```

### Links & Graph

```bash
$OBSIDIAN backlinks file="Foo"            # what links TO this note
$OBSIDIAN links file="Foo"               # what this note links TO
$OBSIDIAN unresolved                     # broken wikilinks
$OBSIDIAN orphans                        # notes with no incoming links
$OBSIDIAN deadends                       # notes with no outgoing links
```

### Tasks

```bash
$OBSIDIAN tasks todo                     # all incomplete tasks in vault
$OBSIDIAN tasks done                     # completed tasks
$OBSIDIAN tasks path="Projekte"          # tasks in a folder
$OBSIDIAN tasks daily                    # tasks from today's daily note
$OBSIDIAN task toggle path="Foo.md" line=12
```

### File & Folder Operations

```bash
$OBSIDIAN files                          # list all files
$OBSIDIAN files folder="Projekte" ext=md
$OBSIDIAN folders
$OBSIDIAN move file="Foo" to="Archiv/Projekte/Foo.md"
$OBSIDIAN rename file="Foo" name="New Name"
$OBSIDIAN delete file="Foo"             # moves to trash by default
```

### Vault Info

```bash
$OBSIDIAN vault
$OBSIDIAN recents                        # recently opened files
$OBSIDIAN outline file="Foo"            # headings as tree
$OBSIDIAN wordcount file="Foo"
```

---

## When to Use CLI vs. Filesystem

| Task | Prefer |
|------|--------|
| Daily note operations | CLI (`daily:*`) |
| Full-text search | CLI (`search`) |
| Backlinks / graph queries | CLI |
| Creating notes with templates | CLI |
| Reading/writing known file paths | Either (filesystem is fine) |
| Bulk file creation or migration | Filesystem (faster) |
| Obsidian not running | Filesystem only |

---

## Notes

- Use `\n` for newline, `\t` for tab in `content=` values.
- The CLI uses the **frontmost/active vault** by default. If multiple vaults are open, add `vault="Obsidian Vault"` to be explicit.
- `format=json` is available on most list commands for structured output.
- The startup message ("Loading updated app package...") is noise — always pipe through `grep -v "Loading updated\|installer is out"`.
