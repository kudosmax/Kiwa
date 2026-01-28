import SwiftUI

struct SymbolsSettingsPane: View {
    @State private var symbolStore = SymbolStore.shared
    @State private var editingSymbol: Symbol?
    @State private var showingAddSheet = false
    @State private var showingResetConfirm = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 0) {
                Text("#")
                    .frame(width: 28, alignment: .center)
                Text(String(localized: "symbols.header.opening"))
                    .frame(width: 44, alignment: .leading)
                Text(String(localized: "symbols.header.closing"))
                    .frame(width: 44, alignment: .leading)
                Text(String(localized: "symbols.header.label"))
                    .frame(width: 80, alignment: .leading)
                Text(String(localized: "symbols.header.usage"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)

            Divider()

            // Symbol list
            ForEach(symbolStore.sortedSymbols) { symbol in
                SymbolRowEditView(
                    symbol: symbol,
                    onEdit: { editingSymbol = symbol },
                    onDelete: { symbolStore.removeSymbol(id: symbol.id) }
                )
                Divider()
            }

            // Bottom buttons
            HStack {
                if symbolStore.symbols.count < 9 {
                    Button(action: { showingAddSheet = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                            Text(String(localized: "symbols.add"))
                        }
                        .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                Button(action: { showingResetConfirm = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                        Text(String(localized: "symbols.reset"))
                    }
                    .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(8)
        }
        .sheet(item: $editingSymbol) { symbol in
            SymbolEditSheet(symbol: symbol, isNew: false) { updatedSymbol in
                symbolStore.updateSymbol(updatedSymbol)
                editingSymbol = nil
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            if let nextSlot = symbolStore.nextAvailableSlot() {
                SymbolEditSheet(
                    symbol: Symbol(opening: "", closing: "", label: "", slotNumber: nextSlot),
                    isNew: true
                ) { newSymbol in
                    symbolStore.addSymbol(newSymbol)
                    showingAddSheet = false
                }
            }
        }
        .alert(String(localized: "symbols.reset.title"), isPresented: $showingResetConfirm) {
            Button(String(localized: "symbols.reset.confirm"), role: .destructive) {
                symbolStore.resetToDefaults()
            }
            Button(String(localized: "symbols.reset.cancel"), role: .cancel) {}
        } message: {
            Text(String(localized: "symbols.reset.message"))
        }
    }
}

struct SymbolRowEditView: View {
    let symbol: Symbol
    var onEdit: () -> Void
    var onDelete: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 0) {
            Text("\(symbol.slotNumber)")
                .frame(width: 28, alignment: .center)
                .foregroundColor(.secondary)

            Text(symbol.opening)
                .frame(width: 44, alignment: .leading)

            Text(symbol.closing ?? String(localized: "symbols.closing.none"))
                .frame(width: 44, alignment: .leading)
                .foregroundColor(symbol.closing == nil ? .secondary : .primary)

            Text(symbol.label)
                .frame(width: 80, alignment: .leading)
                .lineLimit(1)

            Text(symbol.usage)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
                .foregroundColor(.secondary)

            if isHovered {
                HStack(spacing: 8) {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                    }
                    .buttonStyle(.plain)

                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(isHovered ? Color.secondary.opacity(0.1) : Color.clear)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Symbol Presets

private struct SymbolPreset: Identifiable {
    let id = UUID()
    let opening: String
    let closing: String?
    let label: String
    let usage: String

    static let presets: [SymbolPreset] = [
        SymbolPreset(opening: "「", closing: "」", label: String(localized: "preset.paper"), usage: String(localized: "preset.paper.usage")),
        SymbolPreset(opening: "〈", closing: "〉", label: String(localized: "preset.work"), usage: String(localized: "preset.work.usage")),
        SymbolPreset(opening: "『", closing: "』", label: String(localized: "preset.book"), usage: String(localized: "preset.book.usage")),
        SymbolPreset(opening: "《", closing: "》", label: String(localized: "preset.film"), usage: String(localized: "preset.film.usage")),
        SymbolPreset(opening: "\u{201C}", closing: "\u{201D}", label: String(localized: "preset.quote"), usage: String(localized: "preset.quote.usage")),
        SymbolPreset(opening: "\u{2018}", closing: "\u{2019}", label: String(localized: "preset.emphasis"), usage: String(localized: "preset.emphasis.usage")),
        SymbolPreset(opening: "—", closing: nil, label: String(localized: "preset.emdash"), usage: String(localized: "preset.emdash.usage")),
        SymbolPreset(opening: "·", closing: nil, label: String(localized: "preset.middledot"), usage: String(localized: "preset.middledot.usage")),
        SymbolPreset(opening: "……", closing: nil, label: String(localized: "preset.ellipsis"), usage: String(localized: "preset.ellipsis.usage")),
        SymbolPreset(opening: "(", closing: ")", label: String(localized: "preset.paren"), usage: String(localized: "preset.paren.usage")),
        SymbolPreset(opening: "[", closing: "]", label: String(localized: "preset.bracket"), usage: String(localized: "preset.bracket.usage")),
        SymbolPreset(opening: "{", closing: "}", label: String(localized: "preset.brace"), usage: String(localized: "preset.brace.usage")),
        SymbolPreset(opening: "【", closing: "】", label: String(localized: "preset.heavy.bracket"), usage: String(localized: "preset.heavy.bracket.usage")),
        SymbolPreset(opening: "〔", closing: "〕", label: String(localized: "preset.tortoise"), usage: String(localized: "preset.tortoise.usage")),
        SymbolPreset(opening: "―", closing: nil, label: String(localized: "preset.horizontal.bar"), usage: String(localized: "preset.horizontal.bar.usage")),
        SymbolPreset(opening: "~", closing: nil, label: String(localized: "preset.tilde"), usage: String(localized: "preset.tilde.usage")),
    ]
}

struct SymbolEditSheet: View {
    @State var symbol: Symbol
    let isNew: Bool
    var onSave: (Symbol) -> Void

    @State private var showPresets = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(isNew ? String(localized: "edit.add.title") : String(localized: "edit.edit.title"))
                .font(.headline)

            HStack {
                Text(String(localized: "edit.slot"))
                Text("\(symbol.slotNumber)")
                    .foregroundColor(.secondary)
            }

            // Preset picker
            VStack(alignment: .leading, spacing: 8) {
                Button(action: { showPresets.toggle() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "character.book.closed")
                        Text(String(localized: "edit.preset"))
                        Image(systemName: showPresets ? "chevron.up" : "chevron.down")
                            .font(.caption)
                    }
                    .foregroundColor(.accentColor)
                }
                .buttonStyle(.plain)

                if showPresets {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 4) {
                            ForEach(SymbolPreset.presets) { preset in
                                Button(action: {
                                    symbol.opening = preset.opening
                                    symbol.closing = preset.closing
                                    symbol.label = preset.label
                                    symbol.usage = preset.usage
                                    showPresets = false
                                }) {
                                    HStack(spacing: 6) {
                                        Text(preset.opening + (preset.closing ?? ""))
                                            .font(.system(size: 14))
                                            .frame(width: 36, alignment: .center)
                                        Text(preset.label)
                                            .font(.system(size: 11))
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .background(Color.secondary.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(maxHeight: 160)
                }
            }

            Divider()

            // Manual input
            HStack {
                Text(String(localized: "edit.opening"))
                    .frame(width: 80, alignment: .trailing)
                TextField(String(localized: "edit.opening.placeholder"), text: $symbol.opening)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 150)
            }

            HStack {
                Text(String(localized: "edit.closing"))
                    .frame(width: 80, alignment: .trailing)
                TextField(String(localized: "edit.closing.placeholder"), text: Binding(
                    get: { symbol.closing ?? "" },
                    set: { symbol.closing = $0.isEmpty ? nil : $0 }
                ))
                .textFieldStyle(.roundedBorder)
                .frame(width: 150)
            }

            HStack {
                Text(String(localized: "edit.label"))
                    .frame(width: 80, alignment: .trailing)
                TextField(String(localized: "edit.label.placeholder"), text: $symbol.label)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 150)
            }

            HStack {
                Text(String(localized: "edit.usage"))
                    .frame(width: 80, alignment: .trailing)
                TextField(String(localized: "edit.usage.placeholder"), text: $symbol.usage)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 150)
            }

            HStack {
                Spacer()
                Button(String(localized: "edit.cancel")) {
                    dismiss()
                }
                .keyboardShortcut(.escape)

                Button(String(localized: "edit.save")) {
                    onSave(symbol)
                    dismiss()
                }
                .keyboardShortcut(.return)
                .disabled(symbol.opening.isEmpty || symbol.label.isEmpty)
            }
        }
        .padding(20)
        .frame(width: 360)
    }
}

#Preview {
    SymbolsSettingsPane()
        .frame(width: 480)
        .padding()
}
