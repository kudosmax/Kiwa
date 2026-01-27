import AppKit
import Defaults

enum LanguageManager {
    /// Apply language override to UserDefaults. Must be called before UI is loaded.
    static func apply(_ language: String) {
        if language == "system" {
            UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        } else {
            UserDefaults.standard.set([language], forKey: "AppleLanguages")
        }
    }

    /// Apply saved language preference on app launch.
    /// Resets symbol defaults if the language changed since last launch.
    static func applyOnLaunch() {
        let language = Defaults[.appLanguage]
        apply(language)

        if Defaults[.lastAppliedLanguage] != language {
            Defaults[.lastAppliedLanguage] = language
            Defaults[.symbols] = Symbol.defaultSymbols
        }
    }

    /// Restart the app.
    static func restartApp() {
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()

        NSApp.terminate(nil)
    }
}
