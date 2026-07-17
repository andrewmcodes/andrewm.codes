# Changelog

## [Unreleased]

.

## [0.6.2] - 2026-01-23

- Fix errant holdover from previous behavior checks in `remove_file`

## [0.6.1] - 2025-12-17

- Fix kwargs syntax errors

## [0.6.0] - 2025-12-14

- Add support for Serbea-based templates (alternative to ERB)
- Refactor all `params = {}` to real keyword arguments
- Handle ANSI codes in columnar calculations (for `print_table`)
- Use yarddoc syntax for all doc comments

## [0.5.3] - 2025-11-21

- Fix syntax error

## [0.5.2] - 2025-11-21

- Fix for missing `escape_globs`, refactoring of calling automation classes

## [0.5.1] - 2025-11-21

- Only check class `exit_on_failure?` if it has been defined

## [0.5.0] - 2025-11-17

- Initial creation of the Freyia gem, hard-fork of the shell/actions components of Thor
