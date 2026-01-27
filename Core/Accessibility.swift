import AppKit
import ApplicationServices

enum Accessibility {
    static var isEnabled: Bool {
        AXIsProcessTrusted()
    }

    static func requestAccess() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
    }

    static func checkAndRequestIfNeeded(completion: @escaping (Bool) -> Void) {
        if isEnabled {
            completion(true)
            return
        }

        // Show explanation alert
        let alert = NSAlert()
        alert.messageText = String(localized: "accessibility.title")
        alert.informativeText = String(localized: "accessibility.message")
        alert.alertStyle = .informational
        alert.addButton(withTitle: String(localized: "accessibility.open.settings"))
        alert.addButton(withTitle: String(localized: "accessibility.later"))

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            requestAccess()
        }

        // Check again after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.isEnabled)
        }
    }
}
