<img width="128px" src="Resources/Assets.xcassets/AppIcon.appiconset/icon_128x128.png" alt="Kiwa Logo" align="left" />

# Kiwa

[![Downloads](https://img.shields.io/github/downloads/kudosmax/Kiwa/total)](https://github.com/kudosmax/Kiwa/releases)

**English** | [한국어](./README.ko.md)

Kiwa is a lightweight typographic symbol input tool for macOS. It lets you quickly insert academic quotation marks and special characters into any app with a single hotkey.

Kiwa works on macOS Sonoma 14 or later.

<br clear="both" />

<!-- vim-markdown-toc GFM -->

* [Features](#features)
* [Install](#install)
* [Usage](#usage)
* [Default Symbols](#default-symbols)
* [Advanced](#advanced)
  * [Customize Symbols](#customize-symbols)
  * [Change Global Hotkey](#change-global-hotkey)
  * [Change Language](#change-language)
* [FAQ](#faq)
  * [Why doesn't the symbol get inserted?](#why-doesnt-the-symbol-get-inserted)
  * [The floating panel doesn't appear when I press the hotkey](#the-floating-panel-doesnt-appear-when-i-press-the-hotkey)
  * [How do I add custom symbols?](#how-do-i-add-custom-symbols)
  * [Why doesn't Kiwa appear in the Dock?](#why-doesnt-kiwa-appear-in-the-dock)
* [Motivation](#motivation)
* [License](#license)

<!-- vim-markdown-toc -->

## Features

* Lightweight and fast
* Keyboard-first
* Smart cursor placement for paired symbols
* Fully customizable (up to 9 symbol slots)
* Native macOS UI
* Supports Korean and English

## Install

Download the latest version from the [releases](https://github.com/kudosmax/Kiwa/releases/latest) page, or use Homebrew:

```sh
brew install --cask kiwa # coming soon
```

> [!WARNING]
> Since Kiwa is not notarized with Apple, macOS may block it on first launch. To allow it:
>
> 1. Open **System Settings > Privacy & Security**.
> 2. Scroll down to find the message: *"Mac을 보호하기 위해 'Kiwa'을(를) 차단했습니다."*
> 3. Click **"그래도 열기" (Open Anyway)**.
>
> <img width="600px" src="Resources/Screenshots/gatekeeper.png" alt="Gatekeeper warning" />

## Usage

1. <kbd>COMMAND (⌘)</kbd> + <kbd>OPTION (⌥)</kbd> + <kbd>D</kbd> to open the Kiwa panel, or click on its icon in the menu bar.
2. Press <kbd>1</kbd>–<kbd>9</kbd> to select and insert a symbol.
3. The symbol is inserted and the panel closes automatically.
4. For paired symbols (e.g. 「」), the cursor is placed between the opening and closing characters.
5. To dismiss the panel, press <kbd>ESC</kbd> or click outside of it.
6. To customize the behavior, open "Settings" with <kbd>COMMAND (⌘)</kbd> + <kbd>,</kbd>.

## Default Symbols

| Key | Symbol | Usage |
|-----|--------|-------|
| 1 | 「」 | Paper title |
| 2 | 『』 | Book title |
| 3 | 〈〉 | Work / Poem title |
| 4 | 《》 | Film / Album title |
| 5 | “” | Quotation |
| 6 | ‘’ | Emphasis |
| 7 | — | Em Dash |
| 8 | · | Middle Dot |
| 9 | …… | Ellipsis |

## Advanced

### Customize Symbols

You can change the symbol for each slot in the settings:

1. Open settings with <kbd>COMMAND (⌘)</kbd> + <kbd>,</kbd>.
2. In the "Symbol Settings" section, edit the opening symbol, closing symbol, and label for any slot.
3. Leave the closing symbol empty for a single (non-paired) symbol.
4. Use the built-in preset picker to quickly select from 16 common typographic symbols.

### Change Global Hotkey

To change the default hotkey <kbd>⌘</kbd> + <kbd>⌥</kbd> + <kbd>D</kbd>:

1. Open settings.
2. Click the "Change" button in the "Hotkey" section.
3. Press your desired key combination.

### Change Language

Kiwa supports Korean and English. To switch the app language:

1. Open settings.
2. Select your preferred language from the "Language" dropdown.
3. Restart the app when prompted.

## FAQ

### Why doesn't the symbol get inserted?

1. Make sure "Kiwa" is added to System Settings > Privacy & Security > Accessibility.
2. You may need to restart Kiwa after granting the permission.

### The floating panel doesn't appear when I press the hotkey

1. Make sure Kiwa is running in the menu bar.
2. Verify that the hotkey does not conflict with another application.
3. Check Kiwa's accessibility permission under System Settings > Privacy & Security > Accessibility.

### How do I add custom symbols?

Click the "+ Add Symbol" button in the settings to add a new symbol. You can register up to 9 symbols.

### Why doesn't Kiwa appear in the Dock?

Kiwa is a menu bar app. It runs in the background and only appears in the menu bar. This is by design to keep it lightweight and out of the way.

## Motivation

Korean academic writing uses a variety of typographic quotation marks such as 『』, 「」, and 《》. However, these symbols are not available on the standard macOS keyboard. Opening the special character viewer or copy-pasting every time is tedious and breaks the writing flow.

Kiwa was built to solve this problem. With a single hotkey, you can quickly insert frequently used quotation marks, and for paired symbols, the cursor is automatically placed between them so you can start typing right away.

## License

[MIT](./LICENSE)
