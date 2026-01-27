import Foundation

struct Symbol: Codable, Identifiable, Equatable, Sendable {
    let id: UUID
    var opening: String
    var closing: String?
    var label: String
    var slotNumber: Int

    var isPaired: Bool {
        guard let closing else { return false }
        return !closing.isEmpty
    }

    var displayText: String {
        if isPaired, let closing {
            return "\(opening)\(closing)"
        } else {
            return opening
        }
    }

    init(id: UUID = UUID(), opening: String, closing: String? = nil, label: String, slotNumber: Int) {
        self.id = id
        self.opening = opening
        self.closing = closing
        self.label = label
        self.slotNumber = slotNumber
    }

    static let defaultSymbols: [Symbol] = [
        Symbol(opening: "「", closing: "」", label: String(localized: "preset.paper"), slotNumber: 1),
        Symbol(opening: "『", closing: "』", label: String(localized: "preset.book"), slotNumber: 2),
        Symbol(opening: "〈", closing: "〉", label: String(localized: "preset.work"), slotNumber: 3),
        Symbol(opening: "《", closing: "》", label: String(localized: "preset.film"), slotNumber: 4),
        Symbol(opening: "\u{201C}", closing: "\u{201D}", label: String(localized: "preset.quote"), slotNumber: 5),
        Symbol(opening: "'", closing: "'", label: String(localized: "preset.emphasis"), slotNumber: 6),
        Symbol(opening: "—", closing: nil, label: String(localized: "preset.emdash"), slotNumber: 7),
        Symbol(opening: "·", closing: nil, label: String(localized: "preset.middledot"), slotNumber: 8),
        Symbol(opening: "……", closing: nil, label: String(localized: "preset.ellipsis"), slotNumber: 9),
    ]
}
