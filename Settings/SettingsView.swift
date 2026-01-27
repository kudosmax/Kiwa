import SwiftUI
import Defaults
import ServiceManagement

struct SettingsView: View {
    @Default(.launchAtLogin) var launchAtLogin
    @Default(.appLanguage) var appLanguage
    @State private var showingRestartAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(String(localized: "settings.title"))
                .font(.title2)
                .fontWeight(.semibold)

            GroupBox(String(localized: "settings.hotkey")) {
                HotkeySettingsPane()
            }

            GroupBox(String(localized: "settings.symbols")) {
                SymbolsSettingsPane()
            }

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(String(localized: "settings.launch.at.login"), isOn: $launchAtLogin)
                        .onChange(of: launchAtLogin) { _, newValue in
                            do {
                                if newValue {
                                    try SMAppService.mainApp.register()
                                } else {
                                    try SMAppService.mainApp.unregister()
                                }
                            } catch {
                                print("Failed to \(newValue ? "register" : "unregister") login item: \(error)")
                                // Revert toggle on failure
                                launchAtLogin = !newValue
                            }
                        }

                    HStack {
                        Text(String(localized: "settings.language"))
                        Spacer()
                        Picker("", selection: $appLanguage) {
                            Text(String(localized: "settings.language.system")).tag("system")
                            Text("한국어").tag("ko")
                            Text("English").tag("en")
                        }
                        .labelsHidden()
                        .frame(width: 160)
                        .onChange(of: appLanguage) { _, newValue in
                            LanguageManager.apply(newValue)
                            showingRestartAlert = true
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(20)
        .frame(width: 500, height: 600)
        .alert(String(localized: "settings.language.restart.title"), isPresented: $showingRestartAlert) {
            Button(String(localized: "settings.language.restart.now")) {
                LanguageManager.restartApp()
            }
            Button(String(localized: "settings.language.restart.later"), role: .cancel) {}
        } message: {
            Text(String(localized: "settings.language.restart.message"))
        }
    }
}

final class SettingsWindowController {
    static let shared = SettingsWindowController()

    private var window: NSWindow?

    private init() {}

    func show() {
        if let window = window {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)

        let window = NSWindow(contentViewController: hostingController)
        window.title = String(localized: "settings.title")
        window.styleMask = [.titled, .closable, .miniaturizable]
        window.center()
        window.setFrameAutosaveName("SettingsWindow")

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        self.window = window
    }

    func close() {
        window?.close()
        window = nil
    }
}

#Preview {
    SettingsView()
}
