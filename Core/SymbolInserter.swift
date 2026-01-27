import Cocoa

final class SymbolInserter {
    static let shared = SymbolInserter()

    private init() {}

    func insert(_ symbol: Symbol) {
        let textToInsert: String
        if symbol.isPaired, let closing = symbol.closing {
            textToInsert = "\(symbol.opening)\(closing)"
        } else {
            textToInsert = symbol.opening
        }

        // Copy to clipboard
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(textToInsert, forType: .string)
    }

    // Future: Implement paste simulation for better UX
    private func simulatePaste() {
        let source = CGEventSource(stateID: .hidSystemState)

        // Cmd+V key down
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: KeyCode.vKey, keyDown: true)
        keyDown?.flags = .maskCommand
        keyDown?.post(tap: .cghidEventTap)

        // Cmd+V key up
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: KeyCode.vKey, keyDown: false)
        keyUp?.flags = .maskCommand
        keyUp?.post(tap: .cghidEventTap)
    }

    // Future: Position cursor between paired symbols
    private func simulateLeftArrow() {
        let source = CGEventSource(stateID: .hidSystemState)

        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: KeyCode.leftArrow, keyDown: true)
        keyDown?.post(tap: .cghidEventTap)

        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: KeyCode.leftArrow, keyDown: false)
        keyUp?.post(tap: .cghidEventTap)
    }
}
