import SwiftUI

struct SymbolPanelView: View {
    @State private var appState = AppState.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Symbol list
            ForEach(appState.symbolStore.sortedSymbols) { symbol in
                SymbolRowView(
                    symbol: symbol,
                    isSelected: appState.selection == symbol.id
                )
                .onTapGesture {
                    Task { @MainActor in
                        AppState.shared.selectSymbol(at: symbol.slotNumber)
                    }
                }
                .onHover { hovering in
                    if hovering && !appState.isKeyboardNavigating {
                        appState.selection = symbol.id
                    }
                }
            }

            // Footer
            FooterView()
        }
        .padding(.vertical, Popup.verticalPadding)
        .padding(.horizontal, Popup.horizontalPadding)
        .frame(width: Popup.defaultWidth)
        .background(VisualEffectView())
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Symbol Row

struct SymbolRowView: View {
    let symbol: Symbol
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 0) {
            Text(symbol.displayText)
                .font(.system(size: 16))
                .frame(width: 44, alignment: .center)
                .foregroundStyle(isSelected ? .white : .primary)

            Text(symbol.usage)
                .font(.system(size: 13))
                .foregroundStyle(isSelected ? .white.opacity(0.9) : .secondary)
                .lineLimit(1)

            Spacer()

            KeyboardShortcutBadge(shortcut: "\(symbol.slotNumber)", isSelected: isSelected)
                .padding(.trailing, 4)
        }
        .padding(.horizontal, 8)
        .frame(height: Popup.itemHeight)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isSelected ? Color.accentColor.opacity(0.85) : Color.white.opacity(0.001))
        .clipShape(RoundedRectangle(cornerRadius: Popup.cornerRadius))
    }
}

// MARK: - Footer

struct FooterView: View {
    var body: some View {
        VStack(spacing: 2) {
            Divider()
                .padding(.vertical, 6)
                .padding(.horizontal, 8)

            FooterItemView(
                icon: "gearshape",
                title: String(localized: "footer.settings"),
                shortcut: ",",
                action: { AppState.shared.openSettings() }
            )

            FooterItemView(
                icon: "info.circle",
                title: String(localized: "footer.about"),
                shortcut: nil,
                action: { AppState.shared.openAbout() }
            )

            FooterItemView(
                icon: "power",
                title: String(localized: "footer.quit"),
                shortcut: "Q",
                action: { AppState.shared.quit() }
            )
        }
    }
}

struct FooterItemView: View {
    let icon: String
    let title: String
    let shortcut: String?
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(isHovered ? .primary : .secondary)
                .frame(width: 44, alignment: .center)

            Text(title)
                .font(.system(size: 13))
                .foregroundStyle(isHovered ? .primary : .secondary)

            Spacer()

            if let shortcut {
                KeyboardShortcutBadge(shortcut: shortcut, isSelected: false)
                    .padding(.trailing, 4)
            }
        }
        .padding(.horizontal, 8)
        .frame(height: Popup.itemHeight)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isHovered ? Color.secondary.opacity(0.1) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: Popup.cornerRadius))
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.1)) {
                isHovered = hovering
            }
        }
        .onTapGesture {
            action()
        }
    }
}

// MARK: - Keyboard Shortcut Badge

struct KeyboardShortcutBadge: View {
    let shortcut: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 2) {
            Text("\u{2318}")
                .font(.system(size: 11, weight: .medium))
            Text(shortcut)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(isSelected ? .white.opacity(0.8) : .secondary)
        .padding(.horizontal, 6)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isSelected ? Color.white.opacity(0.15) : Color.secondary.opacity(0.1))
        )
    }
}

// MARK: - Visual Effect

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .popover
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

#Preview {
    SymbolPanelView()
}
