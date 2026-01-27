import Carbon

// MARK: - Key Code Constants

enum KeyCode {
    // Number keys 1-9
    static let number1: UInt16 = 0x12
    static let number2: UInt16 = 0x13
    static let number3: UInt16 = 0x14
    static let number4: UInt16 = 0x15
    static let number5: UInt16 = 0x17
    static let number6: UInt16 = 0x16
    static let number7: UInt16 = 0x1A
    static let number8: UInt16 = 0x1C
    static let number9: UInt16 = 0x19

    // Other keys
    static let escape: UInt16 = 0x35
    static let leftArrow: UInt16 = 0x7B
    static let vKey: UInt16 = 0x09
    static let comma: UInt16 = 0x2B

    // Number key array (index 0 = key 1)
    static let numberKeys: [UInt16] = [
        number1, number2, number3, number4, number5,
        number6, number7, number8, number9
    ]

    static func slotNumber(for keyCode: UInt16) -> Int? {
        guard let index = numberKeys.firstIndex(of: keyCode) else { return nil }
        return index + 1
    }
}

// MARK: - Key Code to Character

extension UInt16 {
    var keyCharacter: String {
        switch Int(self) {
        case kVK_ANSI_A: return "A"
        case kVK_ANSI_B: return "B"
        case kVK_ANSI_C: return "C"
        case kVK_ANSI_D: return "D"
        case kVK_ANSI_E: return "E"
        case kVK_ANSI_F: return "F"
        case kVK_ANSI_G: return "G"
        case kVK_ANSI_H: return "H"
        case kVK_ANSI_I: return "I"
        case kVK_ANSI_J: return "J"
        case kVK_ANSI_K: return "K"
        case kVK_ANSI_L: return "L"
        case kVK_ANSI_M: return "M"
        case kVK_ANSI_N: return "N"
        case kVK_ANSI_O: return "O"
        case kVK_ANSI_P: return "P"
        case kVK_ANSI_Q: return "Q"
        case kVK_ANSI_R: return "R"
        case kVK_ANSI_S: return "S"
        case kVK_ANSI_T: return "T"
        case kVK_ANSI_U: return "U"
        case kVK_ANSI_V: return "V"
        case kVK_ANSI_W: return "W"
        case kVK_ANSI_X: return "X"
        case kVK_ANSI_Y: return "Y"
        case kVK_ANSI_Z: return "Z"
        case kVK_ANSI_0: return "0"
        case kVK_ANSI_1: return "1"
        case kVK_ANSI_2: return "2"
        case kVK_ANSI_3: return "3"
        case kVK_ANSI_4: return "4"
        case kVK_ANSI_5: return "5"
        case kVK_ANSI_6: return "6"
        case kVK_ANSI_7: return "7"
        case kVK_ANSI_8: return "8"
        case kVK_ANSI_9: return "9"
        default: return "?"
        }
    }
}

// MARK: - NSEvent Modifier Conversion

import AppKit

extension NSEvent.ModifierFlags {
    var carbonModifiers: UInt32 {
        var result: UInt32 = 0
        if contains(.command) { result |= UInt32(cmdKey) }
        if contains(.option) { result |= UInt32(optionKey) }
        if contains(.control) { result |= UInt32(controlKey) }
        if contains(.shift) { result |= UInt32(shiftKey) }
        return result
    }
}

extension UInt32 {
    var modifierSymbols: String {
        var parts: [String] = []
        if self & UInt32(cmdKey) != 0 { parts.append("\u{2318}") }
        if self & UInt32(optionKey) != 0 { parts.append("\u{2325}") }
        if self & UInt32(controlKey) != 0 { parts.append("\u{2303}") }
        if self & UInt32(shiftKey) != 0 { parts.append("\u{21E7}") }
        return parts.joined()
    }
}
