import Foundation
import Defaults

@Observable
final class SymbolStore {
    static let shared = SymbolStore()

    var symbols: [Symbol] {
        didSet { Defaults[.symbols] = symbols }
    }

    var selectedSymbol: Symbol?

    private init() {
        symbols = Defaults[.symbols]
    }

    // MARK: - Symbol Access

    var sortedSymbols: [Symbol] {
        symbols.sorted { $0.slotNumber < $1.slotNumber }
    }

    func symbol(for slotNumber: Int) -> Symbol? {
        symbols.first { $0.slotNumber == slotNumber }
    }

    // MARK: - Symbol Management

    func updateSymbol(_ symbol: Symbol) {
        guard let index = symbols.firstIndex(where: { $0.id == symbol.id }) else { return }
        symbols[index] = symbol
    }

    func addSymbol(_ symbol: Symbol) {
        guard symbols.count < 9 else { return }
        symbols.append(symbol)
    }

    func removeSymbol(id: UUID) {
        symbols.removeAll { $0.id == id }
    }

    func nextAvailableSlot() -> Int? {
        let usedSlots = Set(symbols.map(\.slotNumber))
        return (1...9).first { !usedSlots.contains($0) }
    }

    // MARK: - Reset

    func resetToDefaults() {
        symbols = Symbol.defaultSymbols
    }
}
