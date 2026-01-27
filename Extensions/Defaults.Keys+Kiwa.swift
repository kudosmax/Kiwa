import AppKit
import Defaults

// MARK: - Defaults.Serializable Conformance

extension Symbol: Defaults.Serializable {}
extension HotkeyCombo: Defaults.Serializable {}

// MARK: - Defaults Keys

extension Defaults.Keys {
    static let symbols = Key<[Symbol]>("symbols", default: Symbol.defaultSymbols)
    static let globalHotkey = Key<HotkeyCombo>("globalHotkey", default: .defaultHotkey)
    static let launchAtLogin = Key<Bool>("launchAtLogin", default: false)

    // Panel settings (stored as width, height)
    static let panelWidth = Key<Double>("panelWidth", default: 260)
    static let panelHeight = Key<Double>("panelHeight", default: 320)

    // Language: "system", "ko", "en"
    static let appLanguage = Key<String>("appLanguage", default: "system")
    static let lastAppliedLanguage = Key<String>("lastAppliedLanguage", default: "system")

    // Migration tracking
    static let didMigrateFromLegacy = Key<Bool>("didMigrateFromLegacy", default: false)
}

// MARK: - Legacy Data Migration

enum SettingsMigration {
    private static let legacyKey = "com.dumpling.settings"

    static func migrateIfNeeded() {
        guard !Defaults[.didMigrateFromLegacy] else { return }

        guard let data = UserDefaults.standard.data(forKey: legacyKey) else {
            Defaults[.didMigrateFromLegacy] = true
            return
        }

        do {
            let decoder = JSONDecoder()
            let legacySettings = try decoder.decode(LegacyAppSettings.self, from: data)

            Defaults[.symbols] = legacySettings.symbols
            Defaults[.globalHotkey] = legacySettings.globalHotkey
            Defaults[.launchAtLogin] = legacySettings.launchAtLogin
            Defaults[.didMigrateFromLegacy] = true

            // Remove legacy data
            UserDefaults.standard.removeObject(forKey: legacyKey)

            print("Successfully migrated settings from legacy format")
        } catch {
            print("Failed to migrate legacy settings: \(error)")
            Defaults[.didMigrateFromLegacy] = true
        }
    }
}

// MARK: - Legacy Settings Model (for migration only)

private struct LegacyAppSettings: Codable {
    var globalHotkey: HotkeyCombo
    var symbols: [Symbol]
    var launchAtLogin: Bool
}
