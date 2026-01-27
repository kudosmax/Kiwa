<img width="128px" src="Resources/Assets.xcassets/AppIcon.appiconset/icon_128x128.png" alt="Kiwa Logo" align="left" />

# Kiwa

A typographic symbol input tool for Korean academic writing on macOS.

Requires macOS Sonoma 14 or later.

<!-- vim-markdown-toc GFM -->

* [Features](#features)
* [Install](#install)
* [Usage](#usage)
* [Default Symbols](#default-symbols)
* [Advanced](#advanced)
  * [Customize Symbols](#customize-symbols)
  * [Change Global Hotkey](#change-global-hotkey)
* [FAQ](#faq)
  * [Why doesn't the symbol get inserted?](#why-doesnt-the-symbol-get-inserted)
  * [The floating panel doesn't appear when I press the hotkey](#the-floating-panel-doesnt-appear-when-i-press-the-hotkey)
  * [How do I add custom symbols?](#how-do-i-add-custom-symbols)
* [Motivation](#motivation)
* [License](#license)

<!-- vim-markdown-toc -->

## Features

* **Quick access**: Summon from anywhere with a single global hotkey
* **Number key selection**: Insert symbols instantly with keys 1–9
* **Smart cursor**: For paired symbols (『』, 「」, etc.), the cursor is automatically placed between them
* **Fully customizable**: Freely configure up to 9 symbol slots
* **Native UI**: Follows macOS design guidelines
* **Lightweight**: Menu bar app with minimal system resource usage
* **Bilingual**: Supports Korean and English interface

## Install

### Homebrew (planned)

```sh
brew install --cask kiwa
```

### Manual

Download the latest version from the [Releases](https://github.com/user/kiwa/releases/latest) page.

## Usage

1. Press <kbd>COMMAND (⌘)</kbd> + <kbd>OPTION (⌥)</kbd> + <kbd>D</kbd> to open the Kiwa panel.
2. Press the number key <kbd>1</kbd>–<kbd>9</kbd> for the desired symbol.
3. The symbol is inserted and the panel closes automatically.
4. For paired symbols, the cursor is automatically placed between the opening and closing characters.
5. Press <kbd>ESC</kbd> or click outside the panel to dismiss it.
6. Press <kbd>COMMAND (⌘)</kbd> + <kbd>,</kbd> or click "Settings" at the bottom of the panel to open settings.

## Default Symbols

| Key | Symbol | Usage |
|-----|--------|-------|
| 1 | 「」 | Paper title |
| 2 | 『』 | Book title |
| 3 | 〈〉 | Work / Poem title |
| 4 | 《》 | Film / Album title |
| 5 | "" | Quotation |
| 6 | '' | Emphasis |
| 7 | — | Em Dash |
| 8 | · | Middle dot |
| 9 | …… | Ellipsis |

## Advanced

### Customize Symbols

You can freely change the symbol for each slot in the settings:

1. Open settings with <kbd>COMMAND (⌘)</kbd> + <kbd>,</kbd>.
2. In the "Symbol Settings" section, edit the opening symbol, closing symbol, and label for any slot.
3. Leave the closing symbol empty for a single (non-paired) symbol.
4. Use the preset picker to quickly select from common typographic symbols.

### Change Global Hotkey

To change the default hotkey <kbd>⌘</kbd> + <kbd>⌥</kbd> + <kbd>D</kbd>:

1. Open settings.
2. Click the "Change" button in the "Hotkey" section.
3. Press your desired key combination.

## FAQ

### Why doesn't the symbol get inserted?

1. Check that Kiwa is listed under "System Settings > Privacy & Security > Accessibility".
2. You may need to restart Kiwa after granting the permission.

### The floating panel doesn't appear when I press the hotkey

1. Make sure Kiwa is running in the menu bar.
2. Verify that the hotkey does not conflict with another app.
3. Check Kiwa's accessibility permission under "System Settings > Privacy & Security > Accessibility".

### How do I add custom symbols?

Click the "+ Add Symbol" button in the settings to add a new symbol. You can register up to 9 symbols.

## Motivation

Korean academic writing uses a variety of typographic quotation marks such as 『』, 「」, and 《》. However, these symbols are difficult to type with the default macOS keyboard. Opening the special character viewer or copy-pasting every time is cumbersome.

Kiwa was built to solve this problem. With a single hotkey, you can quickly insert frequently used quotation marks, and for paired symbols, the cursor is automatically placed between them so you can start typing right away.

## License

[MIT](./LICENSE)
