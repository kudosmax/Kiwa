import AppKit
import SwiftUI
import Defaults

final class FloatingPanel: NSPanel, NSWindowDelegate {
    var isPresented = false
    var statusBarButton: NSStatusBarButton?

    private var localEventMonitor: Any?
    private var globalEventMonitor: Any?
    private let onClose: () -> Void

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override var isMovable: Bool {
        get { true }
        set {}
    }

    init(
        contentRect: NSRect,
        statusBarButton: NSStatusBarButton? = nil,
        onClose: @escaping () -> Void,
        content: () -> some View
    ) {
        self.onClose = onClose

        super.init(
            contentRect: contentRect,
            styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        self.statusBarButton = statusBarButton
        self.delegate = self

        configurePanel()

        let hostingView = NSHostingView(rootView: content())
        contentView = hostingView
    }

    private func configurePanel() {
        animationBehavior = .none
        isFloatingPanel = true
        level = .floating
        collectionBehavior = [.auxiliary, .stationary, .moveToActiveSpace, .fullScreenAuxiliary]

        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        isMovableByWindowBackground = true

        hidesOnDeactivate = false
        backgroundColor = .clear
        titlebarSeparatorStyle = .none
        hasShadow = true

        // Hide traffic light buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }

    // MARK: - Show/Hide

    func toggle() {
        if isPresented {
            close()
        } else {
            open()
        }
    }

    func open() {
        // Store currently active app
        AppState.shared.previousApp = NSWorkspace.shared.frontmostApplication

        positionNearMouse()
        NSApp.activate(ignoringOtherApps: true)
        makeKeyAndOrderFront(nil)
        isPresented = true

        startEventMonitors()
        statusBarButton?.isHighlighted = true

        // Highlight first symbol
        AppState.shared.highlightFirst()
    }

    override func close() {
        stopEventMonitors()
        super.close()
        isPresented = false
        statusBarButton?.isHighlighted = false
        onClose()
    }

    func verticallyResize(to newHeight: CGFloat) {
        var newSize = frame.size
        newSize.height = newHeight

        var newOrigin = frame.origin
        newOrigin.y += (frame.height - newSize.height)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            animator().setFrame(NSRect(origin: newOrigin, size: newSize), display: true)
        }
    }

    // MARK: - Positioning

    private func positionNearMouse() {
        guard let screen = NSScreen.main else { return }

        let mouseLocation = NSEvent.mouseLocation
        let panelSize = frame.size
        let screenFrame = screen.visibleFrame

        var x = mouseLocation.x - panelSize.width / 2
        var y = mouseLocation.y - panelSize.height / 2

        // Keep within screen bounds
        x = max(screenFrame.minX, min(x, screenFrame.maxX - panelSize.width))
        y = max(screenFrame.minY, min(y, screenFrame.maxY - panelSize.height))

        setFrameOrigin(NSPoint(x: x, y: y))
    }

    // MARK: - Event Monitoring

    private func startEventMonitors() {
        // Global keyboard events (for ESC when panel has focus)
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyDown(event)
        }

        // Local events
        localEventMonitor = NSEvent.addLocalMonitorForEvents(
            matching: [.keyDown, .leftMouseDown, .rightMouseDown]
        ) { [weak self] event in
            guard let self, self.isPresented else { return event }

            switch event.type {
            case .keyDown:
                return self.handleKeyDown(event)
            case .leftMouseDown, .rightMouseDown:
                return self.handleMouseDown(event)
            default:
                return event
            }
        }
    }

    private func stopEventMonitors() {
        if let monitor = localEventMonitor {
            NSEvent.removeMonitor(monitor)
            localEventMonitor = nil
        }
        if let monitor = globalEventMonitor {
            NSEvent.removeMonitor(monitor)
            globalEventMonitor = nil
        }
    }

    // MARK: - Event Handling

    @discardableResult
    private func handleKeyDown(_ event: NSEvent) -> NSEvent? {
        guard isPresented else { return event }

        let keyCode = event.keyCode

        // ESC to close
        if keyCode == KeyCode.escape {
            close()
            return nil
        }

        // Cmd+, to open settings
        if keyCode == KeyCode.comma && event.modifierFlags.contains(.command) {
            AppState.shared.openSettings()
            return nil
        }

        // Arrow keys for navigation
        if keyCode == 0x7E { // Up arrow
            AppState.shared.highlightPrevious()
            return nil
        }
        if keyCode == 0x7D { // Down arrow
            AppState.shared.highlightNext()
            return nil
        }

        // Return to select current
        if keyCode == 0x24 { // Return
            Task { @MainActor in
                AppState.shared.selectCurrentSymbol()
            }
            return nil
        }

        // Cmd+1-9 to select symbol
        if event.modifierFlags.contains(.command) {
            if let slotNumber = KeyCode.slotNumber(for: keyCode) {
                Task { @MainActor in
                    AppState.shared.selectSymbol(at: slotNumber)
                }
                return nil
            }
        }

        return event
    }

    private func handleMouseDown(_ event: NSEvent) -> NSEvent? {
        let clickLocation = event.locationInWindow
        let panelFrame = contentView?.frame ?? .zero

        // Close if clicked outside
        if !panelFrame.contains(clickLocation) {
            close()
        }

        return event
    }

    // MARK: - NSWindowDelegate

    func windowDidResignKey(_ notification: Notification) {
        // Don't auto-close when opening settings
        // close()
    }
}
