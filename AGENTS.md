# Tomas Chyly Appliable Core — Agent Instructions

These instructions apply to the whole repository unless a deeper `AGENTS.md` overrides them.

## Platform scope

- This package serves mobile and desktop consumers; web support varies by feature. Preserve existing platform guards and verify the affected feature on its supported platforms rather than applying an app-only platform restriction.

## Branch safety rule

- For implementation work (any non-planning/non-question-only task), if current branch is `main` or `master`, ask the user first whether to switch to a new `version/*` or `feature/*` branch before making edits.
- Do not start code changes on `main`/`master` until the user confirms how to proceed.
- **Exception — version bumps:** When the user asks to bump the package to a specific version, automatically create and switch to `version/x.y.z` without asking again.

## Release versioning rule

Before deciding to update the version without an explicit user request, ask whether to do so and what the next version should be.

When releasing a new package version, always update these 3 files together:

1. `pubspec.yaml` — bump `version`.
2. `CHANGELOG.md` — add a new top entry for the released version.
    - Focus on important changes, especially breaking changes.
    - Summarize general changes in broad terms rather than listing every single change in each file/class.
3. `README.md` — update the dependency snippet version (`tch_appliable_core: ^x.y.z`).

All three files must stay in sync for each release.

During every package version bump, check the `pubspec.yaml` `environment` constraints against the Flutter version used by the project. When Flutter is upgraded, update the Dart SDK and Flutter constraints together so they remain synchronized with the toolchain.

Determine the active toolchain from this project's configuration. Review package and example constraints together, preserve supported consumer minimums, and do not copy another project's baseline or raise minimums solely to match a local toolchain.

## General coding conventions

### Imports

- Always use absolute imports (`package:...`) instead of relative imports.
- When encountering errors with extensions or methods not found, first check whether a required import is missing by finding working examples in similar files in the codebase.

### Code commenting

- Add comments for functions at minimum.
- Add additional comments around special or non-obvious logic.
- Follow the comment style established in nearby Flutter/Dart code, including whether sentence-ending periods are used.

### Runtime invariant handling

- Do not hide logically impossible `null` states with silent guard returns.
- If a value must exist at that point in the flow, prefer a loud failure (`!`, thrown error, assertion, or equivalent) so runtime bugs are visible in logs.
- Use guard returns only for valid user or runtime states, not for broken invariants that should be investigated.

### Pattern consistency

- Following established project patterns is a requirement for every change. Before implementing, read concrete examples of the same kind of behavior; follow the reference-discovery workflow in **Context-first preparation** below.
- Match by purpose and behavior, not just by file proximity or similar names. For example, use comparable public APIs, utilities, providers, widgets, styles, platform implementations, or example flows for their equivalents.
- Follow the reference's structure, naming, layer boundaries, shared abstractions, and applicable behavior. This includes layout/composition, state and data flow, validation, loading/empty/error states, permissions, navigation, persistence, and subscriptions where relevant to the task.
- Reuse established components, widgets, utilities, extensions, and service helpers when they fit. Read their implementation and representative call sites before using them; preserve their intended contracts instead of duplicating their behavior or bypassing them with custom code.
- Prefer consistency with existing structure and naming over introducing a new approach. Do not introduce a parallel abstraction, dependency, or architecture merely because it is familiar or seems cleaner in isolation.
- If multiple patterns exist, prefer the closest feature-equivalent implementation in the same project and layer unless the user explicitly selects another reference. Apply explicit repository rules over conflicting examples; do not copy known bugs or obsolete behavior. Explain material differences when adapting a reference.
- When adding or moving methods, widget helpers, fields, constants, configuration values, provider functions, or utilities, place them with related code rather than at the end of the file or the first convenient location.
- Before editing a file, scan nearby declarations for the existing grouping and order pattern (for example fields before lifecycle methods, lifecycle methods before build helpers, callbacks near related UI, domain workflow order, or alphabetical order), then preserve it.
- In a new file centered on a primary class, mixin, extension, or other type, declare that primary type before supporting top-level declarations. Place helper data classes, enums, constants, typedefs, and similar supporting declarations after the primary type unless Dart, Flutter, or an established local pattern requires a different order.
- For cross-file lists or registries that represent the same domain concept, keep their order consistent across the related files.

### Readability and formatting

- Write code for a human reader: use descriptive names, clear control flow, and functions with focused responsibilities. Avoid dense expressions, excessive nesting, and clever shortcuts when straightforward code is clearer.
- Match surrounding indentation, line wrapping, spacing, braces, and declaration grouping. Use the project's configured formatter where available; avoid unrelated formatting changes.
- Keep related steps together and use blank lines to separate logical stages. Add comments that explain intent or non-obvious constraints, following the code-commenting rules above.
- Before finishing, review the diff for both readability and consistency with the chosen references. A successful build alone does not establish pattern consistency.

### Package architecture and public API

- Keep framework implementation under `lib/src/`, reusable utilities under `lib/utils/`, and curate public exports through `lib/tch_appliable_core.dart` and existing utility entry points
- Read the public entry point and representative consumer or example call sites before changing a public contract; avoid breaking APIs or exports without explicit user approval
- Preserve the separate Navigator V1 and go_router V2 contracts in `router_v1.dart` and `router_v2.dart`; verify argument propagation, replacement behavior, Back navigation, and current-route ownership when changing navigation helpers
- Keep route arguments as strings by default and follow existing `supercharged` conversions where numeric parsing is needed

### Utilities architecture

- Keep generic reusable utilities in `lib/utils/`.
- Keep utilities inside a component or feature file only when they are used exclusively by that component or feature.
- Write utility and provider code in a functional, stateless style where practical; do not introduce stateful service classes without a clear need.

### Build method data processing

- Keep widget build methods focused on composing UI from prepared values.
- Prepare and store derived collections when source data is received instead of repeatedly sorting, grouping, mapping, filtering, or calculating expensive statistics during every build.
- Recompute derived state when its source changes. Perform transformations in build methods only when they are trivial or depend on the current inherited UI context.

### TODO ownership format

- When adding TODO comments, use the format: `// TODO(name) some text`.
- Prefer `name` from `git config user.name` of the user running the agent.
- If the name is unknown, ask the user once, then remember and reuse it consistently.
- Treat existing TODOs as informational only; do not execute or integrate them unless the user explicitly requests that TODO work.

### Enum conventions

- When creating enums, add `none` as the first option unless explicitly instructed otherwise.

### Dart dot shorthands (Flutter 3.38+)

- Prefer Dart dot shorthands in new/edited code when the type is inferable (for example `.start` instead of `MainAxisAlignment.start`, `.all(8)` instead of `EdgeInsets.all(8)`).
- Use dot shorthands for named constructors and enum/static values where it improves conciseness and readability.

### Date handling

- Prefer `Jiffy` for user-facing date/time formatting and richer date operations (for example range boundaries, unit-based comparisons, and relative formatting) when it makes the code simpler.
- Use `DateTime` for basic timestamp parsing, storage, and straightforward conversions where richer date operations are unnecessary.
- Keep consistency with the surrounding file when its existing approach is reasonable; do not refactor unrelated date code.

### `copyWith` nullable clear pattern

- When `copyWith` must support both keeping an existing nullable value and explicitly clearing it to `null`, use a companion clear flag.
- Follow the pattern `field` + `clearField` (for example `locationId` + `clearLocationId`).
- In mapping, prefer: `field: clearField == true ? null : (field ?? this.field)`.
- Do not use sentinel placeholders (for example `_copyWithUndefined`) for this case unless explicitly requested.

## Localization and text

- Translator is optional. Preserve initialization and fallback behavior; do not require a configured Translator for general-purpose utilities. Use the existing `tt`/`parameters` API for translated text instead of duplicating placeholder replacement in callers.
- Do not add or fill translation-file entries unless explicitly requested. In translated example flows, follow their existing key namespaces and use placeholder parameter APIs rather than chained replacements.

## Security

### Dependency updates

- Exception to the 30-day waiting period: the user's own packages `tch_appliable_core` and `tch_common_widgets` are trusted and may be updated immediately after publication.
- Because package ecosystems are exposed to supply-chain attacks, do not update a pub package, framework, library, or dependency to a version that has been publicly available for fewer than 30 days.
- Before choosing the latest version, verify its release date from an official source such as the package registry, vendor release notes, or repository release page.
- If the latest version is newer than 30 days, select the newest version that is at least 30 days old and explain the choice in the handoff.
- Exception: an urgent security fix may use a newer version only when the user explicitly approves that specific update.

## Development workflow

### Cross-project feature planning

- When a new feature is likely to affect this package and multiple consuming projects, or take multiple days, suggest creating a plan before writing code.
- Signals that a feature warrants a plan include changes to public APIs, domain models, integrations, or workflows that may have ripple effects across consumers, especially when the feature does not exist in any affected codebase yet.
- Ask the user which projects are affected before proposing a cross-project plan, and outline the expected scope for each affected project.
- If the user wants to start coding immediately without a plan, respect that choice after noting the suggestion once.

### Context-first preparation

- Before proposing a plan or starting code changes, find and read at least one concrete implementation of the same kind of behavior, when one exists. For work spanning several layers or distinct behaviors, inspect the relevant examples for each part and trace their connected flow as needed.
- Start with references supplied by the user and inspect the related code needed to understand them. If the user supplies no references, search for suitable examples yourself; reference discovery is the agent's responsibility. Do not ask the user to locate examples that can be found in the repository.
- Search the same domain/context first, then comparable features elsewhere in the same project. Inspect shared components, utilities, and helpers used by those examples. For consumer references, first verify the other project's root and read only relevant files using absolute paths; adapt to this package's conventions.
- Before editing, briefly name the main reference files in a progress update and state which patterns you will follow. Reading only filenames or declarations is insufficient; inspect the implementation and relevant call sites.
- If examples conflict, use the selection rules in **Pattern consistency**. If no suitable example exists after searching, state that and use the nearest established conventions. Ask only when an unresolved choice materially affects behavior or architecture; do not invent a new pattern silently.
- Before handoff, compare the changed code with the selected references and correct unexplained differences. Briefly identify the main references followed and explain any material deviations in the handoff.

### IDE tools and reviewability

- Prefer tools and MCP integrations connected to the IDE/editor currently used for the project so changes, diagnostics, and execution results are easy for the user to inspect there.
- JetBrains IDEs are the primary workflow. When available and suitable, prefer their IDE/MCP capabilities for symbol navigation, reference searches, refactoring, inspections, formatting, run configurations, and debugging. Confirm that the integration targets the correct project before using it.
- For edits, use IDE-aware tools when they provide useful refactoring or review support; otherwise use focused file patches that remain easy to review in the IDE's version control diff. Keep changes scoped and preserve unrelated work.
- When running builds or other validation, prefer the IDE's integrated terminal or run configurations when suitable so the user can inspect the output. Follow the validation requirements below regardless of the execution tool.
- Other IDEs/editors are supported too: use their equivalent integrations when available. If an IDE integration is unavailable or unsuitable, continue with standard file, search, shell, and debugger tools without requiring the user to switch editors.
- In the handoff, identify changed files and summarize validation results, including any IDE diagnostics or execution output the user should review. Do not assume external tool output is automatically visible in the IDE.

### Text search fallback

- For plain-text searches outside IDE tools, prefer `rg`/`rg --files`.
- If `rg` is unavailable or not working, use `grep`/`find` and continue.

### Validation

- After finishing code changes, run `dart format` on changed Dart files, then run `flutter analyze` and resolve issues introduced by your changes before handoff.
- Prefer targeting both commands at changed files (for example `dart format lib/path/a.dart lib/path/b.dart` followed by `flutter analyze lib/path/a.dart lib/path/b.dart`) unless there is a clear reason to run them on the whole project.

### Handoff summary format

- Briefly name the reference implementations followed and explain material departures; keep this proportional to the change.
- After code changes and validation, include a short summary of changed files in your final response.
- Use plain text (non-clickable) project-relative file references only.
- For each relevant change block, include the starting line number using the `path:line` format (for example `lib/ui/widgets/device/device_form_widget.dart:890`).
- Do not use markdown file links for handoff file references.
- Keep this summary concise and focused on user-impacting or logic-impacting edits.

### Long-term plans

- Do not create a new plan file unless the user explicitly asks for one.
- Keep active plans in `plans/` and completed plans in `plans/archive/`.
- When working on a task that corresponds to a plan step, reference the relevant plan file and tick completed checklist items by changing `- [ ]` to `- [x]` as part of the handoff.
- When all items in a phase are checked, append `[DONE]` to its heading (for example `### Phase 2 — Providers [DONE]`).
- Before moving a completed plan to `plans/archive/`, ask the user to confirm that the plan is complete and no new steps will be added.
- When archiving a plan, add `Finished: YYYY-MM-DD` immediately below its ID/title heading as the second line, using the date the plan is finished and moved to `plans/archive/`.

### Meeting-focused plan markers

- When a plan has points that need meeting discussion, add a `## Meeting focus` section near the top of the plan.
- Use plain text labels that render reliably in GitLab and other Markdown viewers. Include this legend in the section:
    - `**[DECISION]**` — needs a product or architecture choice before implementation can be finalized.
    - `**[VERIFY]**` — needs review or validation but likely does not require a product decision.
    - `**[BLOCKER]**` — blocks dependent implementation work.
- Include a short checklist of current focus items, and prefix the matching original checklist item titles with the same label.
- Keep the meeting focus list curated; remove or tick items when their source checklist item is resolved.
