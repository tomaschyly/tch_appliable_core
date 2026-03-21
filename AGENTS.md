# Tomas Chyly Appliable Core — Agent Instructions

These instructions apply to the whole repository unless a deeper `AGENTS.md` overrides them.

## Release versioning rule

When releasing a new package version, always update these 3 files together:

1. `pubspec.yaml` - bump `version`.
2. `CHANGELOG.md` - add a new top entry for the released version.
3. `README.md` - update the dependency snippet version (`tch_appliable_core: ^x.y.z`).

All three files must stay in sync for each release.
