import SwiftUI
import Carbon
import Defaults

struct HotkeySettingsPane: View {
    @Default(.globalHotkey) var globalHotkey
    @State private var isRecording = false

    var body: some View {
        HStack {
            Text(globalHotkey.displayString)
                .font(.system(size: 14, design: .monospaced))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isRecording ? Color.accentColor : Color.clear, lineWidth: 2)
                )

            Spacer()

            Button(isRecording ? String(localized: "hotkey.cancel") : String(localized: "hotkey.change")) {
                isRecording.toggle()
            }
            .keyboardShortcut(.escape, modifiers: [])
        }
        .padding(.vertical, 4)
        .background(
            HotkeyRecorderView(isRecording: $isRecording) { keyCode, modifiers in
                let newHotkey = HotkeyCombo(keyCode: keyCode, modifiers: modifiers)
                globalHotkey = newHotkey
                isRecording = false
            }
        )
    }
}

struct HotkeyRecorderView: NSViewRepresentable {
    @Binding var isRecording: Bool
    var onHotkeyRecorded: (UInt16, UInt32) -> Void

    func makeNSView(context: Context) -> HotkeyRecorderNSView {
        let view = HotkeyRecorderNSView()
        view.onHotkeyRecorded = onHotkeyRecorded
        return view
    }

    func updateNSView(_ nsView: HotkeyRecorderNSView, context: Context) {
        nsView.isRecording = isRecording
        if isRecording {
            nsView.window?.makeFirstResponder(nsView)
        }
    }
}

class HotkeyRecorderNSView: NSView {
    var isRecording = false
    var onHotkeyRecorded: ((UInt16, UInt32) -> Void)?

    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        guard isRecording else {
            super.keyDown(with: event)
            return
        }

        // Cancel with ESC
        if event.keyCode == KeyCode.escape {
            return
        }

        // Ignore if only modifier keys pressed
        let modifiers = event.modifierFlags.intersection([.command, .option, .control, .shift])
        if modifiers.isEmpty {
            return
        }

        // Convert to Carbon modifiers
        let carbonModifiers = modifiers.carbonModifiers

        onHotkeyRecorded?(event.keyCode, carbonModifiers)
    }
}

#Preview {
    HotkeySettingsPane()
        .padding()
        .frame(width: 400)
}
