import Foundation
import Carbon

struct HotkeyCombo: Codable, Equatable, Sendable {
    var keyCode: UInt16
    var modifiers: UInt32

    static let defaultHotkey = HotkeyCombo(
        keyCode: UInt16(kVK_ANSI_D),
        modifiers: UInt32(shiftKey | optionKey)
    )

    var displayString: String {
        var parts: [String] = []
        if modifiers & UInt32(cmdKey) != 0 { parts.append("\u{2318}") }
        if modifiers & UInt32(optionKey) != 0 { parts.append("\u{2325}") }
        if modifiers & UInt32(controlKey) != 0 { parts.append("\u{2303}") }
        if modifiers & UInt32(shiftKey) != 0 { parts.append("\u{21E7}") }

        parts.append(keyCode.keyCharacter)

        return parts.joined(separator: " ")
    }
}
