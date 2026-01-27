import Cocoa
import SwiftUI
import Defaults

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    var panel: FloatingPanel?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Apply language override before UI loads
        LanguageManager.applyOnLaunch()

        // Migrate legacy settings if needed
        SettingsMigration.migrateIfNeeded()

        setupMainMenu()
        setupStatusItem()
        setupPanel()
        setupHotkey()

        // Set reference in AppState
        AppState.shared.panel = panel
    }

    // MARK: - Main Menu

    private func setupMainMenu() {
        let mainMenu = NSMenu()

        // App menu
        let appMenu = NSMenu()
        let appMenuItem = NSMenuItem()
        appMenuItem.submenu = appMenu

        // About
        let aboutItem = NSMenuItem(
            title: String(localized: "menu.about"),
            action: #selector(showAbout),
            keyEquivalent: ""
        )
        aboutItem.target = self
        appMenu.addItem(aboutItem)

        appMenu.addItem(NSMenuItem.separator())

        // Settings
        let settingsItem = NSMenuItem(
            title: String(localized: "menu.settings"),
            action: #selector(showSettings),
            keyEquivalent: ","
        )
        settingsItem.keyEquivalentModifierMask = .command
        settingsItem.target = self
        appMenu.addItem(settingsItem)

        appMenu.addItem(NSMenuItem.separator())

        // Quit
        let quitItem = NSMenuItem(
            title: String(localized: "menu.quit.app"),
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.keyEquivalentModifierMask = .command
        quitItem.target = self
        appMenu.addItem(quitItem)

        mainMenu.addItem(appMenuItem)
        NSApp.mainMenu = mainMenu
    }

    // MARK: - Status Item

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "curlybraces", accessibilityDescription: "Kiwa")
            button.action = #selector(statusItemClicked)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
        }
    }

    @objc private func statusItemClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            showContextMenu()
        } else {
            panel?.toggle()
        }
    }

    private func showContextMenu() {
        let menu = NSMenu()

        // Settings
        let settingsItem = NSMenuItem(
            title: String(localized: "menu.settings"),
            action: #selector(showSettings),
            keyEquivalent: ","
        )
        settingsItem.keyEquivalentModifierMask = .command
        settingsItem.target = self
        menu.addItem(settingsItem)

        // About
        let aboutItem = NSMenuItem(
            title: String(localized: "footer.about"),
            action: #selector(showAbout),
            keyEquivalent: ""
        )
        aboutItem.target = self
        menu.addItem(aboutItem)

        menu.addItem(NSMenuItem.separator())

        // Quit
        let quitItem = NSMenuItem(
            title: String(localized: "menu.quit"),
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.keyEquivalentModifierMask = .command
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
        statusItem?.menu = nil
    }

    @objc private func showPanel() {
        panel?.open()
    }

    @objc private func showSettings() {
        AppState.shared.openSettings()
    }

    @objc private func showAbout() {
        NSApp.activate(ignoringOtherApps: true)

        let credits = NSMutableAttributedString()

        // App description
        let description = NSAttributedString(
            string: String(localized: "about.description") + "\n\n",
            attributes: [
                .foregroundColor: NSColor.labelColor,
                .font: NSFont.systemFont(ofSize: 11)
            ]
        )
        credits.append(description)

        // GitHub link
        let githubLink = NSMutableAttributedString(
            string: "GitHub",
            attributes: [
                .link: "https://github.com/example/kiwa",
                .font: NSFont.systemFont(ofSize: 11)
            ]
        )
        credits.append(githubLink)

        credits.setAlignment(.center, range: NSRange(location: 0, length: credits.length))

        NSApp.orderFrontStandardAboutPanel(options: [
            .applicationName: "Kiwa",
            .applicationVersion: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0",
            .version: Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1",
            .credits: credits
        ])
    }

    @objc private func quitApp() {
        AppState.shared.quit()
    }

    // MARK: - Panel

    private func setupPanel() {
        let panelSize = CGSize(width: Defaults[.panelWidth], height: Defaults[.panelHeight])

        panel = FloatingPanel(
            contentRect: NSRect(origin: .zero, size: panelSize),
            statusBarButton: statusItem?.button,
            onClose: { [weak self] in
                // Panel closed callback
                _ = self
            },
            content: {
                SymbolPanelView()
            }
        )
    }

    // MARK: - Hotkey

    private func setupHotkey() {
        HotkeyManager.shared.register { [weak self] in
            self?.panel?.toggle()
        }
    }
}
