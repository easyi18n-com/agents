---
name: easyi18n-translate
description: "Translate and publish with easyi18n: preview the credit spend, get the human approval in the dashboard, wait for the fill, publish and write the result back. Use when the user asks to translate strings, fill missing translations, publish or roll back translations, or add a language with easyi18n."
---

0. status — confirm project, family, languages, published state. If apply
   (preview) lists pending code changes (Flutter), apply {write:true}, show the
   diff, continue.
1. Preview: extract + push_preview (code-first) or sync_preview (file-first).
   Show: N strings × languages, ~C credits, available credits, skipped /
   exhausted / conflicts. If would_exceed_key_cap or not affordable, stop and
   explain. Angular: run ng extract-i18n first (AGENTS.md has the command);
   protected_tokens are the {$…} tokens every translation keeps. Flutter
   Mode A pushes nothing: its keys reach the server through the dashboard
   import (setup step 4), so go to step 4.
2. If C is 0 there is nothing to approve: push or sync without operation_id
   (the server accepts only if nothing turns out billable; a 403 with an
   estimate means it did — continue below with that C). Otherwise authorize
   {action: translate, max_credits: ceil(C × 1.2)}. The server and the local
   ceiling settle M; if the tool aborts with ceiling_below_estimate, tell the
   human how to raise EASYI18N_MCP_MAX_CREDITS and stop. Show the human:
   "Translate N strings for ~C credits, charged at most M. Approve here:
   <approval_url>". Then, in the same turn and without ending it, call
   authorize {operation_id} — never a new authorize without operation_id. It
   waits up to 45 s for the human: while next is wait, call it again.
   approved → push {operation_id} or sync {operation_id}. stop (denied) or
   reauthorize (expired) → tell the human and stop. ask_human (no answer in
   10 min) → tell the human and end the turn; read it again when they say
   they answered (the link expires in 30 min).
3. Poll fill_status every ~10 s (say you are waiting; do not spam).
   failed_needs_requeue → ingest again with the same operation_id, at most
   twice (the server enforces M across attempts). budget_exhausted or
   request_unresolved → do not ingest; report charged_mc; reauthorize only if
   the human says so. exhausted non-empty → tell the human. Over 10 minutes →
   stop and report.
4. When complete: authorize {action: publish} → give the human the
   approval_url → wait for it as in step 2 → publish {operation_id}
   (require_complete stays true).
   Report version_id, key_count and any refused cells with their reasons.
5. pull — file-first: this writes the translations back; show the diff.
   Xcode: into the catalog (key_policy local_owns, set by the sync). Web: one
   file per target language into `output:`; the base file is never
   rewritten. Android: values-<lang>/strings.xml per target language into
   `output:`, the res/ folder; values/strings.xml is never rewritten.
   Angular: messages.<locale>.json per target language into `output:`;
   messages.json is never rewritten. Mode A Flutter: every .arb in
   `output:` but the template (`source:`), which is never rewritten.
6. doctor must be green (or warnings only). Flutter runtime delivery (mode B):
   a running app hot-swaps within seconds, no rebuild; it follows the device
   language, so a target language shows once the device (or, on macOS, the
   app under Language & Region) is set to it. Mode A (.arb), Xcode and
   Android: rebuild to see the translations. Web: reload the app. Angular:
   rebuild with ng build --localize (add the i18n section init printed to
   angular.json first if it is not there), or reload an app that loads them
   at runtime.
7. If the human reports the publish broke something: authorize {action:
   rollback} → approval_url → wait for it as in step 2 → rollback
   {operation_id}.
Adding a language: add_language {code} (or the dashboard), then steps 1-6.
Do not: translate strings yourself; publish with require_complete:false unless
the human said so; call push/sync/publish/rollback without an approved
operation_id from step 2 or 4; raise max_credits without asking.
