import AppKit
import Defaults

@Observable
final class AppState {
    static let shared = AppState()

    // Core observables
    let popup: Popup
    let symbolStore: SymbolStore

    // Panel reference (set by AppDelegate)
    weak var panel: FloatingPanel?

    // Selection state
    var selection: UUID? {
        didSet {
            selectWithoutScrolling(selection)
            scrollTarget = selection
        }
    }

    var scrollTarget: UUID?
    var isKeyboardNavigating = true

    // Previously active app (to restore after panel closes)
    var previousApp: NSRunningApplication?

    private init() {
        popup = Popup()
        symbolStore = SymbolStore.shared
    }

    // MARK: - Selection

    func selectWithoutScrolling(_ id: UUID?) {
        symbolStore.selectedSymbol = symbolStore.symbols.first { $0.id == id }
    }

    func highlightFirst() {
        guard let symbol = symbolStore.sortedSymbols.first else { return }
        selection = symbol.id
    }

    func highlightPrevious() {
        isKeyboardNavigating = true
        guard let current = symbolStore.selectedSymbol,
              let index = symbolStore.sortedSymbols.firstIndex(of: current),
              index > 0 else { return }
        selection = symbolStore.sortedSymbols[index - 1].id
    }

    func highlightNext() {
        isKeyboardNavigating = true
        guard let current = symbolStore.selectedSymbol,
              let index = symbolStore.sortedSymbols.firstIndex(of: current),
              index < symbolStore.sortedSymbols.count - 1 else { return }
        selection = symbolStore.sortedSymbols[index + 1].id
    }

    // MARK: - Actions

    @MainActor
    func selectCurrentSymbol() {
        guard let symbol = symbolStore.selectedSymbol else { return }
        popup.close()
        SymbolInserter.shared.insert(symbol)
        previousApp?.activate(options: [])
    }

    @MainActor
    func selectSymbol(at slotNumber: Int) {
        guard let symbol = symbolStore.symbol(for: slotNumber) else { return }
        popup.close()
        SymbolInserter.shared.insert(symbol)
        previousApp?.activate(options: [])
    }

    func openSettings() {
        popup.close()
        SettingsWindowController.shared.show()
    }

    func openAbout() {
        popup.close()
        NSApp.activate(ignoringOtherApps: true)

        let credits = NSMutableAttributedString()

        let description = NSAttributedString(
            string: String(localized: "about.description") + "\n\n",
            attributes: [
                .foregroundColor: NSColor.labelColor,
                .font: NSFont.systemFont(ofSize: 11)
            ]
        )
        credits.append(description)

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

    func quit() {
        NSApp.terminate(nil)
    }
}
