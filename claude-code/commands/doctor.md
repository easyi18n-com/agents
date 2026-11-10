---
description: Run the easyi18n doctor and fix every failing check until it is green.
---

Call the easyi18n `doctor` tool. For every check with status `fail`, fix the
cause: most are fixed by calling `init` again, and compile errors go to the
project's build tools. Call `doctor` again after each round of fixes, and stop
when no check fails. Report the warnings that remain and what each one needs:
a `credential` warning means the plugin's agent key is not set, which the
human sets under `/plugin` > easyi18n > Configure, never in chat.
