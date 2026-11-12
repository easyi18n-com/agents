---
name: setup
description: "Set up easyi18n in this repository: detect the stack (Flutter, Xcode, Angular, web or Android), wire up the SDK and config, convert user-facing strings and show what would be translated. Use when the user wants to add easyi18n, internationalize or localize an app, or connect a project to easyi18n."
---

Goal: take this repository from zero to "ready to translate".
1. Detect the stack. Flutter: pubspec.yaml with a `flutter:` section. Xcode: an
   *.xcodeproj or *.xcworkspace plus an .xcstrings catalog other than
   InfoPlist.xcstrings. Angular: a package.json that depends on
   @angular/localize plus an angular.json. Web: a package.json that depends on
   @jsverse/transloco, @ngx-translate/core or i18next, with one JSON file per
   locale. Android: a res/values/strings.xml plus a Gradle script
   (settings.gradle or build.gradle, .kts too) or an AndroidManifest.xml.
   Anything else: stop and say easyi18n does not support this stack yet
   (supported: Flutter, Xcode, Angular i18n, web JSON catalogs, Android
   strings.xml; roadmap: web t() extraction, gettext). Do not improvise.
2. Call status. If it names a `project`, the key in this client's config
   already says which project this is: tell the human which one and go on.
   If it answers no_credential, ask the human to run `easyi18n login` in a
   terminal: you then work as them, and spends and publishes need no
   approval link; your next call uses it, no restart. For CI, or an agent
   that must not spend without an approval, they create the project at
   https://app.easyi18n.com and an **Agent key** in it instead (Project →
   Settings → API keys → New API key, Used by "AI agent": scopes read,
   translate, publish — add write if languages will be added from this
   agent; agent keys need a human approval in the dashboard for every spend
   and publish) and put it in this client's config as EASYI18N_TOKEN. Never
   ask them to paste the key in chat.
3. Call init {stack: "auto"}. With a key it reads the project from it.
   Logged in, it writes nothing and lists the human's `workspaces` with
   their `projects`: name them to the human and ask which project to link or
   what to create. Link: init {workspace, project, stack: "auto"}, or
   {project_id} for a project listed without a workspace handle. Create:
   init {workspace, create: {name, target_languages}, stack: "auto"}, with
   the workspace handle or id from the list; base_code only if the tree
   declares no base language. Only if it answers "Missing project ref", ask
   for the workspace handle and project slug from the URL
   app.easyi18n.com/@<handle>/<slug> and call init
   {workspace, project, stack: "auto"}. If it answers "No supported
   stack found", check whether you are at the root of the app: retry with
   project_dir only if you find a directory that meets a stack detection
   of step 1. If you find none, stop and say you found no
   supported stack. Read `steps`. If `scope_snippet` comes back, wire it
   yourself following it: Flutter, Easyi18nScope into main.dart; web, the ICU
   transpiler a step names, installed first with the project's package
   manager; Angular, the loading in src/main.ts, or the i18n section of
   angular.json once pull has written the files it lists (ng build fails
   while one is missing).
4. Flutter Mode B: run `flutter pub get`; convert user-facing literals to
   context.tr('…') (import package:easyi18n/easyi18n.dart). Ask first: one
   screen or the whole app. Rules: natural English, keep punctuation;
   placeholders {name}; plurals in ICU {count, plural, one{…} other{…}}; ctx:
   to disambiguate homonyms; never interpolate ('Hi $name' cannot be
   extracted); leave logs, ids, URLs and keys alone.
   Flutter Mode A (gen_l10n): the template .arb (`source:` in easyi18n.yaml)
   stays the truth and pull never writes it; add keys there as usual. Before
   the first pull, ask the human to import the existing .arb files in the
   dashboard (Keys → Import a file, the template first) and publish: pull
   writes every other .arb in `output:`.
   Xcode: confirm `catalog:` points at the right .xcstrings and that the
   project's languages match the catalog's.
   Angular: mark user-facing text with i18n in templates and $localize in
   code, each with its own id (i18n="@@cart.title"): without one the id is
   a digest of the text, and editing the text starts its translation over.
   Keep every {$…} token as it is. Then run ng extract-i18n --format=json
   with --output-path set to the directory of `source:`. Never hand-edit
   messages.json (the extractor writes it) or messages.<locale>.json (pull
   writes them).
   Web: move user-facing literals into the base file (`source:` in
   easyi18n.yaml) as ICU: placeholders {name}, plurals {count, plural,
   one{…} other{…}}. Keys are yours, nested by screen; read them with the
   library's pipe or t(). Ask first: one screen or the whole app. Never edit
   the other locale files: pull writes them.
   Android: the strings already live in res/values/strings.xml; add new ones
   there with Android escapes and %1$s placeholders, and mark a string that
   must not be translated with translatable="false". sync uploads each
   values-<lang>/strings.xml of a project language as its translations;
   after that, never edit those files: pull writes them.
5. Call doctor. Fix every `fail` (most are fixed by re-running init; compile
   errors go to the build tools). `credential` warning = step 2 not done.
6. Show the human what would be translated: extract (Flutter Mode B) or
   sync_preview (file-first); Flutter Mode A has nothing to preview here.
   Do not push or sync. Hand off to the translate workflow: show the actual
   invocation this client exposes (skill or MCP prompt), so the user can run it.
Do not: edit easyi18n.lock / .easyi18n / assets/easyi18n; add languages by
editing config (use add_language or the dashboard); push, sync or publish here.
