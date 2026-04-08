# Changelog

All notable changes to Kiwa will be documented in this file.

## [1.0.3] - 2026-04-08

### Added
- Copy confirmation sound (Frog) when selecting a symbol
- Click outside panel to dismiss

### Changed
- Menu bar icon from `{ }` to `"` (quote.opening) to match app identity
- Panel appears below menu bar icon when clicked, near mouse cursor when using hotkey
- Panel opens to the bottom-right of the mouse cursor
- Removed About and Quit from panel footer (available via right-click menu)

### Fixed
- Removed titlebar artifact from floating panel

### Improved
- Deprecated `foregroundColor` replaced with `foregroundStyle` throughout
- Removed dead code and unused print statements
- Hover animation on symbol rows

## [1.0.2] - 2026-04-08

### Fixed
- Removed titlebar artifact from floating panel

## [1.0.1] - 2026-02-02

### Fixed
- Display symbol usage instead of label in panel

### Added
- Symbol name and usage fields
- Reordered default symbol slots

## [1.0.0] - 2026-01-27

### Added
- Initial release
- Global hotkey (Shift+Option+D) to open symbol panel
- 9 customizable symbol slots with Cmd+1-9 shortcuts
- Clipboard copy for selected symbols
- Settings for hotkey, symbols, language, and launch at login
- Korean and English localization
