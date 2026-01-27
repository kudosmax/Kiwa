import AppKit
import Defaults

@Observable
final class Popup {
    static let cornerRadius: CGFloat = 8
    static let horizontalPadding: CGFloat = 5
    static let verticalPadding: CGFloat = 5
    static let itemHeight: CGFloat = 32
    static let defaultWidth: CGFloat = 260
    static let defaultHeight: CGFloat = 320

    var needsResize = false
    var height: CGFloat = defaultHeight

    func open() {
        AppState.shared.panel?.open()
    }

    func close() {
        AppState.shared.panel?.close()
    }

    func toggle() {
        AppState.shared.panel?.toggle()
    }

    var isClosed: Bool {
        AppState.shared.panel?.isPresented != true
    }

    func resize(height: CGFloat) {
        self.height = height
        AppState.shared.panel?.verticallyResize(to: height)
        needsResize = false
    }
}
