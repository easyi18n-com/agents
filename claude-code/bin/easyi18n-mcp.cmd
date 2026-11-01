@echo off
rem Windows twin of easyi18n-mcp: the candidates of scripts/ensure-cli.sh in the
rem same order, each only at the version in cli-version. With an empty cache it
rem runs ensure-cli.sh itself: Claude Code starts this server before the
rem SessionStart hook, and a failed start blocks it for 15 minutes (#1419).
rem SHELL is the Git Bash Claude Code resolved; a bare `bash` can be WSL.
setlocal
for /f "usebackq delims=" %%p in ("%~dp0..\cli-version") do set "PIN=%%p"
set "DATA=%CLAUDE_PLUGIN_DATA%"
if not defined DATA set "DATA=%USERPROFILE%\.cache\easyi18n-plugin"
set "BIN=%DATA%\cli\%PIN%\easyi18n.exe"
set "V="
for /f "delims=" %%v in ('easyi18n --version 2^>nul') do set "V=%%v"
if "%V%"=="easyi18n %PIN%" goto path
set "V="
for /f "delims=" %%v in ('dart pub global run easyi18n_cli:easyi18n --version 2^>nul') do set "V=%%v"
if "%V%"=="easyi18n %PIN%" goto dart
if exist "%BIN%" goto cache
if exist "%SHELL%" goto install
echo easyi18n plugin: easyi18n %PIN% is not installed, and installing it needs Git for Windows. Install Git for Windows, or run: npm install -g @easyi18n.com/cli@%PIN% 1>&2
exit /b 1
:install
"%SHELL%" "%~dp0..\scripts\ensure-cli.sh" exec mcp %*
exit /b %errorlevel%
:path
easyi18n mcp %*
exit /b %errorlevel%
:dart
dart pub global run easyi18n_cli:easyi18n mcp %*
exit /b %errorlevel%
:cache
"%BIN%" mcp %*
exit /b %errorlevel%
