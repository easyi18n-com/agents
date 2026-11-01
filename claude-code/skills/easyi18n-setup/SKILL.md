---
name: easyi18n-setup
description: "Set up easyi18n in this repository: detect the stack (Flutter, Xcode, web or Android), wire up the SDK and config, convert user-facing strings and show what would be translated. Use when the user wants to add easyi18n, internationalize or localize an app, or connect a project to easyi18n."
---

Goal: take this repository from zero to "ready to translate".
1. Detect the stack. Flutter: pubspec.yaml with a `flutter:` section. Xcode: an
   *.xcodeproj or *.xcworkspace plus an .xcstrings catalog other than
   InfoPlist.xcstrings. Web: a package.json that depends on
   @jsverse/transloco, @ngx-translate/core or i18next, with one JSON file per
   locale. Android: a res/values/strings.xml plus a Gradle script
   (settings.gradle or build.gradle, .kts too) or an AndroidManifest.xml.
   Anything else: stop and say easyi18n does not support this stack yet
   (supported: Flutter, Xcode, web JSON catalogs, Android strings.xml;
   roadmap: web t() extraction, gettext). Do not improvise.
2. Call status. If it names a `project`, the key in this client's config
   already says which project this is: tell the human which one and go on.
   If it answers no_credential, two things only the human can do: (a) create
   the project at https://app.easyi18n.com (New project → base language +
   target languages); (b) create an **Agent key** (Project → Settings → API
   keys → New API key, Used by "AI agent": scopes read, translate, publish —
   add write if languages will be added from this agent; agent keys need a
   human approval in the dashboard for every spend and publish) and put it in
   this client's config as EASYI18N_TOKEN. Never ask them to paste the key in
   chat.
3. Call init {stack: "auto"}: it reads the project from the key. Only if it
   answers "Missing project ref", ask for the workspace handle and project
   slug from the URL app.easyi18n.com/@<handle>/<slug> and call init
   {workspace, project, stack: "auto"}. If it answers "No supported
   stack found", check whether you are at the root of the app: retry with
   project_dir only if you find a directory that meets a stack detection
   of step 1. If you find none, stop and say you found no
   supported stack. Read `steps`. If `scope_snippet` comes back, wire it
   yourself following it: Flutter, Easyi18nScope into main.dart; web, the ICU
   transpiler a step names, installed first with the project's package
   manager.
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
   errors go to the build tools). `credential` warning = step 2b not done.
6. Show the human what would be translated: extract (Flutter Mode B) or
   sync_preview (file-first); Flutter Mode A has nothing to preview here.
   Do not push or sync. Hand off: "run the translate prompt to translate and
   publish".
Do not: edit easyi18n.lock / .easyi18n / assets/easyi18n; add languages by
editing config (use add_language or the dashboard); push, sync or publish here.
