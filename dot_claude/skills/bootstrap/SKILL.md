---
name: bootstrap
description: Initialize a new Claude session with recurring journal monitoring and any other startup tasks.
---

# Session Bootstrap

Set up recurring monitoring and background tasks at the start of a new session.

## What to do

### 1. Read instructions from Logseq

Read `~/Documents/Logseq/pages/Digital Assistant.md` and follow the instructions under **## Loop Instructions**. Ignore the **## Ideas and Notes** section.

### 2. Start the recurring loops

The Loop Instructions section defines one or more loops, each as its own `###` subsection with its own `interval::` (currently the **Strategic Loop** and the **Laptop Maintenance Loop**). Start each one.

For each loop subsection:
- Read its `interval::` from that subsection's Schedule.
- Construct the loop prompt from all of that subsection's rules.
- Check `CronList` first — if a loop with that purpose is already running, skip it (don't duplicate).
- Start it via the loop skill:

```
/loop <interval> <constructed prompt for that loop>
```

Notes for constructing each prompt:
- **Strategic Loop** (`6h`): fold in the run-order rituals (vacation check, first-of-month Monthly Goals dialog, Monday kickoff, Friday retrospective), the two daily **chat-only** nudges (morning priorities + late-afternoon don't-lose-track sweep), light time tracking (DOING/DONE, no CLOCK), and response style. Journal path is `~/Documents/Logseq/journals/YYYY_MM_DD.md`.
- **Laptop Maintenance Loop** (`4h`): fold in the `brew upgrade -y` step (the `-y` is required, see the page) and the alert-only chezmoi checks.

### 3. Confirm

After the loops are running, briefly confirm that the session is bootstrapped and which loops are active. Keep it short — one or two lines.

### Important notes

- If the loop skill is unavailable, fall back to manually creating each cron via CronCreate with the appropriate cron expression for the interval and the constructed prompt.
- The loops are session-only — they die when Claude exits. Each new session needs a fresh `/bootstrap`.
- Do not start duplicate loops. Check `CronList` first; if a given loop (Strategic or Laptop Maintenance) is already running, skip starting that one and note it's already active.
