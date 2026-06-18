---
name: bootstrap
description: Initialize a new Claude session with recurring journal monitoring and any other startup tasks.
---

# Session Bootstrap

Set up recurring monitoring and background tasks at the start of a new session.

## What to do

### 1. Read instructions from Logseq

Read `~/Documents/Logseq/pages/Digital Assistant.md` and follow the instructions under **## Loop Instructions**. Ignore the **## Ideas and Notes** section.

### 2. Start journal monitoring loop

Using the instructions from the Digital Assistant page, invoke the loop skill:

```
/loop <interval from Digital Assistant page> <constructed prompt based on Digital Assistant loop instructions>
```

- Read the `interval::` property from the Schedule section to determine the loop frequency
- Construct the prompt from all rules on the page: what to check, quadrant prioritization, work/personal focus, active check-in and time tracking, and response style
- The journal path is `~/Documents/Logseq/journals/YYYY_MM_DD.md`

### 3. Confirm

After the loop is running, briefly confirm that the session is bootstrapped and the loop is active. Keep it short — one or two lines.

### Important notes

- If the loop skill is unavailable, fall back to manually creating the cron via CronCreate with the appropriate cron expression for the interval and the constructed prompt.
- The loop is session-only — it dies when Claude exits. Each new session needs a fresh `/bootstrap`.
- Do not start duplicate loops. If a journal monitoring loop is already running (check via CronList), skip step 2 and note that it's already active.
