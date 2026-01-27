import Cocoa
import Carbon
import Defaults

final class HotkeyManager {
    static let shared = HotkeyManager()

    private var hotKeyRef: EventHotKeyRef?
    private var hotkeyCallback: (() -> Void)?
    private var eventHandler: EventHandlerRef?

    private init() {
        observeHotkeyChanges()
    }

    private func observeHotkeyChanges() {
        Task {
            for await hotkey in Defaults.updates(.globalHotkey, initial: false) {
                updateHotkey(hotkey)
            }
        }
    }

    func register(callback: @escaping () -> Void) {
        self.hotkeyCallback = callback
        let hotkey = Defaults[.globalHotkey]
        registerCarbonHotkey(hotkey)
    }

    func unregister() {
        if let ref = hotKeyRef {
            UnregisterEventHotKey(ref)
            hotKeyRef = nil
        }
        if let handler = eventHandler {
            RemoveEventHandler(handler)
            eventHandler = nil
        }
        hotkeyCallback = nil
    }

    func updateHotkey(_ hotkey: HotkeyCombo) {
        guard let callback = hotkeyCallback else { return }
        unregister()
        hotkeyCallback = callback
        registerCarbonHotkey(hotkey)
    }

    private func registerCarbonHotkey(_ hotkey: HotkeyCombo) {
        // Convert to Carbon modifier flags
        var carbonModifiers: UInt32 = 0
        if hotkey.modifiers & UInt32(cmdKey) != 0 { carbonModifiers |= UInt32(cmdKey) }
        if hotkey.modifiers & UInt32(optionKey) != 0 { carbonModifiers |= UInt32(optionKey) }
        if hotkey.modifiers & UInt32(controlKey) != 0 { carbonModifiers |= UInt32(controlKey) }
        if hotkey.modifiers & UInt32(shiftKey) != 0 { carbonModifiers |= UInt32(shiftKey) }

        // Event type spec
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        // Install event handler
        let status = InstallEventHandler(
            GetApplicationEventTarget(),
            { _, _, userData -> OSStatus in
                guard let userData else { return OSStatus(eventNotHandledErr) }
                let manager = Unmanaged<HotkeyManager>.fromOpaque(userData).takeUnretainedValue()
                manager.hotkeyCallback?()
                return noErr
            },
            1,
            &eventType,
            Unmanaged.passUnretained(self).toOpaque(),
            &eventHandler
        )

        guard status == noErr else {
            print("Failed to install event handler: \(status)")
            return
        }

        // Register hotkey
        let hotKeyID = EventHotKeyID(signature: OSType(0x444D504C), id: 1) // "DMPL"
        let registerStatus = RegisterEventHotKey(
            UInt32(hotkey.keyCode),
            carbonModifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )

        if registerStatus == noErr {
            print("Hotkey registered: \(hotkey.displayString)")
        } else {
            print("Failed to register hotkey: \(registerStatus)")
        }
    }
}
